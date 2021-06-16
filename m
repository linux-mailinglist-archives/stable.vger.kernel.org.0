Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E044F3A9FDA
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhFPPmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235322AbhFPPkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E32A1613EE;
        Wed, 16 Jun 2021 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857848;
        bh=LdiMPHC2SguCf+TB0y+7VY8iaDbcVolHgsFcZphQwPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mn22Z97WzeaNSRt11Lkhd0bQCFuS0h/K+5oChIxyIVMo6S0b9gKWgqCxPjAjW+UXj
         abe+KgbvTNnGk1OJAPmQWQq1c/foohKaWVNplDHu/SWpxB9Kt2xdsaVvrlwx3oXomp
         7z/DG3WuNUqRgXcc0QeDNB09aMCmBTgyTBayCxQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 04/48] HID: quirks: Add HID_QUIRK_NO_INIT_REPORTS quirk for Dell K15A keyboard-dock
Date:   Wed, 16 Jun 2021 17:33:14 +0200
Message-Id: <20210616152836.792266939@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ed80bdc4571fae177c44eba0997a0d551fc21e15 ]

Just like the K12A the Dell K15A keyboard-dock has problems with
get_feature requests. This sometimes leads to several
"failed to fetch feature 8" messages getting logged, after which the
touchpad may or may not work.

Just like the K15A these errors are triggered by undocking and docking
the tablet.

There also seem to be other problems when undocking and then docking again
in quick succession. It seems that in this case the keyboard-controller
still retains some power from capacitors and does not go through a
power-on-reset leaving it in a confuses state, symptoms of this are:

1. The USB-ids changing to 048d:8910
2. Failure to read the HID descriptors on the second (mouse) USB intf.
3. The touchpad freezing after a while

These problems can all be cleared by undocking the keyboard and waiting
a full minute before redocking it. Unfortunately there is nothing we can
do about this in the kernel.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1eccdb353ab0..6e25c505f813 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1153,6 +1153,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K12A	0x2819
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012	0x2968
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
+#define USB_DEVICE_ID_SYNAPTICS_DELL_K15A	0x6e21
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index df68dd7a4e80..05d3f498fd44 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -177,6 +177,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_DELL_K12A), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_DELL_K15A), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD), HID_QUIRK_BADPAD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TPV, USB_DEVICE_ID_TPV_OPTICAL_TOUCHSCREEN_8882), HID_QUIRK_NOGET },
-- 
2.30.2



