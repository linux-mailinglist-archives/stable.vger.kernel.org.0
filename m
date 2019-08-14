Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80AF8DA4A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfHNROI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbfHNROH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B9D21721;
        Wed, 14 Aug 2019 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802846;
        bh=wZGJe7e6Uqdpt4OkI4Z49JMwrq3Cg/4veuuSin50I8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ua/JuCud7RlnmrTZt6ZKhEwx+nuz2r05sPp2CbuJx1BTVXmFD6XomS/7L8Fca0W7x
         UGRRHmbtZLLJLUZ1JFl74Yt67av7QHQGN74va3OKTIsQyOrikSW9gUAvSypO1gpD4d
         dl6DSyV1b/Tce7whfwJEgpX2RFTrymlqMym8GF9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 12/69] crypto: ccp - Validate buffer lengths for copy operations
Date:   Wed, 14 Aug 2019 19:01:10 +0200
Message-Id: <20190814165746.285884093@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

commit b698a9f4c5c52317db486b069190c7e3d2b97e7e upstream.

The CCP driver copies data between scatter/gather lists and DMA buffers.
The length of the requested copy operation must be checked against
the available destination buffer length.

Reported-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-ops.c |  108 +++++++++++++++++++++++++++++++------------
 1 file changed, 78 insertions(+), 30 deletions(-)

--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -178,14 +178,18 @@ static int ccp_init_dm_workarea(struct c
 	return 0;
 }
 
-static void ccp_set_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
-			    struct scatterlist *sg, unsigned int sg_offset,
-			    unsigned int len)
+static int ccp_set_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
+			   struct scatterlist *sg, unsigned int sg_offset,
+			   unsigned int len)
 {
 	WARN_ON(!wa->address);
 
+	if (len > (wa->length - wa_offset))
+		return -EINVAL;
+
 	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
 				 0);
+	return 0;
 }
 
 static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
