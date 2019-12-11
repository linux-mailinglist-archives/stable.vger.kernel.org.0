Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF81F11B575
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbfLKPSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731384AbfLKPSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476C422527;
        Wed, 11 Dec 2019 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077494;
        bh=4I0T3q26ZC/IpmhFP0sZA/I+ERS2Sv7601iexpXWXBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hl26FWTmNAeTOTb/frj+mO8Vr0Vo8uf5zPXT6eDuaGBHZIlv/3etlia52bex1vPJ/
         P/WWs7fC+b2JMhwlR4CLTusVUvovig4PH1E9GWtO8nTdomzTUVXbBq4xc1XWwTGyhw
         sJ+34ZV8Yd7aPsRmIb2F1/SOasNBQ1/M2cQC4d2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/243] crypto: bcm - fix normal/non key hash algorithm failure
Date:   Wed, 11 Dec 2019 16:03:41 +0100
Message-Id: <20191211150343.084850526@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>

[ Upstream commit 4f0129d13e69bad0363fd75553fb22897b32c379 ]

Remove setkey() callback handler for normal/non key
hash algorithms and keep it for AES-CBC/CMAC which needs key.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index cd464637b0cb6..49c0097fa4749 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4634,12 +4634,16 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
 	hash->halg.statesize = sizeof(struct spu_hash_export_s);
 
 	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
-		hash->setkey = ahash_setkey;
 		hash->init = ahash_init;
 		hash->update = ahash_update;
 		hash->final = ahash_final;
 		hash->finup = ahash_finup;
 		hash->digest = ahash_digest;
+		if ((driver_alg->auth_info.alg == HASH_ALG_AES) &&
+		    ((driver_alg->auth_info.mode == HASH_MODE_XCBC) ||
+		    (driver_alg->auth_info.mode == HASH_MODE_CMAC))) {
+			hash->setkey = ahash_setkey;
+		}
 	} else {
 		hash->setkey = ahash_hmac_setkey;
 		hash->init = ahash_hmac_init;
-- 
2.20.1



