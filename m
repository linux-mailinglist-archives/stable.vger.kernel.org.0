Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6E08DBDA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfHNRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbfHNRC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750F62084D;
        Wed, 14 Aug 2019 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802148;
        bh=lhftuqc3iQwRdX2KnXA9ThOiKqYNzqiMvpd2PdFQ42M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR7SxHJgaonzzNiXHR/TS2D4oo++g9q8lH9TCvwhe7Hpr1blsB+3sXZGisSH8o2sW
         89ifNOSccSlhRzqWVteA/3CHO6bSAWTGGsGkx310nyK3VbhLCeRi41Ej9+UeiSJ3t9
         +C//gTMpLjaayMqqnrsMU/2gEkilduOqPqHvjCws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 013/144] crypto: ccp - Add support for valid authsize values less than 16
Date:   Wed, 14 Aug 2019 18:59:29 +0200
Message-Id: <20190814165800.495469793@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

commit 9f00baf74e4b6f79a3a3dfab44fb7bb2e797b551 upstream.

AES GCM encryption allows for authsize values of 4, 8, and 12-16 bytes.
Validate the requested authsize, and retain it to save in the request
context.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |   14 ++++++++++++++
 drivers/crypto/ccp/ccp-ops.c               |   26 +++++++++++++++++++++-----
 include/linux/ccp.h                        |    2 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -58,6 +58,19 @@ static int ccp_aes_gcm_setkey(struct cry
 static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 				   unsigned int authsize)
 {
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -104,6 +117,7 @@ static int ccp_aes_gcm_crypt(struct aead
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
 	INIT_LIST_HEAD(&rctx->cmd.entry);
 	rctx->cmd.engine = CCP_ENGINE_AES;
+	rctx->cmd.u.aes.authsize = crypto_aead_authsize(tfm);
 	rctx->cmd.u.aes.type = ctx->u.aes.type;
 	rctx->cmd.u.aes.mode = ctx->u.aes.mode;
 	rctx->cmd.u.aes.action = encrypt;
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -622,6 +622,7 @@ static int ccp_run_aes_gcm_cmd(struct cc
 
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int authsize;
 	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place = true; /* Default value */
@@ -643,6 +644,21 @@ static int ccp_run_aes_gcm_cmd(struct cc
 	if (!aes->key) /* Gotta have a key SGL */
 		return -EINVAL;
 
+	/* Zero defaults to 16 bytes, the maximum size */
+	authsize = aes->authsize ? aes->authsize : AES_BLOCK_SIZE;
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* First, decompose the source buffer into AAD & PT,
 	 * and the destination buffer into AAD, CT & tag, or
 	 * the input into CT & tag.
@@ -657,7 +673,7 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		p_tag = scatterwalk_ffwd(sg_tag, p_outp, ilen);
 	} else {
 		/* Input length for decryption includes tag */
-		ilen = aes->src_len - AES_BLOCK_SIZE;
+		ilen = aes->src_len - authsize;
 		p_tag = scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
 
@@ -839,19 +855,19 @@ static int ccp_run_aes_gcm_cmd(struct cc
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
-		ccp_get_dm_area(&final_wa, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ccp_get_dm_area(&final_wa, 0, p_tag, 0, authsize);
 	} else {
 		/* Does this ciphered tag match the input? */
-		ret = ccp_init_dm_workarea(&tag, cmd_q, AES_BLOCK_SIZE,
+		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_tag;
-		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
 		if (ret)
 			goto e_tag;
 
 		ret = crypto_memneq(tag.address, final_wa.address,
-				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
+				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -170,6 +170,8 @@ struct ccp_aes_engine {
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
 
+	u32 authsize;
+
 	struct scatterlist *key;
 	u32 key_len;		/* In bytes */
 


