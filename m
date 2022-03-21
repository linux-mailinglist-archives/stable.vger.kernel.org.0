Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467794E28E9
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbiCUOA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349147AbiCUN7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6422D7672;
        Mon, 21 Mar 2022 06:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D19611D5;
        Mon, 21 Mar 2022 13:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB74C340E8;
        Mon, 21 Mar 2022 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871077;
        bh=dGOcXsBKGb+pa/3WupTRMH4qEFSFdcbUJ2kNGLJFczo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNYvsx8qu26nv3wSAKblb/LEd3/1mpmDYk8Rjtpp3v0ZBt+fND6vYqo40LCbaGIAt
         xOtGCsA3lpCKE94SOdu/BjzvDWal1CNzoI23Kb4ehsgKY17NaI1x5lMY2Lm04aymwL
         d+HGK9/rXMvQh9fEiJCXvOYpAxbRNT4/QHcYXL0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+75cccf2b7da87fb6f84b@syzkaller.appspotmail.com
Subject: [PATCH 5.4 15/17] Input: aiptek - properly check endpoint type
Date:   Mon, 21 Mar 2022 14:52:51 +0100
Message-Id: <20220321133217.597455661@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

commit 5600f6986628dde8881734090588474f54a540a8 upstream.

Syzbot reported warning in usb_submit_urb() which is caused by wrong
endpoint type. There was a check for the number of endpoints, but not
for the type of endpoint.

Fix it by replacing old desc.bNumEndpoints check with
usb_find_common_endpoints() helper for finding endpoints

Fail log:

usb 5-1: BOGUS urb xfer, pipe 1 != type 3
WARNING: CPU: 2 PID: 48 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 2 PID: 48 Comm: kworker/2:2 Not tainted 5.17.0-rc6-syzkaller-00226-g07ebd38a0da2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: usb_hub_wq hub_event
...
Call Trace:
 <TASK>
 aiptek_open+0xd5/0x130 drivers/input/tablet/aiptek.c:830
 input_open_device+0x1bb/0x320 drivers/input/input.c:629
 kbd_connect+0xfe/0x160 drivers/tty/vt/keyboard.c:1593

Fixes: 8e20cf2bce12 ("Input: aiptek - fix crash on detecting device without endpoints")
Reported-and-tested-by: syzbot+75cccf2b7da87fb6f84b@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20220308194328.26220-1-paskripkin@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/tablet/aiptek.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1801,15 +1801,13 @@ aiptek_probe(struct usb_interface *intf,
 	input_set_abs_params(inputdev, ABS_TILT_Y, AIPTEK_TILT_MIN, AIPTEK_TILT_MAX, 0, 0);
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_MAX - 1, 0, 0);
 
-	/* Verify that a device really has an endpoint */
-	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
+	err = usb_find_common_endpoints(intf->cur_altsetting,
+					NULL, NULL, &endpoint, NULL);
+	if (err) {
 		dev_err(&intf->dev,
-			"interface has %d endpoints, but must have minimum 1\n",
-			intf->cur_altsetting->desc.bNumEndpoints);
-		err = -EINVAL;
+			"interface has no int in endpoints, but must have minimum 1\n");
 		goto fail3;
 	}
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
 
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.


