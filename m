Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CDE137F80
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbgAKKU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgAKKU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:26 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DABC205F4;
        Sat, 11 Jan 2020 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738025;
        bh=W+sKJaj7dhNZNE8kx03VWm50nT0eOXV4jWWj0vm9+18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsjEv2sI1K1sUx5MbMAy2zEejWIR8HVqQz8iZPBgF9KetkvMNitpyChm+fC3o1ic0
         11ZwPhQNCqMSST1IxW7Do+lQRTanNlZhg8Mg9zvPeMAcxP3XwAAHS+L9u/9p0UfxU+
         VbIuJhds7ltlu0A1+RgZkoDuEroxDm8qV93JjC1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 5.4 001/165] USB: dummy-hcd: use usb_urb_dir_in instead of usb_pipein
Date:   Sat, 11 Jan 2020 10:48:40 +0100
Message-Id: <20200111094921.447775542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit 6dabeb891c001c592645df2f477fed9f5d959987 upstream.

Commit fea3409112a9 ("USB: add direction bit to urb->transfer_flags") has
added a usb_urb_dir_in() helper function that can be used to determine
the direction of the URB. With that patch USB_DIR_IN control requests with
wLength == 0 are considered out requests by real USB HCDs. This patch
changes dummy-hcd to use the usb_urb_dir_in() helper to match that
behavior.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/4ae9e68ebca02f08a93ac61fe065057c9a01f0a8.1571667489.git.andreyknvl@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1321,7 +1321,7 @@ static int dummy_perform_transfer(struct
 	u32 this_sg;
 	bool next_sg;
 
-	to_host = usb_pipein(urb->pipe);
+	to_host = usb_urb_dir_in(urb);
 	rbuf = req->req.buf + req->req.actual;
 
 	if (!urb->num_sgs) {
@@ -1409,7 +1409,7 @@ top:
 
 		/* FIXME update emulated data toggle too */
 
-		to_host = usb_pipein(urb->pipe);
+		to_host = usb_urb_dir_in(urb);
 		if (unlikely(len == 0))
 			is_short = 1;
 		else {
@@ -1830,7 +1830,7 @@ restart:
 
 		/* find the gadget's ep for this request (if configured) */
 		address = usb_pipeendpoint (urb->pipe);
-		if (usb_pipein(urb->pipe))
+		if (usb_urb_dir_in(urb))
 			address |= USB_DIR_IN;
 		ep = find_endpoint(dum, address);
 		if (!ep) {
@@ -2385,7 +2385,7 @@ static inline ssize_t show_urb(char *buf
 			s = "?";
 			break;
 		 } s; }),
-		ep, ep ? (usb_pipein(urb->pipe) ? "in" : "out") : "",
+		ep, ep ? (usb_urb_dir_in(urb) ? "in" : "out") : "",
 		({ char *s; \
 		switch (usb_pipetype(urb->pipe)) { \
 		case PIPE_CONTROL: \


