Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3BB21AFD9
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 09:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGJHBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 03:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgGJHBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 03:01:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47A6E206A5;
        Fri, 10 Jul 2020 07:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594364502;
        bh=xnLUssy9nSvnX1b512SiqYrOcxXLTVOCfl3SjV2P6YY=;
        h=Subject:To:From:Date:From;
        b=TWXwBXc78RpgF2tqWyIrwTyhDMsBGsbCU3O5Rz3S0eXDw2IXT2LTx9majy9JL2iKa
         ZHQta2zGSwtpMfPqwMu7DyJmaBA58EExvN60+goc/nfeihKECkpTh/1ip1jbbgQ3XK
         vkjUJWQM61fz1F139QQyo5rCBX5yjkWUhyiaqT3s=
Subject: patch "USB: c67x00: fix use after free in c67x00_giveback_urb" added to usb-linus
To:     trix@redhat.com, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jul 2020 09:01:47 +0200
Message-ID: <159436450728183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: c67x00: fix use after free in c67x00_giveback_urb

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 211f08347355cba1f769bbf3355816a12b3ddd55 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Wed, 8 Jul 2020 06:12:43 -0700
Subject: USB: c67x00: fix use after free in c67x00_giveback_urb

clang static analysis flags this error

c67x00-sched.c:489:55: warning: Use of memory after it is freed [unix.Malloc]
        usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);
                                                             ^~~~~~~~~~~~
Problem happens in this block of code

	c67x00_release_urb(c67x00, urb);
	usb_hcd_unlink_urb_from_ep(c67x00_hcd_to_hcd(c67x00), urb);
	spin_unlock(&c67x00->lock);
	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);

In the call to c67x00_release_urb has this freeing of urbp

	urbp = urb->hcpriv;
	urb->hcpriv = NULL;
	list_del(&urbp->hep_node);
	kfree(urbp);

And so urbp is freed before usb_hcd_giveback_urb uses it as its 3rd
parameter.

Since all is required is the status, pass the status directly as is
done in c64x00_urb_dequeue

Fixes: e9b29ffc519b ("USB: add Cypress c67x00 OTG controller HCD driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200708131243.24336-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/c67x00/c67x00-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index 633c52de3bb3..9865750bc31e 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -486,7 +486,7 @@ c67x00_giveback_urb(struct c67x00_hcd *c67x00, struct urb *urb, int status)
 	c67x00_release_urb(c67x00, urb);
 	usb_hcd_unlink_urb_from_ep(c67x00_hcd_to_hcd(c67x00), urb);
 	spin_unlock(&c67x00->lock);
-	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, urbp->status);
+	usb_hcd_giveback_urb(c67x00_hcd_to_hcd(c67x00), urb, status);
 	spin_lock(&c67x00->lock);
 }
 
-- 
2.27.0


