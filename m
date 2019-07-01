Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5CE23085
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbfETJjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:39:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32798 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfETJjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:39:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id d9so810850wrx.0;
        Mon, 20 May 2019 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9iZXeO5bPn3FMs/pMHTVdUm3Z/mJIi+4s4z/QoGb2Q=;
        b=nBXlLYBUT9cl3yghnjTyeBok2/JIKbRLxpTFKjbhr3BuRv04ZgNxy010g1XaycyHAd
         RMSIhBsPHh7RS9vjzpVqXFrkWuG3O4DKqj1VnBsLObFOXvNrsflLYmJLFKQpQ1e1ZGsD
         ijxQ5T4UQDvb9XpAntQhgLwOt9KflZp+igx3Dyv5pWpUL4Z4Mtwm2mcJoPm5JwOggUim
         RTErFmbGGh+JSul6ox9stwZi9MSc+NaBljMMiBZopCXHkTB65/mv5Vy+zUoGWPInk8sh
         /77bjWdXZZEseYjacirr9UF1qwHRJz8yQODjWhz1Fcic4K3gzclynMh30z2IvcfTaCuF
         7cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9iZXeO5bPn3FMs/pMHTVdUm3Z/mJIi+4s4z/QoGb2Q=;
        b=hqwA6pQul7Otv1g0WVgG0iwu4HN+HPzRn5yrk4R6/6azt0aJEXGc+8WIXGxjfsym1a
         tEeOj6c1N3r3aDEsWgH0paVmqufhGckljTxxUacDdNg3lgbSK14ijq5sd0pwk7pBVXR/
         6BRrSAZo+0DIGfLsiH7fwZQ980kg+Qsq0tkOYyKn5JK85LVcDUyAGzTGOpwCJ0jrt/H0
         h2U5oyAQ44fDhXBkx2y9eks5xCTP5RdIfx0IMTY1H74yuPNZHBMnZfEYcFgGIBzuxOQg
         ri+gIkDaJy4HyB5WoGEC+pYj472XULjSsuQ08nBO6LuL9DnNc1NYFmALMJIVt4EQnIE2
         MZnw==
X-Gm-Message-State: APjAAAV4YhdxIrRQKVwpabjpAkhc5HST/PQnxcp01UyHBQv+z+wwtSHI
        BoaWjP0Z/ECi9SJ8jgHcKfaOormm
X-Google-Smtp-Source: APXvYqzGh4xF4uctJ+O6LyHWFfYrOpLW7JKRqSE95dnjQYGOyFozk4epJm6YdG/9StobsE58gRVGrw==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr28920251wrj.121.1558345153426;
        Mon, 20 May 2019 02:39:13 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id j28sm25787346wrd.64.2019.05.20.02.39.12
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 20 May 2019 02:39:12 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Benjamin Berg <benjamin@sipsolutions.net>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4.9] ath10k: allow setting coverage class
Date:   Mon, 20 May 2019 11:39:09 +0200
Message-Id: <1558345149-3274-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <benjamin@sipsolutions.net>

Unfortunately ath10k does not generally allow modifying the coverage class
with the stock firmware and Qualcomm has so far refused to implement this
feature so that it can be properly supported in ath10k. If we however know
the registers that need to be modified for proper operation with a higher
coverage class, then we can do these modifications from the driver.

This is a hack and might cause subtle problems but as it's not enabled by
default (only when user space changes the coverage class explicitly) it should
not cause new problems for existing setups. But still this should be considered
as an experimental feature and used with caution.

This patch implements the support for first generation cards (QCA9880, QCA9887
and so on) which are based on a core that is similar to ath9k. The registers
are modified in place and need to be re-written every time the firmware sets
them. To achieve this the register status is verified after certain WMI events
from the firmware.

The coverage class may not be modified temporarily right after the card
re-initializes the registers. This is for example the case during scanning.

Thanks to Sebastian Gottschall <s.gottschall@dd-wrt.com> for initially
working on a userspace support for this. This patch wouldn't have been
possible without this documentation.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---

v2:

