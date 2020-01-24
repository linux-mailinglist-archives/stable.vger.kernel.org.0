Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C754C1481CD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391257AbgAXLWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390837AbgAXLWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:50 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61353206D4;
        Fri, 24 Jan 2020 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864969;
        bh=4RKtbmS6F7Gak8AF2aCwYGh6cakAIBpKF6wuJUN/bX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKEWItH0J5IjKUZcPoknWQ+AiFfm7Zlpc+s48cpLuxYDNW0j1wY+pwindAiZvzZjD
         bzT/IfcbrC0CedXN7dOzlfNltH8U5ItpGvgAppdRkFxtpiXNCTj6Q7I/DPdaWeCw+u
         K0kfAXv17Clvr9daaYw7vgFpj5M1OCUYx3aCUz/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 403/639] crypto: talitos - fix AEAD processing.
Date:   Fri, 24 Jan 2020 10:29:33 +0100
Message-Id: <20200124093137.526450037@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit e345177ded17611e36c067751d63d64bf106cb54 ]

This driver is working well in 'simple cases', but as soon as
more exotic SG lists are provided (dst different from src,
auth part not in a single SG fragment, ...) there are
wrong results, overruns, etc ...

This patch cleans up the AEAD processing by:
- Simplifying the location of 'out of line' ICV
- Never using 'out of line' ICV on encryp
- Always using 'out of line' ICV on decrypt
- Forcing the generation of a SG table on decrypt

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 158 +++++++++++++--------------------------
 drivers/crypto/talitos.h |   2 +-
 2 files changed, 55 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 634ae487c372e..db5f939f5aa35 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -974,8 +974,8 @@ static void ipsec_esp_unmap(struct device *dev,
 					 DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, cryptlen,
-			 areq->assoclen);
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst,
+			 cryptlen + authsize, areq->assoclen);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -996,30 +996,15 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 				   struct talitos_desc *desc, void *context,
 				   int err)
 {
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	struct aead_request *areq = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	unsigned int authsize = crypto_aead_authsize(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
-	void *icvdata;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, areq, true);
 
-	/* copy the generated ICV to dst */
-	if (edesc->icv_ool) {
-		if (is_sec1)
-			icvdata = edesc->buf + areq->assoclen + areq->cryptlen;
-		else
-			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2];
-		sg_pcopy_from_buffer(areq->dst, edesc->dst_nents ? : 1, icvdata,
-				     authsize, areq->assoclen + areq->cryptlen);
-	}
-
 	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
 
 	kfree(edesc);
@@ -1036,39 +1021,15 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_edesc *edesc;
 	char *oicv, *icv;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, req, false);
 
 	if (!err) {
-		char icvdata[SHA512_DIGEST_SIZE];
-		int nents = edesc->dst_nents ? : 1;
-		unsigned int len = req->assoclen + req->cryptlen;
-
 		/* auth check */
-		if (nents > 1) {
-			sg_pcopy_to_buffer(req->dst, nents, icvdata, authsize,
-					   len - authsize);
-			icv = icvdata;
-		} else {
-			icv = (char *)sg_virt(req->dst) + len - authsize;
-		}
-
-		if (edesc->dma_len) {
-			if (is_sec1)
-				oicv = (char *)&edesc->dma_link_tbl +
-					       req->assoclen + req->cryptlen;
-			else
-				oicv = (char *)
-				       &edesc->link_tbl[edesc->src_nents +
-							edesc->dst_nents + 2];
-			if (edesc->icv_ool)
-				icv = oicv + authsize;
-		} else
-			oicv = (char *)&edesc->link_tbl[0];
+		oicv = edesc->buf + edesc->dma_len;
+		icv = oicv - authsize;
 
 		err = crypto_memneq(oicv, icv, authsize) ? -EBADMSG : 0;
 	}
@@ -1104,11 +1065,12 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
  * stop at cryptlen bytes
  */
 static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
-				 unsigned int offset, int cryptlen,
+				 unsigned int offset, int datalen, int elen,
 				 struct talitos_ptr *link_tbl_ptr)
 {
-	int n_sg = sg_count;
+	int n_sg = elen ? sg_count + 1 : sg_count;
 	int count = 0;
+	int cryptlen = datalen + elen;
 
 	while (cryptlen && sg && n_sg--) {
 		unsigned int len = sg_dma_len(sg);
@@ -1123,11 +1085,20 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 		if (len > cryptlen)
 			len = cryptlen;
 
+		if (datalen > 0 && len > datalen) {
+			to_talitos_ptr(link_tbl_ptr + count,
+				       sg_dma_address(sg) + offset, datalen, 0);
+			to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
+			count++;
+			len -= datalen;
+			offset += datalen;
+		}
 		to_talitos_ptr(link_tbl_ptr + count,
 			       sg_dma_address(sg) + offset, len, 0);
 		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
 		count++;
 		cryptlen -= len;
+		datalen -= len;
 		offset = 0;
 
 next:
@@ -1137,7 +1108,7 @@ next:
 	/* tag end of link table */
 	if (count > 0)
 		to_talitos_ptr_ext_set(link_tbl_ptr + count - 1,
-				       DESC_PTR_LNKTBL_RETURN, 0);
+				       DESC_PTR_LNKTBL_RET, 0);
 
 	return count;
 }
@@ -1145,7 +1116,8 @@ next:
 static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      unsigned int len, struct talitos_edesc *edesc,
 			      struct talitos_ptr *ptr, int sg_count,
