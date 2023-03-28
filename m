Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655FF6CBE4E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjC1MAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjC1MAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:00:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ABB900F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2F75616EF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A8EC433D2;
        Tue, 28 Mar 2023 12:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004829;
        bh=X2rNMTV55K817BHZFL4rPhaD1RFVw9FX1KTg1iS5kNs=;
        h=Subject:To:Cc:From:Date:From;
        b=qIfXl1Ou/3A9JJijqvFrrGQzDtPeCbNVR66zfzuGjcIaZvwW1m4nLB+jCbBmlbhtx
         M5mSFZiNuXitD6oYCw4YPQkyKWx/bc4hrWc5Th/RXMv53UXrz3+GOJB+J31nJOoXUj
         2316ipbWZ8aPbxHQomYvG0fhG/ZkaQ4LUx/xYS+U=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Add 1ms delay after end transfer command" failed to apply to 5.15-stable tree
To:     quic_wcheng@quicinc.com, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:00:25 +0200
Message-ID: <168000482518837@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x d8a2bb4eb75866275b5cf7de2e593ac3449643e2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000482518837@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

d8a2bb4eb758 ("usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC")
e192cc7b5239 ("usb: dwc3: gadget: move cmd_endtransfer to extra function")
d74dc3e9f58c ("usb: dwc3: gadget: Ignore NoStream after End Transfer")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8a2bb4eb75866275b5cf7de2e593ac3449643e2 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <quic_wcheng@quicinc.com>
Date: Mon, 6 Mar 2023 12:05:57 -0800
Subject: [PATCH] usb: dwc3: gadget: Add 1ms delay after end transfer command
 without IOC

Previously, there was a 100uS delay inserted after issuing an end transfer
command for specific controller revisions.  This was due to the fact that
there was a GUCTL2 bit field which enabled synchronous completion of the
end transfer command once the CMDACT bit was cleared in the DEPCMD
register.  Since this bit does not exist for all controller revisions and
the current implementation heavily relies on utizling the EndTransfer
command completion interrupt, add the delay back in for uses where the
interrupt on completion bit is not set, and increase the duration to 1ms
for the controller to complete the command.

An issue was seen where the USB request buffer was unmapped while the DWC3
controller was still accessing the TRB.  However, it was confirmed that the
end transfer command was successfully submitted. (no end transfer timeout)
In situations, such as dwc3_gadget_soft_disconnect() and
__dwc3_gadget_ep_disable(), the dwc3_remove_request() is utilized, which
will issue the end transfer command, and follow up with
dwc3_gadget_giveback().  At least for the USB ep disable path, it is
required for any pending and started requests to be completed and returned
to the function driver in the same context of the disable call.  Without
the GUCTL2 bit, it is not ensured that the end transfer is completed before
the buffers are unmapped.

Fixes: cf2f8b63f7f1 ("usb: dwc3: gadget: Remove END_TRANSFER delay")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230306200557.29387-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3c63fa97a680..cf5b4f49c3ed 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1699,6 +1699,7 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
  */
 static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
 {
+	struct dwc3 *dwc = dep->dwc;
 	struct dwc3_gadget_ep_cmd_params params;
 	u32 cmd;
 	int ret;
@@ -1722,10 +1723,13 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt) {
+		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
+			mdelay(1);
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	} else if (!ret) {
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	}
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
@@ -3774,7 +3778,11 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * enabled, the EndTransfer command will have completed upon
 	 * returning from this function.
 	 *
-	 * This mode is NOT available on the DWC_usb31 IP.
+	 * This mode is NOT available on the DWC_usb31 IP.  In this
+	 * case, if the IOC bit is not set, then delay by 1ms
+	 * after issuing the EndTransfer command.  This allows for the
+	 * controller to handle the command completely before DWC3
+	 * remove requests attempts to unmap USB request buffers.
 	 */
 
 	__dwc3_stop_active_transfer(dep, force, interrupt);

