Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33064DA186
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 18:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiCORrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiCORrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 13:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91284F9DF
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 10:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88311B81804
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 17:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF5CC340EE;
        Tue, 15 Mar 2022 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647366352;
        bh=Tlu4i3nUmUddXqvJtxJ0hKyvV4/ZfkfzH4nhYnQ8wYI=;
        h=Subject:To:From:Date:From;
        b=PyfKTslHJXns5cWf+Sg6UcI4yTh//mlX5jyhcWSnAeDUpIWpKWbreg9RNeV5hs1YX
         uHPR109YPfqDHpghMCf2nIc8+poSw7w7C6GF4Q733z4pET7s9QZZfElSoKaWUxdHfH
         Xw7h9eq8QYSo9aP5LcnjVCThh5A+AgM1Wt6h1mR4=
Subject: patch "usb: usbtmc: Fix bug in pipe direction for control transfers" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Mar 2022 18:45:42 +0100
Message-ID: <164736634219925@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: usbtmc: Fix bug in pipe direction for control transfers

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e9b667a82cdcfe21d590344447d65daed52b353b Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 3 Mar 2022 16:00:17 -0500
Subject: usb: usbtmc: Fix bug in pipe direction for control transfers

The syzbot fuzzer reported a minor bug in the usbtmc driver:

usb 5-1: BOGUS control dir, pipe 80001e80 doesn't match bRequestType 0
WARNING: CPU: 0 PID: 3813 at drivers/usb/core/urb.c:412
usb_submit_urb+0x13a5/0x1970 drivers/usb/core/urb.c:410
Modules linked in:
CPU: 0 PID: 3813 Comm: syz-executor122 Not tainted
5.17.0-rc5-syzkaller-00306-g2293be58d6a1 #0
...
Call Trace:
 <TASK>
 usb_start_wait_urb+0x113/0x530 drivers/usb/core/message.c:58
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x2a5/0x4b0 drivers/usb/core/message.c:153
 usbtmc_ioctl_request drivers/usb/class/usbtmc.c:1947 [inline]

The problem is that usbtmc_ioctl_request() uses usb_rcvctrlpipe() for
all of its transfers, whether they are in or out.  It's easy to fix.

CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+a48e3d1a875240cab5de@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YiEsYTPEE6lOCOA5@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 73f419adce61..4bb6d304eb4b 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1919,6 +1919,7 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 	struct usbtmc_ctrlrequest request;
 	u8 *buffer = NULL;
 	int rv;
+	unsigned int is_in, pipe;
 	unsigned long res;
 
 	res = copy_from_user(&request, arg, sizeof(struct usbtmc_ctrlrequest));
@@ -1928,12 +1929,14 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 	if (request.req.wLength > USBTMC_BUFSIZE)
 		return -EMSGSIZE;
 
+	is_in = request.req.bRequestType & USB_DIR_IN;
+
 	if (request.req.wLength) {
 		buffer = kmalloc(request.req.wLength, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
 
-		if ((request.req.bRequestType & USB_DIR_IN) == 0) {
+		if (!is_in) {
 			/* Send control data to device */
 			res = copy_from_user(buffer, request.data,
 					     request.req.wLength);
@@ -1944,8 +1947,12 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 		}
 	}
 
+	if (is_in)
+		pipe = usb_rcvctrlpipe(data->usb_dev, 0);
+	else
+		pipe = usb_sndctrlpipe(data->usb_dev, 0);
 	rv = usb_control_msg(data->usb_dev,
-			usb_rcvctrlpipe(data->usb_dev, 0),
+			pipe,
 			request.req.bRequest,
 			request.req.bRequestType,
 			request.req.wValue,
@@ -1957,7 +1964,7 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 		goto exit;
 	}
 
-	if (rv && (request.req.bRequestType & USB_DIR_IN)) {
+	if (rv && is_in) {
 		/* Read control data from device */
 		res = copy_to_user(request.data, buffer, rv);
 		if (res)
-- 
2.35.1


