Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5BD1AEBB2
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDRKXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 06:23:47 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:58471 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbgDRKXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 06:23:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9D7B6634;
        Sat, 18 Apr 2020 06:23:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 18 Apr 2020 06:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=me0AnX
        amg00zwhjfdFz1wk/KyuFkz2LcJ5gGhb06rR8=; b=gd8ogTpjlUC2Qo2v99wF7K
        q7Ny+gh1yZRevN9jiz6Zr+H6zAITPXIXzAw8JcvrIBLLhTI5PLqI6Dh3noaI+6KO
        ohqLmNP1kFLvKMWNCzgxsT59m+/0tznuGSpsI2y5Lcyex8FKY+Y4DnOxdi1ZGHtw
        b2q5a82QqETLVVgAKOu3wlFZohdc/nwgwpUJyit1fQme4STKzonHw0LlJrGWxqYM
        k1eVPdRGneqc+GIxkePxkwnoToYN/+qrbqogAosfwpPbl/oGwq9EZnUx54kzEyVQ
        8YP6Ei09Jw8gM7Ihbixps7opsGywaF7R379RAjhI1xKQ2LKwgpxl0vuhmMqaf+Wg
        ==
X-ME-Sender: <xms:B9WaXoOWtxFZqTLOAeZ5Q276g3ZQ08TbmAu87UMnk6qMl1VPOujkuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:B9WaXuIXRsPuX_omP-glVjW5DY_xRHWRXx-2EuiSO_XEPnwZ7TNhsg>
    <xmx:B9WaXleUF58h0NoTPD8gvdVkHPbpUdsnLvx6hrfxPxfXeD4RPyVxcg>
    <xmx:B9WaXiOdOdiFxLUXefcIGAk56NdG8PbaYh7ZO8LpiZ0u6RS-J9vitw>
    <xmx:CNWaXukLG4yxYFIv7m7AJrRqXW8AwNsiuD9MMiLDjYAeDLALly7fHLkyOqk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9838B3060062;
        Sat, 18 Apr 2020 06:23:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Don't clear flags before transfer ended" failed to apply to 4.19-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Apr 2020 12:23:02 +0200
Message-ID: <158720538210062@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a114c4ca64bd522aec1790c7e5c60c882f699d8f Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 5 Mar 2020 13:23:49 -0800
Subject: [PATCH] usb: dwc3: gadget: Don't clear flags before transfer ended

We track END_TRANSFER command completion. Don't clear transfer
started/ended flag prematurely. Otherwise, we'd run into the problem
with restarting transfer before END_TRANSFER command finishes.

Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1e00bf2d65a2..b032e62fff0f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2570,10 +2570,8 @@ static void dwc3_gadget_endpoint_transfer_in_progress(struct dwc3_ep *dep,
 
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
-	if (stop) {
+	if (stop)
 		dwc3_stop_active_transfer(dep, true, true);
-		dep->flags = DWC3_EP_ENABLED;
-	}
 
 	/*
 	 * WORKAROUND: This is the 2nd half of U1/U2 -> U0 workaround.

