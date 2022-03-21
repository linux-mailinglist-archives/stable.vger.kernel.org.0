Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6704E2877
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348337AbiCUN4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348234AbiCUN4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308A810FE4;
        Mon, 21 Mar 2022 06:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B03F56125C;
        Mon, 21 Mar 2022 13:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F92C340F3;
        Mon, 21 Mar 2022 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870865;
        bh=9vMNZb62DYdqoeF4bjRFvp+m4QYksmbaQVFf/bdLHdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOJ9dH2I6W1S70aYbeHTxlM44qbipHTbWfGv3icGd66hcTlSpUwQ2iwBnyWUxxAqC
         tT1IzWhprOQzvs1U9C4RQrcXMyrleVSba2iEr5NrJesz7GWhHUvMKJiQYiwI124C6F
         981v5mrflGqobD6fjbcsy6JDgvdwYV7zunb7pHZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+348b571beb5eeb70a582@syzkaller.appspotmail.com
Subject: [PATCH 4.14 20/22] usb: gadget: Fix use-after-free bug by not setting udc->dev.driver
Date:   Mon, 21 Mar 2022 14:51:51 +0100
Message-Id: <20220321133218.201616182@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.602054917@linuxfoundation.org>
References: <20220321133217.602054917@linuxfoundation.org>
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

commit 16b1941eac2bd499f065a6739a40ce0011a3d740 upstream.

The syzbot fuzzer found a use-after-free bug:

BUG: KASAN: use-after-free in dev_uevent+0x712/0x780 drivers/base/core.c:2320
Read of size 8 at addr ffff88802b934098 by task udevd/3689

CPU: 2 PID: 3689 Comm: udevd Not tainted 5.17.0-rc4-syzkaller-00229-g4f12b742eb2b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 dev_uevent+0x712/0x780 drivers/base/core.c:2320
 uevent_show+0x1b8/0x380 drivers/base/core.c:2391
 dev_attr_show+0x4b/0x90 drivers/base/core.c:2094

Although the bug manifested in the driver core, the real cause was a
race with the gadget core.  dev_uevent() does:

	if (dev->driver)
		add_uevent_var(env, "DRIVER=%s", dev->driver->name);

and between the test and the dereference of dev->driver, the gadget
core sets dev->driver to NULL.

The race wouldn't occur if the gadget core registered its devices on
a real bus, using the standard synchronization techniques of the
driver core.  However, it's not necessary to make such a large change
in order to fix this bug; all we need to do is make sure that
udc->dev.driver is always NULL.

In fact, there is no reason for udc->dev.driver ever to be set to
anything, let alone to the value it currently gets: the address of the
gadget's driver.  After all, a gadget driver only knows how to manage
a gadget, not how to manage a UDC.

This patch simply removes the statements in the gadget core that touch
udc->dev.driver.

Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+348b571beb5eeb70a582@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YiQgukfFFbBnwJ/9@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1284,7 +1284,6 @@ static void usb_gadget_remove_driver(str
 	usb_gadget_udc_stop(udc);
 
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 }
 
@@ -1333,7 +1332,6 @@ static int udc_bind_to_driver(struct usb
 			driver->function);
 
 	udc->driver = driver;
-	udc->dev.driver = &driver->driver;
 	udc->gadget->dev.driver = &driver->driver;
 
 	usb_gadget_udc_set_speed(udc, driver->max_speed);
@@ -1355,7 +1353,6 @@ err1:
 		dev_err(&udc->dev, "failed to start %s: %d\n",
 			udc->driver->function, ret);
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 	return ret;
 }


