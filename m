Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A832C3A490
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfFIJqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:46:12 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34743 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:46:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C7A9635F;
        Sun,  9 Jun 2019 05:46:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VHm47T
        8As3PSe8CL9gOno8d9cWAZeDWQLh5Eesqy5vk=; b=yGrT3/ewxfYwwSgUuJPNVU
        +jqbxfkaPoqpkK/LMe7rVlLeoVmpR0IybbENH+aXlgEEq/C0aaKG+Qdmda/ZZ3kP
        bnbhSjvin4gP+Vvr8N5fYyTOQ2AojXlPBiNGOJSULH7nwkGzfCOS+GBzeGLu/uFC
        QRYm0Ovt6o6c4ypMlr6ggv2kJwZa0pcB6SyF4LtRB1cOwII6V0va5Cp3YF/4WnlL
        +IDc2Ji0Qgt9GtPqQ1FMIyyAjSHK+eLnZUXHjkF3+ZYhK947QgExh9HkQ7aIbkjf
        VxBnX5pudcImt/8BeptXoINIFQIwC+FWeUuovm4Pmc8OI7lfJL9VgUBEGzuRkETw
        ==
X-ME-Sender: <xms:YtX8XFNTnND6zcpX38AMA5YhegDL3YqrWdXundPwG8TPloRVWvygyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:YtX8XIGNgRoYB6tCmD__d1P-qov1nLeJerrQhw-KQ7NIoAtmmmBsrw>
    <xmx:YtX8XMMvCm0w2gvTsMfBxdp_Zefp1_Fpasdy2UupHrvCVGXdx4vzbA>
    <xmx:YtX8XJ9IMhmtyE63lp-rksl9OevTn_of0lEXwuJwcmAsPK_ttwnKhw>
    <xmx:YtX8XFubM8IjZN-YFMUC2w6zi2yXT-F2zc4fgcPUV6rXZehRnbwcfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2E8A380083;
        Sun,  9 Jun 2019 05:46:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake" failed to apply to 4.9-stable tree
To:     wuyihao@linux.alibaba.com, Anna.Schumaker@Netapp.com,
        jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:46:08 +0200
Message-ID: <156007356814125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

