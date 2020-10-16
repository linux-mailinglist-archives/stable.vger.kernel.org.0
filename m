Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415902900A0
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405050AbgJPJHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405341AbgJPJG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:06:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B8420878;
        Fri, 16 Oct 2020 09:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839219;
        bh=OA9ojlJD5BvhFcZM4dGPho+S/jI+oo7Wg7S4ULiNr1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTq6BAK2+Vb6W8woikmm8+o7KDHuALJ7LyEMJtMb1l+sAr/IMjF2Agy3x3j9BSGeD
         HjUOvGc8pD4m2+u2yeQ7azj1jcK3Xr941NzFFEc/NumWXg4C08V6Zeo7pFgWLxhXs9
         ABFrzIovXJULP9zmhs1fKNLY+Pbh+R0a8u/NQhgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Przychodni <dominik.przychodni@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 16/16] crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA
Date:   Fri, 16 Oct 2020 11:07:09 +0200
Message-Id: <20201016090436.213358749@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
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
@@ -822,6 +822,11 @@ static int qat_alg_aead_dec(struct aead_
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
@@ -836,7 +841,7 @@ static int qat_alg_aead_dec(struct aead_
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_length = cipher_len;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
@@ -865,6 +870,9 @@ static int qat_alg_aead_enc(struct aead_
 	uint8_t *iv = areq->iv;
 	int ret, ctr = 0;
 
+	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;


