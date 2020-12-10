Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0165D2D6270
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391082AbgLJOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391077AbgLJOhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:20 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Vamsi Krishna Samavedam <vskrishn@codeaurora.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.9 01/75] usb: gadget: f_fs: Use local copy of descriptors for userspace copy
Date:   Thu, 10 Dec 2020 15:26:26 +0100
Message-Id: <20201210142606.143549022@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -1324,7 +1324,7 @@ static long ffs_epfile_ioctl(struct file
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
 		int desc_idx;
-		struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1336,10 +1336,12 @@ static long ffs_epfile_ioctl(struct file
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


