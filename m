Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893BC1FE566
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgFRCZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgFRBRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7A7221F6;
        Thu, 18 Jun 2020 01:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443037;
        bh=UDd8uk9p2I+v6hhvAwFRHqjl8gWU2ZvEKxxPoMVqz7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/TOxH/Alh5YahRam0e75zAWl33V2Sksk5zoZcN7U98MQFEUqRJS5m1hwrZgATF7h
         3RnrY0tQWichyReeTntqg3+rgB8roK1kBPN45PNc0yrP7d2MoWZ2/laaJ+3GNMLklf
         d/Z22FxQycYHdbFs0LYe2nMQ/FRXu4UpBE9LesXE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 034/266] misc: fastrpc: fix potential fastrpc_invoke_ctx leak
Date:   Wed, 17 Jun 2020 21:12:39 -0400
Message-Id: <20200618011631.604574-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ee3291f7e615..3a5d2890fe2a 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -886,6 +886,7 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
 	struct fastrpc_channel_ctx *cctx;
 	struct fastrpc_user *fl = ctx->fl;
 	struct fastrpc_msg *msg = &ctx->msg;
+	int ret;
 
 	cctx = fl->cctx;
 	msg->pid = fl->tgid;
@@ -901,7 +902,13 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
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

