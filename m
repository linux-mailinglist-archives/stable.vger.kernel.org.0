Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AE5411F40
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbhITRjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348708AbhITRha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DAC260FE6;
        Mon, 20 Sep 2021 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157611;
        bh=XJmhHQaf6F94Wuqmt+mFIFYZwfjS1+6Hn/BccfhRFCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOSRvQTIMYt112RBxLUfRYPV8ZNXF0ZAWOhH6mQlPeMdcbJ75xBTlmvXVYQksIiXI
         /xkde8xApw7SDMOaJtcgxeeVFKuzPkgnoZYzBDJ74YMmNHvfpMfO6h41DR3SSzxdGk
         woAKmafNYqrzM+lENt3LZUa2FAhvrk81MbSkefO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Goncalves <bgoncalv@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/293] sched/deadline: Fix missing clock update in migrate_task_rq_dl()
Date:   Mon, 20 Sep 2021 18:40:00 +0200
Message-Id: <20210920163934.582868188@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit b4da13aa28d4fd0071247b7b41c579ee8a86c81a ]

A missing clock update is causing the following warning:

rq->clock_update_flags < RQCF_ACT_SKIP
WARNING: CPU: 112 PID: 2041 at kernel/sched/sched.h:1453
sub_running_bw.isra.0+0x190/0x1a0
...
CPU: 112 PID: 2041 Comm: sugov:112 Tainted: G W 5.14.0-rc1 #1
Hardware name: WIWYNN Mt.Jade Server System
B81.030Z1.0007/Mt.Jade Motherboard, BIOS 1.6.20210526 (SCP:
1.06.20210526) 2021/05/26
...
Call trace:
  sub_running_bw.isra.0+0x190/0x1a0
  migrate_task_rq_dl+0xf8/0x1e0
  set_task_cpu+0xa8/0x1f0
  try_to_wake_up+0x150/0x3d4
  wake_up_q+0x64/0xc0
  __up_write+0xd0/0x1c0
  up_write+0x4c/0x2b0
  cppc_set_perf+0x120/0x2d0
  cppc_cpufreq_set_target+0xe0/0x1a4 [cppc_cpufreq]
  __cpufreq_driver_target+0x74/0x140
  sugov_work+0x64/0x80
  kthread_worker_fn+0xe0/0x230
  kthread+0x138/0x140
  ret_from_fork+0x10/0x18

The task causing this is the `cppc_fie` DL task introduced by
commit 1eb5dde674f5 ("cpufreq: CPPC: Add support for frequency
invariance").

With CONFIG_ACPI_CPPC_CPUFREQ_FIE=y and schedutil cpufreq governor on
slow-switching system (like on this Ampere Altra WIWYNN Mt. Jade Arm
Server):

DL task `curr=sugov:112` lets `p=cppc_fie` migrate and since the latter
is in `non_contending` state, migrate_task_rq_dl() calls

  sub_running_bw()->__sub_running_bw()->cpufreq_update_util()->
  rq_clock()->assert_clock_updated()

on p.

Fix this by updating the clock for a non_contending task in
migrate_task_rq_dl() before calling sub_running_bw().

Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20210804135925.3734605-1-dietmar.eggemann@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9b2bb5f3ce09..beec5081a55a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1654,6 +1654,7 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 	 */
 	raw_spin_lock(&rq->lock);
 	if (p->dl.dl_non_contending) {
+		update_rq_clock(rq);
 		sub_running_bw(&p->dl, &rq->dl);
 		p->dl.dl_non_contending = 0;
 		/*
-- 
2.30.2



