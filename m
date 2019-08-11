Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DED289215
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfHKO4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 10:56:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39873 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfHKO4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 10:56:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 184F0203ED;
        Sun, 11 Aug 2019 10:56:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Aug 2019 10:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zgHYvw
        UGAgF+Jw7dkrHlY9VM3DwK/A9IHcCv7CzgzfY=; b=gawZBVBuPSE71AHpdV1Ykl
        ZDQ/jx0Hi88Mg/nXfj1CMDwc5ttRKlkGU/cJcy8hshiABbEzQqyZo4xEObuzPgLL
        ahtlh12FKorMes/HSnY+zuuHO9xkRVNzzu5GIiz/A/3hMbNn7y736FPB2KsiZ0Ep
        vLy2FYw1b8AlsPIbFatz/I+/rghACKzIh/DWSG2kqq0w9uyUEBjWXRpFUmh2YxGr
        4h99w9jblesDkTfBdxQZrfpWCZfID+u2OaTIPnaildEmAsDWGnGrXUDarwAH88oc
        I7PDgdKC+Jue+G7H7sfRiUao4Nlt25nvSUssTQ9jB3KYPQpCEL19DWKPKGpG2k1A
        ==
X-ME-Sender: <xms:pyxQXbalHhCSfKlXpPiViNJuhLQ4201_-He315GwlRNi8OzZdM5OoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:pyxQXUqw8bfkWyf41h1pXE4ABT9IO5XgPtoVqdu-raWGa5KX2UBNHw>
    <xmx:pyxQXftZhBP0se8d2xYd3mU4xZ4ex50z5GK91iLY_rz7ItM9SxVkTQ>
    <xmx:pyxQXWMXvMCXkH0m5XuZbPuddOHXw8wDVKGpG1qEDIhYQltgpkPQbA>
    <xmx:qSxQXf-ZsXVhtOdwubFa9Fw1mdnL6nN8gOI2U5E4G7Elt9krmO-YyA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5488080060;
        Sun, 11 Aug 2019 10:56:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccp - Add support for valid authsize values less than" failed to apply to 4.14-stable tree
To:     gary.hook@amd.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Aug 2019 16:56:38 +0200
Message-ID: <15655353989018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f00baf74e4b6f79a3a3dfab44fb7bb2e797b551 Mon Sep 17 00:00:00 2001
From: Gary R Hook <gary.hook@amd.com>
Date: Tue, 30 Jul 2019 16:05:24 +0000
Subject: [PATCH] crypto: ccp - Add support for valid authsize values less than
 16

AES GCM encryption allows for authsize values of 4, 8, and 12-16 bytes.
Validate the requested authsize, and retain it to save in the request
context.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index d22631cb2bb3..02eba84028b3 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -58,6 +58,19 @@ static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
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
 
@@ -104,6 +117,7 @@ static int ccp_aes_gcm_crypt(struct aead_request *req, bool encrypt)
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
 	INIT_LIST_HEAD(&rctx->cmd.entry);
 	rctx->cmd.engine = CCP_ENGINE_AES;
+	rctx->cmd.u.aes.authsize = crypto_aead_authsize(tfm);
 	rctx->cmd.u.aes.type = ctx->u.aes.type;
 	rctx->cmd.u.aes.mode = ctx->u.aes.mode;
 	rctx->cmd.u.aes.action = encrypt;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 59f9849c3662..ef723e2722a8 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -622,6 +622,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int authsize;
 	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place = true; /* Default value */
@@ -643,6 +644,21 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
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
@@ -657,7 +673,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 		p_tag = scatterwalk_ffwd(sg_tag, p_outp, ilen);
 	} else {
 		/* Input length for decryption includes tag */
-		ilen = aes->src_len - AES_BLOCK_SIZE;
+		ilen = aes->src_len - authsize;
 		p_tag = scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
 
@@ -839,19 +855,19 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 
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
 
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 7e9c991c95e0..43ed9e77cf81 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -173,6 +173,8 @@ struct ccp_aes_engine {
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
 
+	u32 authsize;
+
 	struct scatterlist *key;
 	u32 key_len;		/* In bytes */
 

