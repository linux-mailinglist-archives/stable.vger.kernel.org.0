Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48953AA98
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbfFIQr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbfFIQrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0664205ED;
        Sun,  9 Jun 2019 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098875;
        bh=5Gn3cKXeLvaaV9cKG5BUsjf22qJuT6vgfoenKD8ddLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/im7NW30Gcg+VMjMuCuDNKX68zVI0ViOl8ZFE9s3N/s04ih9NHcAnU0qqD8Q4ZXc
         y/7m4tPNnYo70feZQswfqzYQ4oKmKgqXJRlJUjMHtEj+vEWEihQp0EOOrf3G4DVjkH
         CGlRSM4sTl8EUK0o87dsOgVuD920nr+sSOyvUcPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihao Wu <wuyihao@linux.alibaba.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 21/51] NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled
Date:   Sun,  9 Jun 2019 18:42:02 +0200
Message-Id: <20190609164128.316056941@linuxfoundation.org>
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

commit ba851a39c9703f09684a541885ed176f8fb7c868 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6905,20 +6905,22 @@ nfs4_retry_setlk(struct nfs4_state *stat
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


