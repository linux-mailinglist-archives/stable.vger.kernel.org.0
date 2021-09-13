Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A1409512
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346149AbhIMOhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347807AbhIMOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3389A61884;
        Mon, 13 Sep 2021 13:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541219;
        bh=uUatkYN8xVlepdm3tl4RbHygSuw56q8DTiAcnvJE8c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1XJH3iHFK6HfcXETUbEKtp+mpHbxqDcTxlkYbtmT4qaEz/HUyczNxgXEQVTMTC7s
         osPYtFCQvpkulYb++wsJxNUcWVuuZEhAkLNmcSh2xyg826BZnONOTNM+MDFJmhpWVm
         ewr9cIei+4jX17RTcdyzYItM0B0Z4qtCF0hhRXD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: [PATCH 5.14 212/334] Bluetooth: Move shutdown callback before flushing tx and rx queue
Date:   Mon, 13 Sep 2021 15:14:26 +0200
Message-Id: <20210913131120.589943925@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
 net/bluetooth/hci_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..2331612839d7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1727,6 +1727,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
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
@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
-- 
2.30.2



