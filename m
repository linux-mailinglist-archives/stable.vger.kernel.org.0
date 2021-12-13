Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944424727D2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhLMKFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47700 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbhLMKBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:01:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A6DFB80EA5;
        Mon, 13 Dec 2021 10:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A87CC34600;
        Mon, 13 Dec 2021 10:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389707;
        bh=ZcPJYj7wKB2nIkeBncqyr8Db9prxnEUkUTpkW6uENWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vq9GLgXxUUN+dvi6BUT/+7yaiUQ1S09vsfC0JTJPfwufCkLgM/2N7yNSyV5rve/vu
         eICHlcL/q7/FY+96ePDvU0U/tO/k/Wv3f4wppQSVzu2Nw4e+IRRW9xlKx3HiLmBpXf
         Ja3sA0BpDO2HwSkDRpm8iXcZsRQqOoz5DHa1RwLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 5.15 136/171] USB: gadget: detect too-big endpoint 0 requests
Date:   Mon, 13 Dec 2021 10:30:51 +0100
Message-Id: <20211213092949.620916465@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 153a2d7e3350cc89d406ba2d35be8793a64c2038 upstream.

Sometimes USB hosts can ask for buffers that are too large from endpoint
0, which should not be allowed.  If this happens for OUT requests, stall
the endpoint, but for IN requests, trim the request size to the endpoint
buffer size.

Co-developed-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c    |   12 ++++++++++++
 drivers/usb/gadget/legacy/dbgp.c  |   13 +++++++++++++
 drivers/usb/gadget/legacy/inode.c |   16 +++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1679,6 +1679,18 @@ composite_setup(struct usb_gadget *gadge
 	struct usb_function		*f = NULL;
 	u8				endp;
 
+	if (w_length > USB_COMP_EP0_BUFSIZ) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			goto done;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(USB_COMP_EP0_BUFSIZ);
+			w_length = USB_COMP_EP0_BUFSIZ;
+		}
+	}
+
 	/* partial re-init of the response message; the function or the
 	 * gadget might need to intercept e.g. a control-OUT completion
 	 * when we delegate to it.
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -345,6 +345,19 @@ static int dbgp_setup(struct usb_gadget
 	void *data = NULL;
 	u16 len = 0;
 
+	if (length > DBGP_REQ_LEN) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			return err;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(DBGP_REQ_LEN);
+			length = DBGP_REQ_LEN;
+		}
+	}
+
+
 	if (request == USB_REQ_GET_DESCRIPTOR) {
 		switch (value>>8) {
 		case USB_DT_DEVICE:
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -110,6 +110,8 @@ enum ep0_state {
 /* enough for the whole queue: most events invalidate others */
 #define	N_EVENT			5
 
+#define RBUF_SIZE		256
+
 struct dev_data {
 	spinlock_t			lock;
 	refcount_t			count;
@@ -144,7 +146,7 @@ struct dev_data {
 	struct dentry			*dentry;
 
 	/* except this scratch i/o buffer for ep0 */
-	u8				rbuf [256];
+	u8				rbuf[RBUF_SIZE];
 };
 
 static inline void get_dev (struct dev_data *data)
@@ -1334,6 +1336,18 @@ gadgetfs_setup (struct usb_gadget *gadge
 	u16				w_value = le16_to_cpu(ctrl->wValue);
 	u16				w_length = le16_to_cpu(ctrl->wLength);
 
+	if (w_length > RBUF_SIZE) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			return value;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(RBUF_SIZE);
+			w_length = RBUF_SIZE;
+		}
+	}
+
 	spin_lock (&dev->lock);
 	dev->setup_abort = 0;
 	if (dev->state == STATE_DEV_UNCONNECTED) {


