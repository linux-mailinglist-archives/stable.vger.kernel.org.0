Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB38111EA7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfLCWw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730066AbfLCWw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B14442084F;
        Tue,  3 Dec 2019 22:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413575;
        bh=pd3AeSBtOZjnIaMKLxGwzgSveNiz/pmLImr/pfQFtRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWEjxvALba7qju1WSSp7mwxIDfpoY08YgK+qKUkj49SkASs+ocUr1marCbL+R5lZR
         B2vk0/S81zMmaaAs2XM03xR3NvCuBJPB/VMqIzfvVTt4D8cWgrfFHgOipMWXRq3qh4
         p1u8yq9KdU1s0j51B4VfBvrhcP+o6DPqrz5KMb4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/321] crypto: mxc-scc - fix build warnings on ARM64
Date:   Tue,  3 Dec 2019 23:34:07 +0100
Message-Id: <20191203223436.543308400@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e01c46387df8d..519086730791b 100644
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



