Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A097040E25E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbhIPQhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240868AbhIPQfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50E261406;
        Thu, 16 Sep 2021 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809282;
        bh=WBqf/vBFWRB9NSEQio4Knl9VPu/Recc6Uv25YIjUK0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdTGModNbJMcko6D7M53XDUbLedR+opxril8ljy0buFXUtQv57BmmjOX/WmT8wm/f
         2wAIy+UdBzvRvrTVZObvKI4IIxpUKtEYDbyL+oFXPXLYj0dxvztEZ1yeZ2/iH7lO88
         RWw8fT6kc0QwsZ1LTM7NbL6pf6A23idONRk1eHxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 097/380] SUNRPC: Fix potential memory corruption
Date:   Thu, 16 Sep 2021 17:57:34 +0200
Message-Id: <20210916155807.331504436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 61b622e334ee..52e5b11e4b6a 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -422,6 +422,7 @@ void			xprt_unlock_connect(struct rpc_xprt *, void *);
 #define XPRT_CONGESTED		(9)
 #define XPRT_CWND_WAIT		(10)
 #define XPRT_WRITE_SPACE	(11)
+#define XPRT_SND_IS_COOKIE	(12)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 3509a7f139b9..19fa8616b8cf 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -774,9 +774,9 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
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
@@ -865,6 +865,7 @@ bool xprt_lock_connect(struct rpc_xprt *xprt,
 		goto out;
 	if (xprt->snd_task != task)
 		goto out;
+	set_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->snd_task = cookie;
 	ret = true;
 out:
@@ -880,6 +881,7 @@ void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 	if (!test_bit(XPRT_LOCKED, &xprt->state))
 		goto out;
 	xprt->snd_task =NULL;
+	clear_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->ops->release_xprt(xprt, NULL);
 	xprt_schedule_autodisconnect(xprt);
 out:
-- 
2.30.2



