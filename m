Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA320668C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbgFWVoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgFWUCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5AD2080C;
        Tue, 23 Jun 2020 20:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942556;
        bh=1Jo/vo4tTWbftNChB04q9LW+WzDhrX70cNawXmqn4AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPnyg1XhuepPnBrNfzqXlXd5ssa9qqqojhiysxcZ3EOKEEVgoTcXfccHzkLzt2GH3
         6+PVPldAhOHyvnT1XEfD4jTZTuYOaa/sWkLEqNvxy4niQ6IdnZbJSIWxok4Khxw5zS
         cXqulKbo+QPXjRsoZkBWiKuuf5cloQOoJnBLG8Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 045/477] misc: fastrpc: fix potential fastrpc_invoke_ctx leak
Date:   Tue, 23 Jun 2020 21:50:42 +0200
Message-Id: <20200623195409.736962970@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 74003385cf716f1b88cc7753ca282f5493f204a2 ]

fastrpc_invoke_ctx can have refcount of 2 in error path where
rpmsg_send() fails to send invoke message. decrement the refcount
properly in the error path to fix this leak.

This also fixes below static checker warning:

drivers/misc/fastrpc.c:990 fastrpc_internal_invoke()
warn: 'ctx->refcount.refcount.ref.counter' not decremented on lines: 990.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200512110930.2550-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 9065d3e71ff76..7939c55daceb2 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -904,6 +904,7 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
 	struct fastrpc_channel_ctx *cctx;
 	struct fastrpc_user *fl = ctx->fl;
 	struct fastrpc_msg *msg = &ctx->msg;
+	int ret;
 
 	cctx = fl->cctx;
 	msg->pid = fl->tgid;
@@ -919,7 +920,13 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
 	msg->size = roundup(ctx->msg_sz, PAGE_SIZE);
 	fastrpc_context_get(ctx);
 
-	return rpmsg_send(cctx->rpdev->ept, (void *)msg, sizeof(*msg));
+	ret = rpmsg_send(cctx->rpdev->ept, (void *)msg, sizeof(*msg));
+
+	if (ret)
+		fastrpc_context_put(ctx);
+
+	return ret;
+
 }
 
 static int fastrpc_internal_invoke(struct fastrpc_user *fl,  u32 kernel,
-- 
2.25.1



