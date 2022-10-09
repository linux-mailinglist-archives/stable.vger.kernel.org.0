Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05975F8DF9
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiJIUv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiJIUvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:51:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FA32AE3C;
        Sun,  9 Oct 2022 13:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CA87B80D88;
        Sun,  9 Oct 2022 20:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F2DC433C1;
        Sun,  9 Oct 2022 20:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348706;
        bh=KtOimJEUmu2cKvDrqJBAkgIu9g2nL2KNT4iMyYvQITM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv3IR+YCYjRVtNCvEiS2SmobLzt0FEu3vpZTFSn51jXXXSJ2drCuJKYuWe23twnqE
         WrqgSwM9cI+c2lRRImaSMxXamKZSHXAZfqMzyTMLKso0MbpdkLxOeTDWmAYNRsSnPo
         CMmcMnn86fHciT51kuYQmrQUp/kpr0cb8G8reSPklaH4sj7rCe9/OHQn8MQeYf+V7g
         u0a7LEDG90TU7xTNdrFHOQfArWNNnSR2Fn7ivBWqSkHIhGprZ1DjlDHgpgrj7/mTiB
         NFD0TI9mU9xy+l+v/f/Setvv2WHtap3fUc8BmSeEfdr1SDCObrcFXOIBQe5j6jFZ2M
         N8ucxE5rKn0RA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 05/18] rcu-tasks: Ensure RCU Tasks Trace loops have quiescent states
Date:   Sun,  9 Oct 2022 16:51:22 -0400
Message-Id: <20221009205136.1201774-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit d6ad60635cafe900bcd11ad588d8accb36c36b1b ]

The RCU Tasks Trace grace-period kthread loops across all CPUs, and
there can be quite a few CPUs, with some commercially available systems
sporting well over a thousand of them.  Some of these loops can feature
IPIs, which can take some time.  This commit therefore places a call to
cond_resched_tasks_rcu_qs() in each such loop.

Link: https://docs.google.com/document/d/1V0YnG1HTWMt9WHJjroiJL9lf-hMrud4v8Fn3fhyY0cI/edit?usp=sharing
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 469bf2a3b505..f5bf6fb430da 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1500,6 +1500,7 @@ static void rcu_tasks_trace_pregp_step(struct list_head *hop)
 		if (rcu_tasks_trace_pertask_prep(t, true))
 			trc_add_holdout(t, hop);
 		rcu_read_unlock();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Only after all running tasks have been accounted for is it
@@ -1520,6 +1521,7 @@ static void rcu_tasks_trace_pregp_step(struct list_head *hop)
 			raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
 		}
 		raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Re-enable CPU hotplug now that the holdout list is populated.
@@ -1619,6 +1621,7 @@ static void check_all_holdout_tasks_trace(struct list_head *hop,
 			trc_del_holdout(t);
 		else if (needreport)
 			show_stalled_task_trace(t, firstreport);
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Re-enable CPU hotplug now that the holdout list scan has completed.
-- 
2.35.1

