Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42814E81
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfEFOkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfEFOkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1FA206A3;
        Mon,  6 May 2019 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153618;
        bh=amSlVA1hzfmqqdCQj8fGEwUzx8kmJKq0lPWwCk4bfhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO3xXnxKtvKWIk1Bg8F1unTGviIir0mT63bvvI+OCvbAP7mRVZgLt8+0CmcQMOOpF
         vAX2h3FzVk1vk37fCSMohIsOcZU79BBl5RevyKTEogyOWA2pHk5bRfkFtrZ5Fi0j1R
         /6Vvy4DFIaq4vXaS7OSg2vlZDv9v4V2cpd+bWGHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/99] HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630
Date:   Mon,  6 May 2019 16:32:07 +0200
Message-Id: <20190506143057.036644347@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2bafa1e9625400bec4c840a168d70ba52607a58d ]

Similar to commit edfc3722cfef ("HID: quirks: Fix keyboard + touchpad on
Toshiba Click Mini not working"), the Lenovo Miix 630 has a combo
keyboard/touchpad device with vid:pid of 04F3:0400, which is shared with
Elan touchpads.  The combo on the Miix 630 has an ACPI id of QTEC0001,
which is not claimed by the elan_i2c driver, so key on that similar to
what was done for the Toshiba Click Mini.

Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 94088c0ed68a..e24790c988c0 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -744,7 +744,6 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DEALEXTREAME, USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
-	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, 0x0400) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
@@ -1025,6 +1024,10 @@ bool hid_ignore(struct hid_device *hdev)
 		if (hdev->product == 0x0401 &&
 		    strncmp(hdev->name, "ELAN0800", 8) != 0)
 			return true;
+		/* Same with product id 0x0400 */
+		if (hdev->product == 0x0400 &&
+		    strncmp(hdev->name, "QTEC0001", 8) != 0)
+			return true;
 		break;
 	}
 
-- 
2.20.1



