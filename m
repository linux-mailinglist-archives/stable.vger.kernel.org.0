Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E051481AC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391135AbgAXLVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390522AbgAXLVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1752075D;
        Fri, 24 Jan 2020 11:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864913;
        bh=IODptUNHUasedGKHmhUQ10ZnXdsVBZIRPb84G/A80QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKL87RdiyO+QiNGWZ24ax47p+YnipPoWe5WgaQ3jrw2bAQ7JWyg13B+LUeHSi5zjB
         diq5Xk1wPVE9VKN8hdSPwwuRfii3bbLL7tTjmujte2u2dDJv32UcUtWwxJFd1TYY4v
         ycJag/p4ny5d1KMIrP/dVAImloVllT+5+YkThYoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 386/639] crypto: ccp - fix AES CFB error exposed by new test vectors
Date:   Fri, 24 Jan 2020 10:29:16 +0100
Message-Id: <20200124093135.309230275@linuxfoundation.org>
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

From: Hook, Gary <Gary.Hook@amd.com>

[ Upstream commit c3b359d6567c0b8f413e924feb37cf025067d55a ]

Updated testmgr will exhibit this error message when loading the
ccp-crypto module:

alg: skcipher: cfb-aes-ccp encryption failed with err -22 on test vector 3, cfg="in-place"

Update the CCP crypto driver to correctly treat CFB as a streaming mode
cipher (instead of block mode). Update the configuration for CFB to
specify the block size as a single byte;

Fixes: 2b789435d7f3 ('crypto: ccp - CCP AES crypto API support')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-crypto-aes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 89291c15015cd..3f768699332ba 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * AMD Cryptographic Coprocessor (CCP) AES crypto API support
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013-2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -79,8 +80,7 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	if (((ctx->u.aes.mode == CCP_AES_MODE_ECB) ||
-	     (ctx->u.aes.mode == CCP_AES_MODE_CBC) ||
-	     (ctx->u.aes.mode == CCP_AES_MODE_CFB)) &&
+	     (ctx->u.aes.mode == CCP_AES_MODE_CBC)) &&
 	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
 
@@ -291,7 +291,7 @@ static struct ccp_aes_def aes_algs[] = {
 		.version	= CCP_VERSION(3, 0),
 		.name		= "cfb(aes)",
 		.driver_name	= "cfb-aes-ccp",
-		.blocksize	= AES_BLOCK_SIZE,
+		.blocksize	= 1,
 		.ivsize		= AES_BLOCK_SIZE,
 		.alg_defaults	= &ccp_aes_defaults,
 	},
-- 
2.20.1



