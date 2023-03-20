Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275A6C16E6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjCTPKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjCTPJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177522B9CD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 831E76157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C01C433D2;
        Mon, 20 Mar 2023 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324675;
        bh=wtgYpMKxx8sUG0ay2BSeTjtrL9+HrWmm/S2tOkuz4f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE7F9SgBHEBACpfR5XOU+fKxoMrK305I4Ra/KVTb0CG5manVyzIssYdhVIwo1sRs4
         HwiH0VoQomF4ZPNvGcVA8IrXekQYLpUh+Xt14J2d/gC0QI07nysGW393IogxyOwrCm
         JnYMI6qibrQbmvLV+Ftt0sU1iOATntz2HlmQQYqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/115] nfc: pn533: initialize struct pn533_out_arg properly
Date:   Mon, 20 Mar 2023 15:53:47 +0100
Message-Id: <20230320145450.034553847@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 484b7059796e3bc1cb527caa61dfc60da649b4f6 ]

struct pn533_out_arg used as a temporary context for out_urb is not
initialized properly. Its uninitialized 'phy' field can be dereferenced in
error cases inside pn533_out_complete() callback function. It causes the
following failure:

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
 dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
 expire_timers+0x234/0x330 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107

Initialize the field with the pn533_usb_phy currently used.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9dab880d675b ("nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()")
Reported-by: syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230309165050.207390-1-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 62ad26e4299d1..47d423cc26081 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -175,6 +175,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	arg.phy = phy;
 	init_completion(&arg.done);
 	cntx = phy->out_urb->context;
 	phy->out_urb->context = &arg;
-- 
2.39.2



