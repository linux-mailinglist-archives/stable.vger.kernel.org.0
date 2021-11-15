Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396D6451FC0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354410AbhKPApL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343799AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5940F635E9;
        Mon, 15 Nov 2021 18:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002001;
        bh=ke2VmNCCltzMBgddkx8XxsJJF7/7qzZua360CVfp+Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkToLp6hIr3qPLUHQ+H6pS+VZ9+QQrjA8z3jkuMRAlfDA24MnNajYGmLqUwPRWe5D
         06UeDWz+9H3n7mW5gy1N/Yh7G8H2LpDYUSNh7tRPh5L1kwEs4MQNGlLZmnP3W8UHZH
         5Gr593rc7duzW8eIkv9i2aX+LdzaLrI5uNXmXqOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>,
        Steev Klimaszewski <steev@kali.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/917] ath10k: Dont always treat modem stop events as crashes
Date:   Mon, 15 Nov 2021 17:58:16 +0100
Message-Id: <20211115165442.389010077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 747ff7d3d7424876111b7559b7f6704762f89796 ]

When rebooting on sc7180 Trogdor devices I see the following crash from
the wifi driver.

 ath10k_snoc 18800000.wifi: firmware crashed! (guid 83493570-29a2-4e98-a83e-70048c47669c)

This is because a modem stop event looks just like a firmware crash to
the driver, the qmi connection is closed in both cases. Use the qcom ssr
notifier block to stop treating the qmi connection close event as a
firmware crash signal when the modem hasn't actually crashed. See
ath10k_qmi_event_server_exit() for more details.

This silences the crash message seen during every reboot.

Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
Cc: Youghandhar Chintala <youghand@codeaurora.org>
Cc: Abhishek Kumar <kuabhs@chromium.org>
Cc: Steev Klimaszewski <steev@kali.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
Tested-By: Youghandhar Chintala <youghand@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210922233341.182624-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c  |  3 +-
 drivers/net/wireless/ath/ath10k/snoc.c | 77 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h |  5 ++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 07e478f9a808c..80fcb917fe4e1 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -864,7 +864,8 @@ static void ath10k_qmi_event_server_exit(struct ath10k_qmi *qmi)
 
 	ath10k_qmi_remove_msa_permission(qmi);
 	ath10k_core_free_board_files(ar);
-	if (!test_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags))
+	if (!test_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags) &&
+	    !test_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags))
 		ath10k_snoc_fw_crashed_dump(ar);
 
 	ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_DOWN_IND);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ea00fbb156015..9513ab696fff1 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/regulator/consumer.h>
+#include <linux/remoteproc/qcom_rproc.h>
 #include <linux/of_address.h>
 #include <linux/iommu.h>
 
@@ -1477,6 +1478,74 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
 	mutex_unlock(&ar->dump_mutex);
 }
 
+static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long action,
+				    void *data)
+{
+	struct ath10k_snoc *ar_snoc = container_of(nb, struct ath10k_snoc, nb);
+	struct ath10k *ar = ar_snoc->ar;
+	struct qcom_ssr_notify_data *notify_data = data;
+
+	switch (action) {
+	case QCOM_SSR_BEFORE_POWERUP:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem starting event\n");
+		clear_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags);
+		break;
+
+	case QCOM_SSR_AFTER_POWERUP:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem running event\n");
+		break;
+
+	case QCOM_SSR_BEFORE_SHUTDOWN:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem %s event\n",
+			   notify_data->crashed ? "crashed" : "stopping");
+		if (!notify_data->crashed)
+			set_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags);
+		else
+			clear_bit(ATH10K_SNOC_FLAG_MODEM_STOPPED, &ar_snoc->flags);
+		break;
+
+	case QCOM_SSR_AFTER_SHUTDOWN:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem offline event\n");
+		break;
+
+	default:
+		ath10k_err(ar, "received unrecognized event %lu\n", action);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int ath10k_modem_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	void *notifier;
+	int ret;
+
+	ar_snoc->nb.notifier_call = ath10k_snoc_modem_notify;
+
+	notifier = qcom_register_ssr_notifier("mpss", &ar_snoc->nb);
+	if (IS_ERR(notifier)) {
+		ret = PTR_ERR(notifier);
+		ath10k_err(ar, "failed to initialize modem notifier: %d\n", ret);
+		return ret;
+	}
+
+	ar_snoc->notifier = notifier;
+
+	return 0;
+}
+
+static void ath10k_modem_deinit(struct ath10k *ar)
+{
+	int ret;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
+	ret = qcom_unregister_ssr_notifier(ar_snoc->notifier, &ar_snoc->nb);
+	if (ret)
+		ath10k_err(ar, "error %d unregistering notifier\n", ret);
+}
+
 static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
 {
 	struct device *dev = ar->dev;
@@ -1740,10 +1809,17 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_fw_deinit;
 	}
 
+	ret = ath10k_modem_init(ar);
+	if (ret)
+		goto err_qmi_deinit;
+
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
 
 	return 0;
 
+err_qmi_deinit:
+	ath10k_qmi_deinit(ar);
+
 err_fw_deinit:
 	ath10k_fw_deinit(ar);
 
@@ -1771,6 +1847,7 @@ static int ath10k_snoc_free_resources(struct ath10k *ar)
 	ath10k_fw_deinit(ar);
 	ath10k_snoc_free_irq(ar);
 	ath10k_snoc_release_resource(ar);
+	ath10k_modem_deinit(ar);
 	ath10k_qmi_deinit(ar);
 	ath10k_core_destroy(ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 5095d1893681b..d4bce17076960 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -6,6 +6,8 @@
 #ifndef _SNOC_H_
 #define _SNOC_H_
 
+#include <linux/notifier.h>
+
 #include "hw.h"
 #include "ce.h"
 #include "qmi.h"
@@ -45,6 +47,7 @@ struct ath10k_snoc_ce_irq {
 enum ath10k_snoc_flags {
 	ATH10K_SNOC_FLAG_REGISTERED,
 	ATH10K_SNOC_FLAG_UNREGISTERING,
+	ATH10K_SNOC_FLAG_MODEM_STOPPED,
 	ATH10K_SNOC_FLAG_RECOVERY,
 	ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK,
 };
@@ -75,6 +78,8 @@ struct ath10k_snoc {
 	struct clk_bulk_data *clks;
 	size_t num_clks;
 	struct ath10k_qmi *qmi;
+	struct notifier_block nb;
+	void *notifier;
 	unsigned long flags;
 	bool xo_cal_supported;
 	u32 xo_cal_data;
-- 
2.33.0



