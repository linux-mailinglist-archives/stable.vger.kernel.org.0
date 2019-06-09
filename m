Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60F63A740
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbfFIQrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730968AbfFIQrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1DD206C3;
        Sun,  9 Jun 2019 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098872;
        bh=QCtxU2sR28pkPYBHfyAgs8ZVRZgw/+3pheZ7fz1NubI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UcUHyrDibmlP2rB5MB/bF7/3+NONSbtb/iu8q2XKyu2Cx3X0K6rinGs1A4Ag7KPf
         Lu/uPMq3EEFsZbP/gfd+5AafR5IDyZUlAiadx/AASPzyACl8XgdnKy/aQ3d+bBFQl7
         hKiDWx8/RifDCRMtmYbY9byADfJt4CCV+E7HpDic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihao Wu <wuyihao@linux.alibaba.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 20/51] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter
Date:   Sun,  9 Jun 2019 18:42:01 +0200
Message-Id: <20190609164128.246232064@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yihao Wu <wuyihao@linux.alibaba.com>

commit 52b042ab9948cc367b61f9ca9c18603aa7813c3a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6850,7 +6850,6 @@ struct nfs4_lock_waiter {
 	struct task_struct	*task;
 	struct inode		*inode;
 	struct nfs_lowner	*owner;
-	bool			notified;
 };
 
 static int
@@ -6872,13 +6871,13 @@ nfs4_wake_lock_waiter(wait_queue_entry_t
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
@@ -6887,7 +6886,6 @@ static int
 nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 {
 	int status = -ERESTARTSYS;
-	unsigned long flags;
 	struct nfs4_lock_state *lsp = request->fl_u.nfs4_fl.owner;
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs_client *clp = server->nfs_client;
@@ -6897,8 +6895,7 @@ nfs4_retry_setlk(struct nfs4_state *stat
 				    .s_dev = server->s_dev };
 	struct nfs4_lock_waiter waiter = { .task  = current,
 					   .inode = state->inode,
-					   .owner = &owner,
-					   .notified = false };
+					   .owner = &owner};
 	wait_queue_entry_t wait;
 
 	/* Don't bother with waitqueue if we don't expect a callback */
@@ -6911,21 +6908,14 @@ nfs4_retry_setlk(struct nfs4_state *stat
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


