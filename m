Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2393329011A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405437AbgJPJMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404835AbgJPJLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ABBA21527;
        Fri, 16 Oct 2020 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839506;
        bh=2y3n9mzb6W4INL+zTquuGFKntlcEoY+vd3Ft5ESAUrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WabbCf+AxQQPOOOPm2R+36Sm9RtYKmNkgh8Ty7/aqsUikkcyJta6trIub5neBiOiJ
         FPamT4vaXFTFTjWtOegKZ3YnuwqpHLuIhoO0dNmsQn8+G7HHtXTymbGmPPuKAMwWYf
         8xFi4N5/LaFMB6vLlgey3CftLyowShZYXkLfg9KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Przychodni <dominik.przychodni@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.9 15/15] crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA
Date:   Fri, 16 Oct 2020 11:08:17 +0200
Message-Id: <20201016090437.920293529@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
References: <20201016090437.170032996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Przychodni <dominik.przychodni@intel.com>

commit 45cb6653b0c355fc1445a8069ba78a4ce8720511 upstream.

Return -EINVAL for authenc(hmac(sha1),cbc(aes)),
authenc(hmac(sha256),cbc(aes)) and authenc(hmac(sha512),cbc(aes))
if the cipher length is not multiple of the AES block.
This is to prevent an undefined device behaviour.

Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
[giovanni.cabiddu@intel.com: reworded commit message]
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/qat/qat_common/qat_algs.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -828,6 +828,11 @@ static int qat_alg_aead_dec(struct aead_
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
 	int ret, ctr = 0;
+	u32 cipher_len;
+
+	cipher_len = areq->cryptlen - digst_size;
+	if (cipher_len % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -842,7 +847,7 @@ static int qat_alg_aead_dec(struct aead_
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_length = cipher_len;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
@@ -871,6 +876,9 @@ static int qat_alg_aead_enc(struct aead_
 	u8 *iv = areq->iv;
 	int ret, ctr = 0;
 
+	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;


