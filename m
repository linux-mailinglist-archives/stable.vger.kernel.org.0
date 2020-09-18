Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A5D26F358
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgIRDGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbgIRCEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACEBA235FD;
        Fri, 18 Sep 2020 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394650;
        bh=rH+Ro2yxB1c3K2IWG3dLZLLOQ9cKHPpRcEWropz/1Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIuMhLSiSpQGGORATtT4NzA4FL8GDEZMZMTJEIEmb8HkezSuSZWvF0u9MeNExRSXl
         8z4efLA4k0V4a1982cdoths0e8BvJvLJw8Knh8c4VPhG61N8HPqwJUz272pfEtXoaP
         uwyE2HIjMe9cpdpJE60a7aIi6TczqYmBoAfPquX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 147/330] random: fix data races at timer_rand_state
Date:   Thu, 17 Sep 2020 21:58:07 -0400
Message-Id: <20200918020110.2063155-147-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit e00d996a4317aff5351c4338dd97d390225412c2 ]

Fields in "struct timer_rand_state" could be accessed concurrently.
Lockless plain reads and writes result in data races. Fix them by adding
pairs of READ|WRITE_ONCE(). The data races were reported by KCSAN,

 BUG: KCSAN: data-race in add_timer_randomness / add_timer_randomness

 write to 0xffff9f320a0a01d0 of 8 bytes by interrupt on cpu 22:
  add_timer_randomness+0x100/0x190
  add_timer_randomness at drivers/char/random.c:1152
  add_disk_randomness+0x85/0x280
  scsi_end_request+0x43a/0x4a0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x1ed/0x2a0
  scsi_softirq_done+0x1c9/0x1d0
  blk_done_softirq+0x181/0x1d0
  __do_softirq+0xd9/0x57c
  irq_exit+0xa2/0xc0
  do_IRQ+0x8b/0x190
  ret_from_intr+0x0/0x42
  cpuidle_enter_state+0x15e/0x980
  cpuidle_enter+0x69/0xc0
  call_cpuidle+0x23/0x40
  do_idle+0x248/0x280
  cpu_startup_entry+0x1d/0x1f
  start_secondary+0x1b2/0x230
  secondary_startup_64+0xb6/0xc0

 no locks held by swapper/22/0.
 irq event stamp: 32871382
 _raw_spin_unlock_irqrestore+0x53/0x60
 _raw_spin_lock_irqsave+0x21/0x60
 _local_bh_enable+0x21/0x30
 irq_exit+0xa2/0xc0

 read to 0xffff9f320a0a01d0 of 8 bytes by interrupt on cpu 2:
  add_timer_randomness+0xe8/0x190
  add_disk_randomness+0x85/0x280
  scsi_end_request+0x43a/0x4a0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x1ed/0x2a0
  scsi_softirq_done+0x1c9/0x1d0
  blk_done_softirq+0x181/0x1d0
  __do_softirq+0xd9/0x57c
  irq_exit+0xa2/0xc0
  do_IRQ+0x8b/0x190
  ret_from_intr+0x0/0x42
  cpuidle_enter_state+0x15e/0x980
  cpuidle_enter+0x69/0xc0
  call_cpuidle+0x23/0x40
  do_idle+0x248/0x280
  cpu_startup_entry+0x1d/0x1f
  start_secondary+0x1b2/0x230
  secondary_startup_64+0xb6/0xc0

 no locks held by swapper/2/0.
 irq event stamp: 37846304
 _raw_spin_unlock_irqrestore+0x53/0x60
 _raw_spin_lock_irqsave+0x21/0x60
 _local_bh_enable+0x21/0x30
 irq_exit+0xa2/0xc0

 Reported by Kernel Concurrency Sanitizer on:
 Hardware name: HP ProLiant BL660c Gen9, BIOS I38 10/17/2018

Link: https://lore.kernel.org/r/1582648024-13111-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e877c20e0ee02..75a8f7f572697 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1223,14 +1223,14 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	 * We take into account the first, second and third-order deltas
 	 * in order to make our estimate.
 	 */
-	delta = sample.jiffies - state->last_time;
-	state->last_time = sample.jiffies;
+	delta = sample.jiffies - READ_ONCE(state->last_time);
+	WRITE_ONCE(state->last_time, sample.jiffies);
 
-	delta2 = delta - state->last_delta;
-	state->last_delta = delta;
+	delta2 = delta - READ_ONCE(state->last_delta);
+	WRITE_ONCE(state->last_delta, delta);
 
-	delta3 = delta2 - state->last_delta2;
-	state->last_delta2 = delta2;
+	delta3 = delta2 - READ_ONCE(state->last_delta2);
+	WRITE_ONCE(state->last_delta2, delta2);
 
 	if (delta < 0)
 		delta = -delta;
-- 
2.25.1

