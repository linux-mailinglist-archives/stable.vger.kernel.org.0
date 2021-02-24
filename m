Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ECF323CF0
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhBXM7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235384AbhBXMzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B776A64F23;
        Wed, 24 Feb 2021 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171096;
        bh=UcHg/Dv0cv5MjX11LSzuItK7fmfEFvA5gy4oMj1tj4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duFireQuatVkZESEc12WlYKtT8mYtLv/HwRH12+PTMulX4arzjQ9wkj2QMRUL216b
         MRHOuO60ZjprRIDG3OAK1doZ16FYoQN5ywkAXulbDheLIMwX1X2xADrpTULJMrq63M
         jMvPgNrYSTMfD+RIcH4D7Bq0dttmySOaUuGx6Omej+G+aK5317HjHvB/tPAaKZ23et
         LsbhQA5XeZ/8a6cSDJlknDd+raut7ujMcen2IhKRYGyKkPb99dZRCXWH+p1lFVx0+K
         84Wa6RpCZzfgAivCyzcs80RJvO5LA41Z0oDqpAgPWTavg3hY1xgpV58hWx20djHVSc
         8nKXdmVgW8+UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 52/67] ASoC: Intel: Add DMI quirk table to soc_intel_is_byt_cr()
Date:   Wed, 24 Feb 2021 07:50:10 -0500
Message-Id: <20210224125026.481804-52-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8ade6d8b02b1ead741bd4f6c42921035caab6560 ]

Some Bay Trail systems:
1. Use a non CR version of the Bay Trail SoC
2. Contain at least 6 interrupt resources so that the
   platform_get_resource(pdev, IORESOURCE_IRQ, 5) check to workaround
   non CR systems which list their IPC IRQ at index 0 despite being
   non CR does not work
3. Despite 1. and 2. still have their IPC IRQ at index 0 rather then 5

Add a DMI quirk table to check for the few known models with this issue,
so that the right IPC IRQ index is used on these systems.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210120214957.140232-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-intel-quirks.h | 25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/soc/intel/common/soc-intel-quirks.h b/sound/soc/intel/common/soc-intel-quirks.h
index b07df3059926d..a93987ab7f4d7 100644
--- a/sound/soc/intel/common/soc-intel-quirks.h
+++ b/sound/soc/intel/common/soc-intel-quirks.h
@@ -11,6 +11,7 @@
 
 #if IS_ENABLED(CONFIG_X86)
 
+#include <linux/dmi.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/iosf_mbi.h>
@@ -38,12 +39,36 @@ SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
 
 static inline bool soc_intel_is_byt_cr(struct platform_device *pdev)
 {
+	/*
+	 * List of systems which:
+	 * 1. Use a non CR version of the Bay Trail SoC
+	 * 2. Contain at least 6 interrupt resources so that the
+	 *    platform_get_resource(pdev, IORESOURCE_IRQ, 5) check below
+	 *    succeeds
+	 * 3. Despite 1. and 2. still have their IPC IRQ at index 0 rather then 5
+	 *
+	 * This needs to be here so that it can be shared between the SST and
+	 * SOF drivers. We rely on the compiler to optimize this out in files
+	 * where soc_intel_is_byt_cr is not used.
+	 */
+	static const struct dmi_system_id force_bytcr_table[] = {
+		{	/* Lenovo Yoga Tablet 2 series */
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+				DMI_MATCH(DMI_PRODUCT_FAMILY, "YOGATablet2"),
+			},
+		},
+		{}
+	};
 	struct device *dev = &pdev->dev;
 	int status = 0;
 
 	if (!soc_intel_is_byt())
 		return false;
 
+	if (dmi_check_system(force_bytcr_table))
+		return true;
+
 	if (iosf_mbi_available()) {
 		u32 bios_status;
 
-- 
2.27.0

