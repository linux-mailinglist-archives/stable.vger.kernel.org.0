Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC95E119A45
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLJVvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbfLJVIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A8320836;
        Tue, 10 Dec 2019 21:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012084;
        bh=aGsXyfqPX3236EgvbBto0JuppW0QLi8BbTUtHJ12EMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV4vJDoP2MK/IT0MiVmDxJvpbD7VnPVuS1MHAsWgzFHGWOeCWmWzUrVEM8oxrE85u
         YQCigmBZYhrf/MDTJ6HrRR8NC1ZwrRgQyK+N4gvLbPbTXlW7ZxeadLSk90kC0Gymea
         6gLFsFTCdMvRH7DgdFDts06kWN914bhElEXSlSHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 062/350] crypto: aegis128-neon - use Clang compatible cflags for ARM
Date:   Tue, 10 Dec 2019 16:02:47 -0500
Message-Id: <20191210210735.9077-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fcb1ee6797822..aa740c8492b9d 100644
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

