Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045F613F750
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgAPTLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387730AbgAPRAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97622467E;
        Thu, 16 Jan 2020 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194020;
        bh=iXlGhkD+iPp8vh7EEoCYUfHQYjiFUHCq17Z2sMpPylM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCF82wdt6b+OfEXw9/4Zt9fETmnNEVLEbB07hJugw20CnWLDVKqff07lhJyUvuYGs
         e1M0ghpfTAgj21BP7FfvJPPG9bFzSiuhUUjxCQDk5//kZTYfFnYIbQDWL06G+tLPFa
         r3SYcOyB5Koeaz+vrEZjqCAc6CSevSPNGWCmOPJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 141/671] crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments
Date:   Thu, 16 Jan 2020 11:50:50 -0500
Message-Id: <20200116165940.10720-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 6e88098ca43a3d80ae86908f7badba683c8a0d84 ]

When building without CONFIG_HW_RANDOM_PPC4XX, I hit the following build failure:
drivers/crypto/amcc/crypto4xx_core.c: In function 'crypto4xx_probe':
drivers/crypto/amcc/crypto4xx_core.c:1407:20: error: passing argument 1 of 'ppc4xx_trng_probe' from incompatible pointer type [-Werror=incompatible-pointer-types]
In file included from drivers/crypto/amcc/crypto4xx_core.c:50:0:
drivers/crypto/amcc/crypto4xx_trng.h:28:20: note: expected 'struct crypto4xx_device *' but argument is of type 'struct crypto4xx_core_device *'
drivers/crypto/amcc/crypto4xx_core.c: In function 'crypto4xx_remove':
drivers/crypto/amcc/crypto4xx_core.c:1434:21: error: passing argument 1 of 'ppc4xx_trng_remove' from incompatible pointer type [-Werror=incompatible-pointer-types]
In file included from drivers/crypto/amcc/crypto4xx_core.c:50:0:
drivers/crypto/amcc/crypto4xx_trng.h:30:20: note: expected 'struct crypto4xx_device *' but argument is of type 'struct crypto4xx_core_device *'

This patch fix the needed argument of ppc4xx_trng_probe()/ppc4xx_trng_remove() in that case.

Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_trng.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.h b/drivers/crypto/amcc/crypto4xx_trng.h
index 931d22531f51..7bbda51b7337 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.h
+++ b/drivers/crypto/amcc/crypto4xx_trng.h
@@ -26,9 +26,9 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev);
 void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev);
 #else
 static inline void ppc4xx_trng_probe(
-	struct crypto4xx_device *dev __maybe_unused) { }
+	struct crypto4xx_core_device *dev __maybe_unused) { }
 static inline void ppc4xx_trng_remove(
-	struct crypto4xx_device *dev __maybe_unused) { }
+	struct crypto4xx_core_device *dev __maybe_unused) { }
 #endif
 
 #endif
-- 
2.20.1

