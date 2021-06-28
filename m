Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED63B6210
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhF1Ol0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235356AbhF1Ojw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BAED619BF;
        Mon, 28 Jun 2021 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890789;
        bh=2vHZzaCr2cTsRb/gNLyfv5enlIiCAWNKmoLejdTAoCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6D7XYDSeHU9ApfFth6tONrkUr7bheWc+mWr9iLhk5PXwHjQsyr2VOongNAyGU9ux
         M1UYYI3/b9FbNPHl963E1sq5gWU0cKAVsZTqK8NA10Paaf1uGwoPGxjE4lQZHJJyVk
         B6k5+hbi1fZ6hi9pX087WN88hg/O5nBYBzAZKs863PgD7ejlH0/2bSiwYzGs1Z1F/L
         Uz+lizdwSEwLgSk/QtpAS38GYzwAggokAz1e1Nmr56hYGM91UwR/g1p72LMMhS1bWY
         dvTxNzK9Nzw+9NShjg51rwx8Nr3/WCokTAAbbtuPX+AUog7y8tNvnFX/F0FNhcXyX6
         WK0MS6dLZZ6NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirenjan Krishnan <nirenjan@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/109] HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65
Date:   Mon, 28 Jun 2021 10:31:18 -0400
Message-Id: <20210628143305.32978-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirenjan Krishnan <nirenjan@gmail.com>

[ Upstream commit 25bdbfbb2d8331a67824dd03d0087e9c98835f3a ]

The Saitek X65 joystick has a pair of axes that were used as mouse
pointer controls by the Windows driver. The corresponding usage page is
the Game Controls page, which is not recognized by the generic HID
driver, and therefore, both axes get mapped to ABS_MISC. The quirk makes
the second axis get mapped to ABS_MISC+1, and therefore made available
separately.

Signed-off-by: Nirenjan Krishnan <nirenjan@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 75342f3dfb86..ee5dce862a21 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -999,6 +999,7 @@
 #define USB_DEVICE_ID_SAITEK_X52	0x075c
 #define USB_DEVICE_ID_SAITEK_X52_2	0x0255
 #define USB_DEVICE_ID_SAITEK_X52_PRO	0x0762
+#define USB_DEVICE_ID_SAITEK_X65	0x0b6a
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 8fbe7b9cd84a..48e9761d4ace 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -155,6 +155,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },
-- 
2.30.2