* cc linux-wireless
* fold "ath10k: Fix spinlock use in coverage class hack" into this one (Benjamin)
* emphasise more on the commit log that this is a hack
* remove unnecessary use of unlikely(), this is not in hotpath
* workaround ifdef CONFIG_ATH10K_DEBUGFS with adding
  ath10k_debug_get_fw_dbglog_[mask|level]()

 drivers/net/wireless/ath/ath10k/core.c  |   11 +++
 drivers/net/wireless/ath/ath10k/core.h  |   13 +++
 drivers/net/wireless/ath/ath10k/debug.h |   22 +++++
 drivers/net/wireless/ath/ath10k/hw.c    |  142 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |   28 +++++-
 drivers/net/wireless/ath/ath10k/mac.c   |   19 +++++
 drivers/net/wireless/ath/ath10k/wmi.c   |   48 +++++++++++
 7 files changed, 282 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1574,6 +1574,15 @@ static void ath10k_core_restart(struct w
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_core_set_coverage_class_work(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k,
+					 set_coverage_class_work);
+
+	if (ar->hw_params.hw_ops->set_coverage_class)
+		ar->hw_params.hw_ops->set_coverage_class(ar, -1);
+}
+
 static int ath10k_core_init_firmware_features(struct ath10k *ar)
 {
 	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
@@ -2360,6 +2369,8 @@ struct ath10k *ath10k_core_create(size_t
 
 	INIT_WORK(&ar->register_work, ath10k_core_register_work);
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
+	INIT_WORK(&ar->set_coverage_class_work,
+		  ath10k_core_set_coverage_class_work);
 
 	init_dummy_netdev(&ar->napi_dev);
 
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -911,6 +911,19 @@ struct ath10k {
 	struct net_device napi_dev;
 	struct napi_struct napi;
 
+	struct work_struct set_coverage_class_work;
+	/* protected by conf_mutex */
+	struct {
+		/* writing also protected by data_lock */
+		s16 coverage_class;
+
+		u32 reg_phyclk;
+		u32 reg_slottime_conf;
+		u32 reg_slottime_orig;
+		u32 reg_ack_cts_timeout_conf;
+		u32 reg_ack_cts_timeout_orig;
+	} fw_coverage;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -94,7 +94,19 @@ int ath10k_debug_get_et_sset_count(struc
 void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ethtool_stats *stats, u64 *data);
+
+static inline u64 ath10k_debug_get_fw_dbglog_mask(struct ath10k *ar)
+{
+	return ar->debug.fw_dbglog_mask;
+}
+
+static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
+{
+	return ar->debug.fw_dbglog_level;
+}
+
 #else
+
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
 	return 0;
@@ -144,6 +156,16 @@ ath10k_debug_get_new_fw_crash_data(struc
 	return NULL;
 }
 
+static inline u64 ath10k_debug_get_fw_dbglog_mask(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
+{
+	return 0;
+}
+
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #define ath10k_debug_get_et_strings NULL
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -17,11 +17,14 @@
 #include <linux/types.h>
 #include "core.h"
 #include "hw.h"
+#include "hif.h"
+#include "wmi-ops.h"
 
 const struct ath10k_hw_regs qca988x_regs = {
 	.rtc_soc_base_address		= 0x00004000,
 	.rtc_wmac_base_address		= 0x00005000,
 	.soc_core_base_address		= 0x00009000,
+	.wlan_mac_base_address		= 0x00020000,
 	.ce_wrapper_base_address	= 0x00057000,
 	.ce0_base_address		= 0x00057400,
 	.ce1_base_address		= 0x00057800,
@@ -48,6 +51,7 @@ const struct ath10k_hw_regs qca6174_regs
 	.rtc_soc_base_address			= 0x00000800,
 	.rtc_wmac_base_address			= 0x00001000,
 	.soc_core_base_address			= 0x0003a000,
+	.wlan_mac_base_address			= 0x00020000,
 	.ce_wrapper_base_address		= 0x00034000,
 	.ce0_base_address			= 0x00034400,
 	.ce1_base_address			= 0x00034800,
@@ -74,6 +78,7 @@ const struct ath10k_hw_regs qca99x0_regs
 	.rtc_soc_base_address			= 0x00080000,
 	.rtc_wmac_base_address			= 0x00000000,
 	.soc_core_base_address			= 0x00082000,
+	.wlan_mac_base_address			= 0x00030000,
 	.ce_wrapper_base_address		= 0x0004d000,
 	.ce0_base_address			= 0x0004a000,
 	.ce1_base_address			= 0x0004a400,
@@ -109,6 +114,7 @@ const struct ath10k_hw_regs qca99x0_regs
 const struct ath10k_hw_regs qca4019_regs = {
 	.rtc_soc_base_address                   = 0x00080000,
 	.soc_core_base_address                  = 0x00082000,
+	.wlan_mac_base_address                  = 0x00030000,
 	.ce_wrapper_base_address                = 0x0004d000,
 	.ce0_base_address                       = 0x0004a000,
 	.ce1_base_address                       = 0x0004a400,
@@ -220,7 +226,143 @@ void ath10k_hw_fill_survey_time(struct a
 	survey->time_busy = CCNT_TO_MSEC(ar, rcc);
 }
 
+/* The firmware does not support setting the coverage class. Instead this
+ * function monitors and modifies the corresponding MAC registers.
+ */
+static void ath10k_hw_qca988x_set_coverage_class(struct ath10k *ar,
+						 s16 value)
+{
+	u32 slottime_reg;
+	u32 slottime;
+	u32 timeout_reg;
+	u32 ack_timeout;
+	u32 cts_timeout;
+	u32 phyclk_reg;
+	u32 phyclk;
+	u64 fw_dbglog_mask;
+	u32 fw_dbglog_level;
+
+	mutex_lock(&ar->conf_mutex);
+
+	/* Only modify registers if the core is started. */
+	if ((ar->state != ATH10K_STATE_ON) &&
+	    (ar->state != ATH10K_STATE_RESTARTED))
+		goto unlock;
+
+	/* Retrieve the current values of the two registers that need to be
+	 * adjusted.
+	 */
+	slottime_reg = ath10k_hif_read32(ar, WLAN_MAC_BASE_ADDRESS +
+					     WAVE1_PCU_GBL_IFS_SLOT);
+	timeout_reg = ath10k_hif_read32(ar, WLAN_MAC_BASE_ADDRESS +
+					    WAVE1_PCU_ACK_CTS_TIMEOUT);
+	phyclk_reg = ath10k_hif_read32(ar, WLAN_MAC_BASE_ADDRESS +
+					   WAVE1_PHYCLK);
+	phyclk = MS(phyclk_reg, WAVE1_PHYCLK_USEC) + 1;
+
+	if (value < 0)
+		value = ar->fw_coverage.coverage_class;
+
+	/* Break out if the coverage class and registers have the expected
+	 * value.
+	 */
+	if (value == ar->fw_coverage.coverage_class &&
+	    slottime_reg == ar->fw_coverage.reg_slottime_conf &&
+	    timeout_reg == ar->fw_coverage.reg_ack_cts_timeout_conf &&
+	    phyclk_reg == ar->fw_coverage.reg_phyclk)
+		goto unlock;
+
+	/* Store new initial register values from the firmware. */
+	if (slottime_reg != ar->fw_coverage.reg_slottime_conf)
+		ar->fw_coverage.reg_slottime_orig = slottime_reg;
+	if (timeout_reg != ar->fw_coverage.reg_ack_cts_timeout_conf)
+		ar->fw_coverage.reg_ack_cts_timeout_orig = timeout_reg;
+	ar->fw_coverage.reg_phyclk = phyclk_reg;
+
+	/* Calculat new value based on the (original) firmware calculation. */
+	slottime_reg = ar->fw_coverage.reg_slottime_orig;
+	timeout_reg = ar->fw_coverage.reg_ack_cts_timeout_orig;
+
+	/* Do some sanity checks on the slottime register. */
+	if (slottime_reg % phyclk) {
+		ath10k_warn(ar,
+			    "failed to set coverage class: expected integer microsecond value in register\n");
+
+		goto store_regs;
+	}
+
+	slottime = MS(slottime_reg, WAVE1_PCU_GBL_IFS_SLOT);
+	slottime = slottime / phyclk;
+	if (slottime != 9 && slottime != 20) {
+		ath10k_warn(ar,
+			    "failed to set coverage class: expected slot time of 9 or 20us in HW register. It is %uus.\n",
+			    slottime);
+
+		goto store_regs;
+	}
+
+	/* Recalculate the register values by adding the additional propagation
+	 * delay (3us per coverage class).
+	 */
+
+	slottime = MS(slottime_reg, WAVE1_PCU_GBL_IFS_SLOT);
+	slottime += value * 3 * phyclk;
+	slottime = min_t(u32, slottime, WAVE1_PCU_GBL_IFS_SLOT_MAX);
+	slottime = SM(slottime, WAVE1_PCU_GBL_IFS_SLOT);
+	slottime_reg = (slottime_reg & ~WAVE1_PCU_GBL_IFS_SLOT_MASK) | slottime;
+
+	/* Update ack timeout (lower halfword). */
+	ack_timeout = MS(timeout_reg, WAVE1_PCU_ACK_CTS_TIMEOUT_ACK);
+	ack_timeout += 3 * value * phyclk;
+	ack_timeout = min_t(u32, ack_timeout, WAVE1_PCU_ACK_CTS_TIMEOUT_MAX);
+	ack_timeout = SM(ack_timeout, WAVE1_PCU_ACK_CTS_TIMEOUT_ACK);
+
+	/* Update cts timeout (upper halfword). */
+	cts_timeout = MS(timeout_reg, WAVE1_PCU_ACK_CTS_TIMEOUT_CTS);
+	cts_timeout += 3 * value * phyclk;
+	cts_timeout = min_t(u32, cts_timeout, WAVE1_PCU_ACK_CTS_TIMEOUT_MAX);
+	cts_timeout = SM(cts_timeout, WAVE1_PCU_ACK_CTS_TIMEOUT_CTS);
+
+	timeout_reg = ack_timeout | cts_timeout;
+
+	ath10k_hif_write32(ar,
+			   WLAN_MAC_BASE_ADDRESS + WAVE1_PCU_GBL_IFS_SLOT,
+			   slottime_reg);
+	ath10k_hif_write32(ar,
+			   WLAN_MAC_BASE_ADDRESS + WAVE1_PCU_ACK_CTS_TIMEOUT,
+			   timeout_reg);
+
+	/* Ensure we have a debug level of WARN set for the case that the
+	 * coverage class is larger than 0. This is important as we need to
+	 * set the registers again if the firmware does an internal reset and
+	 * this way we will be notified of the event.
+	 */
+	fw_dbglog_mask = ath10k_debug_get_fw_dbglog_mask(ar);
+	fw_dbglog_level = ath10k_debug_get_fw_dbglog_level(ar);
+
+	if (value > 0) {
+		if (fw_dbglog_level > ATH10K_DBGLOG_LEVEL_WARN)
+			fw_dbglog_level = ATH10K_DBGLOG_LEVEL_WARN;
+		fw_dbglog_mask = ~0;
+	}
+
+	ath10k_wmi_dbglog_cfg(ar, fw_dbglog_mask, fw_dbglog_level);
+
+store_regs:
+	/* After an error we will not retry setting the coverage class. */
+	spin_lock_bh(&ar->data_lock);
+	ar->fw_coverage.coverage_class = value;
+	spin_unlock_bh(&ar->data_lock);
+
+	ar->fw_coverage.reg_slottime_conf = slottime_reg;
+	ar->fw_coverage.reg_ack_cts_timeout_conf = timeout_reg;
+
+unlock:
+	mutex_unlock(&ar->conf_mutex);
+}
+
 const struct ath10k_hw_ops qca988x_ops = {
+	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
 };
 
 static int ath10k_qca99x0_rx_desc_get_l3_pad_bytes(struct htt_rx_desc *rxd)
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -230,6 +230,7 @@ struct ath10k_hw_regs {
 	u32 rtc_soc_base_address;
 	u32 rtc_wmac_base_address;
 	u32 soc_core_base_address;
+	u32 wlan_mac_base_address;
 	u32 ce_wrapper_base_address;
 	u32 ce0_base_address;
 	u32 ce1_base_address;
@@ -418,6 +419,7 @@ struct htt_rx_desc;
 /* Defines needed for Rx descriptor abstraction */
 struct ath10k_hw_ops {
 	int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
+	void (*set_coverage_class)(struct ath10k *ar, s16 value);
 };
 
 extern const struct ath10k_hw_ops qca988x_ops;
@@ -614,7 +616,7 @@ ath10k_rx_desc_get_l3_pad_bytes(struct a
 #define WLAN_SI_BASE_ADDRESS			0x00010000
 #define WLAN_GPIO_BASE_ADDRESS			0x00014000
 #define WLAN_ANALOG_INTF_BASE_ADDRESS		0x0001c000
-#define WLAN_MAC_BASE_ADDRESS			0x00020000
+#define WLAN_MAC_BASE_ADDRESS			ar->regs->wlan_mac_base_address
 #define EFUSE_BASE_ADDRESS			0x00030000
 #define FPGA_REG_BASE_ADDRESS			0x00039000
 #define WLAN_UART2_BASE_ADDRESS			0x00054c00
@@ -814,4 +816,28 @@ ath10k_rx_desc_get_l3_pad_bytes(struct a
 
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
+/* Register definitions for first generation ath10k cards. These cards include
+ * a mac thich has a register allocation similar to ath9k and at least some
+ * registers including the ones relevant for modifying the coverage class are
+ * identical to the ath9k definitions.
+ * These registers are usually managed by the ath10k firmware. However by
+ * overriding them it is possible to support coverage class modifications.
+ */
+#define WAVE1_PCU_ACK_CTS_TIMEOUT		0x8014
+#define WAVE1_PCU_ACK_CTS_TIMEOUT_MAX		0x00003FFF
+#define WAVE1_PCU_ACK_CTS_TIMEOUT_ACK_MASK	0x00003FFF
+#define WAVE1_PCU_ACK_CTS_TIMEOUT_ACK_LSB	0
+#define WAVE1_PCU_ACK_CTS_TIMEOUT_CTS_MASK	0x3FFF0000
+#define WAVE1_PCU_ACK_CTS_TIMEOUT_CTS_LSB	16
+
+#define WAVE1_PCU_GBL_IFS_SLOT			0x1070
+#define WAVE1_PCU_GBL_IFS_SLOT_MASK		0x0000FFFF
+#define WAVE1_PCU_GBL_IFS_SLOT_MAX		0x0000FFFF
+#define WAVE1_PCU_GBL_IFS_SLOT_LSB		0
+#define WAVE1_PCU_GBL_IFS_SLOT_RESV0		0xFFFF0000
+
+#define WAVE1_PHYCLK				0x801C
+#define WAVE1_PHYCLK_USEC_MASK			0x0000007F
+#define WAVE1_PHYCLK_USEC_LSB			0
+
 #endif /* _HW_H_ */
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5452,6 +5452,20 @@ static void ath10k_bss_info_changed(stru
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_mac_op_set_coverage_class(struct ieee80211_hw *hw, s16 value)
+{
+	struct ath10k *ar = hw->priv;
+
+	/* This function should never be called if setting the coverage class
+	 * is not supported on this hardware.
+	 */
+	if (!ar->hw_params.hw_ops->set_coverage_class) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+	ar->hw_params.hw_ops->set_coverage_class(ar, value);
+}
+
 static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_scan_request *hw_req)
@@ -7517,6 +7531,7 @@ static const struct ieee80211_ops ath10k
 	.remove_interface		= ath10k_remove_interface,
 	.configure_filter		= ath10k_configure_filter,
 	.bss_info_changed		= ath10k_bss_info_changed,
+	.set_coverage_class		= ath10k_mac_op_set_coverage_class,
 	.hw_scan			= ath10k_hw_scan,
 	.cancel_hw_scan			= ath10k_cancel_hw_scan,
 	.set_key			= ath10k_set_key,
@@ -8095,6 +8110,10 @@ int ath10k_mac_register(struct ath10k *a
 		      ar->running_fw->fw_file.fw_features))
 		ar->ops->wake_tx_queue = NULL;
 
+	/* Disable set_coverage_class for chipsets that do not support it. */
+	if (!ar->hw_params.hw_ops->set_coverage_class)
+		ar->ops->set_coverage_class = NULL;
+
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4942,6 +4942,23 @@ exit:
 	return 0;
 }
 
+static inline void ath10k_wmi_queue_set_coverage_class_work(struct ath10k *ar)
+{
+	if (ar->hw_params.hw_ops->set_coverage_class) {
+		spin_lock_bh(&ar->data_lock);
+
+		/* This call only ensures that the modified coverage class
+		 * persists in case the firmware sets the registers back to
+		 * their default value. So calling it is only necessary if the
+		 * coverage class has a non-zero value.
+		 */
+		if (ar->fw_coverage.coverage_class)
+			queue_work(ar->workqueue, &ar->set_coverage_class_work);
+
+		spin_unlock_bh(&ar->data_lock);
+	}
+}
+
 static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -4962,6 +4979,7 @@ static void ath10k_wmi_op_rx(struct ath1
 		return;
 	case WMI_SCAN_EVENTID:
 		ath10k_wmi_event_scan(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_chan_info(ar, skb);
@@ -4971,15 +4989,18 @@ static void ath10k_wmi_op_rx(struct ath1
 		break;
 	case WMI_DEBUG_MESG_EVENTID:
 		ath10k_wmi_event_debug_mesg(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_UPDATE_STATS_EVENTID:
 		ath10k_wmi_event_update_stats(ar, skb);
 		break;
 	case WMI_VDEV_START_RESP_EVENTID:
 		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_VDEV_STOPPED_EVENTID:
 		ath10k_wmi_event_vdev_stopped(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
@@ -4995,12 +5016,14 @@ static void ath10k_wmi_op_rx(struct ath1
 		break;
 	case WMI_ROAM_EVENTID:
 		ath10k_wmi_event_roam(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_PROFILE_MATCH:
 		ath10k_wmi_event_profile_match(ar, skb);
 		break;
 	case WMI_DEBUG_PRINT_EVENTID:
 		ath10k_wmi_event_debug_print(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_PDEV_QVIT_EVENTID:
 		ath10k_wmi_event_pdev_qvit(ar, skb);
@@ -5049,6 +5072,7 @@ static void ath10k_wmi_op_rx(struct ath1
 		return;
 	case WMI_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
@@ -5092,6 +5116,7 @@ static void ath10k_wmi_10_1_op_rx(struct
 		return;
 	case WMI_10X_SCAN_EVENTID:
 		ath10k_wmi_event_scan(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_chan_info(ar, skb);
@@ -5101,15 +5126,18 @@ static void ath10k_wmi_10_1_op_rx(struct
 		break;
 	case WMI_10X_DEBUG_MESG_EVENTID:
 		ath10k_wmi_event_debug_mesg(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_UPDATE_STATS_EVENTID:
 		ath10k_wmi_event_update_stats(ar, skb);
 		break;
 	case WMI_10X_VDEV_START_RESP_EVENTID:
 		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_VDEV_STOPPED_EVENTID:
 		ath10k_wmi_event_vdev_stopped(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
@@ -5125,12 +5153,14 @@ static void ath10k_wmi_10_1_op_rx(struct
 		break;
 	case WMI_10X_ROAM_EVENTID:
 		ath10k_wmi_event_roam(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_PROFILE_MATCH:
 		ath10k_wmi_event_profile_match(ar, skb);
 		break;
 	case WMI_10X_DEBUG_PRINT_EVENTID:
 		ath10k_wmi_event_debug_print(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_PDEV_QVIT_EVENTID:
 		ath10k_wmi_event_pdev_qvit(ar, skb);
@@ -5170,6 +5200,7 @@ static void ath10k_wmi_10_1_op_rx(struct
 		return;
 	case WMI_10X_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10X_PDEV_UTF_EVENTID:
 		/* ignore utf events */
@@ -5216,6 +5247,7 @@ static void ath10k_wmi_10_2_op_rx(struct
 		return;
 	case WMI_10_2_SCAN_EVENTID:
 		ath10k_wmi_event_scan(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_chan_info(ar, skb);
@@ -5225,15 +5257,18 @@ static void ath10k_wmi_10_2_op_rx(struct
 		break;
 	case WMI_10_2_DEBUG_MESG_EVENTID:
 		ath10k_wmi_event_debug_mesg(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_UPDATE_STATS_EVENTID:
 		ath10k_wmi_event_update_stats(ar, skb);
 		break;
 	case WMI_10_2_VDEV_START_RESP_EVENTID:
 		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_VDEV_STOPPED_EVENTID:
 		ath10k_wmi_event_vdev_stopped(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
@@ -5249,12 +5284,14 @@ static void ath10k_wmi_10_2_op_rx(struct
 		break;
 	case WMI_10_2_ROAM_EVENTID:
 		ath10k_wmi_event_roam(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_PROFILE_MATCH:
 		ath10k_wmi_event_profile_match(ar, skb);
 		break;
 	case WMI_10_2_DEBUG_PRINT_EVENTID:
 		ath10k_wmi_event_debug_print(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_PDEV_QVIT_EVENTID:
 		ath10k_wmi_event_pdev_qvit(ar, skb);
@@ -5285,15 +5322,18 @@ static void ath10k_wmi_10_2_op_rx(struct
 		break;
 	case WMI_10_2_VDEV_STANDBY_REQ_EVENTID:
 		ath10k_wmi_event_vdev_standby_req(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_VDEV_RESUME_REQ_EVENTID:
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
 		return;
 	case WMI_10_2_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_2_PDEV_TEMPERATURE_EVENTID:
 		ath10k_wmi_event_temperature(ar, skb);
@@ -5356,12 +5396,14 @@ static void ath10k_wmi_10_4_op_rx(struct
 		break;
 	case WMI_10_4_DEBUG_MESG_EVENTID:
 		ath10k_wmi_event_debug_mesg(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
 		return;
 	case WMI_10_4_SCAN_EVENTID:
 		ath10k_wmi_event_scan(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_chan_info(ar, skb);
@@ -5371,12 +5413,14 @@ static void ath10k_wmi_10_4_op_rx(struct
 		break;
 	case WMI_10_4_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
 		break;
 	case WMI_10_4_ROAM_EVENTID:
 		ath10k_wmi_event_roam(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_HOST_SWBA_EVENTID:
 		ath10k_wmi_event_host_swba(ar, skb);
@@ -5386,12 +5430,15 @@ static void ath10k_wmi_10_4_op_rx(struct
 		break;
 	case WMI_10_4_DEBUG_PRINT_EVENTID:
 		ath10k_wmi_event_debug_print(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_VDEV_START_RESP_EVENTID:
 		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_VDEV_STOPPED_EVENTID:
 		ath10k_wmi_event_vdev_stopped(ar, skb);
+		ath10k_wmi_queue_set_coverage_class_work(ar);
 		break;
 	case WMI_10_4_WOW_WAKEUP_HOST_EVENTID:
 	case WMI_10_4_PEER_RATECODE_LIST_EVENTID:
@@ -6107,6 +6154,7 @@ void ath10k_wmi_start_scan_init(struct a
 		| WMI_SCAN_EVENT_COMPLETED
 		| WMI_SCAN_EVENT_BSS_CHANNEL
 		| WMI_SCAN_EVENT_FOREIGN_CHANNEL
+		| WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT
 		| WMI_SCAN_EVENT_DEQUEUED;
 	arg->scan_ctrl_flags |= WMI_SCAN_CHAN_STAT_EVENT;
 	arg->n_bssids = 1;
