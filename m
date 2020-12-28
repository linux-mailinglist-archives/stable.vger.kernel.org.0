Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC74F2E4214
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437325AbgL1OEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437310AbgL1OES (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF0C207B2;
        Mon, 28 Dec 2020 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164217;
        bh=sDO7Y6wWsyYV6vaFNuCuq69JA+NLH7gFEXN8D3JcQJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9gbub7/ckJ9qfhF6KHzov/p/9CXkGVfKPJFyne8m9k1o7dkLligK77SHigY9sKuq
         RqG3nJueHwkMrmwdc4vFE3Ca987hE6cNRaEB6+SSfRryClqJCGncklDdnPKb17Dg+W
         kc50KmagKFF4JJsOJCvFwCz4cKo4LIoljxYs33gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/717] ASoC: SOF: Intel: fix Kconfig dependency for SND_INTEL_DSP_CONFIG
Date:   Mon, 28 Dec 2020 13:41:40 +0100
Message-Id: <20201228125025.857701283@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 358f0ac1f2791c80c19cc26706cf34664c9fd756 ]

SND_INTEL_DSP_CONFIG is selected by the HDaudio, Skylake and SOF
drivers. When the HDaudio link is not selected as a option, this
Kconfig option is not touched and will default to whatever other
drivers selected. In the case e.g. where HDaudio is compiled as
built-in, the linker will complain:

ld: sound/soc/sof/sof-pci-dev.o: in function `sof_pci_probe':
sof-pci-dev.c:(.text+0x5c): undefined reference to
`snd_intel_dsp_driver_probe'

Adding the select for all HDaudio platforms, regardless of whether
they rely on the HDaudio link or not, solves the problem.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 82d9d54a6c0ee ('ALSA: hda: add Intel DSP configuration / probe code')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20201112164425.25603-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index a066e08860cbf..5bfc2f8b13b90 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -271,6 +271,7 @@ config SND_SOC_SOF_JASPERLAKE
 
 config SND_SOC_SOF_HDA_COMMON
 	tristate
+	select SND_INTEL_DSP_CONFIG
 	select SND_SOC_SOF_INTEL_COMMON
 	select SND_SOC_SOF_HDA_LINK_BASELINE
 	help
@@ -330,7 +331,6 @@ config SND_SOC_SOF_HDA
 	tristate
 	select SND_HDA_EXT_CORE if SND_SOC_SOF_HDA_LINK
 	select SND_SOC_HDAC_HDA if SND_SOC_SOF_HDA_AUDIO_CODEC
-	select SND_INTEL_DSP_CONFIG
 	help
 	  This option is not user-selectable but automagically handled by
 	  'select' statements at a higher level
-- 
2.27.0



