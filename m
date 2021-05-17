Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1228D3835A6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242650AbhEQPXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242836AbhEQPQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EB56186A;
        Mon, 17 May 2021 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261976;
        bh=cePfU9NcGXdJAeLEHSy5JpFozNTh5JcfXlp8E8gVRK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtyFSAs0Jqwbs5LHned5OwFrccwsZ+vWtZLV+AFW4s67tPoJsHe2oB8wWK7VbZ5wz
         g3F9ZZeIUOTI1VXBdZAN2Fv+9qif8V5CbkIOen8IYkQxGtgSl1TnO1Mz2DMZxnWYW2
         p3GdIWKfBohkBodRN7cmFJacA/jvuTaRv3QlwjNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 119/141] xhci: Do not use GFP_KERNEL in (potentially) atomic context
Date:   Mon, 17 May 2021 16:02:51 +0200
Message-Id: <20210517140246.801184391@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit dda32c00c9a0fa103b5d54ef72c477b7aa993679 upstream.

'xhci_urb_enqueue()' is passed a 'mem_flags' argument, because "URBs may be
submitted in interrupt context" (see comment related to 'usb_submit_urb()'
in 'drivers/usb/core/urb.c')

So this flag should be used in all the calling chain.
Up to now, 'xhci_check_maxpacket()' which is only called from
'xhci_urb_enqueue()', uses GFP_KERNEL.

Be safe and pass the mem_flags to this function as well.

Fixes: ddba5cd0aeff ("xhci: Use command structures when queuing commands on the command ring")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1397,7 +1397,7 @@ static int xhci_configure_endpoint(struc
  * we need to issue an evaluate context command and wait on it.
  */
 static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
-		unsigned int ep_index, struct urb *urb)
+		unsigned int ep_index, struct urb *urb, gfp_t mem_flags)
 {
 	struct xhci_container_ctx *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
@@ -1428,7 +1428,7 @@ static int xhci_check_maxpacket(struct x
 		 * changes max packet sizes.
 		 */
 
-		command = xhci_alloc_command(xhci, true, GFP_KERNEL);
+		command = xhci_alloc_command(xhci, true, mem_flags);
 		if (!command)
 			return -ENOMEM;
 
@@ -1524,7 +1524,7 @@ static int xhci_urb_enqueue(struct usb_h
 		 */
 		if (urb->dev->speed == USB_SPEED_FULL) {
 			ret = xhci_check_maxpacket(xhci, slot_id,
-					ep_index, urb);
+					ep_index, urb, mem_flags);
 			if (ret < 0) {
 				xhci_urb_free_priv(urb_priv);
 				urb->hcpriv = NULL;


