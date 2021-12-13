Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CF04726D2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhLMJyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbhLMJwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56C4C08ED44;
        Mon, 13 Dec 2021 01:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1BF2CE0E92;
        Mon, 13 Dec 2021 09:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB998C341C5;
        Mon, 13 Dec 2021 09:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388690;
        bh=4uPiRgK/xUd8FgJRZ/tsgwgQSusJRgc9k74qr/IdZDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFk5QndzHJR4asjzIeAoB+U7V92PilUjwXbrTQKK2AkyaYKB5ThkrmU7SK77hB3BO
         7YTNTXRYlrnTXDqsP3AfzZt2Om5cvcTN2fLEvwv+Ranu+C4yVtwL19C0N6k4HacnbM
         8q3NCPg4pywwj4PdUv1/lj4+w2X0Mxgu90opchAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 5.4 64/88] USB: gadget: detect too-big endpoint 0 requests
Date:   Mon, 13 Dec 2021 10:30:34 +0100
Message-Id: <20211213092935.473756792@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -1648,6 +1648,18 @@ composite_setup(struct usb_gadget *gadge
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
@@ -1333,6 +1335,18 @@ gadgetfs_setup (struct usb_gadget *gadge
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


