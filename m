Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63B34C854
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhC2IVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232596AbhC2IUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3873B619BA;
        Mon, 29 Mar 2021 08:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006032;
        bh=4DhnAqqUln9VkTjQiTjETnkRyFF/8p0/XHf7Ei5iNuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0ZjtsXvn0c7SqOragZ9E51PzB/VZ56blsS+7LGUfTReSkSiXGZ/nJfHCJF0yfXVB
         ADMThRqevmEevgcslui+QP0SdJr0Ea9yMODLRME7+XSlyOHbvhoin0CCK5u8Q+ZHjS
         aFOE4ociFIjbbfpkaGEsLVJleq0ViMeT04ODKryE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/221] ARM: OMAP2+: Fix smartreflex init regression after dropping legacy data
Date:   Mon, 29 Mar 2021 09:57:03 +0200
Message-Id: <20210329075632.275046918@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit fbfa463be8dc7957ee4f81556e9e1ea2a951807d ]

When I dropped legacy data for omap4 and dra7 smartreflex in favor of
device tree based data, it seems I only testd for the "SmartReflex Class3
initialized" line in dmesg. I missed the fact that there is also
omap_devinit_smartreflex() that happens later, and now it produces an
error on boot for "No Voltage table for the corresponding vdd. Cannot
create debugfs entries for n-values".

This happens as we no longer have the smartreflex instance legacy data,
and have not yet moved completely to device tree based booting for the
driver. Let's fix the issue by changing the smartreflex init to use names.
This should all eventually go away in favor of doing the init in the
driver based on devicetree compatible value.

Note that dra7xx_init_early() is not calling any voltage domain init like
omap54xx_voltagedomains_init(), or a dra7 specific voltagedomains init.
This means that on dra7 smartreflex is still not fully initialized, and
also seems to be missing the related devicetree nodes.

Fixes: a6b1e717e942 ("ARM: OMAP2+: Drop legacy platform data for omap4 smartreflex")
Fixes: e54740b4afe8 ("ARM: OMAP2+: Drop legacy platform data for dra7 smartreflex")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/sr_device.c | 75 +++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index 62df666c2bd0..17b66f0d0dee 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -88,34 +88,26 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
 
 extern struct omap_sr_data omap_sr_pdata[];
 
-static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
+static int __init sr_init_by_name(const char *name, const char *voltdm)
 {
 	struct omap_sr_data *sr_data = NULL;
 	struct omap_volt_data *volt_data;
-	struct omap_smartreflex_dev_attr *sr_dev_attr;
 	static int i;
 
-	if (!strncmp(oh->name, "smartreflex_mpu_iva", 20) ||
-	    !strncmp(oh->name, "smartreflex_mpu", 16))
+	if (!strncmp(name, "smartreflex_mpu_iva", 20) ||
+	    !strncmp(name, "smartreflex_mpu", 16))
 		sr_data = &omap_sr_pdata[OMAP_SR_MPU];
-	else if (!strncmp(oh->name, "smartreflex_core", 17))
+	else if (!strncmp(name, "smartreflex_core", 17))
 		sr_data = &omap_sr_pdata[OMAP_SR_CORE];
-	else if (!strncmp(oh->name, "smartreflex_iva", 16))
+	else if (!strncmp(name, "smartreflex_iva", 16))
 		sr_data = &omap_sr_pdata[OMAP_SR_IVA];
 
 	if (!sr_data) {
-		pr_err("%s: Unknown instance %s\n", __func__, oh->name);
+		pr_err("%s: Unknown instance %s\n", __func__, name);
 		return -EINVAL;
 	}
 
-	sr_dev_attr = (struct omap_smartreflex_dev_attr *)oh->dev_attr;
-	if (!sr_dev_attr || !sr_dev_attr->sensor_voltdm_name) {
-		pr_err("%s: No voltage domain specified for %s. Cannot initialize\n",
-		       __func__, oh->name);
-		goto exit;
-	}
-
-	sr_data->name = oh->name;
+	sr_data->name = name;
 	if (cpu_is_omap343x())
 		sr_data->ip_type = 1;
 	else
@@ -136,10 +128,10 @@ static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 		}
 	}
 
-	sr_data->voltdm = voltdm_lookup(sr_dev_attr->sensor_voltdm_name);
+	sr_data->voltdm = voltdm_lookup(voltdm);
 	if (!sr_data->voltdm) {
 		pr_err("%s: Unable to get voltage domain pointer for VDD %s\n",
-			__func__, sr_dev_attr->sensor_voltdm_name);
+			__func__, voltdm);
 		goto exit;
 	}
 
@@ -160,6 +152,20 @@ exit:
 	return 0;
 }
 
+static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
+{
+	struct omap_smartreflex_dev_attr *sr_dev_attr;
+
+	sr_dev_attr = (struct omap_smartreflex_dev_attr *)oh->dev_attr;
+	if (!sr_dev_attr || !sr_dev_attr->sensor_voltdm_name) {
+		pr_err("%s: No voltage domain specified for %s. Cannot initialize\n",
+		       __func__, oh->name);
+		return 0;
+	}
+
+	return sr_init_by_name(oh->name, sr_dev_attr->sensor_voltdm_name);
+}
+
 /*
  * API to be called from board files to enable smartreflex
  * autocompensation at init.
@@ -169,7 +175,42 @@ void __init omap_enable_smartreflex_on_init(void)
 	sr_enable_on_init = true;
 }
 
+static const char * const omap4_sr_instances[] = {
+	"mpu",
+	"iva",
+	"core",
+};
+
+static const char * const dra7_sr_instances[] = {
+	"mpu",
+	"core",
+};
+
 int __init omap_devinit_smartreflex(void)
 {
+	const char * const *sr_inst;
+	int i, nr_sr = 0;
+
+	if (soc_is_omap44xx()) {
+		sr_inst = omap4_sr_instances;
+		nr_sr = ARRAY_SIZE(omap4_sr_instances);
+
+	} else if (soc_is_dra7xx()) {
+		sr_inst = dra7_sr_instances;
+		nr_sr = ARRAY_SIZE(dra7_sr_instances);
+	}
+
+	if (nr_sr) {
+		const char *name, *voltdm;
+
+		for (i = 0; i < nr_sr; i++) {
+			name = kasprintf(GFP_KERNEL, "smartreflex_%s", sr_inst[i]);
+			voltdm = sr_inst[i];
+			sr_init_by_name(name, voltdm);
+		}
+
+		return 0;
+	}
+
 	return omap_hwmod_for_each_by_class("smartreflex", sr_dev_init, NULL);
 }
-- 
2.30.1



