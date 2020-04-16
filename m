Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF41AC2D3
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896803AbgDPNdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896794AbgDPNdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:33:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80D0221EB;
        Thu, 16 Apr 2020 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044030;
        bh=JuRk7IwZErEkQs154JWgYaEIehaHU2r9Jj03bNGW2qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpKTnkXArQkIV8Fvy+cvXyTvNEl5eVSRZjfgZ+YU64ykIXslgEfje9GJdybz0DgPh
         jPah3rX6BK/OF18Di/isO19vEZWRVdUsk4sRLMDasL5Fv/jWOG1b60l6WC5m0lB/69
         DWoiZDePI7kCpjpikxRUWAYy7sf04IqWghYY/P+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 052/257] sched: Avoid scale real weight down to zero
Date:   Thu, 16 Apr 2020 15:21:43 +0200
Message-Id: <20200416131332.452089698@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Wang <yun.wang@linux.alibaba.com>

[ Upstream commit 26cf52229efc87e2effa9d788f9b33c40fb3358a ]

During our testing, we found a case that shares no longer
working correctly, the cgroup topology is like:

  /sys/fs/cgroup/cpu/A		(shares=102400)
  /sys/fs/cgroup/cpu/A/B	(shares=2)
  /sys/fs/cgroup/cpu/A/B/C	(shares=1024)

  /sys/fs/cgroup/cpu/D		(shares=1024)
  /sys/fs/cgroup/cpu/D/E	(shares=1024)
  /sys/fs/cgroup/cpu/D/E/F	(shares=1024)

The same benchmark is running in group C & F, no other tasks are
running, the benchmark is capable to consumed all the CPUs.

We suppose the group C will win more CPU resources since it could
enjoy all the shares of group A, but it's F who wins much more.

The reason is because we have group B with shares as 2, since
A->cfs_rq.load.weight == B->se.load.weight == B->shares/nr_cpus,
so A->cfs_rq.load.weight become very small.

And in calc_group_shares() we calculate shares as:

  load = max(scale_load_down(cfs_rq->load.weight), cfs_rq->avg.load_avg);
  shares = (tg_shares * load) / tg_weight;

Since the 'cfs_rq->load.weight' is too small, the load become 0
after scale down, although 'tg_shares' is 102400, shares of the se
which stand for group A on root cfs_rq become 2.

While the se of D on root cfs_rq is far more bigger than 2, so it
wins the battle.

Thus when scale_load_down() scale real weight down to 0, it's no
longer telling the real story, the caller will have the wrong
information and the calculation will be buggy.

This patch add check in scale_load_down(), so the real weight will
be >= MIN_SHARES after scale, after applied the group C wins as
expected.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/38e8e212-59a1-64b2-b247-b6d0b52d8dc1@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 280a3c7359355..0502ea8e0e62a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -118,7 +118,13 @@ extern long calc_load_fold_active(struct rq *this_rq, long adjust);
 #ifdef CONFIG_64BIT
 # define NICE_0_LOAD_SHIFT	(SCHED_FIXEDPOINT_SHIFT + SCHED_FIXEDPOINT_SHIFT)
 # define scale_load(w)		((w) << SCHED_FIXEDPOINT_SHIFT)
-# define scale_load_down(w)	((w) >> SCHED_FIXEDPOINT_SHIFT)
+# define scale_load_down(w) \
+({ \
+	unsigned long __w = (w); \
+	if (__w) \
+		__w = max(2UL, __w >> SCHED_FIXEDPOINT_SHIFT); \
+	__w; \
+})
 #else
 # define NICE_0_LOAD_SHIFT	(SCHED_FIXEDPOINT_SHIFT)
 # define scale_load(w)		(w)
-- 
2.20.1



