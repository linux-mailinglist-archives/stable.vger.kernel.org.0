Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF251A7E1
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354873AbiEDRF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355178AbiEDREL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E5B4E3AC;
        Wed,  4 May 2022 09:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F4DB827A1;
        Wed,  4 May 2022 16:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D597C385A5;
        Wed,  4 May 2022 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683165;
        bh=HCoN8/Wq4Acpa5T6uG4M7Zn2PwaQBMq/3dfZoQIgsyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhThXt4HFzDINnpYisv0qlfXPya09eCVa3Pdm/uWAQp9vLJe8LN9UiQncXH8LUIU4
         /e0obuALBFDUjBt0LBAOMeHSdKeBPPr3M43PxOCIPwBT/1jTKCUDX2oivuQT29tBsm
         AUNc5Cqy6oWqr4HG/XNhl+WzN17+ZTI9KDe6Phyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tasos Sahanidis <tasos@tasossah.com>
Subject: [PATCH 5.15 017/177] usb: core: Dont hold the device lock while sleeping in do_proc_control()
Date:   Wed,  4 May 2022 18:43:30 +0200
Message-Id: <20220504153054.941573165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

commit 0543e4e8852ef5ff1809ae62f1ea963e2ab23b66 upstream.

Since commit ae8709b296d8 ("USB: core: Make do_proc_control() and
do_proc_bulk() killable") if a device has the USB_QUIRK_DELAY_CTRL_MSG
quirk set, it will temporarily block all other URBs (e.g. interrupts)
while sleeping due to a control.

This results in noticeable delays when, for example, a userspace usbfs
application is sending URB interrupts at a high rate to a keyboard and
simultaneously updates the lock indicators using controls. Interrupts
with direction set to IN are also affected by this, meaning that
delivery of HID reports (containing scancodes) to the usbfs application
is delayed as well.

This patch fixes the regression by calling msleep() while the device
mutex is unlocked, as was the case originally with usb_control_msg().

Fixes: ae8709b296d8 ("USB: core: Make do_proc_control() and do_proc_bulk() killable")
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/3e299e2a-13b9-ddff-7fee-6845e868bc06@tasossah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1197,12 +1197,16 @@ static int do_proc_control(struct usb_de
 
 		usb_unlock_device(dev);
 		i = usbfs_start_wait_urb(urb, tmo, &actlen);
+
+		/* Linger a bit, prior to the next control message. */
+		if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
+			msleep(200);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, actlen, i, COMPLETE, tbuf, actlen);
 		if (!i && actlen) {
 			if (copy_to_user(ctrl->data, tbuf, actlen)) {
 				ret = -EFAULT;
-				goto recv_fault;
+				goto done;
 			}
 		}
 	} else {
@@ -1219,6 +1223,10 @@ static int do_proc_control(struct usb_de
 
 		usb_unlock_device(dev);
 		i = usbfs_start_wait_urb(urb, tmo, &actlen);
+
+		/* Linger a bit, prior to the next control message. */
+		if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
+			msleep(200);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, actlen, i, COMPLETE, NULL, 0);
 	}
@@ -1230,10 +1238,6 @@ static int do_proc_control(struct usb_de
 	}
 	ret = (i < 0 ? i : actlen);
 
- recv_fault:
-	/* Linger a bit, prior to the next control message. */
-	if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
-		msleep(200);
  done:
 	kfree(dr);
 	usb_free_urb(urb);


