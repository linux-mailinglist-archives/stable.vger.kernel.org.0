Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973A41062A8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfKVGCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfKVGCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C39820714;
        Fri, 22 Nov 2019 06:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402554;
        bh=ItxSqDFiFPe32iS6WA6fvIXptjkKIjmv+gsp8JwxaaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7GSjh5dWdjHX15kn3aGQJZXHK50WPZKo1/wXoSPUNYC6z8OJ5vrf9OJLGwf5jbgh
         jImrjZQQ6yEC+lSn0w1iMTPzQR1ryToepCuFRKopWbNuqRDWid30RBVH5R8QNzVd0S
         B72y5vJqji1+OIk+nYT0e0Qe8JC9aPULgGDZomWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 59/91] crypto: mxc-scc - fix build warnings on ARM64
Date:   Fri, 22 Nov 2019 01:00:57 -0500
Message-Id: <20191122060129.4239-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 2326828ee40357b3d2b1359b8ca7526af201495b ]

The following build warnings are seen when building for ARM64 allmodconfig:

drivers/crypto/mxc-scc.c:181:20: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:186:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:277:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:339:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/crypto/mxc-scc.c:340:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Fix them by using the %zu specifier to print a size_t variable and using
a plain %x to print the result of a readl().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxc-scc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
index ee4be1b0d30ba..0a57b3db2d67e 100644
--- a/drivers/crypto/mxc-scc.c
+++ b/drivers/crypto/mxc-scc.c
@@ -178,12 +178,12 @@ static int mxc_scc_get_data(struct mxc_scc_ctx *ctx,
 	else
 		from = scc->black_memory;
 
-	dev_dbg(scc->dev, "pcopy: from 0x%p %d bytes\n", from,
+	dev_dbg(scc->dev, "pcopy: from 0x%p %zu bytes\n", from,
 		ctx->dst_nents * 8);
 	len = sg_pcopy_from_buffer(ablkreq->dst, ctx->dst_nents,
 				   from, ctx->size, ctx->offset);
 	if (!len) {
-		dev_err(scc->dev, "pcopy err from 0x%p (len=%d)\n", from, len);
+		dev_err(scc->dev, "pcopy err from 0x%p (len=%zu)\n", from, len);
 		return -EINVAL;
 	}
 
@@ -274,7 +274,7 @@ static int mxc_scc_put_data(struct mxc_scc_ctx *ctx,
 	len = sg_pcopy_to_buffer(req->src, ctx->src_nents,
 				 to, len, ctx->offset);
 	if (!len) {
-		dev_err(scc->dev, "pcopy err to 0x%p (len=%d)\n", to, len);
+		dev_err(scc->dev, "pcopy err to 0x%p (len=%zu)\n", to, len);
 		return -EINVAL;
 	}
 
@@ -335,9 +335,9 @@ static void mxc_scc_ablkcipher_next(struct mxc_scc_ctx *ctx,
 		return;
 	}
 
-	dev_dbg(scc->dev, "Start encryption (0x%p/0x%p)\n",
-		(void *)readl(scc->base + SCC_SCM_RED_START),
-		(void *)readl(scc->base + SCC_SCM_BLACK_START));
+	dev_dbg(scc->dev, "Start encryption (0x%x/0x%x)\n",
+		readl(scc->base + SCC_SCM_RED_START),
+		readl(scc->base + SCC_SCM_BLACK_START));
 
 	/* clear interrupt control registers */
 	writel(SCC_SCM_INTR_CTRL_CLR_INTR,
-- 
2.20.1

