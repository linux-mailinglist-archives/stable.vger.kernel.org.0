Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CCE2C9A8E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgLAI6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbgLAI6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF6022242;
        Tue,  1 Dec 2020 08:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813082;
        bh=/5aYZRAVPI3/P4pxelPqO5iYlEfaT1E9ZRNF2qOQiT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j10Omjemhjp5a6nnsF4VYrgc9TdZ2HOQfM99ZCMtPOr4wEWWXtOxk3BNhRcqQAfjI
         reIujHX4/C9FLZyxobzgl38VVH7aIUkLMM7K2WsesHbIKJQBACmgpB7DEmimEFYXpG
         bsnLWIN59sy5jgguEo8U7bCwfXk26bzvtxFKZI7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/50] HID: Add Logitech Dinovo Edge battery quirk
Date:   Tue,  1 Dec 2020 09:53:18 +0100
Message-Id: <20201201084647.538827233@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7940fb035abd88040d56be209962feffa33b03d0 ]

The battery status is also being reported by the logitech-hidpp driver,
so ignore the standard HID battery status to avoid reporting the same
info twice.

Note the logitech-hidpp battery driver provides more info, such as properly
differentiating between charging and discharging. Also the standard HID
battery info seems to be wrong, reporting a capacity of just 26% after
fully charging the device.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 222204c2da22a..be0707cfc0fd1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -696,6 +696,7 @@
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
 #define USB_DEVICE_ID_LOGITECH_T651	0xb00c
+#define USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD	0xb309
 #define USB_DEVICE_ID_LOGITECH_C007	0xc007
 #define USB_DEVICE_ID_LOGITECH_C077	0xc077
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 07a043ae69f12..0e63cedcc3b51 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -331,6 +331,9 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
 		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
+		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.27.0



