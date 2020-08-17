Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C550247414
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404097AbgHQTFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730578AbgHQPpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:45:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7DC222D01;
        Mon, 17 Aug 2020 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679107;
        bh=15qDq60fpjZ7HW0bZaWJ+geijTtQUm7ianQRg3nvz3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT97ZJNgT7DPD0sFgb9iL7lBVIF7nhC34VS5ldP2MhrCSrRFq75wBOE7ddfUz/1K7
         6nRo7fYBY1BKdOBdQsLgoo35Z0VmkiVgNmKoh0ILjW6qz1PU0R5Ebsjo3xEpFHhr77
         jfTkH/SAWcHekLKfMCp2+YLw8gqK3PtgsE2CNOjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 099/393] Bluetooth: hci_qca: Bug fixes for SSR
Date:   Mon, 17 Aug 2020 17:12:29 +0200
Message-Id: <20200817143824.419459119@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0b1036e5e963c..14e4d2eaf8959 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -71,7 +71,8 @@ enum qca_flags {
 	QCA_DROP_VENDOR_EVENT,
 	QCA_SUSPENDING,
 	QCA_MEMDUMP_COLLECTION,
-	QCA_HW_ERROR_EVENT
+	QCA_HW_ERROR_EVENT,
+	QCA_SSR_TRIGGERED
 };
 
 
@@ -854,6 +855,13 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
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
 
@@ -1085,6 +1093,7 @@ static int qca_controller_memdump_event(struct hci_dev *hdev,
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct qca_data *qca = hu->priv;
 
+	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
 	skb_queue_tail(&qca->rx_memdump_q, skb);
 	queue_work(qca->workqueue, &qca->ctrl_memdump_evt);
 
@@ -1445,6 +1454,7 @@ static void qca_hw_error(struct hci_dev *hdev, u8 code)
 	struct qca_memdump_data *qca_memdump = qca->qca_memdump;
 	char *memdump_buf = NULL;
 
+	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
 	set_bit(QCA_HW_ERROR_EVENT, &qca->flags);
 	bt_dev_info(hdev, "mem_dump_status: %d", qca->memdump_state);
 
@@ -1489,10 +1499,30 @@ static void qca_cmd_timeout(struct hci_dev *hdev)
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
@@ -1603,6 +1633,8 @@ static int qca_setup(struct hci_uart *hu)
 	if (ret)
 		return ret;
 
+	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
+
 	if (qca_is_wcn399x(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 
-- 
2.25.1



