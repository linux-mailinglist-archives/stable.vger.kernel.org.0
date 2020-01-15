Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34113BF37
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgAOMJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgAOMJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:09:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E1592077B;
        Wed, 15 Jan 2020 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579090186;
        bh=a6WsApunUGe8/NnRAhqT82loyTnVDnSJkSjO4YtcwZs=;
        h=Subject:To:From:Date:From;
        b=vv1DyQqZvgc8K8XkI9VEc/J5JWOKV7cfzS+Li3fkLyFV1J1kk2aGBMyAnBi9Cc7ZW
         M37xbOKhOelXiu5nHCJi25LLcRuOs7HkWhaN6DY2r8fpCyG98lacerzdCB0h0DHS6H
         JWD6BDMIB6u3YqzNJY3g2TUTLQ0qEzeomiZca5sc=
Subject: patch "usb: gadget: f_ecm: Use atomic_t to track in-flight request" added to usb-next
To:     bryan.odonoghue@linaro.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:08:56 +0100
Message-ID: <157909013627195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_ecm: Use atomic_t to track in-flight request

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From d710562e01c48d59be3f60d58b7a85958b39aeda Mon Sep 17 00:00:00 2001
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date: Thu, 9 Jan 2020 13:17:22 +0000
Subject: usb: gadget: f_ecm: Use atomic_t to track in-flight request

Currently ecm->notify_req is used to flag when a request is in-flight.
ecm->notify_req is set to NULL and when a request completes it is
subsequently reset.

This is fundamentally buggy in that the unbind logic of the ECM driver will
unconditionally free ecm->notify_req leading to a NULL pointer dereference.

Fixes: da741b8c56d6 ("usb ethernet gadget: split CDC Ethernet function")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ecm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ecm.c b/drivers/usb/gadget/function/f_ecm.c
index 460d5d7c984f..7f5cf488b2b1 100644
--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -52,6 +52,7 @@ struct f_ecm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
 
 	/* FIXME is_open needs some irq-ish locking
@@ -380,7 +381,7 @@ static void ecm_do_notify(struct f_ecm *ecm)
 	int				status;
 
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ecm->notify_count))
 		return;
 
 	event = req->buf;
@@ -420,10 +421,10 @@ static void ecm_do_notify(struct f_ecm *ecm)
 	event->bmRequestType = 0xA1;
 	event->wIndex = cpu_to_le16(ecm->ctrl_id);
 
-	ecm->notify_req = NULL;
+	atomic_inc(&ecm->notify_count);
 	status = usb_ep_queue(ecm->notify, req, GFP_ATOMIC);
 	if (status < 0) {
-		ecm->notify_req = req;
+		atomic_dec(&ecm->notify_count);
 		DBG(cdev, "notify --> %d\n", status);
 	}
 }
@@ -448,17 +449,19 @@ static void ecm_notify_complete(struct usb_ep *ep, struct usb_request *req)
 	switch (req->status) {
 	case 0:
 		/* no fault */
+		atomic_dec(&ecm->notify_count);
 		break;
 	case -ECONNRESET:
 	case -ESHUTDOWN:
+		atomic_set(&ecm->notify_count, 0);
 		ecm->notify_state = ECM_NOTIFY_NONE;
 		break;
 	default:
 		DBG(cdev, "event %02x --> %d\n",
 			event->bNotificationType, req->status);
+		atomic_dec(&ecm->notify_count);
 		break;
 	}
-	ecm->notify_req = req;
 	ecm_do_notify(ecm);
 }
 
@@ -907,6 +910,11 @@ static void ecm_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	usb_free_all_descriptors(f);
 
+	if (atomic_read(&ecm->notify_count)) {
+		usb_ep_dequeue(ecm->notify, ecm->notify_req);
+		atomic_set(&ecm->notify_count, 0);
+	}
+
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
 }
-- 
2.24.1


