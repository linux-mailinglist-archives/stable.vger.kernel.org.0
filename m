Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34A4A47F8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378626AbiAaNXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378625AbiAaNXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:23:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04B8C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 05:23:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A11A6B82ADE
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4515C340E8;
        Mon, 31 Jan 2022 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643635392;
        bh=jSocyW91t7nWw/IABlhsDQdltLhftIqH6xiipzOSY0U=;
        h=Subject:To:From:Date:From;
        b=1cBr6bv0j5Y/vJbhPHms+O+EBfi5yAQi9bIkMq7jxdsx7SzdtSZSEXjuMhswXXlnV
         pNHcOVfD3EyQ2bFzxPmy+TMVXW/h7E+GsMSfybdJ0bFsHH6syQN4DFI4TP4obsoY/b
         F9VEBcKlBcr6P+06NfxrkJ/yxr+K2uqZYx9t2PC8=
Subject: patch "usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition" added to usb-linus
To:     aford173@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:22:59 +0100
Message-ID: <164363537951157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 459702eea6132888b5c5b64c0e9c626da4ec2493 Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Fri, 28 Jan 2022 16:36:03 -0600
Subject: usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

The support the external role switch a variety of situations were
addressed, but the transition from USB_ROLE_HOST to USB_ROLE_NONE
leaves the host up which can cause some error messages when
switching from host to none, to gadget, to none, and then back
to host again.

 xhci-hcd ee000000.usb: Abort failed to stop command ring: -110
 xhci-hcd ee000000.usb: xHCI host controller not responding, assume dead
 xhci-hcd ee000000.usb: HC died; cleaning up
 usb 4-1: device not accepting address 6, error -108
 usb usb4-port1: couldn't allocate usb_device

After this happens it will not act as a host again.
Fix this by releasing the host mode when transitioning to USB_ROLE_NONE.

Fixes: 0604160d8c0b ("usb: gadget: udc: renesas_usb3: Enhance role switch support")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20220128223603.2362621-1-aford173@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 57d417a7c3e0..601829a6b4ba 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2378,6 +2378,8 @@ static void handle_ext_role_switch_states(struct device *dev,
 	switch (role) {
 	case USB_ROLE_NONE:
 		usb3->connection_state = USB_ROLE_NONE;
+		if (cur_role == USB_ROLE_HOST)
+			device_release_driver(host);
 		if (usb3->driver)
 			usb3_disconnect(usb3);
 		usb3_vbus_out(usb3, false);
-- 
2.35.1


