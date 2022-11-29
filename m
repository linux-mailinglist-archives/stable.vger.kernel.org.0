Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5A863C5EF
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 18:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiK2RAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 12:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiK2Q75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 11:59:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F26A6DCD1
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 08:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26548B816E6
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 16:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A47C433D6;
        Tue, 29 Nov 2022 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669740930;
        bh=4JCwUH5vx6V1SM+0x5bjTD7Uyq3K49fUsFcwuRB4K/E=;
        h=Subject:To:Cc:From:Date:From;
        b=XVT+99ayLGjxEyxkuys93U5zNQDQLbAnYQIK68N5eRQej5DTwqWNPjrPUTq3z5y8K
         eCN2DehrntP3AdXmV4jyrLDkDK3KYQYmgo+OT6THIZsftV3hgGMaQmSrKDTDuIdfPI
         aWgK4yTwLBcjoclay9lvoX6mNv1Ou+boJq7tPHkM=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Clear ep descriptor last" failed to apply to 6.0-stable tree
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Nov 2022 17:55:23 +0100
Message-ID: <1669740923132247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f90f5afd5083 ("usb: dwc3: gadget: Clear ep descriptor last")
ffb9da4a04c6 ("usb: dwc3: gadget: Return -ESHUTDOWN on ep disable")
b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f90f5afd5083a7cb4aee13bd4cc0ae600bd381ca Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Tue, 15 Nov 2022 17:19:43 -0800
Subject: [PATCH] usb: dwc3: gadget: Clear ep descriptor last

Until the endpoint is disabled, its descriptors should remain valid.
When its requests are removed from ep disable, the request completion
routine may attempt to access the endpoint's descriptor. Don't clear the
descriptors before that.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/45db7c83b209259115bf652af210f8b2b3b1a383.1668561364.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8b4cfa07539d..6d524fa76443 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1024,12 +1024,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	/* Clear out the ep descriptors for non-ep0 */
-	if (dep->number > 1) {
-		dep->endpoint.comp_desc = NULL;
-		dep->endpoint.desc = NULL;
-	}
-
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
@@ -1044,6 +1038,12 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		mask |= (DWC3_EP_DELAY_STOP | DWC3_EP_TRANSFER_STARTED);
 	dep->flags &= mask;
 
+	/* Clear out the ep descriptors for non-ep0 */
+	if (dep->number > 1) {
+		dep->endpoint.comp_desc = NULL;
+		dep->endpoint.desc = NULL;
+	}
+
 	return 0;
 }
 

