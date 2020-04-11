Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59CA1A51AE
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgDKMOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgDKMOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B25720644;
        Sat, 11 Apr 2020 12:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607271;
        bh=g0AI+qd0PMmNWavP2xzjQz+yCS9cmy1QGCIW6c4d1hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtWsPrveakQidoP3vW4Wyj6XEBZcja+IeXXdgIrQtIWa6xXudJH3Nlr56wf+XIz/T
         ORTDtv5Asplk2Tng0PIAzGmfEhGKo5RqvI/EA9QLkD+pHZ7vFj+0GP8aEC2eLdlHOL
         M1JC2RxGZ4LOayCz0bBKBaIGwkPRz6AcOWdrac1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 37/38] usb: dwc3: dont set gadget->is_otg flag
Date:   Sat, 11 Apr 2020 14:09:21 +0200
Message-Id: <20200411115441.360417768@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit c09b73cfac2a9317f1104169045c519c6021aa1d upstream.

This reverts
commit 6a4290cc28be1 ("usb: dwc3: gadget: set the OTG flag in dwc3 gadget driver.")

We don't yet support any of the OTG mechanisms (HNP/SRP/ADP)
and are not setting gadget->otg_caps, so don't set gadget->is_otg
flag.

If we do then we end up publishing a OTG1.0 descriptor in
the gadget descriptor which causes device enumeration to fail
if we are connected to a host with CONFIG_USB_OTG enabled.

Host side log without this patch

[   96.720453] usb 1-1: new high-speed USB device number 2 using xhci-hcd
[   96.901391] usb 1-1: Dual-Role OTG device on non-HNP port
[   96.907552] usb 1-1: set a_alt_hnp_support failed: -32
[   97.060447] usb 1-1: new high-speed USB device number 3 using xhci-hcd
[   97.241378] usb 1-1: Dual-Role OTG device on non-HNP port
[   97.247536] usb 1-1: set a_alt_hnp_support failed: -32
[   97.253606] usb usb1-port1: attempt power cycle
[   97.960449] usb 1-1: new high-speed USB device number 4 using xhci-hcd
[   98.141383] usb 1-1: Dual-Role OTG device on non-HNP port
[   98.147540] usb 1-1: set a_alt_hnp_support failed: -32
[   98.300453] usb 1-1: new high-speed USB device number 5 using xhci-hcd
[   98.481391] usb 1-1: Dual-Role OTG device on non-HNP port
[   98.487545] usb 1-1: set a_alt_hnp_support failed: -32
[   98.493532] usb usb1-port1: unable to enumerate USB device

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3257,7 +3257,6 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.speed		= USB_SPEED_UNKNOWN;
 	dwc->gadget.sg_supported	= true;
 	dwc->gadget.name		= "dwc3-gadget";
-	dwc->gadget.is_otg		= dwc->dr_mode == USB_DR_MODE_OTG;
 
 	/*
 	 * FIXME We might be setting max_speed to <SUPER, however versions


