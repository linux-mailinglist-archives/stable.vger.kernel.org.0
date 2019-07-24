Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FEE73FD1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfGXTY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfGXTY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF43218F0;
        Wed, 24 Jul 2019 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996296;
        bh=yyxO9p3zO8di+eBCrkLBUX7xtMMFJoPBjjH1svQRMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5vAg4WZFlKvb5Ir1sCat5gmiDJ6r7BqZpob2xdJcUkX0j02JUV84yxV1JDW+4KsO
         z1fnk7pLPQaU+lUqPpDoRX4ggWDwuJyVEWyFogEwsrc6bSXy4t6Pbq9CobXK8WWpkX
         ti+qQgbTHd+ntF5r4KFjhNuUZ2nSFYFbJdCWpCmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 049/413] ASoC: Intel: sof-rt5682: fix undefined references with Baytrail-only support
Date:   Wed, 24 Jul 2019 21:15:40 +0200
Message-Id: <20190724191739.031505780@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



