Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF8D2C9AFC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbgLAJDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388734AbgLAJDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF5C20770;
        Tue,  1 Dec 2020 09:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813416;
        bh=Yj/2xpRPlrshjqL8YeXDyOvWc/YshrQaPA0IU4meP64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlzWdgMsDbCs2Nsz+nYVeHFISq/g1vCEhwDHoN10GgvYBdhVfVK8bWWqQke14whdM
         jPGCXjE9t0SkCUbvvRX6T4N8IDzV6exVWad8418o4cyar+pOPQ1nXSWaV9s+QG4r6m
         tcf8HNGp3srV5wD+NTagNesCPzqId8st0meJde1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?David=20G=C3=A1miz=20Jim=C3=A9nez?= 
        <david.gamiz@gmail.com>
Subject: [PATCH 5.4 24/98] HID: add support for Sega Saturn
Date:   Tue,  1 Dec 2020 09:53:01 +0100
Message-Id: <20201201084655.714310707@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 1811977cb11354aef8cbd13e35ff50db716728a4 ]

This device needs HID_QUIRK_MULTI_INPUT in order to be presented to userspace
in a consistent way.

Reported-and-tested-by: David Gámiz Jiménez <david.gamiz@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b2c86403e43b1..d173badafcf1f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -489,6 +489,7 @@
 #define USB_DEVICE_ID_PENPOWER		0x00f4
 
 #define USB_VENDOR_ID_GREENASIA		0x0e8f
+#define USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR 0x3010
 #define USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD	0x3013
 
 #define USB_VENDOR_ID_GRETAGMACBETH	0x0971
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 0440e2f6e8a3c..abee4e950a4ee 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -83,6 +83,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
-- 
2.27.0



