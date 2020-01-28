Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525C414B7B3
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgA1OQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgA1OQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D1F224681;
        Tue, 28 Jan 2020 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221007;
        bh=9MKGgbGkktR6LgpRauOiAnZovKnboxbvvj4O2cBM3+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyGN6oEBExH7UmA+VuGjBlNQwa/hJ4GjlxT4wP4L0+qiy0qbZ+PRAW3Fao+sJy9Jf
         QknK+uPMj6znWnEGmeSCBsrLJnjTlEEDvOYDcH4UVopTFm5zqcCIPd8K4C8md3X3O6
         eVOP7ZuVweRnXUTPfF5BkN1eZgpLc3yh8xXIAJRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/271] crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments
Date:   Tue, 28 Jan 2020 15:03:20 +0100
Message-Id: <20200128135856.440129336@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 931d22531f515..7bbda51b7337c 100644
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



