Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236C426E3D
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfEVT1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731608AbfEVT1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:27:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 786D520879;
        Wed, 22 May 2019 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553232;
        bh=SJZlZ8tEd34xSlIzQTUceO438JbvwEqk7xemU0PK10s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVUAOb/GWaQx+KKsgaGgz1CX1nHvCc3zTI07ropeRZX/4CODzrZ8y+G9xyAC3EzS7
         nKXqqLWfmCKONTkS+d/ZFH7bGeu3R5YLDGhad/0VF8wvhvc2LwopWoIFOXMapwHcCZ
         5ie3JBMVm5VS4dNh6khJXv+RncEXBQ0ynXb4bJss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 025/244] ASoC: imx: fix fiq dependencies
Date:   Wed, 22 May 2019 15:22:51 -0400
Message-Id: <20190522192630.24917-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ea751227c813ab833609afecfeedaf0aa26f327e ]

During randconfig builds, I occasionally run into an invalid configuration
of the freescale FIQ sound support:

WARNING: unmet direct dependencies detected for SND_SOC_IMX_PCM_FIQ
  Depends on [m]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_IMX_SOC [=m]
  Selected by [y]:
  - SND_SOC_FSL_SPDIF [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_IMX_SOC [=m]!=n && (MXC_TZIC [=n] || MXC_AVIC [=y])

sound/soc/fsl/imx-ssi.o: In function `imx_ssi_remove':
imx-ssi.c:(.text+0x28): undefined reference to `imx_pcm_fiq_exit'
sound/soc/fsl/imx-ssi.o: In function `imx_ssi_probe':
imx-ssi.c:(.text+0xa64): undefined reference to `imx_pcm_fiq_init'

The Kconfig warning is a result of the symbol being defined inside of
the "if SND_IMX_SOC" block, and is otherwise harmless. The link error
is more tricky and happens with SND_SOC_IMX_SSI=y, which may or may not
imply FIQ support. However, if SND_SOC_FSL_SSI is set to =m at the same
time, that selects SND_SOC_IMX_PCM_FIQ as a loadable module dependency,
which then causes a link failure from imx-ssi.

The solution here is to make SND_SOC_IMX_PCM_FIQ built-in whenever
one of its potential users is built-in.

Fixes: ff40260f79dc ("ASoC: fsl: refine DMA/FIQ dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 2e75b5bc5f1da..f721cd4e3f972 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -173,16 +173,17 @@ config SND_MPC52xx_SOC_EFIKA
 
 endif # SND_POWERPC_SOC
 
+config SND_SOC_IMX_PCM_FIQ
+	tristate
+	default y if SND_SOC_IMX_SSI=y && (SND_SOC_FSL_SSI=m || SND_SOC_FSL_SPDIF=m) && (MXC_TZIC || MXC_AVIC)
+	select FIQ
+
 if SND_IMX_SOC
 
 config SND_SOC_IMX_SSI
 	tristate
 	select SND_SOC_FSL_UTILS
 
-config SND_SOC_IMX_PCM_FIQ
-	tristate
-	select FIQ
-
 comment "SoC Audio support for Freescale i.MX boards:"
 
 config SND_MXC_SOC_WM1133_EV1
-- 
2.20.1

