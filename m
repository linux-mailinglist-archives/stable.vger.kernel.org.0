Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF70537F828
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhEMMtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233916AbhEMMtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 08:49:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D064E61154;
        Thu, 13 May 2021 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620910091;
        bh=uogLCFACGA5TeCjmBo2dMvezPd7zwW1lPvbfzEGhf68=;
        h=Subject:To:From:Date:From;
        b=GMjkPXvpw0iQnHOHUjDb38u6B2o1eda8Kgy83sqiquIFG3srCb+LLaQ6R1tjYF2SM
         +qB4/4LVfocDO35lwGwbAhAks2AijR/x+T4kvdqUltk8X6DWI6Gf4Dx1EaIeuUgRwa
         jO1mdjMSbOOWLt7r8M8UEAh2SDvYzSF3yJ+imkXc=
Subject: patch "xhci: Do not use GFP_KERNEL in (potentially) atomic context" added to usb-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 14:47:55 +0200
Message-ID: <16209100758595@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Do not use GFP_KERNEL in (potentially) atomic context

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dda32c00c9a0fa103b5d54ef72c477b7aa993679 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 12 May 2021 11:08:14 +0300
Subject: xhci: Do not use GFP_KERNEL in (potentially) atomic context

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
 drivers/usb/host/xhci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index ca9385d22f68..27283654ca08 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1514,7 +1514,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
  * we need to issue an evaluate context command and wait on it.
  */
 static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
-		unsigned int ep_index, struct urb *urb)
+		unsigned int ep_index, struct urb *urb, gfp_t mem_flags)
 {
 	struct xhci_container_ctx *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
@@ -1545,7 +1545,7 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		 * changes max packet sizes.
 		 */
 
-		command = xhci_alloc_command(xhci, true, GFP_KERNEL);
+		command = xhci_alloc_command(xhci, true, mem_flags);
 		if (!command)
 			return -ENOMEM;
 
@@ -1639,7 +1639,7 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 		 */
 		if (urb->dev->speed == USB_SPEED_FULL) {
 			ret = xhci_check_maxpacket(xhci, slot_id,
-					ep_index, urb);
+					ep_index, urb, mem_flags);
 			if (ret < 0) {
 				xhci_urb_free_priv(urb_priv);
 				urb->hcpriv = NULL;
-- 
2.31.1


