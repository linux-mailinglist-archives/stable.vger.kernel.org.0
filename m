Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0013B3A62D5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhFNLFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234681AbhFNLCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26CC36143A;
        Mon, 14 Jun 2021 10:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667443;
        bh=fJqNwFQZKtb2D/b++FzjAcS0aTJDZRcHfR1c37cWSFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZd+W/Zj0utcWqjQpMlRYcTznUEmBhBoaVnXbwtgriZSVtZuRlvCT0t72O1GruNqV
         3YyCqyl/ixpxZDEcsSft/yzO0/a0WVRhRwrJO0imyzToWA/CKFn19Ol0SL7bAlds92
         dmuyZ4gbHYx98BE0vasttpbrFBKE9zmXkaE6q2Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.10 072/131] usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is NULL
Date:   Mon, 14 Jun 2021 12:27:13 +0200
Message-Id: <20210614102655.482158144@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit 03715ea2e3dbbc56947137ce3b4ac18a726b2f87 upstream.

There exists a possible scenario in which dwc3_gadget_init() can fail:
during during host -> peripheral mode switch in dwc3_set_mode(), and
a pending gadget driver fails to bind.  Then, if the DRD undergoes
another mode switch from peripheral->host the resulting
dwc3_gadget_exit() will attempt to reference an invalid and dangling
dwc->gadget pointer as well as call dma_free_coherent() on unmapped
DMA pointers.

The exact scenario can be reproduced as follows:
 - Start DWC3 in peripheral mode
 - Configure ConfigFS gadget with FunctionFS instance (or use g_ffs)
 - Run FunctionFS userspace application (open EPs, write descriptors, etc)
 - Bind gadget driver to DWC3's UDC
 - Switch DWC3 to host mode
   => dwc3_gadget_exit() is called. usb_del_gadget() will put the
	ConfigFS driver instance on the gadget_driver_pending_list
 - Stop FunctionFS application (closes the ep files)
 - Switch DWC3 to peripheral mode
   => dwc3_gadget_init() fails as usb_add_gadget() calls
	check_pending_gadget_drivers() and attempts to rebind the UDC
	to the ConfigFS gadget but fails with -19 (-ENODEV) because the
	FFS instance is not in FFS_ACTIVE state (userspace has not
	re-opened and written the descriptors yet, i.e. desc_ready!=0).
 - Switch DWC3 back to host mode
   => dwc3_gadget_exit() is called again, but this time dwc->gadget
	is invalid.

Although it can be argued that userspace should take responsibility
for ensuring that the FunctionFS application be ready prior to
allowing the composite driver bind to the UDC, failure to do so
should not result in a panic from the kernel driver.

Fix this by setting dwc->gadget to NULL in the failure path of
dwc3_gadget_init() and add a check to dwc3_gadget_exit() to bail out
unless the gadget pointer is valid.

Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure dynamically")
Cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210528160405.17550-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3936,6 +3936,7 @@ err5:
 	dwc3_gadget_free_endpoints(dwc);
 err4:
 	usb_put_gadget(dwc->gadget);
+	dwc->gadget = NULL;
 err3:
 	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
 			dwc->bounce_addr);
@@ -3955,6 +3956,9 @@ err0:
 
 void dwc3_gadget_exit(struct dwc3 *dwc)
 {
+	if (!dwc->gadget)
+		return;
+
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);


