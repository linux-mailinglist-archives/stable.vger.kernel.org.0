Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140AA472727
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhLMJ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbhLMJ4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1C7C09427D;
        Mon, 13 Dec 2021 01:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88AFACE0E97;
        Mon, 13 Dec 2021 09:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F7FC00446;
        Mon, 13 Dec 2021 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388795;
        bh=B/0lhuog/4p/hExcA4Ya23kecHNdgksh2Z/OjRIbdjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0l5PWgSMYwJ4CcWNtxMNG7DLzsvQvOcqwGvjkfNeww2a+J7Rgy1eGdvsBRG11a2/
         Fsat4iIUkfLtlHwHNnsdJboXa1KNEjEdojF6pBrQJvh8z1P3Am4D9tcM32zSsOvZwR
         RnBy/Ain5apIkrr13b/WLblbMu60031jtPszGFns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 004/132] HID: quirks: Add quirk for the Microsoft Surface 3 type-cover
Date:   Mon, 13 Dec 2021 10:29:05 +0100
Message-Id: <20211213092939.219487485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 9003fbe0f3674b972f56fa7e6bf3ac9dbfc4d0ec upstream.

Add a HID_QUIRK_NO_INIT_REPORTS quirk for the
Microsoft Surface 3 (non pro) type-cover.

Trying to init the reports seems to confuse the type-cover and
causes 2 issues:

1. Despite hid-multitouch sending the command to switch the
touchpad to multitouch mode, it keeps sending events on the
mouse emulation interface.

2. The touchpad completely stops sending events after a reboot.

Adding the HID_QUIRK_NO_INIT_REPORTS quirk fixes both issues.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -865,6 +865,7 @@
 #define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
 #define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
 #define USB_DEVICE_ID_MS_POWER_COVER     0x07da
+#define USB_DEVICE_ID_MS_SURFACE3_COVER		0x07de
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -124,6 +124,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCS, USB_DEVICE_ID_MCS_GAMEPADBLOCK), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PIXART_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_POWER_COVER), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_SURFACE3_COVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_SURFACE_PRO_2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2), HID_QUIRK_NO_INIT_REPORTS },


