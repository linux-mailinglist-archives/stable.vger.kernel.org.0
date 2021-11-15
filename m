Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035A4451399
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbhKOTxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343684AbhKOTVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18DE5635C9;
        Mon, 15 Nov 2021 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001873;
        bh=bd+2F2jxwup3Z8uPlx2LJhzVqbD7Fzo8Ul9a0xGIq7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaP/SHWSLb01XGFG85xUldYRm8fPlcZ8l5LMV5H4H6VEOJM9bUtl00tYS5BqCLbzk
         75UnOLcuZBZf60KmI7HkiVfjiuoDJGC8E+BdM+LNrW4/rc049n5NzT92pv+ajg/9+N
         do9DY+OgE9y7+6boCAlMKXEJOZka0wgK1Y+9LMWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Archie Pusaka <apusaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/917] Bluetooth: hci_h5: Fix (runtime)suspend issues on RTL8723BS HCIs
Date:   Mon, 15 Nov 2021 17:57:29 +0100
Message-Id: <20211115165440.754140172@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9a9023f314873241a43b5a2b96e9c0caaa958433 ]

The recently added H5_WAKEUP_DISABLE h5->flags flag gets checked in
h5_btrtl_open(), but it gets set in h5_serdev_probe() *after*
calling  hci_uart_register_device() and thus after h5_btrtl_open()
is called, set this flag earlier.

Also on devices where suspend/resume involves fully re-probing the HCI,
runtime-pm suspend should not be used, make the runtime-pm setup
conditional on the H5_WAKEUP_DISABLE flag too.

This fixes the HCI being removed and then re-added every 10 seconds
because it was being reprobed as soon as it was runtime-suspended.

Fixes: 66f077dde749 ("Bluetooth: hci_h5: add WAKEUP_DISABLE flag")
Fixes: d9dd833cf6d2 ("Bluetooth: hci_h5: Add runtime suspend")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index eb0099a212888..d49a39d17d7dc 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -848,6 +848,8 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 		h5->vnd = data->vnd;
 	}
 
+	if (data->driver_info & H5_INFO_WAKEUP_DISABLE)
+		set_bit(H5_WAKEUP_DISABLE, &h5->flags);
 
 	h5->enable_gpio = devm_gpiod_get_optional(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(h5->enable_gpio))
@@ -862,9 +864,6 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 	if (err)
 		return err;
 
-	if (data->driver_info & H5_INFO_WAKEUP_DISABLE)
-		set_bit(H5_WAKEUP_DISABLE, &h5->flags);
-
 	return 0;
 }
 
@@ -964,11 +963,13 @@ static void h5_btrtl_open(struct h5 *h5)
 	serdev_device_set_parity(h5->hu->serdev, SERDEV_PARITY_EVEN);
 	serdev_device_set_baudrate(h5->hu->serdev, 115200);
 
-	pm_runtime_set_active(&h5->hu->serdev->dev);
-	pm_runtime_use_autosuspend(&h5->hu->serdev->dev);
-	pm_runtime_set_autosuspend_delay(&h5->hu->serdev->dev,
-					 SUSPEND_TIMEOUT_MS);
-	pm_runtime_enable(&h5->hu->serdev->dev);
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_set_active(&h5->hu->serdev->dev);
+		pm_runtime_use_autosuspend(&h5->hu->serdev->dev);
+		pm_runtime_set_autosuspend_delay(&h5->hu->serdev->dev,
+						 SUSPEND_TIMEOUT_MS);
+		pm_runtime_enable(&h5->hu->serdev->dev);
+	}
 
 	/* The controller needs up to 500ms to wakeup */
 	gpiod_set_value_cansleep(h5->enable_gpio, 1);
@@ -978,7 +979,8 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	pm_runtime_disable(&h5->hu->serdev->dev);
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+		pm_runtime_disable(&h5->hu->serdev->dev);
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);
-- 
2.33.0



