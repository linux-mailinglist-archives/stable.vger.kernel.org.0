Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2D2C079D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgKWMmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732753AbgKWMlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21EF20888;
        Mon, 23 Nov 2020 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135310;
        bh=6H6KG8txNKgnXHNj3Ey5OpYJ13zYZsJJLJPC37mIlEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKSO2CLNmCC/m1Z8fu4wuOimpRfZ7s71YZDtamsaaQ2rlnW0EuqKzvmtRSuDmgfWs
         EqgNNktYT5yQRRNeZ/Ge5o/jTOUFfIV/obv3x1aKDCybE8MfGMEKT4kqYgR44o3Pjk
         T/7PrP17R7WacJOiNtXn1U4v6qNgATphO6Pukqnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 023/252] net: ipa: lock when freeing transaction
Date:   Mon, 23 Nov 2020 13:19:33 +0100
Message-Id: <20201123121836.716621324@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 064c9c32b17ca9b36f95eba32ee790dbbebd9a5f ]

Transactions sit on one of several lists, depending on their state
(allocated, pending, complete, or polled).  A spinlock protects
against concurrent access when transactions are moved between these
lists.

Transactions are also reference counted.  A newly-allocated
transaction has an initial count of 1; a transaction is released in
gsi_trans_free() only if its decremented reference count reaches 0.
Releasing a transaction includes removing it from the polled (or if
unused, allocated) list, so the spinlock is acquired when we release
a transaction.

The reference count is used to allow a caller to synchronously wait
for a committed transaction to complete.  In this case, the waiter
takes an extra reference to the transaction *before* committing it
(so it won't be freed), and releases its reference (calls
gsi_trans_free()) when it is done with it.

Similarly, gsi_channel_update() takes an extra reference to ensure a
transaction isn't released before the function is done operating on
it.  Until the transaction is moved to the completed list (by this
function) it won't be freed, so this reference is taken "safely."

But in the quiesce path, we want to wait for the "last" transaction,
which we find in the completed or polled list.  Transactions on
these lists can be freed at any time, so we (try to) prevent that
by taking the reference while holding the spinlock.

Currently gsi_trans_free() decrements a transaction's reference
count unconditionally, acquiring the lock to remove the transaction
from its list *only* when the count reaches 0.  This does not
protect the quiesce path, which depends on the lock to ensure its
extra reference prevents release of the transaction.

Fix this by only dropping the last reference to a transaction
in gsi_trans_free() while holding the spinlock.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20201114182017.28270-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/gsi_trans.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -363,22 +363,31 @@ struct gsi_trans *gsi_channel_trans_allo
 	return trans;
 }
 
-/* Free a previously-allocated transaction (used only in case of error) */
+/* Free a previously-allocated transaction */
 void gsi_trans_free(struct gsi_trans *trans)
 {
+	refcount_t *refcount = &trans->refcount;
 	struct gsi_trans_info *trans_info;
+	bool last;
 
-	if (!refcount_dec_and_test(&trans->refcount))
+	/* We must hold the lock to release the last reference */
+	if (refcount_dec_not_one(refcount))
 		return;
 
 	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
 
 	spin_lock_bh(&trans_info->spinlock);
 
-	list_del(&trans->links);
+	/* Reference might have been added before we got the lock */
+	last = refcount_dec_and_test(refcount);
+	if (last)
+		list_del(&trans->links);
 
 	spin_unlock_bh(&trans_info->spinlock);
 
+	if (!last)
+		return;
+
 	ipa_gsi_trans_release(trans);
 
 	/* Releasing the reserved TREs implicitly frees the sgl[] and


