Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DED515E961
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392380AbgBNQOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392376AbgBNQOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D821246CD;
        Fri, 14 Feb 2020 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696884;
        bh=aKeGdn6AswwnY5bGNvFbZTnP9hibMN6Y42Cu+W5rI6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLHdwG4in3Lm9/CQIsFuYljSPscMhN9okhFPca/6qwqwRfnxwtZ/KMti6Gosy2Rjg
         lfN6nCuANMireD2T9tKBMmigEiRAStg91M5cqAT4ZZonNhvxC/AGLWNJkAQKpeAs68
         Ib/jDAWYXe2K+L43wBtJ1yWdDOsY0lwnlDL7wYpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 138/252] crypto: artpec6 - return correct error code for failed setkey()
Date:   Fri, 14 Feb 2020 11:09:53 -0500
Message-Id: <20200214161147.15842-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit b828f905904cd76424230c69741a4cabb0174168 ]

->setkey() is supposed to retun -EINVAL for invalid key lengths, not -1.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Lars Persson <lars.persson@axis.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index fdcdc751d03bd..3caf57ebdbff5 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1256,7 +1256,7 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
 
 	if (len != 16 && len != 24 && len != 32) {
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -1;
+		return -EINVAL;
 	}
 
 	ctx->key_length = len;
-- 
2.20.1

