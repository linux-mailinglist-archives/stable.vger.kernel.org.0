Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED475378497
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhEJKxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhEJKwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC32C61961;
        Mon, 10 May 2021 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643249;
        bh=wulewUnb/jPqQ3O6/IZe+6GoO25VtwJfJi1sGBbkcSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfPuKnp/JFrK6f32rO8clUbwoB7LE6uFPAZj7zw+8Ps6yLzjN1/43Xlw1wd7vJjTF
         D0IhV0yIXsq9vOJIKoHjECIaT6zth9aRzaLBpZXsGR9qrhinYmBqLPqHLinDa4xaq4
         zaClW58etwYjtU4dHA0H5nlxzFJ0ZYXlTsKeJ9Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/299] sched,fair: Alternative sched_slice()
Date:   Mon, 10 May 2021 12:20:01 +0200
Message-Id: <20210510102011.679790795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 0c2de3f054a59f15e01804b75a04355c48de628c ]

The current sched_slice() seems to have issues; there's two possible
things that could be improved:

 - the 'nr_running' used for __sched_period() is daft when cgroups are
   considered. Using the RQ wide h_nr_running seems like a much more
   consistent number.

 - (esp) cgroups can slice it real fine, which makes for easy
   over-scheduling, ensure min_gran is what the name says.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210412102001.611897312@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c     | 12 +++++++++++-
 kernel/sched/features.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 481f4cc0958f..a0239649c741 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -700,7 +700,13 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
+	unsigned int nr_running = cfs_rq->nr_running;
+	u64 slice;
+
+	if (sched_feat(ALT_PERIOD))
+		nr_running = rq_of(cfs_rq)->cfs.h_nr_running;
+
+	slice = __sched_period(nr_running + !se->on_rq);
 
 	for_each_sched_entity(se) {
 		struct load_weight *load;
@@ -717,6 +723,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 		slice = __calc_delta(slice, se->load.weight, load);
 	}
+
+	if (sched_feat(BASE_SLICE))
+		slice = max(slice, (u64)sysctl_sched_min_granularity);
+
 	return slice;
 }
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 68d369cba9e4..f1bf5e12d889 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -90,3 +90,6 @@ SCHED_FEAT(WA_BIAS, true)
  */
 SCHED_FEAT(UTIL_EST, true)
 SCHED_FEAT(UTIL_EST_FASTUP, true)
+
+SCHED_FEAT(ALT_PERIOD, true)
+SCHED_FEAT(BASE_SLICE, true)
-- 
2.30.2



