Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807FF4726D7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhLMJzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:55:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238564AbhLMJxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C149B80D1F;
        Mon, 13 Dec 2021 09:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F3C00446;
        Mon, 13 Dec 2021 09:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389190;
        bh=Tl+Ueap+5fanf2k0LwNJ0AzU9nyxgNYsUJRLcw8z5H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+TyGGdtSx5nNVeGTmdXo627VEE/v9V8APDGiYNqlEYaB69aJ2ak0z+Ib3fG2Zkzq
         E7fw8wc7PgqXxeFiKSA9WInHkgCgIAzUR7aXbg9dPDrjYJO1hIx7aS9cO1zCaesPF4
         r0Gkw2ghlXT/Kyhrrv/g3K4o5GgLVHT0wNStVY2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 015/171] HID: Ignore battery for Elan touchscreen on Asus UX550VE
Date:   Mon, 13 Dec 2021 10:28:50 +0100
Message-Id: <20211213092945.594910108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 14902f8961dca9c66bf190f7b1583767c97a4197 upstream.

Battery status is reported for the Asus UX550VE touchscreen even though
it does not have a battery. Prevent it from always reporting the
battery as low.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1897823
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-input.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -394,6 +394,7 @@
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
+#define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -325,6 +325,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),


