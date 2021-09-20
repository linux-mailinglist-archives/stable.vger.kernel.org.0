Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5841226D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350848AbhITSPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358098AbhITSF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:05:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA46763248;
        Mon, 20 Sep 2021 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158267;
        bh=nbwWSCKy9q4DxA0i5QSHUj+4pyyuSx6dn3R8lNa2nxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrr5n0grYkQIppYThBGJ1hketPZXID7/DNr0u2ZgVVX7CtbfsspBpK8j1lm/jA1Qb
         AmokbLC6G5ZyrUrsP27QKylLFFRxOzKLVBTh/eYMJOEtie8poSteZH4FSmOBjlA3IF
         MOa2TRY1S2XOj3cLrCVVrIj8+xTX+rx83FxAW8eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/260] SUNRPC: Fix potential memory corruption
Date:   Mon, 20 Sep 2021 18:41:08 +0200
Message-Id: <20210920163932.810824907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index d7ef5b97174c..3c6c4b1dbf1a 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -419,6 +419,7 @@ void			xprt_unlock_connect(struct rpc_xprt *, void *);
 #define XPRT_CONGESTED		(9)
 #define XPRT_CWND_WAIT		(10)
 #define XPRT_WRITE_SPACE	(11)
+#define XPRT_SND_IS_COOKIE	(12)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 639837b3a5d9..3653898f465f 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -729,9 +729,9 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
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
@@ -820,6 +820,7 @@ bool xprt_lock_connect(struct rpc_xprt *xprt,
 		goto out;
 	if (xprt->snd_task != task)
 		goto out;
+	set_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->snd_task = cookie;
 	ret = true;
 out:
@@ -835,6 +836,7 @@ void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 	if (!test_bit(XPRT_LOCKED, &xprt->state))
 		goto out;
 	xprt->snd_task =NULL;
+	clear_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->ops->release_xprt(xprt, NULL);
 	xprt_schedule_autodisconnect(xprt);
 out:
-- 
2.30.2



