Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB2B7F384
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406685AbfHBJ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406988AbfHBJ5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E311E2064A;
        Fri,  2 Aug 2019 09:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739870;
        bh=MmQFR9nW3lLglYcyNkyalTFjgmjOqs3o5NdCYhQBnAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzYBXvki7bO1exrVqM/fv1dN5WI2Xzbiee35vtkjnMIxf2UCGHPgjvJX6pio1dHFU
         eEaLRtvFv+w7ohlYvzC7QBT+/PR1cCmUv3RZKFXRZ+p9/tymgp8i7jIEDN2CjvoAPg
         r5L6DzjOP2WacfGjZ3pm1shMMr86sLaPD3hPzt/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 03/20] ALSA: usb-audio: Sanity checks for each pipe and EP types
Date:   Fri,  2 Aug 2019 11:39:57 +0200
Message-Id: <20190802092058.248343532@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 801ebf1043ae7b182588554cc9b9ad3c14bc2ab5 upstream.

The recent USB core code performs sanity checks for the given pipe and
EP types, and it can be hit by manipulated USB descriptors by syzbot.
For making syzbot happier, this patch introduces a local helper for a
sanity check in the driver side and calls it at each place before the
message handling, so that we can avoid the WARNING splats.

Reported-by: syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/helper.c |   17 +++++++++++++++++
 sound/usb/helper.h |    1 +
 sound/usb/quirks.c |   18 +++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

--- a/sound/usb/helper.c
+++ b/sound/usb/helper.c
@@ -63,6 +63,20 @@ void *snd_usb_find_csint_desc(void *buff
 	return NULL;
 }
 
+/* check the validity of pipe and EP types */
+int snd_usb_pipe_sanity_check(struct usb_device *dev, unsigned int pipe)
+{
+	static const int pipetypes[4] = {
+		PIPE_CONTROL, PIPE_ISOCHRONOUS, PIPE_BULK, PIPE_INTERRUPT
+	};
+	struct usb_host_endpoint *ep;
+
+	ep = usb_pipe_endpoint(dev, pipe);
+	if (usb_pipetype(pipe) != pipetypes[usb_endpoint_type(&ep->desc)])
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * Wrapper for usb_control_msg().
  * Allocates a temp buffer to prevent dmaing from/to the stack.
@@ -75,6 +89,9 @@ int snd_usb_ctl_msg(struct usb_device *d
 	void *buf = NULL;
 	int timeout;
 
+	if (snd_usb_pipe_sanity_check(dev, pipe))
+		return -EINVAL;
+
 	if (size > 0) {
 		buf = kmemdup(data, size, GFP_KERNEL);
 		if (!buf)
--- a/sound/usb/helper.h
+++ b/sound/usb/helper.h
@@ -7,6 +7,7 @@ unsigned int snd_usb_combine_bytes(unsig
 void *snd_usb_find_desc(void *descstart, int desclen, void *after, u8 dtype);
 void *snd_usb_find_csint_desc(void *descstart, int desclen, void *after, u8 dsubtype);
 
+int snd_usb_pipe_sanity_check(struct usb_device *dev, unsigned int pipe);
 int snd_usb_ctl_msg(struct usb_device *dev, unsigned int pipe,
 		    __u8 request, __u8 requesttype, __u16 value, __u16 index,
 		    void *data, __u16 size);
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -828,11 +828,13 @@ static int snd_usb_novation_boot_quirk(s
 static int snd_usb_accessmusic_boot_quirk(struct usb_device *dev)
 {
 	int err, actual_length;
-
 	/* "midi send" enable */
 	static const u8 seq[] = { 0x4e, 0x73, 0x52, 0x01 };
+	void *buf;
 
-	void *buf = kmemdup(seq, ARRAY_SIZE(seq), GFP_KERNEL);
+	if (snd_usb_pipe_sanity_check(dev, usb_sndintpipe(dev, 0x05)))
+		return -EINVAL;
+	buf = kmemdup(seq, ARRAY_SIZE(seq), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x05), buf,
@@ -857,7 +859,11 @@ static int snd_usb_accessmusic_boot_quir
 
 static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
-	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+	int ret;
+
+	if (snd_usb_pipe_sanity_check(dev, usb_sndctrlpipe(dev, 0)))
+		return -EINVAL;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				  1, 0, NULL, 0, 1000);
 
@@ -964,6 +970,8 @@ static int snd_usb_axefx3_boot_quirk(str
 
 	dev_dbg(&dev->dev, "Waiting for Axe-Fx III to boot up...\n");
 
+	if (snd_usb_pipe_sanity_check(dev, usb_sndctrlpipe(dev, 0)))
+		return -EINVAL;
 	/* If the Axe-Fx III has not fully booted, it will timeout when trying
 	 * to enable the audio streaming interface. A more generous timeout is
 	 * used here to detect when the Axe-Fx III has finished booting as the
@@ -996,6 +1004,8 @@ static int snd_usb_motu_microbookii_comm
 {
 	int err, actual_length;
 
+	if (snd_usb_pipe_sanity_check(dev, usb_sndintpipe(dev, 0x01)))
+		return -EINVAL;
 	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x01), buf, *length,
 				&actual_length, 1000);
 	if (err < 0)
@@ -1006,6 +1016,8 @@ static int snd_usb_motu_microbookii_comm
 
 	memset(buf, 0, buf_size);
 
+	if (snd_usb_pipe_sanity_check(dev, usb_rcvintpipe(dev, 0x82)))
+		return -EINVAL;
 	err = usb_interrupt_msg(dev, usb_rcvintpipe(dev, 0x82), buf, buf_size,
 				&actual_length, 1000);
 	if (err < 0)


