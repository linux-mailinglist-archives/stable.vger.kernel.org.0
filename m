Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B8626139F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgIHPgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbgIHPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA1B22460;
        Tue,  8 Sep 2020 15:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579275;
        bh=ZkMPC1jIJ9hVHaoUTWttYx/nr1BUvboT7/NBKkpiXTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOyudV53neMy8kLVBANOswAZOuyqkfYcOFcZzqjCc+ziE4yFn2EQuDiZ0XhTlKewa
         GrtjYki6rLthEpoTaLPF0vY1DaoxmvjsM6yb4b/zQJV8G8vfP8m6lrqBXCMERtzwmI
         OJWubdXCd5eRiAlesSMZk14ZGdshYGrImWiQuQ6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 002/186] HID: quirks: Always poll three more Lenovo PixArt mice
Date:   Tue,  8 Sep 2020 17:22:24 +0200
Message-Id: <20200908152241.772400551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Parschauer <s.parschauer@gmx.de>

[ Upstream commit 627a49975bdc3220f360a8237603a6344ee6a588 ]

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. One Lenovo PixArt
mouse is already fixed. Got two references for 17ef:602e and three
references for 17ef:6019 misbehaving like this. Got one direct bug
report for 17ef:6093 from Wyatt Ward (wyatt8740). So add
HID_QUIRK_ALWAYS_POLL for all of them.

Link: https://github.com/sriemer/fix-linux-mouse issue 22
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7cfa9785bfbb0..6ea3619842d8d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -727,6 +727,9 @@
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
+#define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093	0x6093
 
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index c242150d35a3a..a65aef6a322fb 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -105,6 +105,9 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406XE), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C007), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS), HID_QUIRK_NOGET },
-- 
2.25.1



