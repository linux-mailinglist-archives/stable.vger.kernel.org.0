Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB81FB804
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbgFPPv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730410AbgFPPvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17FB0207C4;
        Tue, 16 Jun 2020 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322714;
        bh=LHf8gDm6CCyZh1htR8UAvbQLFNdi/dqQI5P0jwFwD2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1wCZXvym1ic6Z0j0ra3OVQR59EdwAEETHzDOWASsJ1W6zc1m2HI6M+/oOevzW3yW
         4hhoUohRoWNlkslE9GlGU+Oc4ku/W9T1RhVXt6FA28BAgLV9Qr1o0DD/BycizhlkJr
         hsgYuZRWksHttdS0lEyyfMAyO2SHDuHjuyPWcArw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 076/161] ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock
Date:   Tue, 16 Jun 2020 17:34:26 +0200
Message-Id: <20200616153110.000851184@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 0c5086f5699906ec8e31ea6509239489f060f2dc upstream.

The HP Thunderbolt Dock has two separate USB devices, one is for speaker
and one is for headset. Add names for them so userspace can apply UCM
settings.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200608062630.10806-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -25,6 +25,26 @@
 	.idProduct = prod, \
 	.bInterfaceClass = USB_CLASS_VENDOR_SPEC
 
+/* HP Thunderbolt Dock Audio Headset */
+{
+	USB_DEVICE(0x03f0, 0x0269),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "HP",
+		.product_name = "Thunderbolt Dock Audio Headset",
+		.profile_name = "HP-Thunderbolt-Dock-Audio-Headset",
+		.ifnum = QUIRK_NO_INTERFACE
+	}
+},
+/* HP Thunderbolt Dock Audio Module */
+{
+	USB_DEVICE(0x03f0, 0x0567),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "HP",
+		.product_name = "Thunderbolt Dock Audio Module",
+		.profile_name = "HP-Thunderbolt-Dock-Audio-Module",
+		.ifnum = QUIRK_NO_INTERFACE
+	}
+},
 /* FTDI devices */
 {
 	USB_DEVICE(0x0403, 0xb8d8),


