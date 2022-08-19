Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40059A32A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353570AbiHSQm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353315AbiHSQkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB806FAC7F;
        Fri, 19 Aug 2022 09:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11DCA61835;
        Fri, 19 Aug 2022 16:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D752C433D6;
        Fri, 19 Aug 2022 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925258;
        bh=K+emOYHNQWqJh5sMA1kjgcBGz3OpadQdHQLQLTykXtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZxqe1wKDNvuQEYD9rgVj8DIbtiRbxn5SvNUlI4YSqgtYVC9tpAlyMHoPiXHrujAp
         Gm1uUuTW1Eb30UhLGVr6PREUEQbg0jy/cAoiJjbRFdHKgU75L4HTH3L7/U8rD+rjA8
         dIW16KZ5GW6VpNXKbq34IFxrnzreleFUEGQWavlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentin Schneider <vschneid@redhat.com>,
        Tianchen Ding <dtcccc@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/545] sched: Fix the check of nr_running at queue wakelist
Date:   Fri, 19 Aug 2022 17:43:24 +0200
Message-Id: <20220819153848.838226872@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 28156108fecb1f808b21d216e8ea8f0d205a530c ]

The commit 2ebb17717550 ("sched/core: Offload wakee task activation if it
the wakee is descheduling") checked rq->nr_running <= 1 to avoid task
stacking when WF_ON_CPU.

Per the ordering of writes to p->on_rq and p->on_cpu, observing p->on_cpu
(WF_ON_CPU) in ttwu_queue_cond() implies !p->on_rq, IOW p has gone through
the deactivate_task() in __schedule(), thus p has been accounted out of
rq->nr_running. As such, the task being the only runnable task on the rq
implies reading rq->nr_running == 0 at that point.

The benchmark result is in [1].

[1] https://lore.kernel.org/all/e34de686-4e85-bde1-9f3c-9bbc86b38627@linux.alibaba.com/

Suggested-by: Valentin Schneider <vschneid@redhat.com>
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20220608233412.327341-2-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8765de76a179..649440107cae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2671,8 +2671,12 @@ static inline bool ttwu_queue_cond(int cpu, int wake_flags)
 	 * CPU then use the wakelist to offload the task activation to
 	 * the soon-to-be-idle CPU as the current CPU is likely busy.
 	 * nr_running is checked to avoid unnecessary task stacking.
+	 *
+	 * Note that we can only get here with (wakee) p->on_rq=0,
+	 * p->on_cpu can be whatever, we've done the dequeue, so
+	 * the wakee has been accounted out of ->nr_running.
 	 */
-	if ((wake_flags & WF_ON_CPU) && cpu_rq(cpu)->nr_running <= 1)
+	if ((wake_flags & WF_ON_CPU) && !cpu_rq(cpu)->nr_running)
 		return true;
 
 	return false;
-- 
2.35.1



