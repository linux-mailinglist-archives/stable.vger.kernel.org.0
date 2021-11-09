Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E5544B7A2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345106AbhKIWgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345495AbhKIWeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D244A619EA;
        Tue,  9 Nov 2021 22:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496523;
        bh=ZMGpCI8oDIhIjEv0205Deqq+Gh7JpQMOGyNXtAcjAOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrLwthaNxaYJpcC1mNppW+TyVWTydyKOty3Nwy3s15bF1eqJIu3WiK94LGHHl8X1i
         u2QRMD9gkUGWaf4P4tMx60Ptfqp7kuaea2U3Kqc6gRjVqBwApb5+m8Tcw3+cEYc+75
         bUIo/HRaKX4NFxelO+JaBaKLanKUTiRlGgb/kV0a5aoL3s5rR8dMVYdvrIdFAPS5Iy
         AUGYWEWzCXjpTY3dG1SaWCIiQn/5Szk40da+Zdgpr6v+rm9iBH02+hh5FTeFefNnm9
         e0Wg7gTr/5Rue9wVnbC7beFmvJgpuQfE2JXMqCmcYx9PQTEfWOVf4CkXJ/shwTSCN4
         8Y6CHc+IVJjfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-m68k@lists.linux-m68k.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 37/50] ALSA: ISA: not for M68K
Date:   Tue,  9 Nov 2021 17:20:50 -0500
Message-Id: <20211109222103.1234885-37-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3c05f1477e62ea5a0a8797ba6a545b1dc751fb31 ]

On m68k, compiling drivers under SND_ISA causes build errors:

../sound/core/isadma.c: In function 'snd_dma_program':
../sound/core/isadma.c:33:17: error: implicit declaration of function 'claim_dma_lock' [-Werror=implicit-function-declaration]
   33 |         flags = claim_dma_lock();
      |                 ^~~~~~~~~~~~~~
../sound/core/isadma.c:41:9: error: implicit declaration of function 'release_dma_lock' [-Werror=implicit-function-declaration]
   41 |         release_dma_lock(flags);
      |         ^~~~~~~~~~~~~~~~

../sound/isa/sb/sb16_main.c: In function 'snd_sb16_playback_prepare':
../sound/isa/sb/sb16_main.c:253:72: error: 'DMA_AUTOINIT' undeclared (first use in this function)
  253 |         snd_dma_program(dma, runtime->dma_addr, size, DMA_MODE_WRITE | DMA_AUTOINIT);
      |                                                                        ^~~~~~~~~~~~
../sound/isa/sb/sb16_main.c:253:72: note: each undeclared identifier is reported only once for each function it appears in
../sound/isa/sb/sb16_main.c: In function 'snd_sb16_capture_prepare':
../sound/isa/sb/sb16_main.c:322:71: error: 'DMA_AUTOINIT' undeclared (first use in this function)
  322 |         snd_dma_program(dma, runtime->dma_addr, size, DMA_MODE_READ | DMA_AUTOINIT);
      |                                                                       ^~~~~~~~~~~~

and more...

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20211016062602.3588-1-rdunlap@infradead.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/Makefile | 2 ++
 sound/isa/Kconfig   | 2 +-
 sound/pci/Kconfig   | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/core/Makefile b/sound/core/Makefile
index ee4a4a6b99ba7..d123587c0fd8f 100644
--- a/sound/core/Makefile
+++ b/sound/core/Makefile
@@ -9,7 +9,9 @@ ifneq ($(CONFIG_SND_PROC_FS),)
 snd-y += info.o
 snd-$(CONFIG_SND_OSSEMUL) += info_oss.o
 endif
+ifneq ($(CONFIG_M68K),y)
 snd-$(CONFIG_ISA_DMA_API) += isadma.o
+endif
 snd-$(CONFIG_SND_OSSEMUL) += sound_oss.o
 snd-$(CONFIG_SND_VMASTER) += vmaster.o
 snd-$(CONFIG_SND_JACK)	  += ctljack.o jack.o
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index 6ffa48dd59830..570b88e0b2018 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -22,7 +22,7 @@ config SND_SB16_DSP
 menuconfig SND_ISA
 	bool "ISA sound devices"
 	depends on ISA || COMPILE_TEST
-	depends on ISA_DMA_API
+	depends on ISA_DMA_API && !M68K
 	default y
 	help
 	  Support for sound devices connected via the ISA bus.
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 93bc9bef7641f..41ce125971777 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -279,6 +279,7 @@ config SND_CS46XX_NEW_DSP
 config SND_CS5530
 	tristate "CS5530 Audio"
 	depends on ISA_DMA_API && (X86_32 || COMPILE_TEST)
+	depends on !M68K
 	select SND_SB16_DSP
 	help
 	  Say Y here to include support for audio on Cyrix/NatSemi CS5530 chips.
-- 
2.33.0

