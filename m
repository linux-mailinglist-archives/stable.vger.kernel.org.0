Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA43A493
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfFIJqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:46:38 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53277 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:46:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DE5A135F;
        Sun,  9 Jun 2019 05:46:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P4Zn2X
        jFBt7vy2Cdimar6vYzrSMZhgvV6RALHRMASW8=; b=Zv+rl3aQ43ZOJXbx0542T6
        D0GBuWQK/lO5LN5CSZLW1TgxxuHSlY3ykGo5lv2y9jGLiiGhcBRnRrsnTqnGdwYx
        qkGWgoe456wKfoifg7ns6arrEURM6pfYy6ckJetZDlhrEfrMJmtLlS4C6mQCiIkx
        q5pfbJx7yIMUa8sAtc2hpiAxvv6HMimfv8kLH1AYBRqeDZEFHKbBpq9nj34eehqR
        6yHVepyFj9/sJU1dNOn2OEsXAL9R0TzAhIkuwxV40REp59pW+k4WFBVEeWgGA7mK
        RVJtpY4/+DjP/FsUkxB2Ch3sfVoEfYnj8Lld7k/dMrAViISi6Ti2W7cWMkmLNtTw
        ==
X-ME-Sender: <xms:fNX8XMtkcOBFo4wZ-sGTk9kzFQR9hxXIWTnJPjcNPACitirAleU2zA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:fNX8XE_fnyIr4i2PQPuR8wRkWpf6oW43osUNVrFOn7z43aYUbfjecg>
    <xmx:fNX8XOM4KEXXisxkloJ8oybGneonGtXkJUXjMNVGZp2_NSNrWn2Vig>
    <xmx:fNX8XKHnlRWfTUGqkWS4ZHX15JTRiM0YpTZ1VOl3y6yasuaGSGD2HA>
    <xmx:fNX8XJ0jRzzOLx5YxulQERKFLIGVhy4cPSEYFBBvQn5wLhArPH5y9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDB3A80059;
        Sun,  9 Jun 2019 05:46:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled" failed to apply to 4.14-stable tree
To:     wuyihao@linux.alibaba.com, Anna.Schumaker@Netapp.com,
        jlayton@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:46:26 +0200
Message-ID: <1560073586152178@kroah.com>
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

