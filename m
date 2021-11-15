Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9115451115
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbhKOTBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243478AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF3960FE7;
        Mon, 15 Nov 2021 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000015;
        bh=rSKTAnT0EGQV08ZjXD6iEHYkZq+ShRp0M2iuP+buSUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3Xai85WqUt9kVMh3ZGuQFpdcsUGzsjgWZ9miPsSMo9wxxsV4LMxUWdaDAS3ETwnl
         0riyOqZ9Y2B/I2YtJzGB7xElX0MAdSzT88oUE6NFEX4DF8nMO+QLqrC2OPsGhljCPl
         NPYJ+CcBOrdHeZALTkL9wZr2vmaGapKWpnEWkcqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abinaya Kalaiselvan <akalaise@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 507/849] ath10k: fix module load regression with iram-recovery feature
Date:   Mon, 15 Nov 2021 17:59:50 +0100
Message-Id: <20211115165437.436403843@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abinaya Kalaiselvan <akalaise@codeaurora.org>

[ Upstream commit 6f8c8bf4c7c9be1c42088689fd4370e06b46608a ]

Commit 9af7c32ceca8 ("ath10k: add target IRAM recovery feature support")
introduced a new firmware feature flag ATH10K_FW_FEATURE_IRAM_RECOVERY. But
this caused ath10k_pci module load to fail if ATH10K_FW_CRASH_DUMP_RAM_DATA bit
was not enabled in the ath10k coredump_mask module parameter:

[ 2209.328190] ath10k_pci 0000:02:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_id 0x00000000 sub 168c:cafe
[ 2209.434414] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
[ 2209.547191] ath10k_pci 0000:02:00.0: firmware ver 10.4-3.9.0.2-00099 api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-rate,iram-recovery crc32 cbade90a
[ 2210.896485] ath10k_pci 0000:02:00.0: board_file api 1 bmi_id 0:1 crc32 a040efc2
[ 2213.603339] ath10k_pci 0000:02:00.0: failed to copy target iram contents: -12
[ 2213.839027] ath10k_pci 0000:02:00.0: could not init core (-12)
[ 2213.933910] ath10k_pci 0000:02:00.0: could not probe fw (-12)

And by default coredump_mask does not have ATH10K_FW_CRASH_DUMP_RAM_DATA
enabled so anyone using a firmware with iram-recovery feature would fail. To my
knowledge only QCA9984 firmwares starting from release 10.4-3.9.0.2-00099
enabled the feature.

The reason for regression was that ath10k_core_copy_target_iram() used
ath10k_coredump_get_mem_layout() to get the memory layout, but when
ATH10K_FW_CRASH_DUMP_RAM_DATA was disabled it would get just NULL and bail out
with an error.

While looking at all this I noticed another bug: if CONFIG_DEV_COREDUMP is
disabled but the firmware has iram-recovery enabled the module load fails with
similar error messages. I fixed that by returning 0 from
ath10k_core_copy_target_iram() when _ath10k_coredump_get_mem_layout() returns
NULL.

Tested-on: QCA9984 hw2.0 PCI 10.4-3.9.0.2-00139

Fixes: 9af7c32ceca8 ("ath10k: add target IRAM recovery feature support")
Signed-off-by: Abinaya Kalaiselvan <akalaise@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211020075054.23061-1-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c     | 11 +++++++++--
 drivers/net/wireless/ath/ath10k/coredump.c | 11 ++++++++---
 drivers/net/wireless/ath/ath10k/coredump.h |  7 +++++++
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2f9be182fbfbb..64c7145b51a2e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2690,9 +2690,16 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
 	int i, ret;
 	u32 len, remaining_len;
 
-	hw_mem = ath10k_coredump_get_mem_layout(ar);
+	/* copy target iram feature must work also when
+	 * ATH10K_FW_CRASH_DUMP_RAM_DATA is disabled, so
+	 * _ath10k_coredump_get_mem_layout() to accomplist that
+	 */
+	hw_mem = _ath10k_coredump_get_mem_layout(ar);
 	if (!hw_mem)
-		return -ENOMEM;
+		/* if CONFIG_DEV_COREDUMP is disabled we get NULL, then
+		 * just silently disable the feature by doing nothing
+		 */
+		return 0;
 
 	for (i = 0; i < hw_mem->region_table.size; i++) {
 		tmp = &hw_mem->region_table.regions[i];
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 7eb72290a925c..55e7e11d06d94 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1447,11 +1447,17 @@ static u32 ath10k_coredump_get_ramdump_size(struct ath10k *ar)
 
 const struct ath10k_hw_mem_layout *ath10k_coredump_get_mem_layout(struct ath10k *ar)
 {
-	int i;
-
 	if (!test_bit(ATH10K_FW_CRASH_DUMP_RAM_DATA, &ath10k_coredump_mask))
 		return NULL;
 
+	return _ath10k_coredump_get_mem_layout(ar);
+}
+EXPORT_SYMBOL(ath10k_coredump_get_mem_layout);
+
+const struct ath10k_hw_mem_layout *_ath10k_coredump_get_mem_layout(struct ath10k *ar)
+{
+	int i;
+
 	if (WARN_ON(ar->target_version == 0))
 		return NULL;
 
@@ -1464,7 +1470,6 @@ const struct ath10k_hw_mem_layout *ath10k_coredump_get_mem_layout(struct ath10k
 
 	return NULL;
 }
-EXPORT_SYMBOL(ath10k_coredump_get_mem_layout);
 
 struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar)
 {
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index 42404e246e0e9..240d705150888 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -176,6 +176,7 @@ int ath10k_coredump_register(struct ath10k *ar);
 void ath10k_coredump_unregister(struct ath10k *ar);
 void ath10k_coredump_destroy(struct ath10k *ar);
 
+const struct ath10k_hw_mem_layout *_ath10k_coredump_get_mem_layout(struct ath10k *ar);
 const struct ath10k_hw_mem_layout *ath10k_coredump_get_mem_layout(struct ath10k *ar);
 
 #else /* CONFIG_DEV_COREDUMP */
@@ -214,6 +215,12 @@ ath10k_coredump_get_mem_layout(struct ath10k *ar)
 	return NULL;
 }
 
+static inline const struct ath10k_hw_mem_layout *
+_ath10k_coredump_get_mem_layout(struct ath10k *ar)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_DEV_COREDUMP */
 
 #endif /* _COREDUMP_H_ */
-- 
2.33.0



