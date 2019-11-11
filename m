Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F4DF7D76
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfKKS5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfKKS5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB53920659;
        Mon, 11 Nov 2019 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498624;
        bh=Xn9xmVhJbceB5TGo945eRhwsCmVWx9YAH+0OcuDbu0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/OiCAUzHN4spkNqzzpIc+aLQ8t+wCivsxh3rj1TMytuRriy0+14z8lzvLpjTE1Bp
         23/swtMGLam+Cm51kSkL/mBeqZ6mkFfabWRi8y/ZuNR+DYp2XL+wMcR7bybHVpXyJj
         9NgBs1uZQfNBRHA6xKyqYaoVfeLTkHMVcF1wCoZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Brown <neilb@suse.de>,
        kbuild test robot <lkp@intel.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 173/193] SUNRPC: Destroy the back channel when we destroy the host transport
Date:   Mon, 11 Nov 2019 19:29:15 +0100
Message-Id: <20191111181513.881682174@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 669996add4c92476e0f8d6b4cd2bb308d1939fd7 ]

When we're destroying the host transport mechanism, we should ensure
that we do not leak memory by failing to release any back channel
slots that might still exist.

Reported-by: Neil Brown <neilb@suse.de>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/bc_xprt.h | 5 +++++
 net/sunrpc/backchannel_rqst.c  | 2 +-
 net/sunrpc/xprt.c              | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/bc_xprt.h b/include/linux/sunrpc/bc_xprt.h
index 87d27e13d8859..d796058cdff2a 100644
--- a/include/linux/sunrpc/bc_xprt.h
+++ b/include/linux/sunrpc/bc_xprt.h
@@ -64,6 +64,11 @@ static inline int xprt_setup_backchannel(struct rpc_xprt *xprt,
 	return 0;
 }
 
+static inline void xprt_destroy_backchannel(struct rpc_xprt *xprt,
+					    unsigned int max_reqs)
+{
+}
+
 static inline bool svc_is_backchannel(const struct svc_rqst *rqstp)
 {
 	return false;
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 7eb251372f947..195b40c5dae4b 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -220,7 +220,7 @@ void xprt_destroy_bc(struct rpc_xprt *xprt, unsigned int max_reqs)
 		goto out;
 
 	spin_lock_bh(&xprt->bc_pa_lock);
-	xprt->bc_alloc_max -= max_reqs;
+	xprt->bc_alloc_max -= min(max_reqs, xprt->bc_alloc_max);
 	list_for_each_entry_safe(req, tmp, &xprt->bc_pa_list, rq_bc_pa_list) {
 		dprintk("RPC:        req=%p\n", req);
 		list_del(&req->rq_bc_pa_list);
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 20631d64312cb..ac796f3d42409 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1935,6 +1935,11 @@ static void xprt_destroy_cb(struct work_struct *work)
 	rpc_destroy_wait_queue(&xprt->sending);
 	rpc_destroy_wait_queue(&xprt->backlog);
 	kfree(xprt->servername);
+	/*
+	 * Destroy any existing back channel
+	 */
+	xprt_destroy_backchannel(xprt, UINT_MAX);
+
 	/*
 	 * Tear down transport state and free the rpc_xprt
 	 */
-- 
2.20.1



