Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AF87400E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfGXTYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387906AbfGXTX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:23:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557D922ADC;
        Wed, 24 Jul 2019 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996238;
        bh=Ii1euPYbWfRkA0/IiLxq62q322Ax1cGkDB0EdrZnnjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4PAbtFYZ8droIc3ZUT5T7edDI0/3wRstnZGilAvJZk++mneKu+yiJUDTr0tOSjwc
         n8frGnRtqlnpz9Y6OnbLimcQ9D+oK3k6lInEj3Ix6SkA677psdxy5ZlYeUfA24/l/W
         DhP4BunG/tWFsccO3qYFqgtrIvEmDhD3IM5eirc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 028/413] crypto: caam - avoid S/G table fetching for AEAD zero-length output
Date:   Wed, 24 Jul 2019 21:15:19 +0200
Message-Id: <20190724191737.504594022@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dcd9c76e5a183af4f793beb5141efcd260b8d09f ]

When enabling IOMMU support, the following issue becomes visible
in the AEAD zero-length case.

Even though the output sequence length is set to zero, the crypto engine
tries to prefetch 4 S/G table entries (since SGF bit is set
in SEQ OUT PTR command - which is either generated in SW in case of
caam/jr or in HW in case of caam/qi, caam/qi2).
The DMA read operation will trigger an IOMMU fault since the address in
the SEQ OUT PTR is "dummy" (set to zero / not obtained via DMA API
mapping).

1. In case of caam/jr, avoid the IOMMU fault by clearing the SGF bit
in SEQ OUT PTR command.

2. In case of caam/qi - setting address, bpid, length to zero for output
entry in the compound frame has a special meaning (cf. CAAM RM):
"Output frame = Unspecified, Input address = Y. A unspecified frame is
indicated by an unused SGT entry (an entry in which the Address, Length,
and BPID fields are all zero). SEC obtains output buffers from BMan as
prescribed by the preheader."

Since no output buffers are needed, modify the preheader by setting
(ABS = 1, ADDBUF = 0):
-"ABS = 1 means obtain the number of buffers in ADDBUF (0 or 1) from
the pool POOL ID"
-ADDBUF: "If ABS is set, ADD BUF specifies whether to allocate
a buffer or not"

3. In case of caam/qi2, since engine:
-does not support FLE[FMT]=2'b11 ("unused" entry) mentioned in DPAA2 RM
-requires output entry to be present, even if not used
the solution chosen is to leave output frame list entry zeroized.

Fixes: 763069ba49d3 ("crypto: caam - handle zero-length AEAD output")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c     | 1 +
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 9 +++++++++
 drivers/crypto/caam/qi.c          | 3 +++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..df416e6c1468 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1106,6 +1106,7 @@ static void init_aead_job(struct aead_request *req,
 	if (unlikely(req->src != req->dst)) {
 		if (!edesc->mapped_dst_nents) {
 			dst_dma = 0;
+			out_options = 0;
 		} else if (edesc->mapped_dst_nents == 1) {
 			dst_dma = sg_dma_address(req->dst);
 			out_options = 0;
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index d290d6b41825..116cbc81fa8d 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1109,7 +1109,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dma_to_qm_sg_one_ext(&fd_sgt[0], qm_sg_dma +
 					     (1 + !!ivsize) * sizeof(*sg_table),
 					     out_len, 0);
-	} else if (mapped_dst_nents == 1) {
+	} else if (mapped_dst_nents <= 1) {
 		dma_to_qm_sg_one(&fd_sgt[0], sg_dma_address(req->dst), out_len,
 				 0);
 	} else {
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 2b2980a8a9b9..b949944c8e55 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -559,6 +559,14 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dpaa2_fl_set_addr(out_fle, qm_sg_dma +
 					  (1 + !!ivsize) * sizeof(*sg_table));
 		}
+	} else if (!mapped_dst_nents) {
+		/*
+		 * crypto engine requires the output entry to be present when
+		 * "frame list" FD is used.
+		 * Since engine does not support FMT=2'b11 (unused entry type),
+		 * leaving out_fle zeroized is the best option.
+		 */
+		goto skip_out_fle;
 	} else if (mapped_dst_nents == 1) {
 		dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
 		dpaa2_fl_set_addr(out_fle, sg_dma_address(req->dst));
@@ -570,6 +578,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	dpaa2_fl_set_len(out_fle, out_len);
 
+skip_out_fle:
 	return edesc;
 }
 
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 9f08f84cca59..2d9b0485141f 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -18,6 +18,7 @@
 #include "desc_constr.h"
 
 #define PREHDR_RSLS_SHIFT	31
+#define PREHDR_ABS		BIT(25)
 
 /*
  * Use a reasonable backlog of frames (per CPU) as congestion threshold,
@@ -346,6 +347,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 	 */
 	drv_ctx->prehdr[0] = cpu_to_caam32((1 << PREHDR_RSLS_SHIFT) |
 					   num_words);
+	drv_ctx->prehdr[1] = cpu_to_caam32(PREHDR_ABS);
 	memcpy(drv_ctx->sh_desc, sh_desc, desc_bytes(sh_desc));
 	dma_sync_single_for_device(qidev, drv_ctx->context_a,
 				   sizeof(drv_ctx->sh_desc) +
@@ -401,6 +403,7 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	 */
 	drv_ctx->prehdr[0] = cpu_to_caam32((1 << PREHDR_RSLS_SHIFT) |
 					   num_words);
+	drv_ctx->prehdr[1] = cpu_to_caam32(PREHDR_ABS);
 	memcpy(drv_ctx->sh_desc, sh_desc, desc_bytes(sh_desc));
 	size = sizeof(drv_ctx->prehdr) + sizeof(drv_ctx->sh_desc);
 	hwdesc = dma_map_single(qidev, drv_ctx->prehdr, size,
-- 
2.20.1



