Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F393215C78D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgBMPWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgBMPWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:20 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA78B24689;
        Thu, 13 Feb 2020 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607339;
        bh=QKirvJTzadsxJZgIjuS6fjr99EEqwS1P5FAtPV2A0xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5Fu4s0Q/xHaAcd+4pi+swccxCzw/q1HysXMhgHjnSCWYYOniMB+ltuoqoaP1xkns
         dhUMiWIhEKJufLgQcDeBnokucXgQWSbKLag1+kg2FDOSWDK+pmp717suEiz63kPTOW
         W5TXEmnfyfwgtBLoAu5oDIKqIB3Dvl8LoVujaT4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.4 14/91] usb: gadget: f_ncm: Use atomic_t to track in-flight request
Date:   Thu, 13 Feb 2020 07:19:31 -0800
Message-Id: <20200213151827.237022864@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 5b24c28cfe136597dc3913e1c00b119307a20c7e upstream.

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
 drivers/usb/gadget/function/f_ncm.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -57,6 +57,7 @@ struct f_ncm {
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
+	atomic_t			notify_count;
 	bool				is_open;
 
 	const struct ndp_parser_opts	*parser_opts;
@@ -480,7 +481,7 @@ static void ncm_do_notify(struct f_ncm *
 	int				status;
 
 	/* notification already in flight? */
-	if (!req)
+	if (atomic_read(&ncm->notify_count))
 		return;
 
 	event = req->buf;
@@ -520,7 +521,8 @@ static void ncm_do_notify(struct f_ncm *
 	event->bmRequestType = 0xA1;
 	event->wIndex = cpu_to_le16(ncm->ctrl_id);
 
-	ncm->notify_req = NULL;
+	atomic_inc(&ncm->notify_count);
+
 	/*
 	 * In double buffering if there is a space in FIFO,
 	 * completion callback can be called right after the call,
@@ -530,7 +532,7 @@ static void ncm_do_notify(struct f_ncm *
 	status = usb_ep_queue(ncm->notify, req, GFP_ATOMIC);
 	spin_lock(&ncm->lock);
 	if (status < 0) {
-		ncm->notify_req = req;
+		atomic_dec(&ncm->notify_count);
 		DBG(cdev, "notify --> %d\n", status);
 	}
 }
@@ -565,17 +567,19 @@ static void ncm_notify_complete(struct u
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
@@ -1559,6 +1563,11 @@ static void ncm_unbind(struct usb_config
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


