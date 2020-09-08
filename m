Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7E3261E61
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgIHTvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbgIHPt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D902485A;
        Tue,  8 Sep 2020 15:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579924;
        bh=A9XxeSx4gLbQ57W6xTa9i3Eig3LYh+sF9DfLdrC6e/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJJWa0YKcbtCqLN3QbEpKVphyV4xiTtAzrjmb9alxaE7XBbIQcF0kye4Hxqr0WbSS
         1pO0/daHUOrW9Su+UlKaLVyBJqSargJkmhFJLJiiGT/gt31SOcr3Vxc8m/s9Wnye1s
         0jS3QM3juuVwiWNfvSbaCDh/7OOrFzJopn8112Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 089/129] Revert "ALSA: hda: Add support for Loongson 7A1000 controller"
Date:   Tue,  8 Sep 2020 17:25:30 +0200
Message-Id: <20200908152234.167102224@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit eed8f88b109aa927fbf0d0c80ff9f8d00444ca7f upstream.

This reverts commit 61eee4a7fc40 ("ALSA: hda: Add support for Loongson
7A1000 controller") to fix the following error on the Loongson LS7A
platform:

rcu: INFO: rcu_preempt self-detected stall on CPU
<SNIP>
NMI backtrace for cpu 0
CPU: 0 PID: 68 Comm: kworker/0:2 Not tainted 5.8.0+ #3
Hardware name:  , BIOS
Workqueue: events azx_probe_work [snd_hda_intel]
<SNIP>
Call Trace:
[<ffffffff80211a64>] show_stack+0x9c/0x130
[<ffffffff8065a740>] dump_stack+0xb0/0xf0
[<ffffffff80665774>] nmi_cpu_backtrace+0x134/0x140
[<ffffffff80665910>] nmi_trigger_cpumask_backtrace+0x190/0x200
[<ffffffff802b1abc>] rcu_dump_cpu_stacks+0x12c/0x190
[<ffffffff802b08cc>] rcu_sched_clock_irq+0xa2c/0xfc8
[<ffffffff802b91d4>] update_process_times+0x2c/0xb8
[<ffffffff802cad80>] tick_sched_timer+0x40/0xb8
[<ffffffff802ba5f0>] __hrtimer_run_queues+0x118/0x1d0
[<ffffffff802bab74>] hrtimer_interrupt+0x12c/0x2d8
[<ffffffff8021547c>] c0_compare_interrupt+0x74/0xa0
[<ffffffff80296bd0>] __handle_irq_event_percpu+0xa8/0x198
[<ffffffff80296cf0>] handle_irq_event_percpu+0x30/0x90
[<ffffffff8029d958>] handle_percpu_irq+0x88/0xb8
[<ffffffff80296124>] generic_handle_irq+0x44/0x60
[<ffffffff80b3cfd0>] do_IRQ+0x18/0x28
[<ffffffff8067ace4>] plat_irq_dispatch+0x64/0x100
[<ffffffff80209a20>] handle_int+0x140/0x14c
[<ffffffff802402e8>] irq_exit+0xf8/0x100

Because AZX_DRIVER_GENERIC can not work well for Loongson LS7A HDA
controller, it needs some workarounds which are not merged into the
upstream kernel at this time, so it should revert this patch now.

Fixes: 61eee4a7fc40 ("ALSA: hda: Add support for Loongson 7A1000 controller")
Cc: <stable@vger.kernel.org> # 5.9-rc1+
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/1598348388-2518-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2671,8 +2671,6 @@ static const struct pci_device_id azx_id
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_HDMI },
 	/* Zhaoxin */
 	{ PCI_DEVICE(0x1d17, 0x3288), .driver_data = AZX_DRIVER_ZHAOXIN },
-	/* Loongson */
-	{ PCI_DEVICE(0x0014, 0x7a07), .driver_data = AZX_DRIVER_GENERIC },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);


