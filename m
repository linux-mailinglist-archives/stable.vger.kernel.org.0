Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132B86A3005
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBZOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBZOpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:45:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BEE126E5;
        Sun, 26 Feb 2023 06:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBDA960C17;
        Sun, 26 Feb 2023 14:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8202BC4339E;
        Sun, 26 Feb 2023 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422699;
        bh=hidf1LCxSl9/1F8ZVMb+D+asQX2snZDriZhMM69zhno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDKVM/9UyUq15Qqd2TustFtF/XIeZZpXdwEIG9mjJTCFCSk+E7NT/woO8Cgb+y9WT
         5bB1DDr7plQpPr9RIVPvIkjsz8ppKszlqNDR5jx7EJ93oBcGAAz2V/q3zloxLC2d6o
         DoFzr3frnfUDAYEMSw9ErjzoQLQICAzyUasGcb0kR+NpusN4q3G1AXfrStceQxIh9k
         GNQ5Jn6IqeVK/u/22xZ77VLXlV8HUC0nuivAxTaXq5O/oXCSirSFehB6phv0L56+d0
         aA1bkqrE3ijawt0z7tFL3ZSjCdiA+mK4VF4OCRnvExO/11+sNk2Sgsa/9A9q2KWTJJ
         qbGLcGT4xFXbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 05/53] rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()
Date:   Sun, 26 Feb 2023 09:43:57 -0500
Message-Id: <20230226144446.824580-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
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

[ Upstream commit 2d7f00b2f01301d6e41fd4a28030dab0442265be ]

The normal grace period's RCU CPU stall warnings are invoked from the
scheduling-clock interrupt handler, and can thus invoke smp_processor_id()
with impunity, which allows them to directly invoke dump_cpu_task().
In contrast, the expedited grace period's RCU CPU stall warnings are
invoked from process context, which causes the dump_cpu_task() function's
calls to smp_processor_id() to complain bitterly in debug kernels.

This commit therefore causes synchronize_rcu_expedited_wait() to disable
preemption around its call to dump_cpu_task().

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_exp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index ed6c3cce28f23..927abaf6c822e 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -667,7 +667,9 @@ static void synchronize_rcu_expedited_wait(void)
 				mask = leaf_node_cpu_bit(rnp, cpu);
 				if (!(READ_ONCE(rnp->expmask) & mask))
 					continue;
+				preempt_disable(); // For smp_processor_id() in dump_cpu_task().
 				dump_cpu_task(cpu);
+				preempt_enable();
 			}
 		}
 		jiffies_stall = 3 * rcu_exp_jiffies_till_stall_check() + 3;
-- 
2.39.0

