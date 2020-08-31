Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B30257DA7
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgHaPje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbgHaPaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A1E20FC3;
        Mon, 31 Aug 2020 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887802;
        bh=fWE5ZsxEltj75glQ2+bET/FqMIgECURt2NMx0lmXbb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2S1JAhkGYg031SXCYrOiAiQGg7h+1K3ySrEgsQ6SVSOBEX+uq14e1qKtgz9OSZXA
         fZzuHj91pPOolZesdUCx0KA9wQRyu02Y0S44KqL6bL0XLT1C5dkw0H2PR6WV2TqTLw
         +tAsMig/2AtlvG1SUeClBAOsl5gCoEFs1nY7m8Jc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 18/42] habanalabs: set max power according to card type
Date:   Mon, 31 Aug 2020 11:29:10 -0400
Message-Id: <20200831152934.1023912-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit 58361aae4b0eed388680a89ac153d27177f40510 ]

In Gaudi, the default max power setting is different between PCI and PMC
cards. Therefore, the driver need to set the default after knowing what is
the card type.

The current code has a bug where it limits the maximum power of the PMC
card to 200W after a reset occurs.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c       |  7 ++++++-
 drivers/misc/habanalabs/gaudi/gaudi.c  | 11 ++++++++++-
 drivers/misc/habanalabs/gaudi/gaudiP.h |  3 ++-
 drivers/misc/habanalabs/habanalabs.h   |  5 ++++-
 drivers/misc/habanalabs/sysfs.c        |  7 ++++---
 5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index 59608d1bac880..baa4e66d4c457 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -1027,7 +1027,7 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 			goto out_err;
 		}
 
-		hl_set_max_power(hdev, hdev->max_power);
+		hl_set_max_power(hdev);
 	} else {
 		rc = hdev->asic_funcs->soft_reset_late_init(hdev);
 		if (rc) {
@@ -1268,6 +1268,11 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 		goto out_disabled;
 	}
 
+	/* Need to call this again because the max power might change,
+	 * depending on card type for certain ASICs
+	 */
+	hl_set_max_power(hdev);
+
 	/*
 	 * hl_hwmon_init() must be called after device_late_init(), because only
 	 * there we get the information from the device about which
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 8b6cf722ddf8e..ca183733847b6 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -447,7 +447,7 @@ static int gaudi_get_fixed_properties(struct hl_device *hdev)
 	prop->num_of_events = GAUDI_EVENT_SIZE;
 	prop->tpc_enabled_mask = TPC_ENABLED_MASK;
 
-	prop->max_power_default = MAX_POWER_DEFAULT;
+	prop->max_power_default = MAX_POWER_DEFAULT_PCI;
 
 	prop->cb_pool_cb_cnt = GAUDI_CB_POOL_CB_CNT;
 	prop->cb_pool_cb_size = GAUDI_CB_POOL_CB_SIZE;
@@ -6241,6 +6241,15 @@ static int gaudi_armcp_info_get(struct hl_device *hdev)
 		strncpy(prop->armcp_info.card_name, GAUDI_DEFAULT_CARD_NAME,
 				CARD_NAME_MAX_LEN);
 
+	hdev->card_type = le32_to_cpu(hdev->asic_prop.armcp_info.card_type);
+
+	if (hdev->card_type == armcp_card_type_pci)
+		prop->max_power_default = MAX_POWER_DEFAULT_PCI;
+	else if (hdev->card_type == armcp_card_type_pmc)
+		prop->max_power_default = MAX_POWER_DEFAULT_PMC;
+
+	hdev->max_power = prop->max_power_default;
+
 	return 0;
 }
 
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 41a8d9bff6bf9..00f1efeaa8832 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -41,7 +41,8 @@
 
 #define GAUDI_MAX_CLK_FREQ		2200000000ull	/* 2200 MHz */
 
-#define MAX_POWER_DEFAULT		200000		/* 200W */
+#define MAX_POWER_DEFAULT_PCI		200000		/* 200W */
+#define MAX_POWER_DEFAULT_PMC		350000		/* 350W */
 
 #define GAUDI_CPU_TIMEOUT_USEC		15000000	/* 15s */
 
diff --git a/drivers/misc/habanalabs/habanalabs.h b/drivers/misc/habanalabs/habanalabs.h
index feedf3194ea6c..1072f300252a4 100644
--- a/drivers/misc/habanalabs/habanalabs.h
+++ b/drivers/misc/habanalabs/habanalabs.h
@@ -1408,6 +1408,8 @@ struct hl_device_idle_busy_ts {
  *                     details.
  * @in_reset: is device in reset flow.
  * @curr_pll_profile: current PLL profile.
+ * @card_type: Various ASICs have several card types. This indicates the card
+ *             type of the current device.
  * @cs_active_cnt: number of active command submissions on this device (active
  *                 means already in H/W queues)
  * @major: habanalabs kernel driver major.
@@ -1503,6 +1505,7 @@ struct hl_device {
 	u64				clock_gating_mask;
 	atomic_t			in_reset;
 	enum hl_pll_frequency		curr_pll_profile;
+	enum armcp_card_types		card_type;
 	int				cs_active_cnt;
 	u32				major;
 	u32				high_pll;
@@ -1792,7 +1795,7 @@ int hl_get_pwm_info(struct hl_device *hdev,
 void hl_set_pwm_info(struct hl_device *hdev, int sensor_index, u32 attr,
 			long value);
 u64 hl_get_max_power(struct hl_device *hdev);
-void hl_set_max_power(struct hl_device *hdev, u64 value);
+void hl_set_max_power(struct hl_device *hdev);
 int hl_set_voltage(struct hl_device *hdev,
 			int sensor_index, u32 attr, long value);
 int hl_set_current(struct hl_device *hdev,
diff --git a/drivers/misc/habanalabs/sysfs.c b/drivers/misc/habanalabs/sysfs.c
index 70b6b1863c2ef..87dadb53ac59d 100644
--- a/drivers/misc/habanalabs/sysfs.c
+++ b/drivers/misc/habanalabs/sysfs.c
@@ -81,7 +81,7 @@ u64 hl_get_max_power(struct hl_device *hdev)
 	return result;
 }
 
-void hl_set_max_power(struct hl_device *hdev, u64 value)
+void hl_set_max_power(struct hl_device *hdev)
 {
 	struct armcp_packet pkt;
 	int rc;
@@ -90,7 +90,7 @@ void hl_set_max_power(struct hl_device *hdev, u64 value)
 
 	pkt.ctl = cpu_to_le32(ARMCP_PACKET_MAX_POWER_SET <<
 				ARMCP_PKT_CTL_OPCODE_SHIFT);
-	pkt.value = cpu_to_le64(value);
+	pkt.value = cpu_to_le64(hdev->max_power);
 
 	rc = hdev->asic_funcs->send_cpu_message(hdev, (u32 *) &pkt, sizeof(pkt),
 						0, NULL);
@@ -316,7 +316,7 @@ static ssize_t max_power_store(struct device *dev,
 	}
 
 	hdev->max_power = value;
-	hl_set_max_power(hdev, value);
+	hl_set_max_power(hdev);
 
 out:
 	return count;
@@ -419,6 +419,7 @@ int hl_sysfs_init(struct hl_device *hdev)
 		hdev->pm_mng_profile = PM_AUTO;
 	else
 		hdev->pm_mng_profile = PM_MANUAL;
+
 	hdev->max_power = hdev->asic_prop.max_power_default;
 
 	hdev->asic_funcs->add_device_attr(hdev, &hl_dev_clks_attr_group);
-- 
2.25.1

