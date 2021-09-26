Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C42B4188A1
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhIZMdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B8CA60F92;
        Sun, 26 Sep 2021 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659506;
        bh=C5tKECUnIxnISbYtrHjptyfP8VzvScINZ3RQe8sMuh4=;
        h=Subject:To:Cc:From:Date:From;
        b=KUNQLlkCtUImqqpMxcKFBsnEFHRZdJKVyup+kza77q09f1L49yeLXMTSLYLtUukbD
         ER/k9vPm/5m/eF7ArhtvM2ywXF+NHQdtfiF4Gi1A0utSupZLhJNUlS7BFcdc7I61kK
         A9eyouDCbTB7slIWcLdi6WNVLvf+NOufC49eLqks=
Subject: FAILED: patch "[PATCH] usb: gadget: f_uac2: Add missing companion descriptor for" failed to apply to 5.14-stable tree
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:31:44 +0200
Message-ID: <163265950422059@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 595091a1426a3b2625dad322f69fe569dc9d8943 Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Thu, 9 Sep 2021 10:48:10 -0700
Subject: [PATCH] usb: gadget: f_uac2: Add missing companion descriptor for
 feedback EP

The f_uac2 function fails to enumerate when connected in SuperSpeed
due to the feedback endpoint missing the companion descriptor.
Add a new ss_epin_fback_desc_comp descriptor and append it behind the
ss_epin_fback_desc both in the static definition of the ss_audio_desc
structure as well as its dynamic construction in setup_headers().

Fixes: 24f779dac8f3 ("usb: gadget: f_uac2/u_audio: add feedback endpoint support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-2-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 3c34995276e7..d89c1ebb07f4 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -406,6 +406,14 @@ static struct usb_endpoint_descriptor ss_epin_fback_desc = {
 	.bInterval = 4,
 };
 
+static struct usb_ss_ep_comp_descriptor ss_epin_fback_desc_comp = {
+	.bLength		= sizeof(ss_epin_fback_desc_comp),
+	.bDescriptorType	= USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst		= 0,
+	.bmAttributes		= 0,
+	.wBytesPerInterval	= cpu_to_le16(4),
+};
+
 
 /* Audio Streaming IN Interface - Alt0 */
 static struct usb_interface_descriptor std_as_in_if0_desc = {
@@ -597,6 +605,7 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
 	(struct usb_descriptor_header *)&ss_epout_desc_comp,
 	(struct usb_descriptor_header *)&as_iso_out_desc,
 	(struct usb_descriptor_header *)&ss_epin_fback_desc,
+	(struct usb_descriptor_header *)&ss_epin_fback_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_in_if0_desc,
 	(struct usb_descriptor_header *)&std_as_in_if1_desc,
@@ -705,6 +714,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 {
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -730,6 +740,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 		epout_desc_comp = &ss_epout_desc_comp;
 		epin_desc_comp = &ss_epin_desc_comp;
 		epin_fback_desc = &ss_epin_fback_desc;
+		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 		ep_int_desc = &ss_ep_int_desc;
 	}
 
@@ -773,8 +784,11 @@ static void setup_headers(struct f_uac2_opts *opts,
 
 		headers[i++] = USBDHDR(&as_iso_out_desc);
 
-		if (EPOUT_FBACK_IN_EN(opts))
+		if (EPOUT_FBACK_IN_EN(opts)) {
 			headers[i++] = USBDHDR(epin_fback_desc);
+			if (epin_fback_desc_comp)
+				headers[i++] = USBDHDR(epin_fback_desc_comp);
+		}
 	}
 
 	if (EPIN_EN(opts)) {