-			      unsigned int offset, int tbl_off, int elen)
+			      unsigned int offset, int tbl_off, int elen,
+			      bool force)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1155,7 +1127,7 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 		return 1;
 	}
 	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
-	if (sg_count == 1) {
+	if (sg_count == 1 && !force) {
 		to_talitos_ptr(ptr, sg_dma_address(src) + offset, len, is_sec1);
 		return sg_count;
 	}
@@ -1163,9 +1135,9 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, len, is_sec1);
 		return sg_count;
 	}
-	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len + elen,
+	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len, elen,
 					 &edesc->link_tbl[tbl_off]);
-	if (sg_count == 1) {
+	if (sg_count == 1 && !force) {
 		/* Only one segment now, so no link tbl needed*/
 		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
 		return sg_count;
@@ -1183,7 +1155,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 			  unsigned int offset, int tbl_off)
 {
 	return talitos_sg_map_ext(dev, src, len, edesc, ptr, sg_count, offset,
-				  tbl_off, 0);
+				  tbl_off, 0, false);
 }
 
 /*
@@ -1211,6 +1183,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
 	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
 	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
+	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
 
 	/* hmac key */
 	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
@@ -1250,7 +1223,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		elen = authsize;
 
 	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
-				 sg_count, areq->assoclen, tbl_off, elen);
+				 sg_count, areq->assoclen, tbl_off, elen,
+				 false);
 
 	if (ret > 1) {
 		tbl_off += ret;
@@ -1264,55 +1238,35 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
 	}
 
-	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
-			     sg_count, areq->assoclen, tbl_off);
-
-	if (is_ipsec_esp)
-		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
+	if (is_ipsec_esp && encrypt)
+		elen = authsize;
+	else
+		elen = 0;
+	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
+				 sg_count, areq->assoclen, tbl_off, elen,
+				 is_ipsec_esp && !encrypt);
+	tbl_off += ret;
 
 	/* ICV data */
-	if (ret > 1) {
-		tbl_off += ret;
-		edesc->icv_ool = true;
-		sync_needed = true;
+	edesc->icv_ool = !encrypt;
 
-		if (is_ipsec_esp) {
-			struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
-			int offset = (edesc->src_nents + edesc->dst_nents + 2) *
-				     sizeof(struct talitos_ptr) + authsize;
+	if (!encrypt && is_ipsec_esp) {
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
-			/* Add an entry to the link table for ICV data */
-			to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
-			to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN,
-					       is_sec1);
+		/* Add an entry to the link table for ICV data */
+		to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
+		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET, is_sec1);
 
-			/* icv data follows link tables */
-			to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl + offset,
-				       authsize, is_sec1);
-		} else {
-			dma_addr_t addr = edesc->dma_link_tbl;
-
-			if (is_sec1)
-				addr += areq->assoclen + cryptlen;
-			else
-				addr += sizeof(struct talitos_ptr) * tbl_off;
-
-			to_talitos_ptr(&desc->ptr[6], addr, authsize, is_sec1);
-		}
+		/* icv data follows link tables */
+		to_talitos_ptr(tbl_ptr, dma_icv, authsize, is_sec1);
+		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
+		sync_needed = true;
+	} else if (!encrypt) {
+		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize, is_sec1);
+		sync_needed = true;
 	} else if (!is_ipsec_esp) {
-		ret = talitos_sg_map(dev, areq->dst, authsize, edesc,
-				     &desc->ptr[6], sg_count, areq->assoclen +
-							      cryptlen,
-				     tbl_off);
-		if (ret > 1) {
-			tbl_off += ret;
-			edesc->icv_ool = true;
-			sync_needed = true;
-		} else {
-			edesc->icv_ool = false;
-		}
-	} else {
-		edesc->icv_ool = false;
+		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
+			       sg_count, areq->assoclen + cryptlen, tbl_off);
 	}
 
 	/* iv out */
@@ -1395,18 +1349,18 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	 * and space for two sets of ICVs (stashed and generated)
 	 */
 	alloc_len = sizeof(struct talitos_edesc);
-	if (src_nents || dst_nents) {
+	if (src_nents || dst_nents || !encrypt) {
 		if (is_sec1)
 			dma_len = (src_nents ? src_len : 0) +
-				  (dst_nents ? dst_len : 0);
+				  (dst_nents ? dst_len : 0) + authsize;
 		else
 			dma_len = (src_nents + dst_nents + 2) *
-				  sizeof(struct talitos_ptr) + authsize * 2;
+				  sizeof(struct talitos_ptr) + authsize;
 		alloc_len += dma_len;
 	} else {
 		dma_len = 0;
-		alloc_len += icv_stashing ? authsize : 0;
 	}
+	alloc_len += icv_stashing ? authsize : 0;
 
 	/* if its a ahash, add space for a second desc next to the first one */
 	if (is_sec1 && !dst)
@@ -1500,11 +1454,7 @@ static int aead_decrypt(struct aead_request *req)
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
 
 	/* stash incoming ICV for later cmp with ICV generated by the h/w */
-	if (edesc->dma_len)
-		icvdata = (char *)&edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 2];
-	else
-		icvdata = &edesc->link_tbl[0];
+	icvdata = edesc->buf + edesc->dma_len;
 
 	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
 			   req->assoclen + req->cryptlen - authsize);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 979f6a61e545f..cb0137e131cc8 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -442,5 +442,5 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 
 /* link table extent field bits */
 #define DESC_PTR_LNKTBL_JUMP			0x80
-#define DESC_PTR_LNKTBL_RETURN			0x02
+#define DESC_PTR_LNKTBL_RET			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
-- 
2.20.1



