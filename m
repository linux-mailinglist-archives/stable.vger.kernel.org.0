Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949181ACC68
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895589AbgDPN1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895581AbgDPN1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:27:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B61206E9;
        Thu, 16 Apr 2020 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043664;
        bh=I2tQbsYyygkptZpEjVSX438TBxfy4L/ZN8/YbUXSsKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3V4fwPt3aSx649xEzMuTMrY37HrjxOZhmnW1TocJXmcaE6PbR4Sw0z0+uSxBr0f2
         knuAz6IN8qTegzJ5IJrufZyhEtH0j/0NSGA2tBmDDmEs/X4mq55FVb5jUmhFR3kNTZ
         9aGMExpMi8ktCauj8WGIkXBezA3P8vElyG95hvc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 050/146] ALSA: usb-audio: Add mixer workaround for TRX40 and co
Date:   Thu, 16 Apr 2020 15:23:11 +0200
Message-Id: <20200416131249.737822924@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2a48218f8e23d47bd3e23cfdfb8aa9066f7dc3e6 upstream.

Some recent boards (supposedly with a new AMD platform) contain the
USB audio class 2 device that is often tied with HD-audio.  The device
exposes an Input Gain Pad control (id=19, control=12) but this node
doesn't behave correctly, returning an error for each inquiry of
GET_MIN and GET_MAX that should have been mandatory.

As a workaround, simply ignore this node by adding a usbmix_name_map
table entry.  The currently known devices are:
* 0414:a002 - Gigabyte TRX40 Aorus Pro WiFi
* 0b05:1916 - ASUS ROG Zenith II
* 0b05:1917 - ASUS ROG Strix
* 0db0:0d64 - MSI TRX40 Creator
* 0db0:543d - MSI TRX40

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206543
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200408140449.22319-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_maps.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -363,6 +363,14 @@ static const struct usbmix_name_map dell
 	{ 0 }
 };
 
+/* Some mobos shipped with a dummy HD-audio show the invalid GET_MIN/GET_MAX
+ * response for Input Gain Pad (id=19, control=12).  Skip it.
+ */
+static const struct usbmix_name_map asus_rog_map[] = {
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -482,6 +490,26 @@ static struct usbmix_ctl_map usbmix_ctl_
 		.id = USB_ID(0x05a7, 0x1020),
 		.map = bose_companion5_map,
 	},
+	{	/* Gigabyte TRX40 Aorus Pro WiFi */
+		.id = USB_ID(0x0414, 0xa002),
+		.map = asus_rog_map,
+	},
+	{	/* ASUS ROG Zenith II */
+		.id = USB_ID(0x0b05, 0x1916),
+		.map = asus_rog_map,
+	},
+	{	/* ASUS ROG Strix */
+		.id = USB_ID(0x0b05, 0x1917),
+		.map = asus_rog_map,
+	},
+	{	/* MSI TRX40 Creator */
+		.id = USB_ID(0x0db0, 0x0d64),
+		.map = asus_rog_map,
+	},
+	{	/* MSI TRX40 */
+		.id = USB_ID(0x0db0, 0x543d),
+		.map = asus_rog_map,
+	},
 	{ 0 } /* terminator */
 };
 


