Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38803676EA6
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjAVPMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjAVPMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA31B12870
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602F360C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E1C433D2;
        Sun, 22 Jan 2023 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400366;
        bh=klDCfTxdSlMAVvKaDs9tcIw+X+jBIuB6jYSumCgRGmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euHpl/0Am9qb7IIXj9HJdgOikbrJwghm6WIxyy2VHyYRv2Aathet6xBsixe6JNSJa
         zz4H502ETlj1EB8gXvq22oX9GlKWGOX/KbLbUWvzstcIXrmv2XW98yzLW90wZRz8VN
         7MYDRxTO5tYpV262gkfX8JgIAeWOzTmAzZ7U0zIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/98] Bluetooth: hci_qca: Wait for timeout during suspend
Date:   Sun, 22 Jan 2023 16:03:34 +0100
Message-Id: <20230122150230.216263248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit 2be43abac5a839d44bf9d14716573ae0ac920f2b ]

Currently qca_suspend() is relied on IBS mechanism. During
FW download and memory dump collections, IBS will be disabled.
In those cases, driver will allow suspend and still uses the
serdev port, which results to errors. Now added a wait timeout
if suspend is triggered during FW download and memory collections.

Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 272970be3dab ("Bluetooth: hci_qca: Fix driver shutdown on closed serdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 48 ++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 60b0e13bb9fc..652290425028 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -50,6 +50,8 @@
 #define IBS_HOST_TX_IDLE_TIMEOUT_MS	2000
 #define CMD_TRANS_TIMEOUT_MS		100
 #define MEMDUMP_TIMEOUT_MS		8000
+#define IBS_DISABLE_SSR_TIMEOUT_MS	(MEMDUMP_TIMEOUT_MS + 1000)
+#define FW_DOWNLOAD_TIMEOUT_MS		3000
 
 /* susclk rate */
 #define SUSCLK_RATE_32KHZ	32768
@@ -68,12 +70,13 @@
 #define QCA_MEMDUMP_BYTE		0xFB
 
 enum qca_flags {
-	QCA_IBS_ENABLED,
+	QCA_IBS_DISABLED,
 	QCA_DROP_VENDOR_EVENT,
 	QCA_SUSPENDING,
 	QCA_MEMDUMP_COLLECTION,
 	QCA_HW_ERROR_EVENT,
-	QCA_SSR_TRIGGERED
+	QCA_SSR_TRIGGERED,
+	QCA_BT_OFF
 };
 
 enum qca_capabilities {
@@ -870,7 +873,7 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	 * Out-Of-Band(GPIOs control) sleep is selected.
 	 * Don't wake the device up when suspending.
 	 */
-	if (!test_bit(QCA_IBS_ENABLED, &qca->flags) ||
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags) ||
 	    test_bit(QCA_SUSPENDING, &qca->flags)) {
 		skb_queue_tail(&qca->txq, skb);
 		spin_unlock_irqrestore(&qca->hci_ibs_lock, flags);
@@ -1015,7 +1018,7 @@ static void qca_controller_memdump(struct work_struct *work)
 			 * the controller to send the dump is 8 seconds. let us
 			 * start timer to handle this asynchronous activity.
 			 */
-			clear_bit(QCA_IBS_ENABLED, &qca->flags);
+			set_bit(QCA_IBS_DISABLED, &qca->flags);
 			set_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
 			dump = (void *) skb->data;
 			dump_size = __le32_to_cpu(dump->dump_size);
@@ -1621,6 +1624,7 @@ static int qca_power_on(struct hci_dev *hdev)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 	struct qca_serdev *qcadev;
+	struct qca_data *qca = hu->priv;
 	int ret = 0;
 
 	/* Non-serdev device usually is powered by external power
@@ -1640,6 +1644,7 @@ static int qca_power_on(struct hci_dev *hdev)
 		}
 	}
 
+	clear_bit(QCA_BT_OFF, &qca->flags);
 	return ret;
 }
 
@@ -1659,7 +1664,7 @@ static int qca_setup(struct hci_uart *hu)
 		return ret;
 
 	/* Patch downloading has to be done without IBS mode */
-	clear_bit(QCA_IBS_ENABLED, &qca->flags);
+	set_bit(QCA_IBS_DISABLED, &qca->flags);
 
 	/* Enable controller to do both LE scan and BR/EDR inquiry
 	 * simultaneously.
@@ -1710,7 +1715,7 @@ static int qca_setup(struct hci_uart *hu)
 	ret = qca_uart_setup(hdev, qca_baudrate, soc_type, soc_ver,
 			firmware_name);
 	if (!ret) {
-		set_bit(QCA_IBS_ENABLED, &qca->flags);
+		clear_bit(QCA_IBS_DISABLED, &qca->flags);
 		qca_debugfs_init(hdev);
 		hu->hdev->hw_error = qca_hw_error;
 		hu->hdev->cmd_timeout = qca_cmd_timeout;
@@ -1814,7 +1819,7 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	 * data in skb's.
 	 */
 	spin_lock_irqsave(&qca->hci_ibs_lock, flags);
-	clear_bit(QCA_IBS_ENABLED, &qca->flags);
+	set_bit(QCA_IBS_DISABLED, &qca->flags);
 	qca_flush(hu);
 	spin_unlock_irqrestore(&qca->hci_ibs_lock, flags);
 
@@ -1833,6 +1838,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	} else if (qcadev->bt_en) {
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 	}
+
+	set_bit(QCA_BT_OFF, &qca->flags);
 }
 
 static int qca_power_off(struct hci_dev *hdev)
@@ -2093,11 +2100,34 @@ static int __maybe_unused qca_suspend(struct device *dev)
 	bool tx_pending = false;
 	int ret = 0;
 	u8 cmd;
+	u32 wait_timeout = 0;
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
-	/* Device is downloading patch or doesn't support in-band sleep. */
-	if (!test_bit(QCA_IBS_ENABLED, &qca->flags))
+	if (test_bit(QCA_BT_OFF, &qca->flags))
+		return 0;
+
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
+		wait_timeout = test_bit(QCA_SSR_TRIGGERED, &qca->flags) ?
+					IBS_DISABLE_SSR_TIMEOUT_MS :
+					FW_DOWNLOAD_TIMEOUT_MS;
+
+		/* QCA_IBS_DISABLED flag is set to true, During FW download
+		 * and during memory dump collection. It is reset to false,
+		 * After FW download complete and after memory dump collections.
+		 */
+		wait_on_bit_timeout(&qca->flags, QCA_IBS_DISABLED,
+			    TASK_UNINTERRUPTIBLE, msecs_to_jiffies(wait_timeout));
+
+		if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
+			bt_dev_err(hu->hdev, "SSR or FW download time out");
+			ret = -ETIMEDOUT;
+			goto error;
+		}
+	}
+
+	/* After memory dump collection, Controller is powered off.*/
+	if (test_bit(QCA_BT_OFF, &qca->flags))
 		return 0;
 
 	cancel_work_sync(&qca->ws_awake_device);
-- 
2.39.0



