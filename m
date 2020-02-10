Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF9E1574F5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgBJMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgBJMhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:17 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E428220842;
        Mon, 10 Feb 2020 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338237;
        bh=rv+mI0w3hDpCkcgcs2ovUWMg5x7dJNDtrZDs+5eGnoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pb07SYIiHyWbDWMeches2qazgMCsXd2dk3oD513uphz0FCLM1MZIGsfxgJtfgk9X0
         oMoGl56LXHsrckaM3YsHUn93Neq0/AvPhyyYIrCmymQgNPscPEoANcRXypN/bSLmIg
         ZC0WZoESWzBQhLJURRoW6BGs3XPoeqXFIazfjcVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 044/309] usb: gadget: f_ecm: Use atomic_t to track in-flight request
Date:   Mon, 10 Feb 2020 04:30:00 -0800
Message-Id: <20200210122410.292898571@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit d710562e01c48d59be3f60d58b7a85958b39aeda upstream.

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
 drivers/usb/gadget/function/f_ecm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -52,6 +52,7 @@ struct f_ecm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
 
 	/* FIXME is_open needs some irq-ish locking
@@ -380,7 +381,7 @@ static void ecm_do_notify(struct f_ecm *
 	int				status;
 
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ecm->notify_count))
 		return;
 
 	event = req->buf;
@@ -420,10 +421,10 @@ static void ecm_do_notify(struct f_ecm *
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
@@ -448,17 +449,19 @@ static void ecm_notify_complete(struct u
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
 
@@ -907,6 +910,11 @@ static void ecm_unbind(struct usb_config
 
 	usb_free_all_descriptors(f);
 
+	if (atomic_read(&ecm->notify_count)) {
+		usb_ep_dequeue(ecm->notify, ecm->notify_req);
+		atomic_set(&ecm->notify_count, 0);
+	}
+
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
 }


