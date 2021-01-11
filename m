Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FC2F1700
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbhAKN76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbhAKNG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0E362251F;
        Mon, 11 Jan 2021 13:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370347;
        bh=I4sHZ/9+9WaCBncCxa31WvcaN/i3zoWGwQUJX7ocuzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyQPXm1j0uUNWjoZ+Qwvp0PFzrImvR6fKjaC4VrFtFnxJFaClEXkuGNADMjO5abd+
         cykEPCA9SGwm5g3tHGV/6gwvrzEdKfOm+lEi1w+sPBm4o7CxHLMF0lzjc75h6hbji9
         Rm2byuGwF48xZMNIpOsFIA5HSxFH+J+nd7RYbPcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 40/57] USB: usblp: fix DMA to stack
Date:   Mon, 11 Jan 2021 14:01:59 +0100
Message-Id: <20210111130035.657475002@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 020a1f453449294926ca548d8d5ca970926e8dfd upstream.

Stack-allocated buffers cannot be used for DMA (on all architectures).

Replace the HP-channel macro with a helper function that allocates a
dedicated transfer buffer so that it can continue to be used with
arguments from the stack.

Note that the buffer is cleared on allocation as usblp_ctrl_msg()
returns success also on short transfers (the buffer is only used for
debugging).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210104145302.2087-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/usblp.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -289,8 +289,25 @@ static int usblp_ctrl_msg(struct usblp *
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


