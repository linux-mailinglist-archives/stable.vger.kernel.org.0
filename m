Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496DA1C155F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgEAN0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgEAN0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:26:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E408820757;
        Fri,  1 May 2020 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339571;
        bh=XbN+XK43HYEmFbefRCu63/+LCwj5Fxct5UImYlR+yoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJo4dto57S1c2D4EFMgSZx3607pELUGLnzaBhLc3XBhx1AniO/iGlbUZ9pzyAMxdS
         L8TUBECIOLL97g2RJTbZ21N1ao6TQ1q3T6c7lRtXLwvJfj4Vq7yPZBOOxUUOVZlC3O
         IJozssyHh2vgRbj4wOy05jKqgZJKdjkxGnVMGz/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Mosberger <davidm@egauge.net>
Subject: [PATCH 4.4 32/70] drivers: usb: core: Dont disable irqs in usb_sg_wait() during URB submit.
Date:   Fri,  1 May 2020 15:21:20 +0200
Message-Id: <20200501131524.259332967@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Mosberger <davidm@egauge.net>

commit 98b74b0ee57af1bcb6e8b2e76e707a71c5ef8ec9 upstream.

usb_submit_urb() may take quite long to execute.  For example, a
single sg list may have 30 or more entries, possibly leading to that
many calls to DMA-map pages.  This can cause interrupt latency of
several hundred micro-seconds.

Avoid the problem by releasing the io->lock spinlock and re-enabling
interrupts before calling usb_submit_urb().  This opens races with
usb_sg_cancel() and sg_complete().  Handle those races by using
usb_block_urb() to stop URBs from being submitted after
usb_sg_cancel() or sg_complete() with error.

Note that usb_unlink_urb() is guaranteed to return -ENODEV if
!io->urbs[i]->dev and since the -ENODEV case is already handled,
we don't have to check for !io->urbs[i]->dev explicitly.

Before this change, reading 512MB from an ext3 filesystem on a USB
memory stick showed a throughput of 12 MB/s with about 500 missed
deadlines.

With this change, reading the same file gave the same throughput but
only one or two missed deadlines.

Signed-off-by: David Mosberger <davidm@egauge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/message.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -306,9 +306,10 @@ static void sg_complete(struct urb *urb)
 		 */
 		spin_unlock(&io->lock);
 		for (i = 0, found = 0; i < io->entries; i++) {
-			if (!io->urbs[i] || !io->urbs[i]->dev)
+			if (!io->urbs[i])
 				continue;
 			if (found) {
+				usb_block_urb(io->urbs[i]);
 				retval = usb_unlink_urb(io->urbs[i]);
 				if (retval != -EINPROGRESS &&
 				    retval != -ENODEV &&
@@ -519,12 +520,10 @@ void usb_sg_wait(struct usb_sg_request *
 		int retval;
 
 		io->urbs[i]->dev = io->dev;
-		retval = usb_submit_urb(io->urbs[i], GFP_ATOMIC);
-
-		/* after we submit, let completions or cancellations fire;
-		 * we handshake using io->status.
-		 */
 		spin_unlock_irq(&io->lock);
+
+		retval = usb_submit_urb(io->urbs[i], GFP_NOIO);
+
 		switch (retval) {
 			/* maybe we retrying will recover */
 		case -ENXIO:	/* hc didn't queue this one */
@@ -594,8 +593,8 @@ void usb_sg_cancel(struct usb_sg_request
 		for (i = 0; i < io->entries; i++) {
 			int retval;
 
-			if (!io->urbs[i]->dev)
-				continue;
+			usb_block_urb(io->urbs[i]);
+
 			retval = usb_unlink_urb(io->urbs[i]);
 			if (retval != -EINPROGRESS
 					&& retval != -ENODEV


