Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6FBA4F1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393565AbfIVSxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389789AbfIVSxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:53:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C07221D79;
        Sun, 22 Sep 2019 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178389;
        bh=WsyQeQ0LKRlhdI1QG341Q+aStMLnCD6mISC3+nH3hEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duYQKVGf3gZQPmah7VQYSFSPj4QYJCTbuC7ERJxzYzTVD8q6G1ryfOfDMNHiZCDiH
         FpDhLWaT0andvUEdfynDeGz2EtTzL7Hza0H3CPyU1wCCA+7j40uKUYm/OQOwL+AS2u
         yA3N0cFcRPOzVY7O8WniYG6R/qPEspb19AAi7IZk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 136/185] ASoC: Intel: Haswell: Adjust machine device private context
Date:   Sun, 22 Sep 2019 14:48:34 -0400
Message-Id: <20190922184924.32534-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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

