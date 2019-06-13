Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2463F44055
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbfFMQFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731344AbfFMIqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A027F2147A;
        Thu, 13 Jun 2019 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415598;
        bh=61GBweix5UTf8kAg2xGTzl6CpAUhZk7wGiUDyCDQ2sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1JKSl7KlOvZvAq0kfIJ0y2kyKzlNPLEAI23ly7lvAGQNutVLPxbHy6u0eU1aNQqj
         KhIR4LAneK87dhHYFpBwEeCvmR1LH1KqrUktwiN9apvTYpincylifu+j7Vc9VE7DMc
         mVSfdHixZ1j+YD5hn6DT2rQciDbqaZoFPjURtTVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 058/155] uml: fix a boot splat wrt use of cpu_all_mask
Date:   Thu, 13 Jun 2019 10:32:50 +0200
Message-Id: <20190613075656.336802452@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 689a58605b63173acb0a8cf954af6a8f60440c93 ]

Memory: 509108K/542612K available (3835K kernel code, 919K rwdata, 1028K rodata, 129K init, 211K bss, 33504K reserved, 0K cma-reserved)
NR_IRQS: 15
clocksource: timer: mask: 0xffffffffffffffff max_cycles: 0x1cd42e205, max_idle_ns: 881590404426 ns
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:458 clockevents_register_device+0x72/0x140
posix-timer cpumask == cpu_all_mask, using cpu_possible_mask instead
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 5.1.0-rc4-00048-ged79cc87302b #4
Stack:
 604ebda0 603c5370 604ebe20 6046fd17
 00000000 6006fcbb 604ebdb0 603c53b5
 604ebe10 6003bfc4 604ebdd0 9000001ca
Call Trace:
 [<6006fcbb>] ? printk+0x0/0x94
 [<60083160>] ? clockevents_register_device+0x72/0x140
 [<6001f16e>] show_stack+0x13b/0x155
 [<603c5370>] ? dump_stack_print_info+0xe2/0xeb
 [<6006fcbb>] ? printk+0x0/0x94
 [<603c53b5>] dump_stack+0x2a/0x2c
 [<6003bfc4>] __warn+0x10e/0x13e
 [<60070320>] ? vprintk_func+0xc8/0xcf
 [<60030fd6>] ? block_signals+0x0/0x16
 [<6006fcbb>] ? printk+0x0/0x94
 [<6003c08b>] warn_slowpath_fmt+0x97/0x99
 [<600311a1>] ? set_signals+0x0/0x3f
 [<6003bff4>] ? warn_slowpath_fmt+0x0/0x99
 [<600842cb>] ? tick_oneshot_mode_active+0x44/0x4f
 [<60030fd6>] ? block_signals+0x0/0x16
 [<6006fcbb>] ? printk+0x0/0x94
 [<6007d2d5>] ? __clocksource_select+0x20/0x1b1
 [<60030fd6>] ? block_signals+0x0/0x16
 [<6006fcbb>] ? printk+0x0/0x94
 [<60083160>] clockevents_register_device+0x72/0x140
 [<60031192>] ? get_signals+0x0/0xf
 [<60030fd6>] ? block_signals+0x0/0x16
 [<6006fcbb>] ? printk+0x0/0x94
 [<60002eec>] um_timer_setup+0xc8/0xca
 [<60001b59>] start_kernel+0x47f/0x57e
 [<600035bc>] start_kernel_proc+0x49/0x4d
 [<6006c483>] ? kmsg_dump_register+0x82/0x8a
 [<6001de62>] new_thread_handler+0x81/0xb2
 [<60003571>] ? kmsg_dumper_stdout_init+0x1a/0x1c
 [<60020c75>] uml_finishsetup+0x54/0x59

random: get_random_bytes called from init_oops_id+0x27/0x34 with crng_init=0
---[ end trace 00173d0117a88acb ]---
Calibrating delay loop... 6941.90 BogoMIPS (lpj=34709504)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: linux-um@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 052de4c8acb2..0c572a48158e 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -56,7 +56,7 @@ static int itimer_one_shot(struct clock_event_device *evt)
 static struct clock_event_device timer_clockevent = {
 	.name			= "posix-timer",
 	.rating			= 250,
-	.cpumask		= cpu_all_mask,
+	.cpumask		= cpu_possible_mask,
 	.features		= CLOCK_EVT_FEAT_PERIODIC |
 				  CLOCK_EVT_FEAT_ONESHOT,
 	.set_state_shutdown	= itimer_shutdown,
-- 
2.20.1



