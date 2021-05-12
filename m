Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49137C985
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbhELQTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236185AbhELQMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCBAC61D55;
        Wed, 12 May 2021 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834060;
        bh=lWAe6F9r8Lrfds6fQrRTVqqyjx7rt38dkj+xdRnVuwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9fEScZFpPEotw8oJFFhYO/8zb12HDpm95iw4OQVN4g2i+aQif72ENfnZ9RzSbSN3
         sVHj8Nq2cS3jO8QkmcAbgWgNb76Rgbg9M3lCF0KdiA9hCG4bqzN8WsvriCuf0XqHLs
         SwAAVMACAW/NyVZURMJs+xsmVBgLHuxmf5W10EKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 393/601] ASoC: Intel: Skylake: Compile when any configuration is selected
Date:   Wed, 12 May 2021 16:47:50 +0200
Message-Id: <20210512144840.750240281@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 1b99d50b9709a2cddaba4a7faf1862b4f7bec865 ]

Skylake is dependent on SND_SOC_INTEL_SKYLAKE (aka "all SST platforms")
whereas selecting specific configuration such as KBL-only will not
cause driver code to compile. Switch to SND_SOC_INTEL_SKYLAKE_COMMON
dependency so selecting any configuration causes the driver to be built.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Suggested-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Fixes: 35bc99aaa1a3 ("ASoC: Intel: Skylake: Add more platform granularity")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20210125115441.10383-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/Makefile         | 2 +-
 sound/soc/intel/skylake/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/Makefile b/sound/soc/intel/Makefile
index 4e0248d2accc..7c5038803be7 100644
--- a/sound/soc/intel/Makefile
+++ b/sound/soc/intel/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_SND_SOC) += common/
 # Platform Support
 obj-$(CONFIG_SND_SST_ATOM_HIFI2_PLATFORM) += atom/
 obj-$(CONFIG_SND_SOC_INTEL_CATPT) += catpt/
-obj-$(CONFIG_SND_SOC_INTEL_SKYLAKE) += skylake/
+obj-$(CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON) += skylake/
 obj-$(CONFIG_SND_SOC_INTEL_KEEMBAY) += keembay/
 
 # Machine support
diff --git a/sound/soc/intel/skylake/Makefile b/sound/soc/intel/skylake/Makefile
index dd39149b89b1..1c4649bccec5 100644
--- a/sound/soc/intel/skylake/Makefile
+++ b/sound/soc/intel/skylake/Makefile
@@ -7,7 +7,7 @@ ifdef CONFIG_DEBUG_FS
   snd-soc-skl-objs += skl-debug.o
 endif
 
-obj-$(CONFIG_SND_SOC_INTEL_SKYLAKE) += snd-soc-skl.o
+obj-$(CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON) += snd-soc-skl.o
 
 #Skylake Clock device support
 snd-soc-skl-ssp-clk-objs := skl-ssp-clk.o
-- 
2.30.2



