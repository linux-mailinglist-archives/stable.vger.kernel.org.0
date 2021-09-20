Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C8C411BB3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344818AbhITRBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344822AbhITQ7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A2061245;
        Mon, 20 Sep 2021 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156752;
        bh=N/+2iF4axbVSXVamD5ZG5X5d7eKlirdq2taoRlq3zuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt7cD8mLbbdb8j0zpWn72/2X2rTNzMfE8GAdWg7gNbZ+huwXDcO9FdHy41wCfNDPk
         MxIGTK5rRzs7o5Z/XuYC6d3fbVKj/mutqltLzFJiDmTGRUhWas4UF9BtxbZCJdbBLD
         K6ree8QUSjPEfyM/486mHx1OS9MqsnvoBzoSU8aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: [PATCH 4.9 068/175] Bluetooth: Move shutdown callback before flushing tx and rx queue
Date:   Mon, 20 Sep 2021 18:41:57 +0200
Message-Id: <20210920163920.282152107@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2 ]

Commit 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues
are flushed or cancelled") introduced a regression that makes mtkbtsdio
driver stops working:
[   36.593956] Bluetooth: hci0: Firmware already downloaded
[   46.814613] Bluetooth: hci0: Execution of wmt command timed out
[   46.814619] Bluetooth: hci0: Failed to send wmt func ctrl (-110)

The shutdown callback depends on the result of hdev->rx_work, so we
should call it before flushing rx_work:
-> btmtksdio_shutdown()
 -> mtk_hci_wmt_sync()
  -> __hci_cmd_send()
   -> wait for BTMTKSDIO_TX_WAIT_VND_EVT gets cleared

-> btmtksdio_recv_event()
 -> hci_recv_frame()
  -> queue_work(hdev->workqueue, &hdev->rx_work)
   -> clears BTMTKSDIO_TX_WAIT_VND_EVT

So move the shutdown callback before flushing TX/RX queue to resolve the
issue.

Reported-and-tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8517da7f282e..b4875e6339c6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1546,6 +1546,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
-- 
2.30.2



