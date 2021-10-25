Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A697439027
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhJYHRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhJYHRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 03:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 051496008E;
        Mon, 25 Oct 2021 07:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635146085;
        bh=xatxAxmQbaFByHaItu/INuiVZD/K29i/ZedNF2qifTU=;
        h=Subject:To:From:Date:From;
        b=fUwUAAkx3kAHpx7jHcMntEoUoM73S/Caqb/mFZesKU+PLzB2HrVul0bqdxNktZKF3
         YYch3t58ZOrhpQ++UTZJgT1SR/2obym/YgtUH873L/8O7LxJUv65eq5C6cJPCsZvZp
         KIB//NxN+JistJ7xhN8pRQ6zThRuNtVn9PGL6DOM=
Subject: patch "usb: musb: Balance list entry in musb_gadget_queue" added to usb-next
To:     viraj.shah@linutronix.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Oct 2021 09:14:39 +0200
Message-ID: <1635146079222108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: musb: Balance list entry in musb_gadget_queue

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 21b5fcdccb32ff09b6b63d4a83c037150665a83f Mon Sep 17 00:00:00 2001
From: Viraj Shah <viraj.shah@linutronix.de>
Date: Thu, 21 Oct 2021 11:36:44 +0200
Subject: usb: musb: Balance list entry in musb_gadget_queue

musb_gadget_queue() adds the passed request to musb_ep::req_list. If the
endpoint is idle and it is the first request then it invokes
musb_queue_resume_work(). If the function returns an error then the
error is passed to the caller without any clean-up and the request
remains enqueued on the list. If the caller enqueues the request again
then the list corrupts.

Remove the request from the list on error.

Fixes: ea2f35c01d5ea ("usb: musb: Fix sleeping function called from invalid context for hdrc glue")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Viraj Shah <viraj.shah@linutronix.de>
Link: https://lore.kernel.org/r/20211021093644.4734-1-viraj.shah@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 98c0f4c1bffd..51274b87f46c 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1247,9 +1247,11 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
 		status = musb_queue_resume_work(musb,
 						musb_ep_restart_resume_work,
 						request);
-		if (status < 0)
+		if (status < 0) {
 			dev_err(musb->controller, "%s resume work: %i\n",
 				__func__, status);
+			list_del(&request->list);
+		}
 	}
 
 unlock:
-- 
2.33.1


