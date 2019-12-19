Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D755126D80
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfLSSgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfLSSge (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AEBF2467B;
        Thu, 19 Dec 2019 18:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780593;
        bh=8TgAuhidk5oSTwZ1eaoHs9t4kw2w9ZuWglFYXHYxt9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFi5C8fHUcLx3GyaqCd2bx80xo3EcAK+sVGkBCeOl34A7VmnoY46TbJqMXsxJLs3g
         FEsLzL730aVuGjwZp+SB8OnBPthJpdy8dUDuZOvyKQeRIVVAhIrfppfxHczbY364R1
         Id2a9oOBfQZT4pkXZoMVq1scqcRIV+aSvSU3djNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 038/162] nfsd: fix a warning in __cld_pipe_upcall()
Date:   Thu, 19 Dec 2019 19:32:26 +0100
Message-Id: <20191219183210.143633078@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit b493fd31c0b89d9453917e977002de58bebc3802 ]

__cld_pipe_upcall() emits a "do not call blocking ops when
!TASK_RUNNING" warning due to the dput() call in rpc_queue_upcall().
Fix it by using a completion instead of hand coding the wait.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index e3d47091b191d..2cb2e61cdbf6c 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -655,7 +655,7 @@ struct cld_net {
 struct cld_upcall {
 	struct list_head	 cu_list;
 	struct cld_net		*cu_net;
-	struct task_struct	*cu_task;
+	struct completion	 cu_done;
 	struct cld_msg		 cu_msg;
 };
 
@@ -664,23 +664,18 @@ __cld_pipe_upcall(struct rpc_pipe *pipe, struct cld_msg *cmsg)
 {
 	int ret;
 	struct rpc_pipe_msg msg;
+	struct cld_upcall *cup = container_of(cmsg, struct cld_upcall, cu_msg);
 
 	memset(&msg, 0, sizeof(msg));
 	msg.data = cmsg;
 	msg.len = sizeof(*cmsg);
 
-	/*
-	 * Set task state before we queue the upcall. That prevents
-	 * wake_up_process in the downcall from racing with schedule.
-	 */
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	ret = rpc_queue_upcall(pipe, &msg);
 	if (ret < 0) {
-		set_current_state(TASK_RUNNING);
 		goto out;
 	}
 
-	schedule();
+	wait_for_completion(&cup->cu_done);
 
 	if (msg.errno < 0)
 		ret = msg.errno;
@@ -747,7 +742,7 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	if (copy_from_user(&cup->cu_msg, src, mlen) != 0)
 		return -EFAULT;
 
-	wake_up_process(cup->cu_task);
+	complete(&cup->cu_done);
 	return mlen;
 }
 
@@ -762,7 +757,7 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	if (msg->errno >= 0)
 		return;
 
-	wake_up_process(cup->cu_task);
+	complete(&cup->cu_done);
 }
 
 static const struct rpc_pipe_ops cld_upcall_ops = {
@@ -893,7 +888,7 @@ restart_search:
 			goto restart_search;
 		}
 	}
-	new->cu_task = current;
+	init_completion(&new->cu_done);
 	new->cu_msg.cm_vers = CLD_UPCALL_VERSION;
 	put_unaligned(cn->cn_xid++, &new->cu_msg.cm_xid);
 	new->cu_net = cn;
-- 
2.20.1



