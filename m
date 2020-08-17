Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3A2473E8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgHQTCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbgHQPrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D43020789;
        Mon, 17 Aug 2020 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679222;
        bh=FhSwidwZ9FMKss9Vtyczk5OhFwu3nyShbS4ZmaGdGqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TgzNS5y+CP0MpTvRfjiCvfX2LAhnYWwUe2IznkVMlgP9pBoQMzCo6YzNGwI0NwIC
         agXQ8sqBK2BBk9zFXjd7xCFWbktwsVcdzlU40r6RYImgyh3RwtEg5Lk9eXLtQ0UEL9
         1DjiRiI1ZuL9qcY9iZjK6OQfHBSOfI0ZAX7Wyiu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 138/393] Bluetooth: hci_qca: Bug fix during SSR timeout
Date:   Mon, 17 Aug 2020 17:13:08 +0200
Message-Id: <20200817143826.305358765@linuxfoundation.org>
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

[ Upstream commit f98aa80ff78c34fe328eb9cd3e2cc3058e42bcfd ]

Due to race conditions between qca_hw_error and qca_controller_memdump
during SSR timeout,the same pointer is freed twice. This results in a
double free. Now a lock is acquired before checking the stauts of SSR
state.

Fixes: d841502c79e3 ("Bluetooth: hci_qca: Collect controller memory dump during SSR")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index dc949592c4ed5..a6dd13a2975a8 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -981,8 +981,11 @@ static void qca_controller_memdump(struct work_struct *work)
 	while ((skb = skb_dequeue(&qca->rx_memdump_q))) {
 
 		mutex_lock(&qca->hci_memdump_lock);
-		/* Skip processing the received packets if timeout detected. */
-		if (qca->memdump_state == QCA_MEMDUMP_TIMEOUT) {
+		/* Skip processing the received packets if timeout detected
+		 * or memdump collection completed.
+		 */
+		if (qca->memdump_state == QCA_MEMDUMP_TIMEOUT ||
+		    qca->memdump_state == QCA_MEMDUMP_COLLECTED) {
 			mutex_unlock(&qca->hci_memdump_lock);
 			return;
 		}
@@ -1451,8 +1454,6 @@ static void qca_hw_error(struct hci_dev *hdev, u8 code)
 {
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct qca_data *qca = hu->priv;
-	struct qca_memdump_data *qca_memdump = qca->qca_memdump;
-	char *memdump_buf = NULL;
 
 	set_bit(QCA_SSR_TRIGGERED, &qca->flags);
 	set_bit(QCA_HW_ERROR_EVENT, &qca->flags);
@@ -1476,19 +1477,23 @@ static void qca_hw_error(struct hci_dev *hdev, u8 code)
 		qca_wait_for_dump_collection(hdev);
 	}
 
+	mutex_lock(&qca->hci_memdump_lock);
 	if (qca->memdump_state != QCA_MEMDUMP_COLLECTED) {
 		bt_dev_err(hu->hdev, "clearing allocated memory due to memdump timeout");
-		mutex_lock(&qca->hci_memdump_lock);
-		if (qca_memdump)
-			memdump_buf = qca_memdump->memdump_buf_head;
-		vfree(memdump_buf);
-		kfree(qca_memdump);
-		qca->qca_memdump = NULL;
+		if (qca->qca_memdump) {
+			vfree(qca->qca_memdump->memdump_buf_head);
+			kfree(qca->qca_memdump);
+			qca->qca_memdump = NULL;
+		}
 		qca->memdump_state = QCA_MEMDUMP_TIMEOUT;
 		cancel_delayed_work(&qca->ctrl_memdump_timeout);
-		skb_queue_purge(&qca->rx_memdump_q);
-		mutex_unlock(&qca->hci_memdump_lock);
+	}
+	mutex_unlock(&qca->hci_memdump_lock);
+
+	if (qca->memdump_state == QCA_MEMDUMP_TIMEOUT ||
+	    qca->memdump_state == QCA_MEMDUMP_COLLECTED) {
 		cancel_work_sync(&qca->ctrl_memdump_evt);
+		skb_queue_purge(&qca->rx_memdump_q);
 	}
 
 	clear_bit(QCA_HW_ERROR_EVENT, &qca->flags);
-- 
2.25.1



