Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144403A492
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfFIJq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:46:29 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35913 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:46:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7636C3C9;
        Sun,  9 Jun 2019 05:46:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tamn1n
        b9iw8Euiab7t0ZvIhrQnaUBK6bJBcTYbV+4EQ=; b=kVXEm9KpcXtqwax4JJWdbe
        lZI6EBcje/TAgUAIaUqGSUzbXCdJerIvMgtdW5ovak+EN6naiuye8KdyNVkHUN0m
        gV0/IKdh5u56Lvn048krs40Mve19MSxKVoAcZXXNRhD7iNDOwLOhE74LZCdCNgGl
        rfC+8BQjtWzlNu0Bf2StqJ6zOtuk/pu901GekkSzn6SplbcBHKNVYbgdN4BQJuW8
        gQPjx7xnyqk0LgEzpyx1KEvwpe+luNAEF7ZlzyMHFqkU0l5ztxzh+BUS0l7qZX1L
        UvR2xXJiiSKuw6neJRqsq0sjnXrB2m0mDy2BsVlW2UFbxLENgNHmsgev0R+PzXNA
        ==
X-ME-Sender: <xms:c9X8XB56GfCrTBKb0QAzC8iJl8Axb3QxONRhq0FdTF5xOIxrpSisuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:dNX8XHqOYFOvZcsZcgi8FRDFbQf-qUhGmOroC964Br8vg3PjPvIjnQ>
    <xmx:dNX8XHJlNa8Z6TJ2p-jUBuRlY5f0U5wNDU6S7TqSyv3n1rVrppu9KA>
    <xmx:dNX8XMg0E1bmNWNPlcxwEhc3R2aiRH_0y-qn7gMi_AAYCFETOYy5wA>
    <xmx:dNX8XIOtxkA9Ge5wVgnjLnYLw30YTkOguWm-ocqdvfLSPFFFpNFXhg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 949C5380087;
        Sun,  9 Jun 2019 05:46:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled" failed to apply to 4.9-stable tree
To:     wuyihao@linux.alibaba.com, Anna.Schumaker@Netapp.com,
        jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:46:26 +0200
Message-ID: <1560073586114172@kroah.com>
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

From ba851a39c9703f09684a541885ed176f8fb7c868 Mon Sep 17 00:00:00 2001
From: Yihao Wu <wuyihao@linux.alibaba.com>
Date: Mon, 13 May 2019 14:58:22 +0800
Subject: [PATCH] NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled

When a waiter is waked by CB_NOTIFY_LOCK, it will retry
nfs4_proc_setlk(). The waiter may fail to nfs4_proc_setlk() and sleep
again. However, the waiter is already removed from clp->cl_lock_waitq
when handling CB_NOTIFY_LOCK in nfs4_wake_lock_waiter(). So any
subsequent CB_NOTIFY_LOCK won't wake this waiter anymore. We should
put the waiter back to clp->cl_lock_waitq before retrying.

Cc: stable@vger.kernel.org #4.9+
Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5f89bbd177c6..e38f4af20950 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6987,20 +6987,22 @@ nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 	init_wait(&wait);
 	wait.private = &waiter;
 	wait.func = nfs4_wake_lock_waiter;
-	add_wait_queue(q, &wait);
 
 	while(!signalled()) {
+		add_wait_queue(q, &wait);
 		status = nfs4_proc_setlk(state, cmd, request);
-		if ((status != -EAGAIN) || IS_SETLK(cmd))
+		if ((status != -EAGAIN) || IS_SETLK(cmd)) {
+			finish_wait(q, &wait);
 			break;
+		}
 
 		status = -ERESTARTSYS;
 		freezer_do_not_count();
 		wait_woken(&wait, TASK_INTERRUPTIBLE, NFS4_LOCK_MAXTIMEOUT);
 		freezer_count();
+		finish_wait(q, &wait);
 	}
 
-	finish_wait(q, &wait);
 	return status;
 }
 #else /* !CONFIG_NFS_V4_1 */

