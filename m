Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B006E13E503
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbgAPRMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390385AbgAPRMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155FF24698;
        Thu, 16 Jan 2020 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194725;
        bh=NEJ9cspdl9wGfVplcbENKdgyFw0bHoTrRFhM9X9pK4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4bA+mFHOr2FWN58RHdQT8cALrbU4O/4F9sU/67mtKXRIoeEF1m2Yz57RY60hCoFX
         zfQsCU8elNowf2+PVerS56sGgfOllqYABZwtBJqnM3MruQxU/1Z4NPh72EZSE7tfjE
         5/droG66x6CsyJDT3MIYUp6VzdiXB7fB3363QNN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 559/671] crypto: hisilicon - Matching the dma address for dma_pool_free()
Date:   Thu, 16 Jan 2020 12:03:17 -0500
Message-Id: <20200116170509.12787-296-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index db2983c51f1e..bf9658800bda 100644
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

