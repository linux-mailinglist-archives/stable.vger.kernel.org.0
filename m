Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8375A5B74B9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiIMP3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiIMP1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D377DF60;
        Tue, 13 Sep 2022 07:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3162CB80FE1;
        Tue, 13 Sep 2022 14:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7EDC433B5;
        Tue, 13 Sep 2022 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079796;
        bh=ysz1jOKMvZYF00xca0bynzbiuGanz8aiYjGSU62Dn08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRFVrDegazDo/gh4iUCyY4irmkTuNXG+C1D9PmNeMG7Ec+A/KT+FBUNtKKhviB8ru
         7dGAwNwXp8doRsa5sZN+tC8tdHGwNn91zKBrQs0pVPa9oHvzKfz+IAdp6+UK4+nSMU
         WPv9yVzZm5zG3DZEDSweU6rIpnMyECub06I8X73w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Rondreis <linhaoguo86@gmail.com>
Subject: [PATCH 4.9 17/42] USB: core: Prevent nested device-reset calls
Date:   Tue, 13 Sep 2022 16:07:48 +0200
Message-Id: <20220913140343.138541841@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
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

commit 9c6d778800b921bde3bff3cff5003d1650f942d1 upstream.

Automatic kernel fuzzing revealed a recursive locking violation in
usb-storage:

============================================
WARNING: possible recursive locking detected
5.18.0 #3 Not tainted
--------------------------------------------
kworker/1:3/1205 is trying to acquire lock:
ffff888018638db8 (&us_interface_key[i]){+.+.}-{3:3}, at:
usb_stor_pre_reset+0x35/0x40 drivers/usb/storage/usb.c:230

but task is already holding lock:
ffff888018638db8 (&us_interface_key[i]){+.+.}-{3:3}, at:
usb_stor_pre_reset+0x35/0x40 drivers/usb/storage/usb.c:230

...

stack backtrace:
CPU: 1 PID: 1205 Comm: kworker/1:3 Not tainted 5.18.0 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
check_deadlock kernel/locking/lockdep.c:3031 [inline]
validate_chain kernel/locking/lockdep.c:3816 [inline]
__lock_acquire.cold+0x152/0x3ca kernel/locking/lockdep.c:5053
lock_acquire kernel/locking/lockdep.c:5665 [inline]
lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5630
__mutex_lock_common kernel/locking/mutex.c:603 [inline]
__mutex_lock+0x14f/0x1610 kernel/locking/mutex.c:747
usb_stor_pre_reset+0x35/0x40 drivers/usb/storage/usb.c:230
usb_reset_device+0x37d/0x9a0 drivers/usb/core/hub.c:6109
r871xu_dev_remove+0x21a/0x270 drivers/staging/rtl8712/usb_intf.c:622
usb_unbind_interface+0x1bd/0x890 drivers/usb/core/driver.c:458
device_remove drivers/base/dd.c:545 [inline]
device_remove+0x11f/0x170 drivers/base/dd.c:537
__device_release_driver drivers/base/dd.c:1222 [inline]
device_release_driver_internal+0x1a7/0x2f0 drivers/base/dd.c:1248
usb_driver_release_interface+0x102/0x180 drivers/usb/core/driver.c:627
usb_forced_unbind_intf+0x4d/0xa0 drivers/usb/core/driver.c:1118
usb_reset_device+0x39b/0x9a0 drivers/usb/core/hub.c:6114

This turned out not to be an error in usb-storage but rather a nested
device reset attempt.  That is, as the rtl8712 driver was being
unbound from a composite device in preparation for an unrelated USB
reset (that driver does not have pre_reset or post_reset callbacks),
its ->remove routine called usb_reset_device() -- thus nesting one
reset call within another.

Performing a reset as part of disconnect processing is a questionable
practice at best.  However, the bug report points out that the USB
core does not have any protection against nested resets.  Adding a
reset_in_progress flag and testing it will prevent such errors in the
future.

Link: https://lore.kernel.org/all/CAB7eexKUpvX-JNiLzhXBDWgfg2T9e9_0Tw4HQ6keN==voRbP0g@mail.gmail.com/
Cc: stable@vger.kernel.org
Reported-and-tested-by: Rondreis <linhaoguo86@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YwkflDxvg0KWqyZK@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   10 ++++++++++
 include/linux/usb.h    |    2 ++
 2 files changed, 12 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5701,6 +5701,11 @@ re_enumerate_no_bos:
  * the reset is over (using their post_reset method).
  *
  * Return: The same as for usb_reset_and_verify_device().
+ * However, if a reset is already in progress (for instance, if a
+ * driver doesn't have pre_ or post_reset() callbacks, and while
+ * being unbound or re-bound during the ongoing reset its disconnect()
+ * or probe() routine tries to perform a second, nested reset), the
+ * routine returns -EINPROGRESS.
  *
  * Note:
  * The caller must own the device lock.  For example, it's safe to use
@@ -5734,6 +5739,10 @@ int usb_reset_device(struct usb_device *
 		return -EISDIR;
 	}
 
+	if (udev->reset_in_progress)
+		return -EINPROGRESS;
+	udev->reset_in_progress = 1;
+
 	port_dev = hub->ports[udev->portnum - 1];
 
 	/*
@@ -5798,6 +5807,7 @@ int usb_reset_device(struct usb_device *
 
 	usb_autosuspend_device(udev);
 	memalloc_noio_restore(noio_flag);
+	udev->reset_in_progress = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -531,6 +531,7 @@ struct usb3_lpm_parameters {
  * @level: number of USB hub ancestors
  * @can_submit: URBs may be submitted
  * @persist_enabled:  USB_PERSIST enabled for this device
+ * @reset_in_progress: the device is being reset
  * @have_langid: whether string_langid is valid
  * @authorized: policy has said we can use it;
  *	(user space) policy determines if we authorize this device to be
@@ -609,6 +610,7 @@ struct usb_device {
 
 	unsigned can_submit:1;
 	unsigned persist_enabled:1;
+	unsigned reset_in_progress:1;
 	unsigned have_langid:1;
 	unsigned authorized:1;
 	unsigned authenticated:1;


