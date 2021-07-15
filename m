Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153BA3CAB05
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244509AbhGOTQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241208AbhGOTPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF1B6141A;
        Thu, 15 Jul 2021 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376297;
        bh=YMOxE68I2OG4nozWpiThawn1e5/WvDB4M0Ept09UuEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdERPuthXdG3zLALQz61D/2mGEdZRH27c3S52IohM3bTmbJ+H46WAi45Tnkler2xS
         EZ9SX+kRCRVRMDjBueYH+LxfWvWyPFSyYISgMQ6fjNCEbVkS7mdqyAu7H9mKwAA1qx
         3GFUKmx8PkBJsWhc/XwTvMtZ8aZHZ4feg0DoOuwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 169/266] sched/fair: Ensure _sum and _avg values stay consistent
Date:   Thu, 15 Jul 2021 20:38:44 +0200
Message-Id: <20210715182642.201036677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit 1c35b07e6d3986474e5635be566e7bc79d97c64d ]

The _sum and _avg values are in general sync together with the PELT
divider. They are however not always completely in perfect sync,
resulting in situations where _sum gets to zero while _avg stays
positive. Such situations are undesirable.

This comes from the fact that PELT will increase period_contrib, also
increasing the PELT divider, without updating _sum and _avg values to
stay in perfect sync where (_sum == _avg * divider). However, such PELT
change will never lower _sum, making it impossible to end up in a
situation where _sum is zero and _avg is not.

Therefore, we need to ensure that when subtracting load outside PELT,
that when _sum is zero, _avg is also set to zero. This occurs when
(_sum < _avg * divider), and the subtracted (_avg * divider) is bigger
or equal to the current _sum, while the subtracted _avg is smaller than
the current _avg.

Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20210624111815.57937-1-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e807b743353d..7dd0d859d95b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3716,15 +3716,15 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 
 		r = removed_load;
 		sub_positive(&sa->load_avg, r);
-		sub_positive(&sa->load_sum, r * divider);
+		sa->load_sum = sa->load_avg * divider;
 
 		r = removed_util;
 		sub_positive(&sa->util_avg, r);
-		sub_positive(&sa->util_sum, r * divider);
+		sa->util_sum = sa->util_avg * divider;
 
 		r = removed_runnable;
 		sub_positive(&sa->runnable_avg, r);
-		sub_positive(&sa->runnable_sum, r * divider);
+		sa->runnable_sum = sa->runnable_avg * divider;
 
 		/*
 		 * removed_runnable is the unweighted version of removed_load so we
-- 
2.30.2



