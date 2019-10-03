Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A99CCA582
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403846AbfJCQfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404014AbfJCQdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E5F2133F;
        Thu,  3 Oct 2019 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120384;
        bh=WsyQeQ0LKRlhdI1QG341Q+aStMLnCD6mISC3+nH3hEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABGye2nzhNtpJV52C4Z0wJcxmKQBbUhCV7jycS0jFx/O2UMFp/pE9MsVyxye/r3RL
         7FkQSl3avAxsOQgCaVlpYyYbkSo6RY7R8H0L9GQ9BtiONCSDwV6aa7lNt7ST0Ossif
         zPvSV3zxw5NyaCENKLwFwYqxhDSyAvKMWzbRrKTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 164/313] ASoC: Intel: Haswell: Adjust machine device private context
Date:   Thu,  3 Oct 2019 17:52:22 +0200
Message-Id: <20191003154549.108845163@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



