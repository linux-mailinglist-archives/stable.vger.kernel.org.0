Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6F291D11
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbgJRTmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgJRTXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05AE1207DE;
        Sun, 18 Oct 2020 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049028;
        bh=mzKnN9/77JyM4zThwiss97RjQWHqBe2bRWXFQNB+de4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9rSF9FcPbMi7wtORZgl5AxOtbejhpSzWUKyVFw5Zn92SuoFfxwcIb7JCC+dNNFzs
         B90lT6GfYxYAcW9+t+ZQeShAVXO9hLUeFZBqeWbhyxpEtPbWQcdxcuG2nvRkeUEWmQ
         5tYo8AAy9ViLnrUM2OA0GeWCZbynXfTnx+WdtMyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 61/80] HID: ite: Add USB id match for Acer One S1003 keyboard dock
Date:   Sun, 18 Oct 2020 15:22:12 -0400
Message-Id: <20201018192231.4054535-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5bf2f2f331ad812c9b7eea6e14a3ea328acbffc0 ]

The Acer One S1003 2-in-1 keyboard dock uses a Synaptics S910xx touchpad
which is connected to an ITE 8910 USB keyboard controller chip.

This keyboard has the same quirk for its rfkill / airplane mode hotkey as
other keyboards with ITE keyboard chips, it only sends a single release
event when pressed and released, it never sends a press event.

This commit adds this keyboards USB id to the hid-ite id-table, fixing
the rfkill key not working on this keyboard. Note that like for the
Acer Aspire Switch 10 (SW5-012) the id-table entry matches on the
HID_GROUP_GENERIC generic group so that hid-ite only binds to the
keyboard interface and the mouse/touchpad interface is left untouched
so that hid-multitouch can bind to it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h | 1 +
 drivers/hid/hid-ite.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e03a4d794240c..7363d0b488bd8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1119,6 +1119,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K12A	0x2819
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012	0x2968
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
+#define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 6c55682c59740..044a93f3c1178 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -44,6 +44,10 @@ static const struct hid_device_id ite_devices[] = {
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
-- 
2.25.1

