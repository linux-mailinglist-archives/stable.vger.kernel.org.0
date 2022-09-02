Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5603C5AB01A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbiIBMth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236077AbiIBMs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA9C356F1;
        Fri,  2 Sep 2022 05:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B24E5621EC;
        Fri,  2 Sep 2022 12:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A8DC433D6;
        Fri,  2 Sep 2022 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122097;
        bh=GnataGiAFSX5NG5nekK6YOQLkPP8Hse4ndp5l0psnBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqV0trct8Wfq9mPEo2C6P8VI0DYax7Ka69IDVf3d0pgD3BGowlbowrX0jc36BSy9e
         q58Lo4CN7G5cggQG3xOgXLcYDkEmWgQiIXs5AJIe6ah3nmw/4Ge4ZgSMWWZzW9+GjM
         RoVaekIa+pMl5VGqWTCHuNZsCOn3wetmNsRorE2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+b0de012ceb1e2a97891b@syzkaller.appspotmail.com
Subject: [PATCH 5.19 12/72] USB: gadget: Fix use-after-free Read in usb_udc_uevent()
Date:   Fri,  2 Sep 2022 14:18:48 +0200
Message-Id: <20220902121405.199084223@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 2191c00855b03aa59c20e698be713d952d51fc18 upstream.

The syzbot fuzzer found a race between uevent callbacks and gadget
driver unregistration that can cause a use-after-free bug:

---------------------------------------------------------------
BUG: KASAN: use-after-free in usb_udc_uevent+0x11f/0x130
drivers/usb/gadget/udc/core.c:1732
Read of size 8 at addr ffff888078ce2050 by task udevd/2968

CPU: 1 PID: 2968 Comm: udevd Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
06/29/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
 usb_udc_uevent+0x11f/0x130 drivers/usb/gadget/udc/core.c:1732
 dev_uevent+0x290/0x770 drivers/base/core.c:2424
---------------------------------------------------------------

The bug occurs because usb_udc_uevent() dereferences udc->driver but
does so without acquiring the udc_lock mutex, which protects this
field.  If the gadget driver is unbound from the udc concurrently with
uevent processing, the driver structure may be accessed after it has
been deallocated.

To prevent the race, we make sure that the routine holds the mutex
around the racing accesses.

Link: <https://lore.kernel.org/all/0000000000004de90405a719c951@google.com>
CC: stable@vger.kernel.org # fc274c1e9973
Reported-and-tested-by: syzbot+b0de012ceb1e2a97891b@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YtlrnhHyrHsSky9m@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 7886497253cc..cafcf260394c 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1728,13 +1728,14 @@ static int usb_udc_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return ret;
 	}
 
-	if (udc->driver) {
+	mutex_lock(&udc_lock);
+	if (udc->driver)
 		ret = add_uevent_var(env, "USB_UDC_DRIVER=%s",
 				udc->driver->function);
-		if (ret) {
-			dev_err(dev, "failed to add uevent USB_UDC_DRIVER\n");
-			return ret;
-		}
+	mutex_unlock(&udc_lock);
+	if (ret) {
+		dev_err(dev, "failed to add uevent USB_UDC_DRIVER\n");
+		return ret;
 	}
 
 	return 0;
-- 
2.37.2



