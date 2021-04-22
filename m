Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7E367CF4
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhDVIyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 04:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235449AbhDVIyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 04:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 836F961417;
        Thu, 22 Apr 2021 08:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619081626;
        bh=OXGSZkGQaVtRi11ADXV2ibSePfGAAh6remT7Bk+POvI=;
        h=Subject:To:From:Date:From;
        b=p/oK3CnMGCyXSW2gxfQZkR2lAhi+z7g6CN6olW2pfgxrNJ1+z9mG2qhrV+nlVqinp
         KicHNYLs60A1NhRSgdcjSfoEy6Jja5INKu3NLE615EEAgOwjihwgCpK2hKFX8WmTOZ
         rLKwI94gIrO94ZAhRTOQSGW+cIIASdZNqjhA5bQw=
Subject: patch "USB: CDC-ACM: fix poison/unpoison imbalance" added to usb-testing
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Apr 2021 10:53:29 +0200
Message-ID: <1619081609114113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: CDC-ACM: fix poison/unpoison imbalance

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a8b3b519618f30a87a304c4e120267ce6f8dc68a Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 21 Apr 2021 09:45:13 +0200
Subject: USB: CDC-ACM: fix poison/unpoison imbalance

suspend() does its poisoning conditionally, resume() does it
unconditionally. On a device with combined interfaces this
will balance, on a device with two interfaces the counter will
go negative and resubmission will fail.

Both actions need to be done conditionally.

Fixes: 6069e3e927c8f ("USB: cdc-acm: untangle a circular dependency between callback and softint")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210421074513.4327-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b74713518b3a..c103961c3fae 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1624,12 +1624,13 @@ static int acm_resume(struct usb_interface *intf)
 	struct urb *urb;
 	int rv = 0;
 
-	acm_unpoison_urbs(acm);
 	spin_lock_irq(&acm->write_lock);
 
 	if (--acm->susp_count)
 		goto out;
 
+	acm_unpoison_urbs(acm);
+
 	if (tty_port_initialized(&acm->port)) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_ATOMIC);
 
-- 
2.31.1


