Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CED205DA8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389273AbgFWUPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389265AbgFWUPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CCB2073E;
        Tue, 23 Jun 2020 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943311;
        bh=OXoq7U7vrOFSjjoT5wdL3Gv4N5mXgeMwFrsSNSlyM4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBCVJ1yHWdVhcWzNttEJrd+mMsTN3OaIflHoycztBI3L0SJduA8Pa5nO0q2BoK7Qk
         5kt4/N8StKznGS1kVQ9k7OiM0p/z9FLu3KGjIlOeAY/UTaTmGnFRlaNWwFeSztXXN8
         ii7k0j+6iY7VIsC5YS60rGznCYQt6C+H1+9uKo3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 335/477] gfs2: fix use-after-free on transaction ail lists
Date:   Tue, 23 Jun 2020 21:55:32 +0200
Message-Id: <20200623195423.375999221@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]

Before this patch, transactions could be merged into the system
transaction by function gfs2_merge_trans(), but the transaction ail
lists were never merged. Because the ail flushing mechanism can run
separately, bd elements can be attached to the transaction's buffer
list during the transaction (trans_add_meta, etc) but quickly moved
to its ail lists. Later, in function gfs2_trans_end, the transaction
can be freed (by gfs2_trans_end) while it still has bd elements
queued to its ail lists, which can cause it to either lose track of
the bd elements altogether (memory leak) or worse, reference the bd
elements after the parent transaction has been freed.

Although I've not seen any serious consequences, the problem becomes
apparent with the previous patch's addition of:

	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));

to function gfs2_trans_free().

This patch adds logic into gfs2_merge_trans() to move the merged
transaction's ail lists to the sdp transaction. This prevents the
use-after-free. To do this properly, we need to hold the ail lock,
so we pass sdp into the function instead of the transaction itself.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 0644e58c6191b..b7a5221bea7d5 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1003,8 +1003,10 @@ out:
  * @new: New transaction to be merged
  */
 
-static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
+static void gfs2_merge_trans(struct gfs2_sbd *sdp, struct gfs2_trans *new)
 {
+	struct gfs2_trans *old = sdp->sd_log_tr;
+
 	WARN_ON_ONCE(!test_bit(TR_ATTACHED, &old->tr_flags));
 
 	old->tr_num_buf_new	+= new->tr_num_buf_new;
@@ -1016,6 +1018,11 @@ static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
 
 	list_splice_tail_init(&new->tr_databuf, &old->tr_databuf);
 	list_splice_tail_init(&new->tr_buf, &old->tr_buf);
+
+	spin_lock(&sdp->sd_ail_lock);
+	list_splice_tail_init(&new->tr_ail1_list, &old->tr_ail1_list);
+	list_splice_tail_init(&new->tr_ail2_list, &old->tr_ail2_list);
+	spin_unlock(&sdp->sd_ail_lock);
 }
 
 static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
@@ -1027,7 +1034,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_log_lock(sdp);
 
 	if (sdp->sd_log_tr) {
-		gfs2_merge_trans(sdp->sd_log_tr, tr);
+		gfs2_merge_trans(sdp, tr);
 	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
 		gfs2_assert_withdraw(sdp, test_bit(TR_ALLOCED, &tr->tr_flags));
 		sdp->sd_log_tr = tr;
-- 
2.25.1



