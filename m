Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4D1ACA91
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897952AbgDPNjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897933AbgDPNjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5553321D94;
        Thu, 16 Apr 2020 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043873;
        bh=z4Y8kmHA0kzaiF82tX9ljWFZJuBuSiiOA2BFNp01Q+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQf6PqqJkSMM4rEGT6DEi47Zw9J9bY60nVlo4emI3uGIRje7Cg0ftgiLt6Qs6V3VI
         kpkLjC/Qf+Y8iBUHd4AUK5yb222m2yJmDHH0NqFEKPPwny1+s8tHXZJakaM2LnG62U
         4eLdKy0n/2Io0t2wSGw4bqvYNaWk+hSF6+8mjvAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/146] crypto: ccree - zero out internal struct before use
Date:   Thu, 16 Apr 2020 15:24:37 +0200
Message-Id: <20200416131301.008084729@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 9f31eb6e08cc1b0eb3926eebf4c51467479a7722 ]

We did not zero out the internal struct before use causing problem
in some rare error code paths.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_aead.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index aa6b45bc13b98..c9233420fe421 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2058,6 +2058,8 @@ static int cc_aead_encrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2087,6 +2089,8 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2106,6 +2110,8 @@ static int cc_aead_decrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2133,6 +2139,8 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2250,6 +2258,8 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2273,6 +2283,8 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	//plaintext is not encryped with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
@@ -2305,6 +2317,8 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 		goto out;
 	}
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
@@ -2328,6 +2342,8 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
 
+	memset(areq_ctx, 0, sizeof(*areq_ctx));
+
 	//plaintext is not decryped with rfc4543
 	areq_ctx->plaintext_authenticate_only = true;
 
-- 
2.20.1