@@ -205,8 +209,11 @@ static int ccp_reverse_set_dm_area(struc
 				   unsigned int len)
 {
 	u8 *p, *q;
+	int	rc;
 
-	ccp_set_dm_area(wa, wa_offset, sg, sg_offset, len);
+	rc = ccp_set_dm_area(wa, wa_offset, sg, sg_offset, len);
+	if (rc)
+		return rc;
 
 	p = wa->address + wa_offset;
 	q = p + len - 1;
@@ -509,7 +516,9 @@ static int ccp_run_aes_cmac_cmd(struct c
 		return ret;
 
 	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	if (ret)
+		goto e_key;
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -528,7 +537,9 @@ static int ccp_run_aes_cmac_cmd(struct c
 		goto e_key;
 
 	dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	if (ret)
+		goto e_ctx;
 	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -556,8 +567,10 @@ static int ccp_run_aes_cmac_cmd(struct c
 				goto e_src;
 			}
 
-			ccp_set_dm_area(&ctx, 0, aes->cmac_key, 0,
-					aes->cmac_key_len);
+			ret = ccp_set_dm_area(&ctx, 0, aes->cmac_key, 0,
+					      aes->cmac_key_len);
+			if (ret)
+				goto e_src;
 			ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 					     CCP_PASSTHRU_BYTESWAP_256BIT);
 			if (ret) {
@@ -669,7 +682,9 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		return ret;
 
 	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	if (ret)
+		goto e_key;
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -688,7 +703,9 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		goto e_key;
 
 	dm_offset = CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES - aes->iv_len;
-	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	if (ret)
+		goto e_ctx;
 
 	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
@@ -779,7 +796,9 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		goto e_dst;
 	}
 
-	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	if (ret)
+		goto e_dst;
 
 	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
@@ -829,7 +848,9 @@ static int ccp_run_aes_gcm_cmd(struct cc
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_tag;
-		ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		if (ret)
+			goto e_tag;
 
 		ret = crypto_memneq(tag.address, final_wa.address,
 				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
@@ -924,7 +945,9 @@ static int ccp_run_aes_cmd(struct ccp_cm
 		return ret;
 
 	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	if (ret)
+		goto e_key;
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -945,7 +968,9 @@ static int ccp_run_aes_cmd(struct ccp_cm
 	if (aes->mode != CCP_AES_MODE_ECB) {
 		/* Load the AES context - convert to LE */
 		dm_offset = CCP_SB_BYTES - AES_BLOCK_SIZE;
-		ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+		ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+		if (ret)
+			goto e_ctx;
 		ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 				     CCP_PASSTHRU_BYTESWAP_256BIT);
 		if (ret) {
@@ -1123,8 +1148,12 @@ static int ccp_run_xts_aes_cmd(struct cc
 		 * big endian to little endian.
 		 */
 		dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
-		ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
-		ccp_set_dm_area(&key, 0, xts->key, xts->key_len, xts->key_len);
+		ret = ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
+		if (ret)
+			goto e_key;
+		ret = ccp_set_dm_area(&key, 0, xts->key, xts->key_len, xts->key_len);
+		if (ret)
+			goto e_key;
 	} else {
 		/* Version 5 CCPs use a 512-bit space for the key: each portion
 		 * occupies 256 bits, or one entire slot, and is zero-padded.
@@ -1133,9 +1162,13 @@ static int ccp_run_xts_aes_cmd(struct cc
 
 		dm_offset = CCP_SB_BYTES;
 		pad = dm_offset - xts->key_len;
-		ccp_set_dm_area(&key, pad, xts->key, 0, xts->key_len);
-		ccp_set_dm_area(&key, dm_offset + pad, xts->key, xts->key_len,
-				xts->key_len);
+		ret = ccp_set_dm_area(&key, pad, xts->key, 0, xts->key_len);
+		if (ret)
+			goto e_key;
+		ret = ccp_set_dm_area(&key, dm_offset + pad, xts->key,
+				      xts->key_len, xts->key_len);
+		if (ret)
+			goto e_key;
 	}
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
@@ -1154,7 +1187,9 @@ static int ccp_run_xts_aes_cmd(struct cc
 	if (ret)
 		goto e_key;
 
-	ccp_set_dm_area(&ctx, 0, xts->iv, 0, xts->iv_len);
+	ret = ccp_set_dm_area(&ctx, 0, xts->iv, 0, xts->iv_len);
+	if (ret)
+		goto e_ctx;
 	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_NOOP);
 	if (ret) {
@@ -1297,12 +1332,18 @@ static int ccp_run_des3_cmd(struct ccp_c
 	dm_offset = CCP_SB_BYTES - des3->key_len; /* Basic offset */
 
 	len_singlekey = des3->key_len / 3;
-	ccp_set_dm_area(&key, dm_offset + 2 * len_singlekey,
-			des3->key, 0, len_singlekey);
-	ccp_set_dm_area(&key, dm_offset + len_singlekey,
-			des3->key, len_singlekey, len_singlekey);
-	ccp_set_dm_area(&key, dm_offset,
-			des3->key, 2 * len_singlekey, len_singlekey);
+	ret = ccp_set_dm_area(&key, dm_offset + 2 * len_singlekey,
+			      des3->key, 0, len_singlekey);
+	if (ret)
+		goto e_key;
+	ret = ccp_set_dm_area(&key, dm_offset + len_singlekey,
+			      des3->key, len_singlekey, len_singlekey);
+	if (ret)
+		goto e_key;
+	ret = ccp_set_dm_area(&key, dm_offset,
+			      des3->key, 2 * len_singlekey, len_singlekey);
+	if (ret)
+		goto e_key;
 
 	/* Copy the key to the SB */
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
@@ -1330,7 +1371,10 @@ static int ccp_run_des3_cmd(struct ccp_c
 
 		/* Load the context into the LSB */
 		dm_offset = CCP_SB_BYTES - des3->iv_len;
-		ccp_set_dm_area(&ctx, dm_offset, des3->iv, 0, des3->iv_len);
+		ret = ccp_set_dm_area(&ctx, dm_offset, des3->iv, 0,
+				      des3->iv_len);
+		if (ret)
+			goto e_ctx;
 
 		if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
 			load_mode = CCP_PASSTHRU_BYTESWAP_NOOP;
@@ -1614,8 +1658,10 @@ static int ccp_run_sha_cmd(struct ccp_cm
 		}
 	} else {
 		/* Restore the context */
-		ccp_set_dm_area(&ctx, 0, sha->ctx, 0,
-				sb_count * CCP_SB_BYTES);
+		ret = ccp_set_dm_area(&ctx, 0, sha->ctx, 0,
+				      sb_count * CCP_SB_BYTES);
+		if (ret)
+			goto e_ctx;
 	}
 
 	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
@@ -1937,7 +1983,9 @@ static int ccp_run_passthru_cmd(struct c
 		if (ret)
 			return ret;
 
-		ccp_set_dm_area(&mask, 0, pt->mask, 0, pt->mask_len);
+		ret = ccp_set_dm_area(&mask, 0, pt->mask, 0, pt->mask_len);
+		if (ret)
+			goto e_mask;
 		ret = ccp_copy_to_sb(cmd_q, &mask, op.jobid, op.sb_key,
 				     CCP_PASSTHRU_BYTESWAP_NOOP);
 		if (ret) {


