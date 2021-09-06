Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AFA401446
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbhIFBcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346053AbhIFB3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 228EF611CB;
        Mon,  6 Sep 2021 01:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891412;
        bh=XJmhHQaf6F94Wuqmt+mFIFYZwfjS1+6Hn/BccfhRFCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHleTAGQMjENFJcp8xeoK/Jmg3uqyqvE1oti07wNLtkFlfqgRn3ATNfGqJ3tPGy7A
         LFdBZ9JQs8A2li8GP068Ba7vCHOEFE8/GDjh9M5BUbey8BJd0k9xB0+3C/sNPtal8n
         YcP19gO/RXsvMDcd1f/nLIi0aP6iJL/9PSXtn9NO9TsYhk6u7dHznAQV/qx0bXHVhH
         cR78uQsmFVaWb+r3A134r+QqV5VziTjwWHHwnwbAliU5LcEJwf47wFK7XoZ2Jto7mR
         bP9joFV9ttDkzr0VD4c3FdIzssZQgIXULgVFfhhOuB4scD6ujHBRvfvP6VmD3aukcq
         F8o0kofq6sciw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 07/23] sched/deadline: Fix missing clock update in migrate_task_rq_dl()
Date:   Sun,  5 Sep 2021 21:23:06 -0400
Message-Id: <20210906012322.930668-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

