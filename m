Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3E2FC80A
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbhATCbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbhATB3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFA5A23121;
        Wed, 20 Jan 2021 01:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106069;
        bh=KGpDxYJ+g6L/VPqmi7zokT5Xz6lfTzBbY1R8MRG1KoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIXouIELlaXcStWiqLhSl0ROTDjQxtT29SPbzRMf3GV34aMig0PUKU9J1GnJs3C27
         isPOCBzsZX241W3WapS4Mttz2SQxrN94xLAh2dU8bwRvKFpeKKjldyG83AYgUj14+b
         IvHOYXeDW4TwmzVuq745dGb3sAOikm3OBS6CdnrEh3W8xtO03GnqDPxqab06giBUXQ
         T1UL+FYRY2VIj4IrkmpO+u/pc0cx0ec7R+/+hE3yoda1II34h7N6/O/2bEknjCAV7v
         31eK3wj0r8ctyzFsi9WaJVWX2Lu/vr0qYaGyjyok9ATEK71aIQZaxDhwxykkMrWTWT
         EIsKHzXaXiFNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seth Miller <miller.seth@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/15] HID: Ignore battery for Elan touchscreen on ASUS UX550
Date:   Tue, 19 Jan 2021 20:27:31 -0500
Message-Id: <20210120012740.770354-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Miller <miller.seth@gmail.com>

[ Upstream commit 7c38e769d5c508939ce5dc26df72602f3c902342 ]

Battery status is being reported for the Elan touchscreen on ASUS
UX550 laptops despite not having a batter. It always shows either 0 or
1%.

Signed-off-by: Seth Miller <miller.seth@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d118da1615d4..ab2be7a115d8f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -386,6 +386,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 13deb9a676855..4dd151b2924e2 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -334,6 +334,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.27.0

