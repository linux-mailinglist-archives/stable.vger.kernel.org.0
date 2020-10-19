Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AD7292C41
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgJSRDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:03:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32812 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgJSRCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:43 -0400
Date:   Mon, 19 Oct 2020 17:02:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126960;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=BrswgScNJ+fYSR/qepwJ/3Q4GT0OpTzS5j5S5x19ZIQ=;
        b=nkARTXNfOSGkogtjdDxSLhJOxNR87rVM2ppQgSJLuNTnPBiPBcTZUJF0GZ+R7lbU7N30MD
        1XUmNUyVkY+AaXy0HfjOylYKFTMNypA0bvwPRS1la4c0H+ypLHXEQ1s1dn6/DfOKzfoyQ7
        5b1xmGJkEPhR35eTtkdvaMGAqD5BRYUD83QMK8g15Hw7lqmhtnwnrXjMqOwAEArkqkduRN
        DoDlabeGhtqnF/Y/WdDQEohD3RFU5TUuOLfPHlB5isOppPcFysPcvBULFnsDDa4njnlbqR
        zZwVHaTE40tx4+p1oMNpb8YB0QDbywNsFRGisL2VgUSenErX1djClzMXqCBoRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126960;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=BrswgScNJ+fYSR/qepwJ/3Q4GT0OpTzS5j5S5x19ZIQ=;
        b=bSUTdiClWmWCFDOEAon0rGFeQI25nBoTXAOofAokEBRuZrrOP9jCmgq44ZjVrAfJUey1yP
        +3/6U6szqRAI8mCQ==
From:   "tip-bot2 for Dominik Przychodni" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] crypto: qat - check cipher length for aead
 AES-CBC-HMAC-SHA
Cc:     <stable@vger.kernel.org>,
        Dominik Przychodni <dominik.przychodni@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160312696001.7002.14458961892848492825.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     876ca389c95c69b0328ee887ab89207b7e4a66a3
Gitweb:        https://git.kernel.org/tip/876ca389c95c69b0328ee887ab89207b7e4a66a3
Author:        Dominik Przychodni <dominik.przychodni@intel.com>
AuthorDate:    Mon, 31 Aug 2020 11:59:59 +01:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:22 +02:00

crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

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
 drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 72753b8..d552dbc 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -828,6 +828,11 @@ static int qat_alg_aead_dec(struct aead_request *areq)
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
@@ -842,7 +847,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_length = cipher_len;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
@@ -871,6 +876,9 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	u8 *iv = areq->iv;
 	int ret, ctr = 0;
 
+	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
