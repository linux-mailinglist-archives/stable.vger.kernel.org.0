Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5FC29BDD1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812966AbgJ0QrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794984AbgJ0POp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC87122384;
        Tue, 27 Oct 2020 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811684;
        bh=zlDNZx9rt71dhDzH3YzbXbl2z1FGcNMtbtHfolhdRjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTkw8ZasOjisEtFf8aYtGPS2yuVKxD+fPxP3rIanXN4OnEsDr+qRFzgRR68imdQZ9
         NpvCnFnXNRJ7m4lEMoZHChuHkwHAv0ueZgBkQXTGtoPp8IaWXbxi70H5O2ULE7Jst3
         xOE5eQv/OZD1840tCXmNIvwqbVjhTwX/aV8yE0Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mikael=20Wikstr=C3=B6m?= <leakim.wikstrom@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 579/633] HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons
Date:   Tue, 27 Oct 2020 14:55:22 +0100
Message-Id: <20201027135549.973576588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikael Wikström <leakim.wikstrom@gmail.com>

[ Upstream commit 140958da9ab53a7df9e9ccc7678ea64655279ac1 ]

One more device that needs 40d5bb87 to resolve regression for the trackpoint
and three mouse buttons on the type cover of the Lenovo X1 Tablet Gen3.

It is probably also needed for the Lenovo X1 Tablet Gen2 with PID 0x60a3

Signed-off-by: Mikael Wikström <leakim.wikstrom@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b49ec7dde6457..0ca8906a6f839 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -726,6 +726,7 @@
 #define USB_DEVICE_ID_LENOVO_SCROLLPOINT_OPTICAL	0x6049
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
+#define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e3152155c4b85..99f041afd5c0c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1973,6 +1973,12 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_GENERIC,
 			USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_7010) },
 
+	/* Lenovo X1 TAB Gen 3 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
-- 
2.25.1



