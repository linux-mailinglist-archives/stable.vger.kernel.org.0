Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC52C9DCD
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbgLAJ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbgLAJC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3752520809;
        Tue,  1 Dec 2020 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813301;
        bh=7Ue//Zng0WP0KW0pSdTtBSWbvhT1XT/7/kSp4eyX0n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqUJW287jqFODTNx0ozNk0Rd+MCHLIAqkvGULBx7BKnUgysFSa0nbwRkCTg/zfbqz
         OTy/ntzK6W3tdlRNYpTBrOFbiNWKGLaLuN1Lc6bzxFzMOSQZI6c2GPj+rrMTLrtyIc
         AOn98oFh60DhTJqI/mOkXuCe8Zp+rPKhrSAgRJJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamsi Krishna Samavedam <vskrishn@codeaurora.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 50/57] USB: core: Change %pK for __user pointers to %px
Date:   Tue,  1 Dec 2020 09:53:55 +0100
Message-Id: <20201201084651.570228911@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit f3bc432aa8a7a2bfe9ebb432502be5c5d979d7fe upstream.

Commit 2f964780c03b ("USB: core: replace %p with %pK") used the %pK
format specifier for a bunch of __user pointers.  But as the 'K' in
the specifier indicates, it is meant for kernel pointers.  The reason
for the %pK specifier is to avoid leaks of kernel addresses, but when
the pointer is to an address in userspace the security implications
are minimal.  In particular, no kernel information is leaked.

This patch changes the __user %pK specifiers (used in a bunch of
debugging output lines) to %px, which will always print the actual
address with no mangling.  (Notably, there is no printk format
specifier particularly intended for __user pointers.)

Fixes: 2f964780c03b ("USB: core: replace %p with %pK")
CC: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
CC: <stable@vger.kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201119170228.GB576844@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -463,11 +463,11 @@ static void snoop_urb(struct usb_device
 
 	if (userurb) {		/* Async */
 		if (when == SUBMIT)
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %px, ep%d %s-%s, "
 					"length %u\n",
 					userurb, ep, t, d, length);
 		else
-			dev_info(&udev->dev, "userurb %pK, ep%d %s-%s, "
+			dev_info(&udev->dev, "userurb %px, ep%d %s-%s, "
 					"actual_length %u status %d\n",
 					userurb, ep, t, d, length,
 					timeout_or_status);
@@ -1927,7 +1927,7 @@ static int proc_reapurb(struct usb_dev_s
 	if (as) {
 		int retval;
 
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %px\n", as->userurb);
 		retval = processcompl(as, (void __user * __user *)arg);
 		free_async(as);
 		return retval;
@@ -1944,7 +1944,7 @@ static int proc_reapurbnonblock(struct u
 
 	as = async_getcompleted(ps);
 	if (as) {
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %px\n", as->userurb);
 		retval = processcompl(as, (void __user * __user *)arg);
 		free_async(as);
 	} else {
@@ -2070,7 +2070,7 @@ static int proc_reapurb_compat(struct us
 	if (as) {
 		int retval;
 
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %px\n", as->userurb);
 		retval = processcompl_compat(as, (void __user * __user *)arg);
 		free_async(as);
 		return retval;
@@ -2087,7 +2087,7 @@ static int proc_reapurbnonblock_compat(s
 
 	as = async_getcompleted(ps);
 	if (as) {
-		snoop(&ps->dev->dev, "reap %pK\n", as->userurb);
+		snoop(&ps->dev->dev, "reap %px\n", as->userurb);
 		retval = processcompl_compat(as, (void __user * __user *)arg);
 		free_async(as);
 	} else {
@@ -2512,7 +2512,7 @@ static long usbdev_do_ioctl(struct file
 #endif
 
 	case USBDEVFS_DISCARDURB:
-		snoop(&dev->dev, "%s: DISCARDURB %pK\n", __func__, p);
+		snoop(&dev->dev, "%s: DISCARDURB %px\n", __func__, p);
 		ret = proc_unlinkurb(ps, p);
 		break;
 


