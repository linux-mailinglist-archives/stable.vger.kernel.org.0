Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1053112C7B3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbfL2Rpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730948AbfL2Rpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5771F207FF;
        Sun, 29 Dec 2019 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641542;
        bh=E7izfWPlwyhCF3cCpQ1/HKIJmhsp2mzd5B227t/0c1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHk8xTuj60y05Xrh055uE67u2pwwylHvWy88f/g9Xv5WUojgoRX9p4n9/cKAeKzYt
         sUy8dpH9VddB+91NkNombY7AgFltx48xxz8Wa8E7apxxc+HDO1hcPGXwEypjYOTkMB
         jBMm6Bruwv6OCTtZj6eQs3ZMRsCQKEfOIY5oZxY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/434] crypto: aegis128-neon - use Clang compatible cflags for ARM
Date:   Sun, 29 Dec 2019 18:22:35 +0100
Message-Id: <20191229172708.377116281@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 2eb2d198bd6cd0083a5363ce66272fb34a19928f ]

The next version of Clang will start policing compiler command line
options, and will reject combinations of -march and -mfpu that it
thinks are incompatible.

This results in errors like

  clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
  architecture does not support it [-Winvalid-command-line-argument]
  /tmp/aegis128-neon-inner-5ee428.s: Assembler messages:
            /tmp/aegis128-neon-inner-5ee428.s:73: Error: selected
  processor does not support `aese.8 q2,q14' in ARM mode

when buiding the SIMD aegis128 code for 32-bit ARM, given that the
'armv7-a' -march argument is considered to be compatible with the
ARM crypto extensions. Instead, we should use armv8-a, which does
allow the crypto extensions to be enabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index fcb1ee679782..aa740c8492b9 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -93,7 +93,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
 ifeq ($(ARCH),arm)
-CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
 CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
-- 
2.20.1



