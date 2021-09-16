Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098940E5F2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349703AbhIPRQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350362AbhIPRN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D59FC619F6;
        Thu, 16 Sep 2021 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810344;
        bh=/9ZeHPsAYaa/bfOWXBSn4lSroZxotpqoYmEanuFiTM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTJg4aJY4JOIei+O5N2jXxsA0RROgrJbHgqpqLo8TchXtOvKmvZ2LuyXEnvE1p292
         Osk/aYftrYidc2R9yZ6eFl5GqDSX9OwvOc6ysv0/W9pMD03ZjKscUoIvl/gkzboOf8
         QsvgFsdIvtjaWhfze2lquOAMV5QCmwMkJCbG0pPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 107/432] SUNRPC: Fix potential memory corruption
Date:   Thu, 16 Sep 2021 17:57:36 +0200
Message-Id: <20210916155814.393357131@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c2dc3e5fad13aca5d7bdf4bcb52b1a1d707c8555 ]

We really should not call rpc_wake_up_queued_task_set_status() with
xprt->snd_task as an argument unless we are certain that is actually an
rpc_task.

Fixes: 0445f92c5d53 ("SUNRPC: Fix disconnection races")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprt.h | 1 +
 net/sunrpc/xprt.c           | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index c8c39f22d3b1..59cd97da895b 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -432,6 +432,7 @@ void			xprt_release_write(struct rpc_xprt *, struct rpc_task *);
 #define XPRT_CONGESTED		(9)
 #define XPRT_CWND_WAIT		(10)
 #define XPRT_WRITE_SPACE	(11)
+#define XPRT_SND_IS_COOKIE	(12)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index fb6db09725c7..bddd354a0076 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -775,9 +775,9 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
 	/* Try to schedule an autoclose RPC call */
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	else if (xprt->snd_task)
+	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
 		rpc_wake_up_queued_task_set_status(&xprt->pending,
-				xprt->snd_task, -ENOTCONN);
+						   xprt->snd_task, -ENOTCONN);
 	spin_unlock(&xprt->transport_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_force_disconnect);
@@ -866,6 +866,7 @@ bool xprt_lock_connect(struct rpc_xprt *xprt,
 		goto out;
 	if (xprt->snd_task != task)
 		goto out;
+	set_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->snd_task = cookie;
 	ret = true;
 out:
@@ -881,6 +882,7 @@ void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 	if (!test_bit(XPRT_LOCKED, &xprt->state))
 		goto out;
 	xprt->snd_task =NULL;
+	clear_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->ops->release_xprt(xprt, NULL);
 	xprt_schedule_autodisconnect(xprt);
 out:
-- 
2.30.2



