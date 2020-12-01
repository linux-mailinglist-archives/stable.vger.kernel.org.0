Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ACF2C9C65
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgLAJRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389521AbgLAJLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8CC5221FD;
        Tue,  1 Dec 2020 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813849;
        bh=fptW/T5PsFBIDxk2dMk/MHWGvW8o1qYSp0PJg90OYmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7mBe5jLGLJYmmduKPM0SuFxPf6k7Q0yWwccYp2l69J1MeNxuIcoKQMq2ITK/Q98K
         zU9MG90tJBJdBrhiKiU3vNaj3OXE0CcLaKvNkqx8itAjxz8baZl5hk5iZlMKJotX8g
         d7LbED6Xb7OxHKV4W42uZm/VPVKpEy2Jj2YuEh9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 050/152] HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge
Date:   Tue,  1 Dec 2020 09:52:45 +0100
Message-Id: <20201201084718.471599451@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c27168a04a438a457c100253b1aaf0c779218aae ]

Like the MX5000 and MX5500 quad/bluetooth keyboards the Dinovo Edge also
needs the HIDPP_CONSUMER_VENDOR_KEYS quirk for some special keys to work.
Specifically without this the "Phone" and the 'A' - 'D' Smart Keys do not
send any events.

In addition to fixing these keys not sending any events, adding the
Bluetooth match, so that hid-logitech-hidpp is used instead of the
generic HID driver, also adds battery monitoring support when the
keyboard is connected over Bluetooth.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index a2991622702ae..0ca7231195473 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3997,6 +3997,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* Keyboard MX5000 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb305),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Dinovo Edge (Bluetooth-receiver in HID proxy mode) */
+	  LDJ_DEVICE(0xb309),
+	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
 	{ /* Keyboard MX5500 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
@@ -4039,6 +4042,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* MX5000 keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb305),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Dinovo Edge keyboard over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb309),
+	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
 	{ /* MX5500 keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
-- 
2.27.0



