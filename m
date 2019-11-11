Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C962F7F07
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKKTHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbfKKShy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5BA2190F;
        Mon, 11 Nov 2019 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497472;
        bh=2ygbkTHE3K7gbiAlBub3WN3pgJ4Tnybqo6Luz2tlZyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2dVUBbfoUojt9TZWpEABoAbbYzjpr+gQs9xoLsXLT7QmGwHExfqT5SPX78tDcO53
         fdnWBYV4rx8vP0/6jv7ZN5g7hn5gbXkRBbMdDihF++g2CWIb5B8FAsHLFbSTqj30Zr
         s4yDpS8tc7kAC+8rqVUWuuXRmFY66X1uA4SfMhl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 4.14 066/105] usbip: stub_rx: fix static checker warning on unnecessary checks
Date:   Mon, 11 Nov 2019 19:28:36 +0100
Message-Id: <20191111181445.374314522@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <shuahkh@osg.samsung.com>

commit 10c90120930628e8b959bf58d4a0aaef3ae5d945 upstream.

Fix the following static checker warnings:

The patch c6688ef9f297: "usbip: fix stub_rx: harden CMD_SUBMIT path
to handle malicious input" from Dec 7, 2017, leads to the following
static checker warning:

    drivers/usb/usbip/stub_rx.c:346 get_pipe()
    warn: impossible condition
'(pdu->u.cmd_submit.transfer_buffer_length > ((~0 >> 1))) =>
(s32min-s32max > s32max)'
    drivers/usb/usbip/stub_rx.c:486 stub_recv_cmd_submit()
    warn: always true condition
'(pdu->u.cmd_submit.transfer_buffer_length <= ((~0 >> 1))) =>
(s32min-s32max <= s32max)'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_rx.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -353,14 +353,6 @@ static int get_pipe(struct stub_device *
 
 	epd = &ep->desc;
 
-	/* validate transfer_buffer_length */
-	if (pdu->u.cmd_submit.transfer_buffer_length > INT_MAX) {
-		dev_err(&sdev->udev->dev,
-			"CMD_SUBMIT: -EMSGSIZE transfer_buffer_length %d\n",
-			pdu->u.cmd_submit.transfer_buffer_length);
-		return -1;
-	}
-
 	if (usb_endpoint_xfer_control(epd)) {
 		if (dir == USBIP_DIR_OUT)
 			return usb_sndctrlpipe(udev, epnum);
@@ -487,8 +479,7 @@ static void stub_recv_cmd_submit(struct
 	}
 
 	/* allocate urb transfer buffer, if needed */
-	if (pdu->u.cmd_submit.transfer_buffer_length > 0 &&
-	    pdu->u.cmd_submit.transfer_buffer_length <= INT_MAX) {
+	if (pdu->u.cmd_submit.transfer_buffer_length > 0) {
 		priv->urb->transfer_buffer =
 			kzalloc(pdu->u.cmd_submit.transfer_buffer_length,
 				GFP_KERNEL);


