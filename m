Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31817BA454
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391326AbfIVSsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391301AbfIVSsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D185F214AF;
        Sun, 22 Sep 2019 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178079;
        bh=WsyQeQ0LKRlhdI1QG341Q+aStMLnCD6mISC3+nH3hEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jytDDgEqfa2iLz+pNYJQjygAWuhsdrLlM49yN8cJ9mpu+LFKw+5gpQi5IxO3Ixb2w
         A+o4EzXt+A0Jd8NvOqyrV44bkmU4fgPuyhOeYIlcXY50FE2DOruMekFxFuSmUlu9Nv
         r9s7yENdiZqRfK51ZOTwGFytq/7HGksjJ1MhCH5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 150/203] ASoC: Intel: Haswell: Adjust machine device private context
Date:   Sun, 22 Sep 2019 14:42:56 -0400
Message-Id: <20190922184350.30563-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit ca964edf0ddbfec2cb10b3d251d09598e7ca9b13 ]

Apart from Haswell machines, all other devices have their private data
set to snd_soc_acpi_mach instance.

Changes for HSW/ BDW boards introduced with series:
https://patchwork.kernel.org/cover/10782035/

added support for dai_link platform_name adjustments within card probe
routines. These take for granted private_data points to
snd_soc_acpi_mach whereas for Haswell, it's sst_pdata instead. Change
private context of platform_device - representing machine board - to
address this.

Fixes: e87055d732e3 ("ASoC: Intel: haswell: platform name fixup support")
Fixes: 7e40ddcf974a ("ASoC: Intel: bdw-rt5677: platform name fixup support")
Fixes: 2d067b2807f9 ("ASoC: Intel: broadwell: platform name fixup support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20190822113616.22702-2-cezary.rojewski@intel.com
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/sst-acpi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/sst-acpi.c b/sound/soc/intel/common/sst-acpi.c
index 0e8e0a7a11df3..5854868650b9e 100644
--- a/sound/soc/intel/common/sst-acpi.c
+++ b/sound/soc/intel/common/sst-acpi.c
@@ -141,11 +141,12 @@ static int sst_acpi_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, sst_acpi);
+	mach->pdata = sst_pdata;
 
 	/* register machine driver */
 	sst_acpi->pdev_mach =
 		platform_device_register_data(dev, mach->drv_name, -1,
-					      sst_pdata, sizeof(*sst_pdata));
+					      mach, sizeof(*mach));
 	if (IS_ERR(sst_acpi->pdev_mach))
 		return PTR_ERR(sst_acpi->pdev_mach);
 
-- 
2.20.1

