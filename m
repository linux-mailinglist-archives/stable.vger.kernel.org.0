Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F2649FF3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiLLNRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiLLNQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:16:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0EB263
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:16:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCAC86105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE993C433F1;
        Mon, 12 Dec 2022 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850999;
        bh=Kt2XjoS8AtJa9Rb71rqz+die/tom3ykCn2N9L5Z/J0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ8Q+SluAxaBT4RGfJ6f42R7lfipyLv6BGY9MKwH2qzublLKlq2+o2oY60iEmgmE0
         6pN3JbNGikmUqQwXO/7Cn0Nz9tp6ggx3nw0DDlfNs4OIn1AW9KgPrZYg8osbd4HM8v
         2TS1MWrC8VElg/DZ6kPkNM07qZVh7I5zm0NSgcXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8b1641d2f14732407e23@syzkaller.appspotmail.com,
        ZhangPeng <zhangpeng362@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 058/106] HID: core: fix shift-out-of-bounds in hid_report_raw_event
Date:   Mon, 12 Dec 2022 14:10:01 +0100
Message-Id: <20221212130927.415918294@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangPeng <zhangpeng362@huawei.com>

commit ec61b41918587be530398b0d1c9a0d16619397e5 upstream.

Syzbot reported shift-out-of-bounds in hid_report_raw_event.

microsoft 0003:045E:07DA.0001: hid_field_extract() called with n (128) >
32! (swapper/0)
======================================================================
UBSAN: shift-out-of-bounds in drivers/hid/hid-core.c:1323:20
shift exponent 127 is too large for 32-bit type 'int'
CPU: 0 PID: 0 Comm: swapper/0 Not tainted
6.1.0-rc4-syzkaller-00159-g4bbf3422df78 #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS
Google 10/26/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:151 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3a6/0x420 lib/ubsan.c:322
 snto32 drivers/hid/hid-core.c:1323 [inline]
 hid_input_fetch_field drivers/hid/hid-core.c:1572 [inline]
 hid_process_report drivers/hid/hid-core.c:1665 [inline]
 hid_report_raw_event+0xd56/0x18b0 drivers/hid/hid-core.c:1998
 hid_input_report+0x408/0x4f0 drivers/hid/hid-core.c:2066
 hid_irq_in+0x459/0x690 drivers/hid/usbhid/hid-core.c:284
 __usb_hcd_giveback_urb+0x369/0x530 drivers/usb/core/hcd.c:1671
 dummy_timer+0x86b/0x3110 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0xf5/0x210 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers+0x76a/0x980 kernel/time/timer.c:1790
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1803
 __do_softirq+0x277/0x75b kernel/softirq.c:571
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1107
======================================================================

If the size of the integer (unsigned n) is bigger than 32 in snto32(),
shift exponent will be too large for 32-bit type 'int', resulting in a
shift-out-of-bounds bug.
Fix this by adding a check on the size of the integer (unsigned n) in
snto32(). To add support for n greater than 32 bits, set n to 32, if n
is greater than 32.

Reported-by: syzbot+8b1641d2f14732407e23@syzkaller.appspotmail.com
Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1310,6 +1310,9 @@ static s32 snto32(__u32 value, unsigned
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);


