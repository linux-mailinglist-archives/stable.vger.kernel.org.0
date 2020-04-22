Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC131B3C39
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgDVKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgDVKDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:03:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912D720575;
        Wed, 22 Apr 2020 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549822;
        bh=I2tQbsYyygkptZpEjVSX438TBxfy4L/ZN8/YbUXSsKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/ACTrN8I0TqIIGWmYeJ1mFe+1Qsi5/rxqMORKT/6McidPBDTfoVpMn0qD+y0CTmj
         qWnzaRMaRX4AuoF/PCE/ixPfphQDecE4k8s51EjFSfRnS8bsRNHmexJv/ucjiN0X4I
         lh5CDpA75Pej55AX67pUVOC91nAmFqQ4T1SxSRFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 021/125] ALSA: usb-audio: Add mixer workaround for TRX40 and co
Date:   Wed, 22 Apr 2020 11:55:38 +0200
Message-Id: <20200422095036.712469123@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
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
 


