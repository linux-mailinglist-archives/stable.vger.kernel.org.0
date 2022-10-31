Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E29612FF0
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiJaFp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaFp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:45:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283A4627A
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4173B8111A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD89C433D6;
        Mon, 31 Oct 2022 05:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667195146;
        bh=oHuT+PofRtEv0io4p19uOiVZek7HVwEsLM/I7fVpZ3o=;
        h=Subject:To:Cc:From:Date:From;
        b=N7vdGLux4/brogSMrDfrBSvcJGJJ8C9S0MCV5xM3TltTJOiyT9EPSs660LWqAkpgk
         5jlUHCmRBFp87kwNfu5lPQfVAGUkeymI27mYpsQ1PTSkMdekKryq+LIh3kq0NA3E8Y
         7J0J1QeRsfuLCED4fsEqBJSm3HWm5z+DWrgY/Mm8=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Don't set IMI for no_interrupt" failed to apply to 4.9-stable tree
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        jdv1029@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:46:42 +0100
Message-ID: <1667195202255158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

308c316d16cb ("usb: dwc3: gadget: Don't set IMI for no_interrupt")
0a695d4c75ff ("usb: dwc3: gadget: never ever kill the machine")
6b9018d4c1e5 ("usb: dwc3: gadget: set PCM1 field of isochronous-first TRBs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 308c316d16cbad99bb834767382baa693ac42169 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Tue, 25 Oct 2022 15:10:20 -0700
Subject: [PATCH] usb: dwc3: gadget: Don't set IMI for no_interrupt

The gadget driver may have a certain expectation of how the request
completion flow should be from to its configuration. Make sure the
controller driver respect that. That is, don't set IMI (Interrupt on
Missed Isoc) when usb_request->no_interrupt is set. Also, the driver
should only set IMI to the last TRB of a chain.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 230b3c660054..5fe2d136dff5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:

