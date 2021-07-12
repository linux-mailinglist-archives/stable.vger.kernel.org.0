Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF10A3C4906
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbhGLGlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238451AbhGLGkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F106113A;
        Mon, 12 Jul 2021 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071844;
        bh=PwLa1igOKSV8BZprhQw0f1RZYwQaR324yKmmiYBmM44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfoF/a1tRtBPMU+4N+HsyyakI/jR27nKwXa87PLPAJuCkZ0SYTqhFY6+VvDX/vyMq
         NPYAyZ1SQwd0PUmJ/0o6hQU1RPyCbzA3y1ohRIMM9+yEnKY4lNUXh7604TicXM2J+m
         0qw5BRTRblqxmi8A2ToPxTff8s/3j6jf5fcVeX/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/593] crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit
Date:   Mon, 12 Jul 2021 08:06:42 +0200
Message-Id: <20210712060909.519906289@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 1b82435d17774f3eaab35dce239d354548aa9da2 ]

In curve25519_mod_init() the curve25519_alg will be registered only when
(X86_FEATURE_BMI2 && X86_FEATURE_ADX). But in curve25519_mod_exit()
it still checks (X86_FEATURE_BMI2 || X86_FEATURE_ADX) when do crypto
unregister. This will trigger a BUG_ON in crypto_unregister_alg() as
alg->cra_refcnt is 0 if the cpu only supports one of X86_FEATURE_BMI2
and X86_FEATURE_ADX.

Fixes: 07b586fe0662 ("crypto: x86/curve25519 - replace with formally verified implementation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/curve25519-x86_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 5af8021b98ce..11b4c83c715e 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -1500,7 +1500,7 @@ static int __init curve25519_mod_init(void)
 static void __exit curve25519_mod_exit(void)
 {
 	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
-	    (boot_cpu_has(X86_FEATURE_BMI2) || boot_cpu_has(X86_FEATURE_ADX)))
+	    static_branch_likely(&curve25519_use_bmi2_adx))
 		crypto_unregister_kpp(&curve25519_alg);
 }
 
-- 
2.30.2



