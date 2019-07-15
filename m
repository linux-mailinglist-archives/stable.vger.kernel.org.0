Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7014A68C2F
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbfGONtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731167AbfGONtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:49:49 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DCC2083D;
        Mon, 15 Jul 2019 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198588;
        bh=bEJefS2tws+SL3mfnqp2N4aCqJvGJuT0J6mFt8zFPXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZB9VNTBML6/Yo6ojw4UlZgi11CKia5hTI+ZgTQMTQ2jZdFTsIaMQhn+AEvyTCoRN
         pnGehkIn5eYCSQU9aFCPPiQydWfq3PCpYYVN+H102tQPKNklpiNObervgysZThrftL
         DmMsWbwyTnAZc1BvJomEj8kjgByR7ehNEU4IUDvg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        kbuild test robot <lkp@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 052/249] ASoC: Intel: sof-rt5682: fix undefined references with Baytrail-only support
Date:   Mon, 15 Jul 2019 09:43:37 -0400
Message-Id: <20190715134655.4076-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 17fc24875da1bef4650cf007edae3b2e26d2fa4e ]

The sof-rt5682 machine driver supports both legacy Baytrail devices
and more recent ApolloLake/CometLake platforms. When only Baytrail is
selected, the compilation fails with the following errors:

ERROR: "hdac_hdmi_jack_port_init"
[sound/soc/intel/boards/snd-soc-sof_rt5682.ko] undefined!

ERROR: "hdac_hdmi_jack_init"
[sound/soc/intel/boards/snd-soc-sof_rt5682.ko] undefined!

Fix by selecting SND_SOC_HDAC_HDMI unconditionally. The code for HDMI
support is not reachable on Baytrail so this change has no functional
impact.

Fixes: f70abd75b7c6 ("ASoC: Intel: add sof-rt5682 machine driver")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/Kconfig b/sound/soc/intel/boards/Kconfig
index 5407d217228e..c0aef45d335a 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -392,7 +392,7 @@ config SND_SOC_INTEL_SOF_RT5682_MACH
 		   (SND_SOC_SOF_BAYTRAIL && X86_INTEL_LPSS)
 	select SND_SOC_RT5682
 	select SND_SOC_DMIC
-	select SND_SOC_HDAC_HDMI if SND_SOC_SOF_HDA_COMMON
+	select SND_SOC_HDAC_HDMI
 	help
 	   This adds support for ASoC machine driver for SOF platforms
 	   with rt5682 codec.
-- 
2.20.1

