Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65B3171DCA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389101AbgB0OOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389105AbgB0OOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D740B24697;
        Thu, 27 Feb 2020 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812857;
        bh=Dqe8peYwQwuHYE4wE7HzqKcEV4TelEPWey30f3hiVvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaYxrrnUVztyfLYJ/Dhq4e7af7CMcAnaCqrHofBQmf5YokhRNO1SHDERZ9kQgwzyK
         o8YYHlt0x+ztB4jTQQ3R+ZwCE/jdJxSqSGABOKb6SXjBz7egLUVzM/BbAiPNcrR8vx
         9bc+7D0JlMDJIQMlYSQiSunSVkxeyBjk9eWoeteQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5.5 042/150] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
Date:   Thu, 27 Feb 2020 14:36:19 +0100
Message-Id: <20200227132239.087998024@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>

commit 5ee858975b13a9b40db00f456989a689fdbb296c upstream.

The current code in dwc3_gadget_ep_reclaim_completed_trb() will
check for IOC/LST bit in the event->status and returns if
IOC/LST bit is set. This logic doesn't work if multiple TRBs
are queued per request and the IOC/LST bit is set on the last
TRB of that request.

Consider an example where a queued request has multiple queued
TRBs and IOC/LST bit is set only for the last TRB. In this case,
the core generates XferComplete/XferInProgress events only for
the last TRB (since IOC/LST are set only for the last TRB). As
per the logic in dwc3_gadget_ep_reclaim_completed_trb()
event->status is checked for IOC/LST bit and returns on the
first TRB. This leaves the remaining TRBs left unhandled.

Similarly, if the gadget function enqueues an unaligned request
with sglist already in it, it should fail the same way, since we
will append another TRB to something that already uses more than
one TRB.

To aviod this, this patch changes the code to check for IOC/LST
bits in TRB->ctrl instead.

At a practical level, this patch resolves USB transfer stalls seen
with adb on dwc3 based HiKey960 after functionfs gadget added
scatter-gather support around v4.20.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
[jstultz: forward ported to mainline, reworded commit log, reworked
 to only check trb->ctrl as suggested by Felipe]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2426,7 +2426,8 @@ static int dwc3_gadget_ep_reclaim_comple
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
-	if (event->status & DEPEVT_STATUS_IOC)
+	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
+	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
 
 	return 0;


