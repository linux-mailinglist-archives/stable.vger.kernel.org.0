Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2805B4912
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIJVQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIJVQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA224C610;
        Sat, 10 Sep 2022 14:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA38B8094C;
        Sat, 10 Sep 2022 21:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2940CC43470;
        Sat, 10 Sep 2022 21:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844598;
        bh=+OnK7N6dAGoTTl5b469qqdBVhC78W2H8TUmFni4c6m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3WnAUmbfZzMZsLM18H7VIYKBuShtQTxAUdxxBWpV9vRrL/w0zXL211Y43RrvefEX
         iOKsi123iAY03OHP/DeZTEynuuK9L8Sw/+XkONVROFxddZ06JZsiFUeFwTtxwxkLmb
         vEbvAJybd/+cij8LC9M18tsAQtpmANzEM4bNSYweippmuV8mH0AMZeXWakRVKG+egr
         VoPRUDKq8DhoCNd3Gy3qsz8ngTOye1CNPNxZ7cADNsLlMg+XhrEx9f+5wyYl1es04L
         naCwdEB5rhxFbaJMXnQkt5htRNt/L6vzHrHb4f1GG/r+RlOyvBTP8fmTFUrAzGy9mA
         /RVgV4AbjSnmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthik Alapati <mail@karthek.com>,
        syzbot+f59100a0428e6ded9443@syzkaller.appspotmail.com,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 08/38] HID: hidraw: fix memory leak in hidraw_release()
Date:   Sat, 10 Sep 2022 17:15:53 -0400
Message-Id: <20220910211623.69825-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Karthik Alapati <mail@karthek.com>

[ Upstream commit a5623a203cffe2d2b84d2f6c989d9017db1856af ]

Free the buffered reports before deleting the list entry.

BUG: memory leak
unreferenced object 0xffff88810e72f180 (size 32):
  comm "softirq", pid 0, jiffies 4294945143 (age 16.080s)
  hex dump (first 32 bytes):
    64 f3 c6 6a d1 88 07 04 00 00 00 00 00 00 00 00  d..j............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814ac6c3>] kmemdup+0x23/0x50 mm/util.c:128
    [<ffffffff8357c1d2>] kmemdup include/linux/fortify-string.h:440 [inline]
    [<ffffffff8357c1d2>] hidraw_report_event+0xa2/0x150 drivers/hid/hidraw.c:521
    [<ffffffff8356ddad>] hid_report_raw_event+0x27d/0x740 drivers/hid/hid-core.c:1992
    [<ffffffff8356e41e>] hid_input_report+0x1ae/0x270 drivers/hid/hid-core.c:2065
    [<ffffffff835f0d3f>] hid_irq_in+0x1ff/0x250 drivers/hid/usbhid/hid-core.c:284
    [<ffffffff82d3c7f9>] __usb_hcd_giveback_urb+0xf9/0x230 drivers/usb/core/hcd.c:1670
    [<ffffffff82d3cc26>] usb_hcd_giveback_urb+0x1b6/0x1d0 drivers/usb/core/hcd.c:1747
    [<ffffffff82ef1e14>] dummy_timer+0x8e4/0x14c0 drivers/usb/gadget/udc/dummy_hcd.c:1988
    [<ffffffff812f50a8>] call_timer_fn+0x38/0x200 kernel/time/timer.c:1474
    [<ffffffff812f5586>] expire_timers kernel/time/timer.c:1519 [inline]
    [<ffffffff812f5586>] __run_timers.part.0+0x316/0x430 kernel/time/timer.c:1790
    [<ffffffff812f56e4>] __run_timers kernel/time/timer.c:1768 [inline]
    [<ffffffff812f56e4>] run_timer_softirq+0x44/0x90 kernel/time/timer.c:1803
    [<ffffffff848000e6>] __do_softirq+0xe6/0x2ea kernel/softirq.c:571
    [<ffffffff81246db0>] invoke_softirq kernel/softirq.c:445 [inline]
    [<ffffffff81246db0>] __irq_exit_rcu kernel/softirq.c:650 [inline]
    [<ffffffff81246db0>] irq_exit_rcu+0xc0/0x110 kernel/softirq.c:662
    [<ffffffff84574f02>] sysvec_apic_timer_interrupt+0xa2/0xd0 arch/x86/kernel/apic/apic.c:1106
    [<ffffffff84600c8b>] asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:649
    [<ffffffff8458a070>] native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
    [<ffffffff8458a070>] arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
    [<ffffffff8458a070>] acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
    [<ffffffff8458a070>] acpi_idle_do_entry+0xc0/0xd0 drivers/acpi/processor_idle.c:554

Link: https://syzkaller.appspot.com/bug?id=19a04b43c75ed1092021010419b5e560a8172c4f
Reported-by: syzbot+f59100a0428e6ded9443@syzkaller.appspotmail.com
Signed-off-by: Karthik Alapati <mail@karthek.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 681614a8302a5..197b1e7bf029e 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -350,6 +350,8 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	down_write(&minors_rwsem);
 
 	spin_lock_irqsave(&hidraw_table[minor]->list_lock, flags);
+	for (int i = list->tail; i < list->head; i++)
+		kfree(list->buffer[i].value);
 	list_del(&list->node);
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	kfree(list);
-- 
2.35.1

