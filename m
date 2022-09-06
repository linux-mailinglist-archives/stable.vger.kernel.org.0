Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618B55AE69C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiIFLaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiIFLaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:30:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4470114D3A
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 935C0CE16FB
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE71C433C1;
        Tue,  6 Sep 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463816;
        bh=RM75NrjzRw1tfHlQLSkJYkWhST1okJNKv99zBYtsXEQ=;
        h=Subject:To:Cc:From:Date:From;
        b=IqWfIST6QEBkmBdXuA5HYtNpUu9WG1NuGyq7wBNkqdrZSb5to+C9kSMRST/acJP40
         rl+yXyRGphpGaqsSlF4c5kfvvWplK7giSv+ElDhjmHKsU69Sh7YT95L6dyZHljNFMF
         rnpSOPo4c7VPZD6dLMz809SsXmh2fu/+1JwMdhsg=
Subject: FAILED: patch "[PATCH] usb: gadget: f_uac2: fix superspeed transfer" failed to apply to 5.15-stable tree
To:     jleng@ambarella.com, gregkh@linuxfoundation.org,
        quic_jackp@quicinc.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:30:14 +0200
Message-ID: <1662463814122169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f511aef2ebe5377d4c263842f2e0c0b8e274e8e5 Mon Sep 17 00:00:00 2001
From: Jing Leng <jleng@ambarella.com>
Date: Wed, 20 Jul 2022 18:48:15 -0700
Subject: [PATCH] usb: gadget: f_uac2: fix superspeed transfer

On page 362 of the USB3.2 specification (
https://usb.org/sites/default/files/usb_32_20210125.zip),
The 'SuperSpeed Endpoint Companion Descriptor' shall only be returned
by Enhanced SuperSpeed devices that are operating at Gen X speed.
Each endpoint described in an interface is followed by a 'SuperSpeed
Endpoint Companion Descriptor'.

If users use SuperSpeed UDC, host can't recognize the device if endpoint
doesn't have 'SuperSpeed Endpoint Companion Descriptor' followed.

Currently in the uac2 driver code:
1. ss_epout_desc_comp follows ss_epout_desc;
2. ss_epin_fback_desc_comp follows ss_epin_fback_desc;
3. ss_epin_desc_comp follows ss_epin_desc;
4. Only ss_ep_int_desc endpoint doesn't have 'SuperSpeed Endpoint
Companion Descriptor' followed, so we should add it.

Fixes: eaf6cbe09920 ("usb: gadget: f_uac2: add volume and mute support")
Cc: stable <stable@kernel.org>
Signed-off-by: Jing Leng <jleng@ambarella.com>
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Link: https://lore.kernel.org/r/20220721014815.14453-1-quic_jackp@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 1905a8d8e0c9..08726e4c68a5 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -291,6 +291,12 @@ static struct usb_endpoint_descriptor ss_ep_int_desc = {
 	.bInterval = 4,
 };
 
+static struct usb_ss_ep_comp_descriptor ss_ep_int_desc_comp = {
+	.bLength = sizeof(ss_ep_int_desc_comp),
+	.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
+	.wBytesPerInterval = cpu_to_le16(6),
+};
+
 /* Audio Streaming OUT Interface - Alt0 */
 static struct usb_interface_descriptor std_as_out_if0_desc = {
 	.bLength = sizeof std_as_out_if0_desc,
@@ -604,7 +610,8 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
 	(struct usb_descriptor_header *)&in_feature_unit_desc,
 	(struct usb_descriptor_header *)&io_out_ot_desc,
 
-  (struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_out_if0_desc,
 	(struct usb_descriptor_header *)&std_as_out_if1_desc,
@@ -800,6 +807,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *ep_int_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -827,6 +835,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 		epin_fback_desc = &ss_epin_fback_desc;
 		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 		ep_int_desc = &ss_ep_int_desc;
+		ep_int_desc_comp = &ss_ep_int_desc_comp;
 	}
 
 	i = 0;
@@ -855,8 +864,11 @@ static void setup_headers(struct f_uac2_opts *opts,
 	if (EPOUT_EN(opts))
 		headers[i++] = USBDHDR(&io_out_ot_desc);
 
-	if (FUOUT_EN(opts) || FUIN_EN(opts))
+	if (FUOUT_EN(opts) || FUIN_EN(opts)) {
 		headers[i++] = USBDHDR(ep_int_desc);
+		if (ep_int_desc_comp)
+			headers[i++] = USBDHDR(ep_int_desc_comp);
+	}
 
 	if (EPOUT_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_out_if0_desc);

