Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83911482F6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404426AbgAXLcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404424AbgAXLcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:16 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF792075D;
        Fri, 24 Jan 2020 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865535;
        bh=ykPsnisee6l2ZoXb3npcV1AdZ6los6mJ+xxFfFNMFJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwSIyHrxbwycY8p9zun/a6u2F4dQfdGbrUXQZ9nC5RV8jNTFmCkyp5TEiTBzeSWvL
         /oTg893NAJYf/4QZ66aJgbdVhObe3p2M4cgVthYfhez2T01tiP9DJLGfUfMKllPb/t
         3Ikdg18wge5AoMcSTCes0Y0sYXUux6sH4sfp19BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 572/639] crypto: hisilicon - Matching the dma address for dma_pool_free()
Date:   Fri, 24 Jan 2020 10:32:22 +0100
Message-Id: <20200124093201.055092101@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit e00371af1d4ce73d527d8ee69fda2febaf5a42c2 ]

When dma_pool_zalloc() fail in sec_alloc_and_fill_hw_sgl(),
dma_pool_free() is invoked, but the parameters that sgl_current and
sgl_current->next_sgl is not match.

Using sec_free_hw_sgl() instead of the original free routine.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 44 +++++++++++--------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index db2983c51f1e6..bf9658800bda5 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -153,6 +153,24 @@ static void sec_alg_skcipher_init_context(struct crypto_skcipher *atfm,
 				       ctx->cipher_alg);
 }
 
+static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
+			    dma_addr_t psec_sgl, struct sec_dev_info *info)
+{
+	struct sec_hw_sgl *sgl_current, *sgl_next;
+	dma_addr_t sgl_next_dma;
+
+	sgl_current = hw_sgl;
+	while (sgl_current) {
+		sgl_next = sgl_current->next;
+		sgl_next_dma = sgl_current->next_sgl;
+
+		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
+
+		sgl_current = sgl_next;
+		psec_sgl = sgl_next_dma;
+	}
+}
+
 static int sec_alloc_and_fill_hw_sgl(struct sec_hw_sgl **sec_sgl,
 				     dma_addr_t *psec_sgl,
 				     struct scatterlist *sgl,
@@ -199,36 +217,12 @@ static int sec_alloc_and_fill_hw_sgl(struct sec_hw_sgl **sec_sgl,
 	return 0;
 
 err_free_hw_sgls:
-	sgl_current = *sec_sgl;
-	while (sgl_current) {
-		sgl_next = sgl_current->next;
-		dma_pool_free(info->hw_sgl_pool, sgl_current,
-			      sgl_current->next_sgl);
-		sgl_current = sgl_next;
-	}
+	sec_free_hw_sgl(*sec_sgl, *psec_sgl, info);
 	*psec_sgl = 0;
 
 	return ret;
 }
 
-static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
-			    dma_addr_t psec_sgl, struct sec_dev_info *info)
-{
-	struct sec_hw_sgl *sgl_current, *sgl_next;
-	dma_addr_t sgl_next_dma;
-
-	sgl_current = hw_sgl;
-	while (sgl_current) {
-		sgl_next = sgl_current->next;
-		sgl_next_dma = sgl_current->next_sgl;
-
-		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
-
-		sgl_current = sgl_next;
-		psec_sgl = sgl_next_dma;
-	}
-}
-
 static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen,
 				   enum sec_cipher_alg alg)
-- 
2.20.1



