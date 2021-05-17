Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E838322F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhEQOq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240502AbhEQOnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0587613BA;
        Mon, 17 May 2021 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261223;
        bh=ad0xPnMx0C8ZjLx23sEnIjuqCSEcaTx75owKAoihxnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRnRH93NN/dQY20RNF9VWN/wnLsRiVNzLsyrzc+9flPIpPOSnO0Z4IRAwWxeGN5/e
         kUyNEV08rghyP6ZIx4eDAp9YfHaeWCoyP00VoE9A7Yy0kmZtZ6nYpn/OBrRC+lH+NQ
         EOb9/f3cnxKWdu8Ic3GzOgu+qGJJRWMb8tW9qc5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 321/363] xhci: Do not use GFP_KERNEL in (potentially) atomic context
Date:   Mon, 17 May 2021 16:03:07 +0200
Message-Id: <20210517140313.454804934@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
@@ -1514,7 +1514,7 @@ static int xhci_configure_endpoint(struc
  * we need to issue an evaluate context command and wait on it.
  */
 static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
-		unsigned int ep_index, struct urb *urb)
+		unsigned int ep_index, struct urb *urb, gfp_t mem_flags)
 {
 	struct xhci_container_ctx *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
@@ -1545,7 +1545,7 @@ static int xhci_check_maxpacket(struct x
 		 * changes max packet sizes.
 		 */
 
-		command = xhci_alloc_command(xhci, true, GFP_KERNEL);
+		command = xhci_alloc_command(xhci, true, mem_flags);
 		if (!command)
 			return -ENOMEM;
 
@@ -1639,7 +1639,7 @@ static int xhci_urb_enqueue(struct usb_h
 		 */
 		if (urb->dev->speed == USB_SPEED_FULL) {
 			ret = xhci_check_maxpacket(xhci, slot_id,
-					ep_index, urb);
+					ep_index, urb, mem_flags);
 			if (ret < 0) {
 				xhci_urb_free_priv(urb_priv);
 				urb->hcpriv = NULL;


