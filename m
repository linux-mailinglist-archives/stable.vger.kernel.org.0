Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8120C1714AC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgB0KFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:05:41 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40571 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgB0KFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:05:41 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2922D76E;
        Thu, 27 Feb 2020 05:05:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 05:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MTwmz9
        l0s0frxONUGrdBqCpqyXCz0cybpYKWQgctW3Y=; b=kam3RfyTmzgMKFmsVFd3kx
        UJP1IZHo1bL2lE8saqTtFW4dNBRPdsa+4p9HdTMrmYNLUGHaJDwB6MjfOM4E4CRB
        C0cOwgW862GOa35yVRKYs7sRicc4F+MekM/qKwulRqlrWlQykpcd/Y3bdHyHi+Tp
        U6ZAgHUd/lJDa67T39oSwizQfG2DJz9hRTHsLrYwC4n9yjRDgyZ6sySEHUsB3RfE
        Zf2fcS2Es42pbKXuD4eRHgNKCNue3GwKuO+cgbH6o6J/kLogg4n1F1rA2As+w0ne
        q2MjOpv7Gw0Yf7/TqucmnERAuwVJGwWBlVJG04Ck1u5SQ6bnMEvuyJ9ibbOgyo5g
        ==
X-ME-Sender: <xms:c5RXXnulCsmh6KJbNrFkn7scxfmrxs3MlHl424QsqUN4RMUZGMutcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:c5RXXgRs6LS6o0LX6_EGJvc44Bs0esfEKrnjNF78FZaVxkWTTfOu-Q>
    <xmx:c5RXXhLA0_yMCB7gc8LO2I4t00B5im6yGujuonqEuIcoQc8BON4mRw>
    <xmx:c5RXXuScaoirNvR_-myvOEc8NpT-U8hKBRcAmpyh-HlsrBgSfO51ng>
    <xmx:c5RXXutaQTJt-vQzNhhRLY1IKnFRGf0zgiLoyjbOvMR2x7QiqD8wlw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 685463060FCB;
        Thu, 27 Feb 2020 05:05:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix in ISOC request length checking" failed to apply to 4.9-stable tree
To:     Minas.Harutyunyan@synopsys.com, balbi@kernel.org,
        hminas@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 11:05:30 +0100
Message-ID: <158279793025353@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 860ef6cd3f90b84a1832f8a6485c90c34d3b588b Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Tue, 21 Jan 2020 14:24:04 +0400
Subject: [PATCH] usb: dwc2: Fix in ISOC request length checking

Moved ISOC request length checking from dwc2_hsotg_start_req() function to
dwc2_hsotg_ep_queue().

Fixes: 4fca54aa58293 ("usb: gadget: s3c-hsotg: add multi count support")
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 88f7d6d4ff2d..7b40cf5bdc2f 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1083,11 +1083,6 @@ static void dwc2_hsotg_start_req(struct dwc2_hsotg *hsotg,
 	else
 		packets = 1;	/* send one packet if length is zero. */
 
-	if (hs_ep->isochronous && length > (hs_ep->mc * hs_ep->ep.maxpacket)) {
-		dev_err(hsotg->dev, "req length > maxpacket*mc\n");
-		return;
-	}
-
 	if (dir_in && index != 0)
 		if (hs_ep->isochronous)
 			epsize = DXEPTSIZ_MC(packets);
@@ -1391,6 +1386,13 @@ static int dwc2_hsotg_ep_queue(struct usb_ep *ep, struct usb_request *req,
 	req->actual = 0;
 	req->status = -EINPROGRESS;
 
+	/* Don't queue ISOC request if length greater than mps*mc */
+	if (hs_ep->isochronous &&
+	    req->length > (hs_ep->mc * hs_ep->ep.maxpacket)) {
+		dev_err(hs->dev, "req length > maxpacket*mc\n");
+		return -EINVAL;
+	}
+
 	/* In DDMA mode for ISOC's don't queue request if length greater
 	 * than descriptor limits.
 	 */

