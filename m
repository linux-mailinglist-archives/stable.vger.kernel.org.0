Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136192E4204
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437393AbgL1OEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437380AbgL1OEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC668207CC;
        Mon, 28 Dec 2020 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164234;
        bh=y7iakMPtbfVP2HoO/fYnalgpMO7wdd/HzF17UrpbBEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbNMd+4xAF6/nhGRaP8xfHpprwK9F/Eov0XwRjsgoaYqYTkDu3pKO3gb0HowTifrD
         93bX3anSQgyKOV09KNQOMtCf5ZkjFm/3R4iPmPlrW/p6x8PBK6tz0iVRHAsYdzaWR+
         LjbBpIlOrS4heVGBNxYpJxku154znojE7JgXkd4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/717] crypto: Kconfig - CRYPTO_MANAGER_EXTRA_TESTS requires the manager
Date:   Mon, 28 Dec 2020 13:41:45 +0100
Message-Id: <20201228125026.082236817@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 6569e3097f1c4a490bdf2b23d326855e04942dfd ]

The extra tests in the manager actually require the manager to be
selected too. Otherwise the linker gives errors like:

ld: arch/x86/crypto/chacha_glue.o: in function `chacha_simd_stream_xor':
chacha_glue.c:(.text+0x422): undefined reference to `crypto_simd_disabled_for_test'

Fixes: 2343d1529aff ("crypto: Kconfig - allow tests to be disabled when manager is disabled")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b42..37de7d006858d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -145,7 +145,7 @@ config CRYPTO_MANAGER_DISABLE_TESTS
 
 config CRYPTO_MANAGER_EXTRA_TESTS
 	bool "Enable extra run-time crypto self tests"
-	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS
+	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS && CRYPTO_MANAGER
 	help
 	  Enable extra run-time self tests of registered crypto algorithms,
 	  including randomized fuzz tests.
-- 
2.27.0



