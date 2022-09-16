Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2C5BAAAA
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIPKTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiIPKSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A77AFAF3;
        Fri, 16 Sep 2022 03:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF29662A20;
        Fri, 16 Sep 2022 10:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B88C433C1;
        Fri, 16 Sep 2022 10:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323162;
        bh=8ThC85J/wSX3GFsBiI4U7mtGNrOsFRRcVFqnrA//jpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2Kowy92iu+Ao3ZyxwIQTDo3qrcSd6P0n+wIqUCnWH6o6d2viEAfFFUr0tQRKqdF0
         Hgu0Si4h96j7BwH1C4p7lcYZH9xoQ9i13XlB90KhnNyIkBtKH8WuF9XNeXDpkBO3xI
         VjlcMet6Ch+w0gjX/ShdYY5wlKjn6d4BMEpvpWK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Jing Leng <jleng@ambarella.com>,
        Jack Pham <quic_jackp@quicinc.com>
Subject: [PATCH 5.15 33/35] usb: gadget: f_uac2: fix superspeed transfer
Date:   Fri, 16 Sep 2022 12:08:56 +0200
Message-Id: <20220916100448.339070740@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Leng <jleng@ambarella.com>

commit f511aef2ebe5377d4c263842f2e0c0b8e274e8e5 upstream.

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
---
 drivers/usb/gadget/function/f_uac2.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -281,6 +281,12 @@ static struct usb_endpoint_descriptor ss
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
@@ -594,7 +600,8 @@ static struct usb_descriptor_header *ss_
 	(struct usb_descriptor_header *)&in_feature_unit_desc,
 	(struct usb_descriptor_header *)&io_out_ot_desc,
 
-  (struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_out_if0_desc,
 	(struct usb_descriptor_header *)&std_as_out_if1_desc,
@@ -721,6 +728,7 @@ static void setup_headers(struct f_uac2_
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *ep_int_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -748,6 +756,7 @@ static void setup_headers(struct f_uac2_
 		epin_fback_desc = &ss_epin_fback_desc;
 		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 		ep_int_desc = &ss_ep_int_desc;
+		ep_int_desc_comp = &ss_ep_int_desc_comp;
 	}
 
 	i = 0;
@@ -776,8 +785,11 @@ static void setup_headers(struct f_uac2_
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


