Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EE23A491
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfFIJqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:46:20 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:32967 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:46:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2214E273;
        Sun,  9 Jun 2019 05:46:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IS9jpr
        RRV7bxkZQTkVOtzPovT/IN4yGXJwAyTRFU+6g=; b=HUuOBZSRXCGdtGnXVqPXLH
        AFcUIcmnunLRiS9wurdJOn+XvHHJJzoJofg2kCGg4iHscVEdjJepsZxYOuyOECJF
        R/0mYwjaEoAY28tW6YW7PLBAsjmtygX8RVRWa8XlkWlVlS6YYeS647ZNDbdu374e
        5Iq9NbRnfbr5lMNWdUNe4SgiTsDD9tkDA2CPjQCFpcMZLLDvpnHKbF9v7X47zVNM
        po2GRiPAcx5uVPiVwNFH1ochMYVvm2CUFnaceSjDrnKr0iMx5sgG1lnL1t2tP1ro
        /ZyiKEirm8R78FsB9jyJT3fEBIHpl5M4jv+2/q+z4bwfc8mUmIuyJ0Y/FwmItmsQ
        ==
X-ME-Sender: <xms:atX8XHhO59Fpqga9NtLbI7BSx8u4VzQ7XaEigH6lXyOq6TFQ8X5Rbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:atX8XMzQ_RnSxnn4OYEhiUxUykwFjo9YoakdHbI32D_7i0qdX1ndHw>
    <xmx:atX8XJRkLnBNiGt_iiHT4XSGDC096rSC7Q1C2jeR2H2_MzTluGxQvQ>
    <xmx:atX8XLGBUELuuxzDP1SBmSNyHXNvuUfyfgaqnt8J3CZGaRTX7oJ2-A>
    <xmx:atX8XJZAfgWf4w9-mdUleyvzEy2pDUcUY_bajv3MfQ8XnNX9P9qgow>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C0D78005A;
        Sun,  9 Jun 2019 05:46:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake" failed to apply to 4.14-stable tree
To:     wuyihao@linux.alibaba.com, Anna.Schumaker@Netapp.com,
        jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:46:08 +0200
Message-ID: <15600735684899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52b042ab9948cc367b61f9ca9c18603aa7813c3a Mon Sep 17 00:00:00 2001
From: Yihao Wu <wuyihao@linux.alibaba.com>
Date: Wed, 22 May 2019 01:57:10 +0800
Subject: [PATCH] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake
 a waiter

Commit b7dbcc0e433f "NFSv4.1: Fix a race where CB_NOTIFY_LOCK fails to wake a waiter"
found this bug. However it didn't fix it.

This commit replaces schedule_timeout() with wait_woken() and
default_wake_function() with woken_wake_function() in function
nfs4_retry_setlk() and nfs4_wake_lock_waiter(). wait_woken() uses
memory barriers in its implementation to avoid potential race condition
when putting a process into sleeping state and then waking it up.

Fixes: a1d617d8f134 ("nfs: allow blocking locks to be awoken by lock callbacks")
Cc: stable@vger.kernel.org #4.9+
Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c29cbef6b53f..5f89bbd177c6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6932,7 +6932,6 @@ struct nfs4_lock_waiter {
 	struct task_struct	*task;
 	struct inode		*inode;
 	struct nfs_lowner	*owner;
-	bool			notified;
 };
 
 static int
@@ -6954,13 +6953,13 @@ nfs4_wake_lock_waiter(wait_queue_entry_t *wait, unsigned int mode, int flags, vo
 		/* Make sure it's for the right inode */
 		if (nfs_compare_fh(NFS_FH(waiter->inode), &cbnl->cbnl_fh))
 			return 0;
-
-		waiter->notified = true;
 	}
 
 	/* override "private" so we can use default_wake_function */
 	wait->private = waiter->task;
-	ret = autoremove_wake_function(wait, mode, flags, key);
+	ret = woken_wake_function(wait, mode, flags, key);
+	if (ret)
+		list_del_init(&wait->entry);
 	wait->private = waiter;
 	return ret;
 }
@@ -6969,7 +6968,6 @@ static int
 nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 {
 	int status = -ERESTARTSYS;
-	unsigned long flags;
 	struct nfs4_lock_state *lsp = request->fl_u.nfs4_fl.owner;
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs_client *clp = server->nfs_client;
@@ -6979,8 +6977,7 @@ nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 				    .s_dev = server->s_dev };
 	struct nfs4_lock_waiter waiter = { .task  = current,
 					   .inode = state->inode,
-					   .owner = &owner,
-					   .notified = false };
+					   .owner = &owner};
 	wait_queue_entry_t wait;
 
 	/* Don't bother with waitqueue if we don't expect a callback */
@@ -6993,21 +6990,14 @@ nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 	add_wait_queue(q, &wait);
 
 	while(!signalled()) {
-		waiter.notified = false;
 		status = nfs4_proc_setlk(state, cmd, request);
 		if ((status != -EAGAIN) || IS_SETLK(cmd))
 			break;
 
 		status = -ERESTARTSYS;
-		spin_lock_irqsave(&q->lock, flags);
-		if (waiter.notified) {
-			spin_unlock_irqrestore(&q->lock, flags);
-			continue;
-		}
-		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock_irqrestore(&q->lock, flags);
-
-		freezable_schedule_timeout(NFS4_LOCK_MAXTIMEOUT);
+		freezer_do_not_count();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, NFS4_LOCK_MAXTIMEOUT);
+		freezer_count();
 	}
 
 	finish_wait(q, &wait);

