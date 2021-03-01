Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6A328F3F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhCATsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239903AbhCAThy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:37:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314DA65332;
        Mon,  1 Mar 2021 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620685;
        bh=88hT5iEwyS/israhNPTwb5lWWxKqFqB6jEsxk2A4Uzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVzC7Hxey0s9s2sXReRaKNzeJcvUfAhzD6/fgQbr/TJuNZobb4gY4+JNid8LziPw8
         hV6DY5eqenc03jcxi4owWOpt/Zoa0QHbiau03qHA+GTSoffpG4JVKV6WD4dehrlHjJ
         1T+Oq6VfgtVKrXbhQlQzno9RYQUGxtW0uMdY8vgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 243/775] crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)
Date:   Mon,  1 Mar 2021 17:06:51 +0100
Message-Id: <20210301161213.645614972@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 416b846757bcea20006a9197e67ba3a8b5b2a680 ]

Talitos Security Engine AESU considers any input
data size that is not a multiple of 16 bytes to be an error.
This is not a problem in general, except for Counter mode
that is a stream cipher and can have an input of any size.

Test Manager for ctr(aes) fails on 4th test vector which has
a length of 499 while all previous vectors which have a 16 bytes
multiple length succeed.

As suggested by Freescale, round up the input data length to the
nearest 16 bytes.

Fixes: 5e75ae1b3cef ("crypto: talitos - add new crypto modes")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 28 ++++++++++++++++------------
 drivers/crypto/talitos.h |  1 +
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4fd85f31630ac..b656983c1ef4e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1093,11 +1093,12 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
  */
 static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 				 unsigned int offset, int datalen, int elen,
-				 struct talitos_ptr *link_tbl_ptr)
+				 struct talitos_ptr *link_tbl_ptr, int align)
 {
 	int n_sg = elen ? sg_count + 1 : sg_count;
 	int count = 0;
 	int cryptlen = datalen + elen;
+	int padding = ALIGN(cryptlen, align) - cryptlen;
 
 	while (cryptlen && sg && n_sg--) {
 		unsigned int len = sg_dma_len(sg);
@@ -1121,7 +1122,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 			offset += datalen;
 		}
 		to_talitos_ptr(link_tbl_ptr + count,
-			       sg_dma_address(sg) + offset, len, 0);
+			       sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding, 0);
 		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
 		count++;
 		cryptlen -= len;
@@ -1144,10 +1145,11 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      unsigned int len, struct talitos_edesc *edesc,
 			      struct talitos_ptr *ptr, int sg_count,
 			      unsigned int offset, int tbl_off, int elen,
-			      bool force)
+			      bool force, int align)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
+	int aligned_len = ALIGN(len, align);
 
 	if (!src) {
 		to_talitos_ptr(ptr, 0, 0, is_sec1);
@@ -1155,22 +1157,22 @@ static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 	}
 	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
 	if (sg_count == 1 && !force) {
-		to_talitos_ptr(ptr, sg_dma_address(src) + offset, len, is_sec1);
+		to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len, is_sec1);
 		return sg_count;
 	}
 	if (is_sec1) {
-		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, len, is_sec1);
+		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len, is_sec1);
 		return sg_count;
 	}
 	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len, elen,
-					 &edesc->link_tbl[tbl_off]);
+					 &edesc->link_tbl[tbl_off], align);
 	if (sg_count == 1 && !force) {
 		/* Only one segment now, so no link tbl needed*/
 		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
 		return sg_count;
 	}
 	to_talitos_ptr(ptr, edesc->dma_link_tbl +
-			    tbl_off * sizeof(struct talitos_ptr), len, is_sec1);
+			    tbl_off * sizeof(struct talitos_ptr), aligned_len, is_sec1);
 	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
 
 	return sg_count;
@@ -1182,7 +1184,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 			  unsigned int offset, int tbl_off)
 {
 	return talitos_sg_map_ext(dev, src, len, edesc, ptr, sg_count, offset,
-				  tbl_off, 0, false);
+				  tbl_off, 0, false, 1);
 }
 
 /*
@@ -1251,7 +1253,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
 				 sg_count, areq->assoclen, tbl_off, elen,
-				 false);
+				 false, 1);
 
 	if (ret > 1) {
 		tbl_off += ret;
@@ -1271,7 +1273,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		elen = 0;
 	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
 				 sg_count, areq->assoclen, tbl_off, elen,
-				 is_ipsec_esp && !encrypt);
+				 is_ipsec_esp && !encrypt, 1);
 	tbl_off += ret;
 
 	if (!encrypt && is_ipsec_esp) {
@@ -1577,6 +1579,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
+	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
+		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
 
 	/* first DWORD empty */
 
@@ -1597,8 +1601,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/*
 	 * cipher in
 	 */
-	sg_count = talitos_sg_map(dev, areq->src, cryptlen, edesc,
-				  &desc->ptr[3], sg_count, 0, 0);
+	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
+				      sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
 	if (sg_count > 1)
 		sync_needed = true;
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 1469b956948ab..32825119e8805 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -344,6 +344,7 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 
 /* primary execution unit mode (MODE0) and derivatives */
 #define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
+#define	DESC_HDR_MODE0_AESU_MASK	cpu_to_be32(0x00600000)
 #define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_AESU_CTR		cpu_to_be32(0x00600000)
 #define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
-- 
2.27.0



