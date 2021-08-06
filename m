Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE253E24EC
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243764AbhHFIPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243763AbhHFIPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE90B611CE;
        Fri,  6 Aug 2021 08:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237694;
        bh=/bT9lnLsRgo1oLJYpz2EtkO4AcjDzcA2znDE/Lz4PUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuP3g08cyFySdYLfEpxy+val1NjZxOoEco8BY9dH/R5/h4El3GsQ5ugCowpUola/y
         dFMWJuwNNUjwrchdsy+j4M5477hRQ8GFV5zIz9On8gZBQukTKDJvBf5ZoWUZhNmKAF
         n5+GsN2h/KH7HsgYbEVfBUDZ0sjMuFp9HIAz3fjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 5/6] Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
Date:   Fri,  6 Aug 2021 10:14:37 +0200
Message-Id: <20210806081109.110744766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
References: <20210806081108.939164003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 5d16a8280078701fc03d6a0367c3251809743274 which is
commit 0ea9fd001a14ebc294f112b0361a4e601551d508 upstream.

It has been reported to have problems:
	https://lore.kernel.org/linux-bluetooth/8735ryk0o7.fsf@baylibre.com/

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1666,6 +1666,14 @@ int hci_dev_do_close(struct hci_dev *hde
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	cancel_delayed_work(&hdev->power_off);
 
 	hci_req_cancel(hdev, ENODEV);
@@ -1738,14 +1746,6 @@ int hci_dev_do_close(struct hci_dev *hde
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
 


