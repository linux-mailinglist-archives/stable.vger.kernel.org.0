Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF28C2E97B3
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbhADOxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhADOxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8893B2076D;
        Mon,  4 Jan 2021 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609771991;
        bh=J+3vsxzw9vXTfriidHRxRTH6/fVGpXe4m4jfb5Ltbx4=;
        h=From:To:Cc:Subject:Date:From;
        b=MWpaEk6mFeku11oDrBQxQZJJtPsTRy0uGKqjRG14b1Nqc8TJ+FEtR80ofSIjS3UND
         htXPNxIuZze2KGDFD4cSDzWaNt3ftnJRvuiP2yMHBBBiM6teiQovsIQaDAo2QTKCIh
         q6cf2AwrCMS1+hc4t1cSjjRs/hDbUQr7yccFatF8TXmql6ozZ+1I4f/40dIFH+hgqe
         UR3KtmrBk3iB02glQakhz/T88YIt4OCiHvHzA43ceKM1uBZ+78UqYTFWpDzU0uJdxW
         udVNQH+xNDnOWnM/kfm4krbbkaNvu6JQD4fTFLCZA0wQF+jbT4LVaLtZg0K0F+dYVi
         xZq6BnveTBWZw==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwREL-0000YP-31; Mon, 04 Jan 2021 15:53:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pete Zaitcev <zaitcev@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: usblp: fix DMA to stack
Date:   Mon,  4 Jan 2021 15:53:02 +0100
Message-Id: <20210104145302.2087-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stack-allocated buffers cannot be used for DMA (on all architectures).

Replace the HP-channel macro with a helper function that allocates a
dedicated transfer buffer so that it can continue to be used with
arguments from the stack.

Note that the buffer is cleared on allocation as usblp_ctrl_msg()
returns success also on short transfers (the buffer is only used for
debugging).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/usblp.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 67cbd42421be..134dc2005ce9 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -274,8 +274,25 @@ static int usblp_ctrl_msg(struct usblp *usblp, int request, int type, int dir, i
 #define usblp_reset(usblp)\
 	usblp_ctrl_msg(usblp, USBLP_REQ_RESET, USB_TYPE_CLASS, USB_DIR_OUT, USB_RECIP_OTHER, 0, NULL, 0)
 
-#define usblp_hp_channel_change_request(usblp, channel, buffer) \
-	usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST, USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE, channel, buffer, 1)
+static int usblp_hp_channel_change_request(struct usblp *usblp, int channel, u8 *new_channel)
+{
+	u8 *buf;
+	int ret;
+
+	buf = kzalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST,
+			USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE,
+			channel, buf, 1);
+	if (ret == 0)
+		*new_channel = buf[0];
+
+	kfree(buf);
+
+	return ret;
+}
 
 /*
  * See the description for usblp_select_alts() below for the usage
-- 
2.26.2

