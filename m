Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC9B11B49D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbfLKPsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732673AbfLKPZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D54208C3;
        Wed, 11 Dec 2019 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077923;
        bh=qi46wH0VA46RLqAO45JyHZqu4fDMoxutCjmxaUR8ReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnzXlLrSF3eIqbKZDp+13UtCBSt+7BECM6+4+ifULY/XtBZ6caJTLtiUz+aYFQIPR
         Wg3G7YPZqhW0Bojxkn3mx7Mu10Ln5SRZAP2EccotVuETuJPtWxnc9x+sWLbp2GTN+e
         QwuQ6miDqIcWwY5RKKnk4R4RLHoMDurICFB/tNos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 221/243] jbd2: Fix possible overflow in jbd2_log_space_left()
Date:   Wed, 11 Dec 2019 16:06:23 +0100
Message-Id: <20191211150354.248903005@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit add3efdd78b8a0478ce423bb9d4df6bd95e8b335 upstream.

When number of free space in the journal is very low, the arithmetic in
jbd2_log_space_left() could underflow resulting in very high number of
free blocks and thus triggering assertion failure in transaction commit
code complaining there's not enough space in the journal:

J_ASSERT(journal->j_free > 1);

Properly check for the low number of free blocks.

CC: stable@vger.kernel.org
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/jbd2.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1587,7 +1587,7 @@ static inline int jbd2_space_needed(jour
 static inline unsigned long jbd2_log_space_left(journal_t *journal)
 {
 	/* Allow for rounding errors */
-	unsigned long free = journal->j_free - 32;
+	long free = journal->j_free - 32;
 
 	if (journal->j_committing_transaction) {
 		unsigned long committing = atomic_read(&journal->
@@ -1596,7 +1596,7 @@ static inline unsigned long jbd2_log_spa
 		/* Transaction + control blocks */
 		free -= committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
 	}
-	return free;
+	return max_t(long, free, 0);
 }
 
 /*


