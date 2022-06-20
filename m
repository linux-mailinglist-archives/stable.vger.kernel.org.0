Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C54B55127A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239875AbiFTIT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbiFTITr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:19:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C9111A3D
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E2961291
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F41EC3411B;
        Mon, 20 Jun 2022 08:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655713186;
        bh=TQzVSwcsvaB7w67/E95aUge2cIqPZpiOvlK36HKiXAE=;
        h=Subject:To:Cc:From:Date:From;
        b=ZHSKTlUS7RaC2pZ+NVOttmSOp58vGQG/EzJgTdfczIHrF/2YKXtxuDXOx3AHVgmTm
         5/ZO3wwxVz6G/Om+10ZJ/VowOunJpVe9eUS+U88nRitT3GPuylGNFaFswKsPFC/DMz
         D6X4V+/tQxi3HoiFvCHewg2v4Kigvv2m6UhwdEr8=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Fix IN endpoint max packet size allocation" failed to apply to 4.19-stable tree
To:     quic_wcheng@quicinc.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 10:19:30 +0200
Message-ID: <16557131707599@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9c1e916960c1192e746bf615e4dae25423473a64 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <quic_wcheng@quicinc.com>
Date: Mon, 23 May 2022 14:39:48 -0700
Subject: [PATCH] usb: dwc3: gadget: Fix IN endpoint max packet size allocation

The current logic to assign the max packet limit for IN endpoints attempts
to take the default HW value and apply the optimal endpoint settings based
on it.  However, if the default value reports a TxFIFO size large enough
for only one max packet, it will divide the value and assign a smaller ep
max packet limit.

For example, if the default TxFIFO size fits 1024B, current logic will
assign 1024/3 = 341B to ep max packet size.  If function drivers attempt to
request for an endpoint with a wMaxPacketSize of 1024B (SS BULK max packet
size) then it will fail, as the gadget is unable to find an endpoint which
can fit the requested size.

Functionally, if the TxFIFO has enough space to fit one max packet, it will
be sufficient, at least when initializing the endpoints.

Fixes: d94ea5319813 ("usb: dwc3: gadget: Properly set maxpacket limit")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220523213948.22142-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 00427d108ab9..8716bece1072 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2976,6 +2976,7 @@ static int dwc3_gadget_init_in_endpoint(struct dwc3_ep *dep)
 	struct dwc3 *dwc = dep->dwc;
 	u32 mdwidth;
 	int size;
+	int maxpacket;
 
 	mdwidth = dwc3_mdwidth(dwc);
 
@@ -2988,21 +2989,24 @@ static int dwc3_gadget_init_in_endpoint(struct dwc3_ep *dep)
 	else
 		size = DWC31_GTXFIFOSIZ_TXFDEP(size);
 
-	/* FIFO Depth is in MDWDITH bytes. Multiply */
-	size *= mdwidth;
-
 	/*
-	 * To meet performance requirement, a minimum TxFIFO size of 3x
-	 * MaxPacketSize is recommended for endpoints that support burst and a
-	 * minimum TxFIFO size of 2x MaxPacketSize for endpoints that don't
-	 * support burst. Use those numbers and we can calculate the max packet
-	 * limit as below.
+	 * maxpacket size is determined as part of the following, after assuming
+	 * a mult value of one maxpacket:
+	 * DWC3 revision 280A and prior:
+	 * fifo_size = mult * (max_packet / mdwidth) + 1;
+	 * maxpacket = mdwidth * (fifo_size - 1);
+	 *
+	 * DWC3 revision 290A and onwards:
+	 * fifo_size = mult * ((max_packet + mdwidth)/mdwidth + 1) + 1
+	 * maxpacket = mdwidth * ((fifo_size - 1) - 1) - mdwidth;
 	 */
-	if (dwc->maximum_speed >= USB_SPEED_SUPER)
-		size /= 3;
+	if (DWC3_VER_IS_PRIOR(DWC3, 290A))
+		maxpacket = mdwidth * (size - 1);
 	else
-		size /= 2;
+		maxpacket = mdwidth * ((size - 1) - 1) - mdwidth;
 
+	/* Functionally, space for one max packet is sufficient */
+	size = min_t(int, maxpacket, 1024);
 	usb_ep_set_maxpacket_limit(&dep->endpoint, size);
 
 	dep->endpoint.max_streams = 16;

