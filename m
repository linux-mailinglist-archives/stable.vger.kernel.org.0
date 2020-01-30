Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2714E219
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgA3St7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgA3Srf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507C6205F4;
        Thu, 30 Jan 2020 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410054;
        bh=QEJHaPr01/ZhIn6sMg9jH836SZl7p9PXfvQE+moXujA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hueXotFYfoRhEDO5MCAq/TKYbsIP5F+0WjhjYE+sohe0uvSlRl1L+ydA75HXBy7ax
         orczrwnGaqjJc8pCXFTfNs8c6zZuLy9EvhJlOpSUFprTRckkUUS7NHvvQ50mP/k8z5
         ONmLo3Mj5khMzL2sRROo2dyw2c2PhgXjazabSkHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/55] HID: ite: Add USB id match for Acer SW5-012 keyboard dock
Date:   Thu, 30 Jan 2020 19:39:09 +0100
Message-Id: <20200130183613.818173837@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8f18eca9ebc57d6b150237033f6439242907e0ba ]

The Acer SW5-012 2-in-1 keyboard dock uses a Synaptics S91028 touchpad
which is connected to an ITE 8595 USB keyboard controller chip.

This keyboard has the same quirk for its rfkill / airplane mode hotkey as
other keyboards with the ITE 8595 chip, it only sends a single release
event when pressed and released, it never sends a press event.

This commit adds this keyboards USB id to the hid-ite id-table, fixing
the rfkill key not working on this keyboard.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h | 1 +
 drivers/hid/hid-ite.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ee243bf8cc3df..03d65b6910673 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1075,6 +1075,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_LTS2	0x1d10
 #define USB_DEVICE_ID_SYNAPTICS_HD	0x0ac3
 #define USB_DEVICE_ID_SYNAPTICS_QUAD_HD	0x1ac3
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012	0x2968
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 98b059d79bc89..2ce1eb0c92125 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -43,6 +43,9 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
 static const struct hid_device_id ite_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
+	/* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
+			 USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
-- 
2.20.1



