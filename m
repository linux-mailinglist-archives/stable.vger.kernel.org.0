Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F016A327E
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjBZPsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBZPsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:48:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F23F1FE7;
        Sun, 26 Feb 2023 07:48:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19EB8B80C04;
        Sun, 26 Feb 2023 14:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C23C433A4;
        Sun, 26 Feb 2023 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423142;
        bh=fBzdyOtSe80tKomtAqPBp0f1/8evDFPPrN1ZHAxfBuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzyinWL/0FTDy3yE80bpb+IcsmFk5J1HNTiMn7JfArLAvHIdVUz+7TrsosVB/poNT
         MNKPC95h56X6LI9iu3Je3GbvViHqt4Pcuinuw/i/UwL1JyT6Pxxkc8sRpo5NDyigWI
         ZbGmgGqDPlxwbGdmfQP2dr+TFWMjk7woAnHS/VCoFbj0Phq6+K1oQQ2TPrWF9Hhgou
         CDiVsApXItQXe6QzF6fWh1YEzGWpjXrUfcwbc4yI4uV5iS1S4fLex/+Jsm+cZN3JxT
         r9gttmBI2CCDP49MBrERTsui/Yhj0QzahDx5GnBCvIWImfLwDcq05l86s3Y7Dr37JA
         qxuBWCYRJHL0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/13] rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()
Date:   Sun, 26 Feb 2023 09:52:04 -0500
Message-Id: <20230226145217.829485-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145217.829485-1-sashal@kernel.org>
References: <20230226145217.829485-1-sashal@kernel.org>
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
2.39.0

