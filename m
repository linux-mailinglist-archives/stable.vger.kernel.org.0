Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4FE246A82
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbgHQPhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgHQPhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9221208E4;
        Mon, 17 Aug 2020 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678645;
        bh=fWb5i/sL6YwHawL+Gmxy2JyxEb358yH7fmSsuBuZ0s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgfJkRBpDVN/F2dw3uwGaAuYgeYczQ8h79cdMZgP4AoVmtd2AH8PTUTOVTHixWQCZ
         RbnQrPuh9f1mQSA93XCqebBbuR+lUK9XUdqBKUoIcX/8XHn5ZYxbTqOK83obsvSyvx
         dFrE7wBxfvwQmMstscOs5cs/YuXx3U9IX+cxK9hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 405/464] ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
Date:   Mon, 17 Aug 2020 17:15:58 +0200
Message-Id: <20200817143853.179530624@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 14a720dc1f5332f3bdf30a23a3bc549e81be974c upstream.

Matching by device matches all interfaces, which breaks the video/HID
portions of the device depending on module load order.

Fixes: e337bf19f6af ("ALSA: usb-audio: add quirk for MacroSilicon MS2109")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20200810045319.128745-1-marcan@marcan.st
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3645,7 +3645,13 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
  * with.
  */
 {
-	USB_DEVICE(0x534d, 0x2109),
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x534d,
+	.idProduct = 0x2109,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.vendor_name = "MacroSilicon",
 		.product_name = "MS2109",


