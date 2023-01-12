Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0170966741F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjALOCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbjALOCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA8351333
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6282DB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F71C433EF;
        Thu, 12 Jan 2023 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532163;
        bh=x4jJklfXyiGG3hf/hgC+Km9UVMZm+1+hfK5jNklt75o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k15Y8I5PCbcwoBC9UWzyT5HN4XP3hODEVSVB9tDyL8/phcsNMk51gERhKusCnTHOR
         vpcyv4ZIc8XQcKwvVJNy/IYChFk0vAyBsJZPshOwW675CXj01gO3Kf1qzQwn/wg4F5
         eOgV4sA7U67zEbz/55OrSZRg6B2g95XJ2XOE8x3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/783] sched/fair: Cleanup task_util and capacity type
Date:   Thu, 12 Jan 2023 14:45:59 +0100
Message-Id: <20230112135526.133767526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit ef8df9798d469b7c45c66664550e93469749f1e8 ]

task_util and capacity are comparable unsigned long values. There is no
need for an intermidiate implicit signed cast.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211207095755.859972-1-vincent.donnefort@arm.com
Stable-dep-of: 48d5e9daa8b7 ("sched/uclamp: Fix relationship between uclamp and migration margin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bca0efc03a51..2d3ea0679207 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4074,7 +4074,8 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_se_tp(&p->se);
 }
 
-static inline int task_fits_capacity(struct task_struct *p, long capacity)
+static inline int task_fits_capacity(struct task_struct *p,
+				     unsigned long capacity)
 {
 	return fits_capacity(uclamp_task_util(p), capacity);
 }
@@ -6247,7 +6248,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	return best_cpu;
 }
 
-static inline bool asym_fits_capacity(int task_util, int cpu)
+static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 {
 	if (static_branch_unlikely(&sched_asym_cpucapacity))
 		return fits_capacity(task_util, capacity_of(cpu));
-- 
2.35.1



