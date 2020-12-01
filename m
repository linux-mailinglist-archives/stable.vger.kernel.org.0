Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB22C9D98
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390833AbgLAJZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbgLAJFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE23221EB;
        Tue,  1 Dec 2020 09:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813503;
        bh=PnALDJJysI/Z+uPUS4m2ghNME1MNLS8cJ12T/Y+zxyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG5YxDZtNGOP/Y13A/8vSdmJpqdxOyXlgTfxY55qcYGLCbz0DtOV3LS4FNMO+KZpy
         zqOfGXE0/eVP9vJVQUmGtfQL8tgyqYEnHoo3T11mtbOklztFgeNrThqOCyHlxaiKdg
         PojDk8fuCqbsApKkZbJCEs7Eg37T7lvX8pSZBg1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/98] HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge
Date:   Tue,  1 Dec 2020 09:53:08 +0100
Message-Id: <20201201084656.556466056@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index e49d36de07968..919551ed5809c 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3789,6 +3789,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* Keyboard MX5000 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb305),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Dinovo Edge (Bluetooth-receiver in HID proxy mode) */
+	  LDJ_DEVICE(0xb309),
+	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
 	{ /* Keyboard MX5500 (Bluetooth-receiver in HID proxy mode) */
 	  LDJ_DEVICE(0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
@@ -3831,6 +3834,9 @@ static const struct hid_device_id hidpp_devices[] = {
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



