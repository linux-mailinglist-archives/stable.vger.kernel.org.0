Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E822E3C2A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407579AbgL1N7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407910AbgL1N7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84783207A9;
        Mon, 28 Dec 2020 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163941;
        bh=13Jd/DXuJbGSVunn27AfmRjke9PfKRxKU/B0vebFACw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHr3Iu4Kp5SD3of2pqSI60EhfmqxFlRGKf9OTJk5c4GR3SkqBR20/VFOaYBeeQx2D
         YCRE89gxMUpHZGIhffPZsr+eOBFF3t3semiqcatGsJ9Pq8GcKsg29sTp+vbdIUrOBZ
         xGZelRZ1BouD43JmQmRTC313o8oCXqydI8kGo308=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Artem S. Tashkinov" <aros@gmx.com>,
        Wei Huang <wei.huang2@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 001/717] hwmon: (k10temp) Remove support for displaying voltage and current on Zen CPUs
Date:   Mon, 28 Dec 2020 13:39:59 +0100
Message-Id: <20201228125021.047814624@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 0a4e668b5d52eed8026f5d717196b02b55fb2dc6 upstream.

Voltages and current are reported by Zen CPUs. However, the means
to do so is undocumented, changes from CPU to CPU, and the raw data
is not calibrated. Calibration information is available, but again
not documented. This results in less than perfect user experience,
up to concerns that loading the driver might possibly damage
the hardware (by reporting out-of range voltages). Effectively
support for reporting voltages and current is not maintainable.
Drop it.

Cc: Artem S. Tashkinov <aros@gmx.com>
Cc: Wei Huang <wei.huang2@amd.com>
Tested-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/k10temp.c |   98 ------------------------------------------------
 1 file changed, 98 deletions(-)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -11,13 +11,6 @@
  *   convert raw register values is from https://github.com/ocerman/zenpower.
  *   The information is not confirmed from chip datasheets, but experiments
  *   suggest that it provides reasonable temperature values.
- * - Register addresses to read chip voltage and current are also from
- *   https://github.com/ocerman/zenpower, and not confirmed from chip
- *   datasheets. Current calibration is board specific and not typically
- *   shared by board vendors. For this reason, current values are
- *   normalized to report 1A/LSB for core current and and 0.25A/LSB for SoC
- *   current. Reported values can be adjusted using the sensors configuration
- *   file.
  */
 
 #include <linux/bitops.h>
@@ -109,10 +102,7 @@ struct k10temp_data {
 	int temp_offset;
 	u32 temp_adjust_mask;
 	u32 show_temp;
-	u32 svi_addr[2];
 	bool is_zen;
-	bool show_current;
-	int cfactor[2];
 };
 
 #define TCTL_BIT	0
@@ -137,16 +127,6 @@ static const struct tctl_offset tctl_off
 	{ 0x17, "AMD Ryzen Threadripper 29", 27000 }, /* 29{20,50,70,90}[W]X */
 };
 
-static bool is_threadripper(void)
-{
-	return strstr(boot_cpu_data.x86_model_id, "Threadripper");
-}
-
-static bool is_epyc(void)
-{
-	return strstr(boot_cpu_data.x86_model_id, "EPYC");
-}
-
 static void read_htcreg_pci(struct pci_dev *pdev, u32 *regval)
 {
 	pci_read_config_dword(pdev, REG_HARDWARE_THERMAL_CONTROL, regval);
@@ -211,16 +191,6 @@ static const char *k10temp_temp_label[]
 	"Tccd8",
 };
 
-static const char *k10temp_in_label[] = {
-	"Vcore",
-	"Vsoc",
-};
-
-static const char *k10temp_curr_label[] = {
-	"Icore",
-	"Isoc",
-};
-
 static int k10temp_read_labels(struct device *dev,
 			       enum hwmon_sensor_types type,
 			       u32 attr, int channel, const char **str)
