Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5222C43C8
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgKYPgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbgKYPgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FE221D7A;
        Wed, 25 Nov 2020 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318614;
        bh=PnALDJJysI/Z+uPUS4m2ghNME1MNLS8cJ12T/Y+zxyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CLID7Z8S4T/6e3leI7H7kqm8WsrNIw6Xdep+MFgIHU9l8UqrzWiKJTXPPq5dqW5M
         c58Ww/ntV4kXwT2H6feA25J3FqqZw205d1lBogGihDr4rHXCxiMPz/NTc4E8l/YLnp
         ZAFZRFCayBqJ6QRQ1UYIByhs9sgd+Xx/aiGsXIqM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/23] HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge
Date:   Wed, 25 Nov 2020 10:36:26 -0500
Message-Id: <20201125153638.810419-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153638.810419-1-sashal@kernel.org>
References: <20201125153638.810419-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

