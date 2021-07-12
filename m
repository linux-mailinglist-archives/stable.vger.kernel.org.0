Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0693C5275
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbhGLHqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349643AbhGLHo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3125761289;
        Mon, 12 Jul 2021 07:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075663;
        bh=3HIwDNyDWYbehoePnsv0f3vi2d+khs0nYmChAy/KP9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrYbEw/3zCIKs74/+mJb6ZSWLfskG2LSF4Zn2Y72UkUaYq4RYihjwDjfpw+qTvuIJ
         72eSajNyVYxWpo5t1zY6Xd59j0hBXHASRMq3/JUTe+nmdTeNY7nB8JawmjT6ISX519
         lahNvkA4dyIe0wC4qqnvxQlmiu/1nkcmSaEtTvLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 311/800] crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit
Date:   Mon, 12 Jul 2021 08:05:34 +0200
Message-Id: <20210712060958.653102312@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 6706b6cb1d0f..38caf61cd5b7 100644
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



