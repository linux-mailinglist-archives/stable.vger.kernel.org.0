Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9582A1CAACA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEHMgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgEHMgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140D521473;
        Fri,  8 May 2020 12:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941414;
        bh=fDxB7yOTpGNNY3i43zVtWuGlUS+QbkbR0NmagnPSfpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcXoU4UkWHl0fzo4sr/IJvDYObs/OXWrMD+YK9teTdGJRNGChBfCgPFlKCQiRK/ff
         v6S4tcr/BUbkEIrmXYkrSkc0PPpvpTXc6eHGOSlJpPAwfNERdtWvk390IG6zWWecue
         bVhFOPO+UzZlw1Pd2HEzOsbenERSHnjsGC9tNGvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iago Abal <mail@iagoabal.eu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.4 007/312] usb: gadget: pch_udc: reorder spin_[un]lock to avoid deadlock
Date:   Fri,  8 May 2020 14:29:58 +0200
Message-Id: <20200508123125.033701501@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iago Abal <mail@iagoabal.eu>

commit 1d23d16a88e6c8143b07339435ba061b131ebb8c upstream.

The above commit reordered spin_lock/unlock and now `&dev->lock' is acquired
(rather than released) before calling `dev->driver->disconnect',
`dev->driver->setup', `dev->driver->suspend', `usb_gadget_giveback_request', and
`usb_gadget_udc_reset'.

But this *may* not be the right way to fix the problem pointed by d3cb25a12138.

Note that the other usb/gadget/udc drivers do release the lock before calling
these functions. There are also inconsistencies within pch_udc.c, where
`dev->driver->disconnect' is called while holding `&dev->lock' in lines 613 and
1184, but not in line 2739.

Finally, commit d3cb25a12138 may have introduced several potential deadlocks.

For instance, EBA (https://github.com/models-team/eba) reports:

    Double lock in drivers/usb/gadget/udc/pch_udc.c
    first at 2791: spin_lock(& dev->lock); [pch_udc_isr]
    second at 2694: spin_lock(& dev->lock); [pch_udc_svc_cfg_interrupt]
        after calling from 2793: pch_udc_dev_isr(dev, dev_intr);
        after calling from 2724: pch_udc_svc_cfg_interrupt(dev);

Similarly, other potential deadlocks are 2791 -> 2793 -> 2721 -> 2657; and
2791 -> 2793 -> 2711 -> 2573 -> 1499 -> 1480.

Fixes: d3cb25a12138 ("usb: gadget: udc: fix spin_lock in pch_udc")
Signed-off-by: Iago Abal <mail@iagoabal.eu>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/pch_udc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1488,11 +1488,11 @@ static void complete_req(struct pch_udc_
 		req->dma_mapped = 0;
 	}
 	ep->halted = 1;
-	spin_lock(&dev->lock);
+	spin_unlock(&dev->lock);
 	if (!ep->in)
 		pch_udc_ep_clear_rrdy(ep);
 	usb_gadget_giveback_request(&ep->ep, &req->req);
-	spin_unlock(&dev->lock);
+	spin_lock(&dev->lock);
 	ep->halted = halted;
 }
 
@@ -2583,9 +2583,9 @@ static void pch_udc_svc_ur_interrupt(str
 		empty_req_queue(ep);
 	}
 	if (dev->driver) {
-		spin_lock(&dev->lock);
-		usb_gadget_udc_reset(&dev->gadget, dev->driver);
 		spin_unlock(&dev->lock);
+		usb_gadget_udc_reset(&dev->gadget, dev->driver);
+		spin_lock(&dev->lock);
 	}
 }
 
@@ -2664,9 +2664,9 @@ static void pch_udc_svc_intf_interrupt(s
 		dev->ep[i].halted = 0;
 	}
 	dev->stall = 0;
-	spin_lock(&dev->lock);
-	dev->driver->setup(&dev->gadget, &dev->setup_data);
 	spin_unlock(&dev->lock);
+	dev->driver->setup(&dev->gadget, &dev->setup_data);
+	spin_lock(&dev->lock);
 }
 
 /**
@@ -2701,9 +2701,9 @@ static void pch_udc_svc_cfg_interrupt(st
 	dev->stall = 0;
 
 	/* call gadget zero with setup data received */
-	spin_lock(&dev->lock);
-	dev->driver->setup(&dev->gadget, &dev->setup_data);
 	spin_unlock(&dev->lock);
+	dev->driver->setup(&dev->gadget, &dev->setup_data);
+	spin_lock(&dev->lock);
 }
 
 /**


