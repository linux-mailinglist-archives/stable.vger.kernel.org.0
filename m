Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90960226A9E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgGTPxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgGTPxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36CD206E9;
        Mon, 20 Jul 2020 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260385;
        bh=w3L0ltA9Lm03hwxJdwEednYK1OeTpgermLdcgX8ulc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRw+Q0IgnoipkTUjkLIHrFf8FRtGC4dFOYCyw0Vzn67X9o4Xg3m+2m2lKrCW5qf9X
         ltgD02OoWXkEkLC29OW9d/6Annhtrv/7i/pcC0RK6edd0G/4m4zlC7MxSqls6dplg6
         G+G4afMFAj21dtiMO5cyh5Ga9ks+GfLcbCcQxkvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 083/133] HID: quirks: Always poll Obins Anne Pro 2 keyboard
Date:   Mon, 20 Jul 2020 17:37:10 +0200
Message-Id: <20200720152807.722207307@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Parschauer <s.parschauer@gmx.de>

commit ca28aff0e1dc7dce9e12a7fd9276b7118ce5e73a upstream.

The Obins Anne Pro 2 keyboard (04d9:a293) disconnects after a few
minutes of inactivity when using it wired and typing does not result
in any input events any more. This is a common firmware flaw. So add
the ALWAYS_POLL quirk for this device.

GitHub user Dietrich Moerman (dietrichm) tested the quirk and
requested my help in my project
https://github.com/sriemer/fix-linux-mouse issue 22 to provide
this patch.

Link: https://www.reddit.com/r/AnnePro/comments/gruzcb/anne_pro_2_linux_cant_type_after_inactivity/
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -609,6 +609,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293	0xa293
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -90,6 +90,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },


