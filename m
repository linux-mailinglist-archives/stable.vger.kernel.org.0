Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFD3A9FBB
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhFPPk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234656AbhFPPi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F68613E9;
        Wed, 16 Jun 2021 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857796;
        bh=8NROY7982HeFSxDEn9mkhUirj3sifUv/lZZ+MmRV36g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiKXxiHGwjVNyrgEgupLWIZqQz1VTpN7UuO01R/eNjDNUGnJpXP1dA7tSejlZXLSr
         kOwmye+pOAfJd1rh7LIXwqVDMU9PKkjh9bf7ZHXykuNBd5icEZsbCx1bi8kTTWrqWo
         Bzs3tfsl1kNsy0LJnnkQ5ggPH2ioMhcppOpnraFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirenjan Krishnan <nirenjan@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/38] HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65
Date:   Wed, 16 Jun 2021 17:33:11 +0200
Message-Id: <20210616152835.484633676@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e220a05a05b4..c2e0c65b111b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1034,6 +1034,7 @@
 #define USB_DEVICE_ID_SAITEK_X52	0x075c
 #define USB_DEVICE_ID_SAITEK_X52_2	0x0255
 #define USB_DEVICE_ID_SAITEK_X52_PRO	0x0762
+#define USB_DEVICE_ID_SAITEK_X65	0x0b6a
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 2e38340e19df..2bda94199aaf 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -158,6 +158,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },
-- 
2.30.2



