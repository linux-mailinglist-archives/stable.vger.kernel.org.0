Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F22410BA
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgHJTJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgHJTJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B33722D07;
        Mon, 10 Aug 2020 19:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086595;
        bh=TWkVTrn4wtXnPeHy9dd1qMkMpuJMdWKnycx+yE2RMEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yvl+W82k+iWq5bnQy2piXwuP2WWEp9opIzE72SrmVUHbzZXCk8OgGI9lB5uoZcFSX
         3IVdwrQOk0zxNSBFYVGo1Pahx6PLIQ1si799e+i6QXjt9pyqhLFCOjyk7RKQ5CMDse
         olSkZzpYQHFl2reUZq20RuwE50vUc9ZChyxZH8yY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 41/64] Bluetooth: hci_qca: Bug fixes for SSR
Date:   Mon, 10 Aug 2020 15:08:36 -0400
Message-Id: <20200810190859.3793319-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit 3344537f614b966f726c1ec044d1c70a8cabe178 ]

1.During SSR for command time out if BT SoC goes to inresponsive
state, power cycling of BT SoC was not happening. Given the fix by
sending hw error event to reset the BT SoC.

2.If SSR is triggered then ignore the transmit data requests to
BT SoC until SSR is completed.

Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 40 +++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 81c3c38baba18..3788ec7a4ad6b 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -72,7 +72,8 @@ enum qca_flags {
 	QCA_DROP_VENDOR_EVENT,
 	QCA_SUSPENDING,
 	QCA_MEMDUMP_COLLECTION,
-	QCA_HW_ERROR_EVENT
+	QCA_HW_ERROR_EVENT,
+	QCA_SSR_TRIGGERED
 };
 
 enum qca_capabilities {
@@ -862,6 +863,13 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	BT_DBG("hu %p qca enq skb %p tx_ibs_state %d", hu, skb,
 	       qca->tx_ibs_state);
 
+	if (test_bit(QCA_SSR_TRIGGERED, &qca->flags)) {
+		/* As SSR is in progress, ignore the packets */
+		bt_dev_dbg(hu->hdev, "SSR is in progress");
+		kfree_skb(skb);
+		return 0;
+	}
+
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
 
@@ -1128,6 +1136,7 @@ static int qca_controller_memdump_event(struct hci_dev *hdev,
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct qca_data *qca = hu->priv;
 
+	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
 	skb_queue_tail(&qca->rx_memdump_q, skb);
 	queue_work(qca->workqueue, &qca->ctrl_memdump_evt);
 
@@ -1488,6 +1497,7 @@ static void qca_hw_error(struct hci_dev *hdev, u8 code)
 	struct qca_memdump_data *qca_memdump = qca->qca_memdump;
 	char *memdump_buf = NULL;
 
+	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
 	set_bit(QCA_HW_ERROR_EVENT, &qca->flags);
 	bt_dev_info(hdev, "mem_dump_status: %d", qca->memdump_state);
 
@@ -1532,10 +1542,30 @@ static void qca_cmd_timeout(struct hci_dev *hdev)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct qca_data *qca = hu->priv;
 
-	if (qca->memdump_state == QCA_MEMDUMP_IDLE)
+	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
+	if (qca->memdump_state == QCA_MEMDUMP_IDLE) {
+		set_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
 		qca_send_crashbuffer(hu);
-	else
-		bt_dev_info(hdev, "Dump collection is in process");
+		qca_wait_for_dump_collection(hdev);
+	} else if (qca->memdump_state == QCA_MEMDUMP_COLLECTING) {
+		/* Let us wait here until memory dump collected or
+		 * memory dump timer expired.
+		 */
+		bt_dev_info(hdev, "waiting for dump to complete");
+		qca_wait_for_dump_collection(hdev);
+	}
+
+	mutex_lock(&qca->hci_memdump_lock);
+	if (qca->memdump_state != QCA_MEMDUMP_COLLECTED) {
+		qca->memdump_state = QCA_MEMDUMP_TIMEOUT;
+		if (!test_bit(QCA_HW_ERROR_EVENT, &qca->flags)) {
+			/* Inject hw error event to reset the device
+			 * and driver.
+			 */
+			hci_reset_dev(hu->hdev);
+		}
+	}
+	mutex_unlock(&qca->hci_memdump_lock);
 }
 
 static int qca_wcn3990_init(struct hci_uart *hu)
@@ -1646,6 +1676,8 @@ static int qca_setup(struct hci_uart *hu)
 	if (ret)
 		return ret;
 
+	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
+
 	if (qca_is_wcn399x(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 
-- 
2.25.1

