Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1786A451DF0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbhKPAed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344005AbhKOTXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8C72633B5;
        Mon, 15 Nov 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002204;
        bh=2Tl6eJqLtD01E2lXx8xQTjI7Wbb9nDy/gpW8Sdk1P2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zd9EzO2cVqxEEeyHcv2XxI8agbMauOZKRt9kV28Z+RyRLEeUtQfSWCecyfJgBC2Tj
         vCBELIeD4Ln2l7e7Xg1nxKozAyU8dIfVZCiZLEvRFdY3ZD/WcIH49l6gbAJ7dixc+Y
         PPYf2fiAa9wUbaIB8ag40gzULRBPTsruz+Z34bgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/917] blk-wbt: prevent NULL pointer dereference in wb_timer_fn
Date:   Mon, 15 Nov 2021 17:59:05 +0100
Message-Id: <20211115165444.038581185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit 480d42dc001bbfe953825a92073012fcd5a99161 ]

The timer callback used to evaluate if the latency is exceeded can be
executed after the corresponding disk has been released, causing the
following NULL pointer dereference:

[ 119.987108] BUG: kernel NULL pointer dereference, address: 0000000000000098
[ 119.987617] #PF: supervisor read access in kernel mode
[ 119.987971] #PF: error_code(0x0000) - not-present page
[ 119.988325] PGD 7c4a4067 P4D 7c4a4067 PUD 7bf63067 PMD 0
[ 119.988697] Oops: 0000 [#1] SMP NOPTI
[ 119.988959] CPU: 1 PID: 9353 Comm: cloud-init Not tainted 5.15-rc5+arighi #rc5+arighi
[ 119.989520] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
[ 119.990055] RIP: 0010:wb_timer_fn+0x44/0x3c0
[ 119.990376] Code: 41 8b 9c 24 98 00 00 00 41 8b 94 24 b8 00 00 00 41 8b 84 24 d8 00 00 00 4d 8b 74 24 28 01 d3 01 c3 49 8b 44 24 60 48 8b 40 78 <4c> 8b b8 98 00 00 00 4d 85 f6 0f 84 c4 00 00 00 49 83 7c 24 30 00
[ 119.991578] RSP: 0000:ffffb5f580957da8 EFLAGS: 00010246
[ 119.991937] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000004
[ 119.992412] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88f476d7f780
[ 119.992895] RBP: ffffb5f580957dd0 R08: 0000000000000000 R09: 0000000000000000
[ 119.993371] R10: 0000000000000004 R11: 0000000000000002 R12: ffff88f476c84500
[ 119.993847] R13: ffff88f4434390c0 R14: 0000000000000000 R15: ffff88f4bdc98c00
[ 119.994323] FS: 00007fb90bcd9c00(0000) GS:ffff88f4bdc80000(0000) knlGS:0000000000000000
[ 119.994952] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 119.995380] CR2: 0000000000000098 CR3: 000000007c0d6000 CR4: 00000000000006e0
[ 119.995906] Call Trace:
[ 119.996130] ? blk_stat_free_callback_rcu+0x30/0x30
[ 119.996505] blk_stat_timer_fn+0x138/0x140
[ 119.996830] call_timer_fn+0x2b/0x100
[ 119.997136] __run_timers.part.0+0x1d1/0x240
[ 119.997470] ? kvm_clock_get_cycles+0x11/0x20
[ 119.997826] ? ktime_get+0x3e/0xa0
[ 119.998110] ? native_apic_msr_write+0x2c/0x30
[ 119.998456] ? lapic_next_event+0x20/0x30
[ 119.998779] ? clockevents_program_event+0x94/0xf0
[ 119.999150] run_timer_softirq+0x2a/0x50
[ 119.999465] __do_softirq+0xcb/0x26f
[ 119.999764] irq_exit_rcu+0x8c/0xb0
[ 120.000057] sysvec_apic_timer_interrupt+0x43/0x90
[ 120.000429] ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[ 120.000836] asm_sysvec_apic_timer_interrupt+0x12/0x20

In this case simply return from the timer callback (no action
required) to prevent the NULL pointer dereference.

BugLink: https://bugs.launchpad.net/bugs/1947557
Link: https://lore.kernel.org/linux-mm/YWRNVTk9N8K0RMst@arighi-desktop/
Fixes: 34dbad5d26e2 ("blk-stat: convert to callback-based statistics reporting")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Link: https://lore.kernel.org/r/YW6N2qXpBU3oc50q@arighi-desktop
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-wbt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 874c1c37bf0c6..0c119be0e8133 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -357,6 +357,9 @@ static void wb_timer_fn(struct blk_stat_callback *cb)
 	unsigned int inflight = wbt_inflight(rwb);
 	int status;
 
+	if (!rwb->rqos.q->disk)
+		return;
+
 	status = latency_exceeded(rwb, cb->stat);
 
 	trace_wbt_timer(rwb->rqos.q->disk->bdi, status, rqd->scale_step,
-- 
2.33.0



