Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934312F5334
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 20:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbhAMTSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 14:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbhAMTS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 14:18:29 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666C6C061786
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:17:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y17so3297328wrr.10
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BT6sc0LO7SzeOpKivqGcn1BjVwvAbMsr3JIitlBMX5Y=;
        b=sQt02oXp0fzeIU1v92Q204JUE7qylN2YjTQ/+GSMsn0oC5FFPn608iTt6fJW2TkjfR
         YLeLCVtjIpFV3ALS8RV9AeLBSrdDStmx26ckj6iGz7FQJThbdEeo9DYGdcOKOPaUZzZS
         3TVko9MYA1AMe3Q7ENdXxd6LHYHKA01zJiQq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BT6sc0LO7SzeOpKivqGcn1BjVwvAbMsr3JIitlBMX5Y=;
        b=B73O21RbrwRZkBrSfwsauzaNaAlorRg6weYY410slGM6Bzqjqqm2bEcmqinoE/lagh
         pkIisAJVUuTvKcmY4oqnFtGKh4JTOwcITXIyvicOdqZr5pG3z1SQUQ+c626A3pef9/JO
         AfQ+IDumBMKJBIzHbuyg4dECKooKKXd7lPjXKW0ShG6VVmWkds2R9fvavIKgcHUKRA4L
         vT/wszuCuyco1Z2VJoS43BIbZ6d9i9x/2A/LJnQCdmJcQQRNtuBGQ5sw2IpUWnm8ZgFV
         pa3vNW0T0FTtRpDouPxR0enZv3+RFlD0f8tukEu9EGndjeVtk95Mtwpr2VyltiVdLS/e
         Z8jw==
X-Gm-Message-State: AOAM5326zOfc7A4wkxXNPa9OeRpGHklT/cUSYnyGuZGaDITC74mzvnp6
        A6CSFyVYSSIqz5Z14OIQcqx/Sw==
X-Google-Smtp-Source: ABdhPJzsLL4mdNTwqMFjJceUqcEp0acXy3/jj4mBN6qWL9f7kvjPvrAVV9xgxTfuHL833oldgRzabA==
X-Received: by 2002:a5d:40ce:: with SMTP id b14mr4040202wrq.350.1610565457971;
        Wed, 13 Jan 2021 11:17:37 -0800 (PST)
Received: from dev.cfops.net (29.177.200.146.dyn.plus.net. [146.200.177.29])
        by smtp.gmail.com with ESMTPSA id w8sm4804681wrl.91.2021.01.13.11.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 11:17:37 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: [PATCH] dm crypt: defer the decryption to a tasklet, when being called with interrupts disabled
Date:   Wed, 13 Jan 2021 19:17:17 +0000
Message-Id: <20210113191717.1439-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On some specific hardware on early boot we occasionally get

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
context, so just defer it to a tasklet as with requests from hard irqs.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53791138d78b..c56b01bfdb60 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2091,8 +2091,11 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 
 	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
 	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
-		if (in_irq()) {
-			/* Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context */
+		/* in_irq(): Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context.
+		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
+		   it is being executed with irqs disabled.
+		 */
+		if (in_irq() || irqs_disabled()) {
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
-- 
2.20.1

