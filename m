Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB494ABB0F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384549AbiBGL2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382546AbiBGLTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:19:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BBEC043181;
        Mon,  7 Feb 2022 03:19:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6D86077B;
        Mon,  7 Feb 2022 11:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372FAC340F0;
        Mon,  7 Feb 2022 11:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232779;
        bh=wsyRc9ZMvzorUJmWyI3fLh+nyyibMv5xQACoeXZCBwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCRSVOhZuJHvM1A/Z/Ixnj6wJXlM/ksa1skypCs0DG8ZbE9oib8aPLDfWAlMrt4hi
         PXc+tE6nGWoTSl7qrXcHsT8lG2Bs2SW4KPGwEtijw5q6EtAEtkeErQT/BGI1HOdMer
         0TXfHWKhPPEcH3I2xOgF0pNdEUeAYT8nXmPXaWPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 05/44] ALSA: usb-audio: Simplify quirk entries with a macro
Date:   Mon,  7 Feb 2022 12:06:21 +0100
Message-Id: <20220207103753.334915098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit fa10635fca359f047df6a18b3befd2f1e7304e1a upstream.

Introduce a new macro USB_AUDIO_DEVICE() for the entries matching with
the pid/vid pair and the class/subclass, and remove the open-code.

Link: https://lore.kernel.org/r/20200817082140.20232-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ just add the macro for 5.4.y, no entry changes made - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -25,6 +25,16 @@
 	.idProduct = prod, \
 	.bInterfaceClass = USB_CLASS_VENDOR_SPEC
 
+/* A standard entry matching with vid/pid and the audio class/subclass */
+#define USB_AUDIO_DEVICE(vend, prod) \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS, \
+	.idVendor = vend, \
+	.idProduct = prod, \
+	.bInterfaceClass = USB_CLASS_AUDIO, \
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL
+
 /* HP Thunderbolt Dock Audio Headset */
 {
 	USB_DEVICE(0x03f0, 0x0269),


