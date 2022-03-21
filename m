Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E624E28F3
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348638AbiCUOAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349134AbiCUN7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC72BC34;
        Mon, 21 Mar 2022 06:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA0E611D5;
        Mon, 21 Mar 2022 13:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE6CC340E8;
        Mon, 21 Mar 2022 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871074;
        bh=B2PwWKJauXDFQuvSQYT/EWCzPk39Vbs2uYKXUVD7pOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xS5HMhVBtD9nxfy03qiSWqnTICjoDP8NJmk6Zm/Q1iqt+3icHv0N4fJclSxxkvvm4
         z1bx6NpTJsfKtu7E+8ImxGqhOCihWbwEiM93/baeUWj2pSGmIdJaQdPM9UZZNzr5yu
         drF+xrT4L6ghZv8Qt8rJG5ITpSjGjqVwkVFMzh/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+a48e3d1a875240cab5de@syzkaller.appspotmail.com
Subject: [PATCH 5.4 14/17] usb: usbtmc: Fix bug in pipe direction for control transfers
Date:   Mon, 21 Mar 2022 14:52:50 +0100
Message-Id: <20220321133217.568942903@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit e9b667a82cdcfe21d590344447d65daed52b353b upstream.

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
 drivers/usb/class/usbtmc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1889,6 +1889,7 @@ static int usbtmc_ioctl_request(struct u
 	struct usbtmc_ctrlrequest request;
 	u8 *buffer = NULL;
 	int rv;
+	unsigned int is_in, pipe;
 	unsigned long res;
 
 	res = copy_from_user(&request, arg, sizeof(struct usbtmc_ctrlrequest));
@@ -1898,12 +1899,14 @@ static int usbtmc_ioctl_request(struct u
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
@@ -1914,8 +1917,12 @@ static int usbtmc_ioctl_request(struct u
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
@@ -1927,7 +1934,7 @@ static int usbtmc_ioctl_request(struct u
 		goto exit;
 	}
 
-	if (rv && (request.req.bRequestType & USB_DIR_IN)) {
+	if (rv && is_in) {
 		/* Read control data from device */
 		res = copy_to_user(request.data, buffer, rv);
 		if (res)


