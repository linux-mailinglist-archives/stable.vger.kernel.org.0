Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B42313BF36
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgAOMJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgAOMJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:09:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828D82077B;
        Wed, 15 Jan 2020 12:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579090184;
        bh=0OrJOTBSq1IRtu+zWHP7Bua/MQzvhxmsKukRzcFoY4s=;
        h=Subject:To:From:Date:From;
        b=x6j/o+JDvPSYwpDauLwo+90u9XVnszjNv4e2B4gqb9Kj2x0hrYJblwmtafKjHOEBr
         x0sBfgjZuyDPjYlvrcCtko6dEsh8CoY8Iwitnf0rAJ9G2jzi3K16DRoYXFw4o1/bOk
         IqgJmccIwLALzfVMnV4dDsLGrHFYjlFaW/WB6f1A=
Subject: patch "usb: gadget: f_ncm: Use atomic_t to track in-flight request" added to usb-next
To:     bryan.odonoghue@linaro.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:08:55 +0100
Message-ID: <1579090135196166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_ncm: Use atomic_t to track in-flight request

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 5b24c28cfe136597dc3913e1c00b119307a20c7e Mon Sep 17 00:00:00 2001
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date: Thu, 9 Jan 2020 13:17:21 +0000
Subject: usb: gadget: f_ncm: Use atomic_t to track in-flight request

Currently ncm->notify_req is used to flag when a request is in-flight.
ncm->notify_req is set to NULL and when a request completes it is
subsequently reset.

This is fundamentally buggy in that the unbind logic of the NCM driver will
unconditionally free ncm->notify_req leading to a NULL pointer dereference.

Fixes: 40d133d7f542 ("usb: gadget: f_ncm: convert to new function interface with backward compatibility")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 2d6e76e4cffa..1d900081b1f0 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -53,6 +53,7 @@ struct f_ncm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
 
 	const struct ndp_parser_opts	*parser_opts;
@@ -547,7 +548,7 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	int				status;
 
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ncm->notify_count))
 		return;
 
 	event = req->buf;
@@ -587,7 +588,8 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	event->bmRequestType = 0xA1;
 	event->wIndex = cpu_to_le16(ncm->ctrl_id);
 
-	ncm->notify_req = NULL;
+	atomic_inc(&ncm->notify_count);
+
 	/*
 	 * In double buffering if there is a space in FIFO,
 	 * completion callback can be called right after the call,
@@ -597,7 +599,7 @@ static void ncm_do_notify(struct f_ncm *ncm)
 	status = usb_ep_queue(ncm->notify, req, GFP_ATOMIC);
 	spin_lock(&ncm->lock);
 	if (status < 0) {
-		ncm->notify_req = req;
+		atomic_dec(&ncm->notify_count);
 		DBG(cdev, "notify --> %d\n", status);
 	}
 }
@@ -632,17 +634,19 @@ static void ncm_notify_complete(struct usb_ep *ep, struct usb_request *req)
 	case 0:
 		VDBG(cdev, "Notification %02x sent\n",
 		     event->bNotificationType);
+		atomic_dec(&ncm->notify_count);
 		break;
 	case -ECONNRESET:
 	case -ESHUTDOWN:
+		atomic_set(&ncm->notify_count, 0);
 		ncm->notify_state = NCM_NOTIFY_NONE;
 		break;
 	default:
 		DBG(cdev, "event %02x --> %d\n",
 			event->bNotificationType, req->status);
+		atomic_dec(&ncm->notify_count);
 		break;
 	}
-	ncm->notify_req = req;
 	ncm_do_notify(ncm);
 	spin_unlock(&ncm->lock);
 }
@@ -1649,6 +1653,11 @@ static void ncm_unbind(struct usb_configuration *c, struct usb_function *f)
 	ncm_string_defs[0].id = 0;
 	usb_free_all_descriptors(f);
 
+	if (atomic_read(&ncm->notify_count)) {
+		usb_ep_dequeue(ncm->notify, ncm->notify_req);
+		atomic_set(&ncm->notify_count, 0);
+	}
+
 	kfree(ncm->notify_req->buf);
 	usb_ep_free_request(ncm->notify, ncm->notify_req);
 }
-- 
2.24.1


