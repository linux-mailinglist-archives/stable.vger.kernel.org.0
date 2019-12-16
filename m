Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9C121262
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLPRwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfLPRwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 734612072D;
        Mon, 16 Dec 2019 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518728;
        bh=HcUYgSYlUCITTOZa8rSIH+WdoK4E/zfacRzSELwWZYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnN1yWqsj1eOMJjqtjKXGrD/FL8J14VxygUAxFdcUL+Rgl+Xer6g/lBDkkSV4sxG0
         AdHhpJlJXleKQeBMK49yCjqthpEMIarw8gnuR88SoB0h20DyRNdOZ4hfDwGVjQ3s/W
         TMhv4cfLLHw8Y2KY9lV6fTM8I4b0Ynu8W9uqWXqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/267] crypto: bcm - fix normal/non key hash algorithm failure
Date:   Mon, 16 Dec 2019 18:46:08 +0100
Message-Id: <20191216174853.435520386@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index b6be383a51a6a..84422435f39b4 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4637,12 +4637,16 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
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



