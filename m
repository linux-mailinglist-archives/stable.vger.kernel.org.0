Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4E259CC9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIARTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgIAPNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B4D216C4;
        Tue,  1 Sep 2020 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973202;
        bh=tuclfC2n6eSkApmklnVXwE3XVCDNPnrHxJckzXjbm1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUQ5yJxurB9u4jTnj92xNR2sC4y1dUQ0a2wDNp07ePwbFFGf0Dd2IPIWnjhEbDOMF
         2aGYnbix+XcKa/VHzkS54Gzcxd7bRFnRdgMpm+LmWttdJA6XxD/+iZ8w+X+HYX3rrN
         8HTHyrjqnifpGG5ec2+qTpw0O2WSxYdq3Apv2Aws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 47/62] writeback: Protect inode->i_io_list with inode->i_lock
Date:   Tue,  1 Sep 2020 17:10:30 +0200
Message-Id: <20200901150923.092862691@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit b35250c0816c7cf7d0a8de92f5fafb6a7508a708 upstream.

Currently, operations on inode->i_io_list are protected by
wb->list_lock. In the following patches we'll need to maintain
consistency between inode->i_state and inode->i_io_list so change the
code so that inode->i_lock protects also all inode's i_io_list handling.

Reviewed-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
CC: stable@vger.kernel.org # Prerequisite for "writeback: Avoid skipping inode writeback"
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -160,6 +160,7 @@ static void inode_io_list_del_locked(str
 				     struct bdi_writeback *wb)
 {
 	assert_spin_locked(&wb->list_lock);
+	assert_spin_locked(&inode->i_lock);
 
 	list_del_init(&inode->i_io_list);
 	wb_io_lists_depopulated(wb);
@@ -1034,7 +1035,9 @@ void inode_io_list_del(struct inode *ino
 	struct bdi_writeback *wb;
 
 	wb = inode_to_wb_and_lock_list(inode);
+	spin_lock(&inode->i_lock);
 	inode_io_list_del_locked(inode, wb);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -1047,8 +1050,10 @@ void inode_io_list_del(struct inode *ino
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
+static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
 {
+	assert_spin_locked(&inode->i_lock);
+
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -1059,6 +1064,13 @@ static void redirty_tail(struct inode *i
 	inode_io_list_move_locked(inode, wb, &wb->b_dirty);
 }
 
+static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
+{
+	spin_lock(&inode->i_lock);
+	redirty_tail_locked(inode, wb);
+	spin_unlock(&inode->i_lock);
+}
+
 /*
  * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
@@ -1269,7 +1281,7 @@ static void requeue_inode(struct inode *
 		 * writeback is not making progress due to locked
 		 * buffers. Skip this inode for now.
 		 */
-		redirty_tail(inode, wb);
+		redirty_tail_locked(inode, wb);
 		return;
 	}
 
@@ -1289,7 +1301,7 @@ static void requeue_inode(struct inode *
 			 * retrying writeback of the dirty page/inode
 			 * that cannot be performed immediately.
 			 */
-			redirty_tail(inode, wb);
+			redirty_tail_locked(inode, wb);
 		}
 	} else if (inode->i_state & I_DIRTY) {
 		/*
@@ -1297,7 +1309,7 @@ static void requeue_inode(struct inode *
 		 * such as delayed allocation during submission or metadata
 		 * updates after data IO completion.
 		 */
-		redirty_tail(inode, wb);
+		redirty_tail_locked(inode, wb);
 	} else if (inode->i_state & I_DIRTY_TIME) {
 		inode->dirtied_when = jiffies;
 		inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
@@ -1543,8 +1555,8 @@ static long writeback_sb_inodes(struct s
 		 */
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			redirty_tail_locked(inode, wb);
 			spin_unlock(&inode->i_lock);
-			redirty_tail(inode, wb);
 			continue;
 		}
 		if ((inode->i_state & I_SYNC) && wbc.sync_mode != WB_SYNC_ALL) {


