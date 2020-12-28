Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF83A2E39C2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbgL1N1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:27:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389680AbgL1N1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F3C206ED;
        Mon, 28 Dec 2020 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162049;
        bh=Gjs4qdOuDnn63+Pi5qiKnksxD/kUiBp00n4BwzCuhzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBRo2is2hT1MTij7gJM5cxq5br3Ti6jF4JAcDl8lOzXdE5GwgVtx8D+sAQhy+xGpw
         oXbA+nDFnoryUJTKva2glhkI4tA06WWbpJvcj2/YeUFkBS1cDDcs7iZWhWghB8t8l6
         0fSFSq3cinUu1u+IiO0n04+07177XUCQKRefRiZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/346] crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd
Date:   Mon, 28 Dec 2020 13:47:52 +0100
Message-Id: <20201228124927.183394360@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 68d5ea818b6c0..cd00afb5786e8 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -926,7 +926,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
-		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
+		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
 		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
 	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
-- 
2.27.0



