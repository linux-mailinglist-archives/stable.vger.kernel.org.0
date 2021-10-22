Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB26437487
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhJVJQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 05:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhJVJQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 05:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19960610CF;
        Fri, 22 Oct 2021 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634894077;
        bh=SgyTpbHmSdcBS+F2zpLvh+Bqsn/VulTNRDwsAlQA5OY=;
        h=Subject:To:From:Date:From;
        b=ucVkhkK3c9MIn9ZdcuvXp/001qHXfk4gFjk+uzzT+FKxdnhJLvwlBmh0c9j0h0IwY
         gpZaSLlmHC79QsDs+bO2FRzZR+Clal2JGqwkO49kSF3jueW4JJueUErx3vdq6jx+cS
         Mjo2RKNpStGKj6KOSGZ1gsPTvH0WJsxwzwwrT0cA=
Subject: patch "usb: musb: Balance list entry in musb_gadget_queue" added to usb-testing
To:     viraj.shah@linutronix.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Oct 2021 11:14:33 +0200
Message-ID: <16348940738960@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

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


