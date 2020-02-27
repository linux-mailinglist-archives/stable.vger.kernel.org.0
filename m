Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663BA1714AA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgB0KFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:05:33 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60537 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgB0KFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:05:33 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2F76D63D;
        Thu, 27 Feb 2020 05:05:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 05:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g71PCV
        0lkVW9lSb4xXEqFOfJzhNhHBLfQksQEWzdpB4=; b=u+Lw5ThJ4MbVyU0H/+pE8j
        5Q+lEU+df+/DS7DVxJcv2rqa/I2zov9kBcw2xD+u7mK9J4nMyq8aB9aDfqkn7sBp
        QkCGFf1zL91VwiNedRHEI0gBrxJzNLuzJJz1VCLFiyBwlNvvSosjLcLvDotMVPFJ
        rBcAUXVfLPH4o83dEJQ4hrQzxVQVKQKZ/U8IW68Nt1GAaodXSY6Rze8e1d3OS7io
        2MjBucYEvT1WpR+71fB+Xa9x6PnbaeAZgI7jyWFDBn0JcoxMfrMbECanJPCHKlmt
        n6iVBVAZkxPBOG1+wpfWJ6yNzRUUIxSo0f2017EmTo4SEm/KRjLc0vwpA64eXu3w
        ==
X-ME-Sender: <xms:a5RXXu03WUzRc3vbRQlf__GjplzyFTF5ZxxS8Xm_xJpI7FIsRYGJZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:a5RXXjIBjA6CCAJKf45aG394wHMTvKyXUz3-Zcejgu0BtDjmGoh1oA>
    <xmx:a5RXXlB0nOmb1UaMvRBLKGvzXQXt1hLpJjJ7Ei8qEO1yglYZizZomA>
    <xmx:a5RXXkzask2sVSN-c_MZNEylhzqpVocy0ThQ0nvQobgXK7Pkxx1dPg>
    <xmx:a5RXXhl2tIfQO3UtnlTP40QrsDgZ03lYdQgBK5eR7gFs4HozonThrg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 640973060FCB;
        Thu, 27 Feb 2020 05:05:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix in ISOC request length checking" failed to apply to 4.14-stable tree
To:     Minas.Harutyunyan@synopsys.com, balbi@kernel.org,
        hminas@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 11:05:30 +0100
Message-ID: <158279793077241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

