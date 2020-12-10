Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDCC2D6510
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390767AbgLJOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbgLJOdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:33:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Vamsi Krishna Samavedam <vskrishn@codeaurora.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 4.19 03/39] usb: gadget: f_fs: Use local copy of descriptors for userspace copy
Date:   Thu, 10 Dec 2020 15:26:42 +0100
Message-Id: <20201210142602.458518859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>

commit a4b98a7512f18534ce33a7e98e49115af59ffa00 upstream.

The function may be unbound causing the ffs_ep and its descriptors
to be freed while userspace is in the middle of an ioctl requesting
the same descriptors. Avoid dangling pointer reference by first
making a local copy of desctiptors before releasing the spinlock.

Fixes: c559a3534109 ("usb: gadget: f_fs: add ioctl returning ep descriptor")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201130203453.28154-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1243,7 +1243,7 @@ static long ffs_epfile_ioctl(struct file
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
 		int desc_idx;
-		struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1255,10 +1255,12 @@ static long ffs_epfile_ioctl(struct file
 		default:
 			desc_idx = 0;
 		}
+
 		desc = epfile->ep->descs[desc_idx];
+		memcpy(&desc1, desc, desc->bLength);
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);
-		ret = copy_to_user((void __user *)value, desc, desc->bLength);
+		ret = copy_to_user((void __user *)value, &desc1, desc1.bLength);
 		if (ret)
 			ret = -EFAULT;
 		return ret;


