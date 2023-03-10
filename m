Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46796B4414
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjCJOVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjCJOUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:20:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301CD11F6B0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:19:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A3D61380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3971C433EF;
        Fri, 10 Mar 2023 14:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457970;
        bh=5IMOn9v6wq2NhZdJfiIb19wEI8llyEQTfS9XDjFSoeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIcUpwG08n6wdZo9B24uk3pcwiEnfdIF+dbCP3T2U1cpOxC/uW37HPImOnM+Yz0Sk
         m2CKeqBRq+nyYilYj4rVEyCiKcl5u9UtSSSePPIYirqUduoEdtRFhdSP2Dz79TfSNW
         mtu4CCFCmHZxIzZvZ0kAiNjTqRXVeW38jyHsNDhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/252] rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()
Date:   Fri, 10 Mar 2023 14:38:08 +0100
Message-Id: <20230310133722.359470873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

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
index 72770a551c24d..fa6ae9ed2e1df 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -577,7 +577,9 @@ static void synchronize_sched_expedited_wait(struct rcu_state *rsp)
 				mask = leaf_node_cpu_bit(rnp, cpu);
 				if (!(rnp->expmask & mask))
 					continue;
+				preempt_disable(); // For smp_processor_id() in dump_cpu_task().
 				dump_cpu_task(cpu);
+				preempt_enable();
 			}
 		}
 		jiffies_stall = 3 * rcu_jiffies_till_stall_check() + 3;
-- 
2.39.2



