Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA52FA421
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405568AbhARPHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390790AbhARLmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57DBB22D49;
        Mon, 18 Jan 2021 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970124;
        bh=Oze4GNEGTuLxG2M9xVeuMlnwIDqG6KIAx9EJvie1tpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxmYqh62hiGsxk9r1i//9/DbcSIvF3nLqe3l7za3PegKz/TZNhdUClrB26jGWE8L1
         rAciBM8pqGc5DvgTPauX/BpcTcDiatVXl+Vg2NmQ8gz3+sQbSWqod41ExRy3Pc9QCA
         LNNvbGVf80NfDl7jCoeRlMEVtDZkqAo1CHZ3JybM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 048/152] dm crypt: defer decryption to a tasklet if interrupts disabled
Date:   Mon, 18 Jan 2021 12:33:43 +0100
Message-Id: <20210118113355.091418487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

commit c87a95dc28b1431c7e77e2c0c983cf37698089d2 upstream.

On some specific hardware on early boot we occasionally get:

[ 1193.920255][    T0] BUG: sleeping function called from invalid context at mm/mempool.c:381
[ 1193.936616][    T0] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/69
[ 1193.953233][    T0] no locks held by swapper/69/0.
[ 1193.965871][    T0] irq event stamp: 575062
[ 1193.977724][    T0] hardirqs last  enabled at (575061): [<ffffffffab73f662>] tick_nohz_idle_exit+0xe2/0x3e0
[ 1194.002762][    T0] hardirqs last disabled at (575062): [<ffffffffab74e8af>] flush_smp_call_function_from_idle+0x4f/0x80
[ 1194.029035][    T0] softirqs last  enabled at (575050): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
[ 1194.054227][    T0] softirqs last disabled at (575043): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
[ 1194.079389][    T0] CPU: 69 PID: 0 Comm: swapper/69 Not tainted 5.10.6-cloudflare-kasan-2021.1.4-dev #1
[ 1194.104103][    T0] Hardware name: NULL R162-Z12-CD/MZ12-HD4-CD, BIOS R10 06/04/2020
[ 1194.119591][    T0] Call Trace:
[ 1194.130233][    T0]  dump_stack+0x9a/0xcc
[ 1194.141617][    T0]  ___might_sleep.cold+0x180/0x1b0
[ 1194.153825][    T0]  mempool_alloc+0x16b/0x300
[ 1194.165313][    T0]  ? remove_element+0x160/0x160
[ 1194.176961][    T0]  ? blk_mq_end_request+0x4b/0x490
[ 1194.188778][    T0]  crypt_convert+0x27f6/0x45f0 [dm_crypt]
[ 1194.201024][    T0]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 1194.212906][    T0]  ? module_assert_mutex_or_preempt+0x3e/0x70
[ 1194.225318][    T0]  ? __module_address.part.0+0x1b/0x3a0
[ 1194.237212][    T0]  ? is_kernel_percpu_address+0x5b/0x190
[ 1194.249238][    T0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0 [dm_crypt]
[ 1194.261593][    T0]  ? is_module_address+0x25/0x40
[ 1194.272905][    T0]  ? static_obj+0x8a/0xc0
[ 1194.283582][    T0]  ? lockdep_init_map_waits+0x26a/0x700
[ 1194.295570][    T0]  ? __raw_spin_lock_init+0x39/0x110
[ 1194.307330][    T0]  kcryptd_crypt_read_convert+0x31c/0x560 [dm_crypt]
[ 1194.320496][    T0]  ? kcryptd_queue_crypt+0x1be/0x380 [dm_crypt]
[ 1194.333203][    T0]  blk_update_request+0x6d7/0x1500
[ 1194.344841][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
[ 1194.356831][    T0]  blk_mq_end_request+0x4b/0x490
[ 1194.367994][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
[ 1194.379693][    T0]  flush_smp_call_function_queue+0x24b/0x560
[ 1194.391847][    T0]  flush_smp_call_function_from_idle+0x59/0x80
[ 1194.403969][    T0]  do_idle+0x287/0x450
[ 1194.413891][    T0]  ? arch_cpu_idle_exit+0x40/0x40
[ 1194.424716][    T0]  ? lockdep_hardirqs_on_prepare+0x286/0x3f0
[ 1194.436399][    T0]  ? _raw_spin_unlock_irqrestore+0x39/0x40
[ 1194.447759][    T0]  cpu_startup_entry+0x19/0x20
[ 1194.458038][    T0]  secondary_startup_64_no_verify+0xb0/0xbb

IO completion can be queued to a different CPU by the block subsystem as a "call
single function/data". The CPU may run these routines from the idle task, but it
does so with interrupts disabled.

It is not a good idea to do decryption with irqs disabled even in an idle task
context, so just defer it to a tasklet (as is done with requests from hard irqs).

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2221,8 +2221,12 @@ static void kcryptd_queue_crypt(struct d
 
 	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
 	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
-		if (in_irq()) {
-			/* Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context */
+		/*
+		 * in_irq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
+		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
+		 * it is being executed with irqs disabled.
+		 */
+		if (in_irq() || irqs_disabled()) {
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;


