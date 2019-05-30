Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D680D2EFA3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbfE3D5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731732AbfE3DSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAD124777;
        Thu, 30 May 2019 03:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186330;
        bh=na4CyxEsEuxP5NhcIN35foFKL/ChBDwaX/t8mPmZ248=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXHgXrkhhjSynd1kp7+l0Bte2ar8fs6wBOkA3m8tK9CU8VXBT6iPLLAjTRNsLZ92j
         N/o4TGSlwusAMDu9jULjs42OHy0jRPEYl698nfMh7YhVcTOyKykJXyS6V5qckbyEfJ
         pPdtZqKAnnLcoBTvkafeWyu4y96vTK1aUd5q7ruQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/193] ASoC: imx: fix fiq dependencies
Date:   Wed, 29 May 2019 20:05:03 -0700
Message-Id: <20190530030456.508767576@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 4087deeda7cf9..2523b00659908 100644
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



