Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49F72C9AC4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388380AbgLAJAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388374AbgLAJAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FE02222E;
        Tue,  1 Dec 2020 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813200;
        bh=ZeIzVfLco/GLm6tYbOevg3JIWmsCYliTX+lwwVPA2uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ogG3rWOSz9D7eyEQU/uYUONmMTO//FrKm+bkhEoFYXQaghZxctgjUbF1QQKQIVgW
         t3JBqOjRJT46pGtrYwe7SRjwI0PpVj7tY1G6E52IbhfzieJP2WTMFGYI/qpNRsQ7B5
         eXPNDvt6qu51apMLXrvm4y93lgpVg/o/0YuNpFxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Ye <lzye@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/57] HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices
Date:   Tue,  1 Dec 2020 09:53:22 +0100
Message-Id: <20201201084649.707179761@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Ye <lzye@google.com>

[ Upstream commit f59ee399de4a8ca4d7d19cdcabb4b63e94867f09 ]

Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices need to
be set explicitly with this flag.

Signed-off-by: Chris Ye <lzye@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 4 ++++
 drivers/hid/hid-quirks.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4d2a1d540a821..ad079aca68898 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -444,6 +444,10 @@
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
+#define USB_VENDOR_ID_GAMEVICE	0x27F8
+#define USB_DEVICE_ID_GAMEVICE_GV186	0x0BBE
+#define USB_DEVICE_ID_GAMEVICE_KISHI	0x0BBF
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 493e2e7e12de0..10cb42a00fe87 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -87,6 +87,10 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_GV186),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_KISHI),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
-- 
2.27.0



