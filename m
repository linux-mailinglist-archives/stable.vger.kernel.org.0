Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520A5234F1
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbfETMb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390439AbfETMb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AB921721;
        Mon, 20 May 2019 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355516;
        bh=IqBmoSM96v4bYFnjHppE/DaAFI2uFXSkXXCv3Hvb7sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0y34N6BmFTtyio8908sSekf527plYK0BUckR8YlBIrVMflEq2e2mK9XaZt2cb3ZD
         LjPORxOnpuvkuDcpJsU6h8nGE7/deLqIv3hD/NclhOxpplmAuns9bJT2MVppZdF7Dh
         e+Ed6Pq0tlKR8t34aKefQAt+HIi/I/1H9wtYYggw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 024/128] crypto: crypto4xx - fix cfb and ofb "overran dst buffer" issues
Date:   Mon, 20 May 2019 14:13:31 +0200
Message-Id: <20190520115251.191741775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 7e92e1717e3eaf6b322c252947c696b3059f05be upstream.

Currently, crypto4xx CFB and OFB AES ciphers are
failing testmgr's test vectors.

|cfb-aes-ppc4xx encryption overran dst buffer on test vector 3, cfg="in-place"
|ofb-aes-ppc4xx encryption overran dst buffer on test vector 1, cfg="in-place"

This is because of a very subtile "bug" in the hardware that
gets indirectly mentioned in 18.1.3.5 Encryption/Decryption
of the hardware spec:

the OFB and CFB modes for AES are listed there as operation
modes for >>> "Block ciphers" <<<. Which kind of makes sense,
but we would like them to be considered as stream ciphers just
like the CTR mode.

To workaround this issue and stop the hardware from causing
"overran dst buffer" on crypttexts that are not a multiple
of 16 (AES_BLOCK_SIZE), we force the driver to use the scatter
buffers as the go-between.

As a bonus this patch also kills redundant pd_uinfo->num_gd
and pd_uinfo->num_sd setters since the value has already been
set before.

Cc: stable@vger.kernel.org
Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_core.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -714,7 +714,23 @@ int crypto4xx_build_pd(struct crypto_asy
 	size_t offset_to_sr_ptr;
 	u32 gd_idx = 0;
 	int tmp;
-	bool is_busy;
+	bool is_busy, force_sd;
+
+	/*
+	 * There's a very subtile/disguised "bug" in the hardware that
+	 * gets indirectly mentioned in 18.1.3.5 Encryption/Decryption
+	 * of the hardware spec:
+	 * *drum roll* the AES/(T)DES OFB and CFB modes are listed as
+	 * operation modes for >>> "Block ciphers" <<<.
+	 *
+	 * To workaround this issue and stop the hardware from causing
+	 * "overran dst buffer" on crypttexts that are not a multiple
+	 * of 16 (AES_BLOCK_SIZE), we force the driver to use the
+	 * scatter buffers.
+	 */
+	force_sd = (req_sa->sa_command_1.bf.crypto_mode9_8 == CRYPTO_MODE_CFB
+		|| req_sa->sa_command_1.bf.crypto_mode9_8 == CRYPTO_MODE_OFB)
+		&& (datalen % AES_BLOCK_SIZE);
 
 	/* figure how many gd are needed */
 	tmp = sg_nents_for_len(src, assoclen + datalen);
@@ -732,7 +748,7 @@ int crypto4xx_build_pd(struct crypto_asy
 	}
 
 	/* figure how many sd are needed */
-	if (sg_is_last(dst)) {
+	if (sg_is_last(dst) && force_sd == false) {
 		num_sd = 0;
 	} else {
 		if (datalen > PPC4XX_SD_BUFFER_SIZE) {
@@ -807,9 +823,10 @@ int crypto4xx_build_pd(struct crypto_asy
 	pd->sa_len = sa_len;
 
 	pd_uinfo = &dev->pdr_uinfo[pd_entry];
-	pd_uinfo->async_req = req;
 	pd_uinfo->num_gd = num_gd;
 	pd_uinfo->num_sd = num_sd;
+	pd_uinfo->dest_va = dst;
+	pd_uinfo->async_req = req;
 
 	if (iv_len)
 		memcpy(pd_uinfo->sr_va->save_iv, iv, iv_len);
@@ -828,7 +845,6 @@ int crypto4xx_build_pd(struct crypto_asy
 		/* get first gd we are going to use */
 		gd_idx = fst_gd;
 		pd_uinfo->first_gd = fst_gd;
-		pd_uinfo->num_gd = num_gd;
 		gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
 		pd->src = gd_dma;
 		/* enable gather */
@@ -865,17 +881,14 @@ int crypto4xx_build_pd(struct crypto_asy
 		 * Indicate gather array is not used
 		 */
 		pd_uinfo->first_gd = 0xffffffff;
-		pd_uinfo->num_gd = 0;
 	}
-	if (sg_is_last(dst)) {
+	if (!num_sd) {
 		/*
 		 * we know application give us dst a whole piece of memory
 		 * no need to use scatter ring.
 		 */
 		pd_uinfo->using_sd = 0;
 		pd_uinfo->first_sd = 0xffffffff;
-		pd_uinfo->num_sd = 0;
-		pd_uinfo->dest_va = dst;
 		sa->sa_command_0.bf.scatter = 0;
 		pd->dest = (u32)dma_map_page(dev->core_dev->device,
 					     sg_page(dst), dst->offset,
@@ -889,9 +902,7 @@ int crypto4xx_build_pd(struct crypto_asy
 		nbytes = datalen;
 		sa->sa_command_0.bf.scatter = 1;
 		pd_uinfo->using_sd = 1;
-		pd_uinfo->dest_va = dst;
 		pd_uinfo->first_sd = fst_sd;
-		pd_uinfo->num_sd = num_sd;
 		sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
 		pd->dest = sd_dma;
 		/* setup scatter descriptor */


