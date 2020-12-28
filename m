Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182C22E41BC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438311AbgL1OHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438303AbgL1OHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3711420731;
        Mon, 28 Dec 2020 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164409;
        bh=Av0ZvDdXrYRO7Vxeh2s11XeTZ2iC8pXcflEjAgmHgKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bL1y8jniVfFuXI6KZ8XsMXmfCEQBOxHljcm7u+tJHGp5uOfBdj79/MnjZS+iIJBa1
         Yjo9OtFs//D0dG3vYzRZrEVHY3fV++eTMfvanL74w0qoUU7J0N3HQPsrEOkTrlhZzG
         vdAvn5bcKfsRdhXz/5CyqaCidm4nR0gU3KqzDhKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/717] crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd
Date:   Mon, 28 Dec 2020 13:42:48 +0100
Message-Id: <20201228125029.103657776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 5bdad829c31a09069fd508534f03c2ea1576ac75 ]

Clang warns:

drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
lower precedence than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
around the '|' expression to silence this warning
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                                                                         ^
                                                                        )
drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
around the '?:' expression to evaluate it first
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                                                                         ^
                 (
1 warning generated.

It looks like this should have been a logical OR so that
PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD. Change the
operator so that everything works properly.

Fixes: 4b5b79998af6 ("crypto: crypto4xx - fix stalls under heavy load")
Link: https://github.com/ClangBuiltLinux/linux/issues/1198
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 981de43ea5e24..2e3690f65786d 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -917,7 +917,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
-		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
+		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
 		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
 	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
-- 
2.27.0