@@ -229,50 +199,6 @@ static int k10temp_read_labels(struct de
 	case hwmon_temp:
 		*str = k10temp_temp_label[channel];
 		break;
-	case hwmon_in:
-		*str = k10temp_in_label[channel];
-		break;
-	case hwmon_curr:
-		*str = k10temp_curr_label[channel];
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static int k10temp_read_curr(struct device *dev, u32 attr, int channel,
-			     long *val)
-{
-	struct k10temp_data *data = dev_get_drvdata(dev);
-	u32 regval;
-
-	switch (attr) {
-	case hwmon_curr_input:
-		amd_smn_read(amd_pci_dev_to_node_id(data->pdev),
-			     data->svi_addr[channel], &regval);
-		*val = DIV_ROUND_CLOSEST(data->cfactor[channel] *
-					 (regval & 0xff),
-					 1000);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static int k10temp_read_in(struct device *dev, u32 attr, int channel, long *val)
-{
-	struct k10temp_data *data = dev_get_drvdata(dev);
-	u32 regval;
-
-	switch (attr) {
-	case hwmon_in_input:
-		amd_smn_read(amd_pci_dev_to_node_id(data->pdev),
-			     data->svi_addr[channel], &regval);
-		regval = (regval >> 16) & 0xff;
-		*val = DIV_ROUND_CLOSEST(155000 - regval * 625, 100);
-		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -331,10 +257,6 @@ static int k10temp_read(struct device *d
 	switch (type) {
 	case hwmon_temp:
 		return k10temp_read_temp(dev, attr, channel, val);
-	case hwmon_in:
-		return k10temp_read_in(dev, attr, channel, val);
-	case hwmon_curr:
-		return k10temp_read_curr(dev, attr, channel, val);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -383,11 +305,6 @@ static umode_t k10temp_is_visible(const
 			return 0;
 		}
 		break;
-	case hwmon_in:
-	case hwmon_curr:
-		if (!data->show_current)
-			return 0;
-		break;
 	default:
 		return 0;
 	}
@@ -517,20 +434,10 @@ static int k10temp_probe(struct pci_dev
 		case 0x8:	/* Zen+ */
 		case 0x11:	/* Zen APU */
 		case 0x18:	/* Zen+ APU */
-			data->show_current = !is_threadripper() && !is_epyc();
-			data->svi_addr[0] = F17H_M01H_SVI_TEL_PLANE0;
-			data->svi_addr[1] = F17H_M01H_SVI_TEL_PLANE1;
-			data->cfactor[0] = F17H_M01H_CFACTOR_ICORE;
-			data->cfactor[1] = F17H_M01H_CFACTOR_ISOC;
 			k10temp_get_ccd_support(pdev, data, 4);
 			break;
 		case 0x31:	/* Zen2 Threadripper */
 		case 0x71:	/* Zen2 */
-			data->show_current = !is_threadripper() && !is_epyc();
-			data->cfactor[0] = F17H_M31H_CFACTOR_ICORE;
-			data->cfactor[1] = F17H_M31H_CFACTOR_ISOC;
-			data->svi_addr[0] = F17H_M31H_SVI_TEL_PLANE0;
-			data->svi_addr[1] = F17H_M31H_SVI_TEL_PLANE1;
 			k10temp_get_ccd_support(pdev, data, 8);
 			break;
 		}
@@ -542,11 +449,6 @@ static int k10temp_probe(struct pci_dev
 
 		switch (boot_cpu_data.x86_model) {
 		case 0x0 ... 0x1:	/* Zen3 */
-			data->show_current = true;
-			data->svi_addr[0] = F19H_M01_SVI_TEL_PLANE0;
-			data->svi_addr[1] = F19H_M01_SVI_TEL_PLANE1;
-			data->cfactor[0] = F19H_M01H_CFACTOR_ICORE;
-			data->cfactor[1] = F19H_M01H_CFACTOR_ISOC;
 			k10temp_get_ccd_support(pdev, data, 8);
 			break;
 		}


