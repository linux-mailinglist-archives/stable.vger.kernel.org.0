Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8597D68301E
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjAaPAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjAaPAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDEC10242;
        Tue, 31 Jan 2023 07:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9891FB81D47;
        Tue, 31 Jan 2023 15:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71DDC433D2;
        Tue, 31 Jan 2023 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177199;
        bh=RQvz+kH4LSpL35lxAqi+Bd7/BNj1sjnMI557/UDZ4Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t61vNDWJ73cDh57S9yQssQcbk/N3doobODJbagkD9zl1wFdyMqklZXn/l34/kxoKC
         LOXMtWehxGYRmBs40yYQw0kjHj/YulR2iOP0ag50dxbcFoGnd5yIdkYjXBtddYtm97
         9FNcQh2pgDrcFGQLMB6W4kDi9wH/WyFBJMJwtV1QuL8LNTBcA110xRpU5YKHE7A3Ql
         Mn9JHPmDSNo9/68PwZViMIdtuuIlROCEXnHVFUYLeqlesHX6wmo7kw1In5u0pAEuZv
         tdCkB20KXIbzgv1Ug9Wj7r5sI4yO4beK1Y5hRRpw9vpKRdH80EDY77i1UlEp73qolD
         bDxcj4v33P0gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yair Podemsky <ypodemsk@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, rafael.j.wysocki@intel.com, paulmck@kernel.org,
        frederic@kernel.org
Subject: [PATCH AUTOSEL 6.1 04/20] x86/aperfmperf: Erase stale arch_freq_scale values when disabling frequency invariance readings
Date:   Tue, 31 Jan 2023 09:59:30 -0500
Message-Id: <20230131145946.1249850-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
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

From: Yair Podemsky <ypodemsk@redhat.com>

[ Upstream commit 5f5cc9ed992cbab6361f198966f0edba5fc52688 ]

Once disable_freq_invariance_work is called the scale_freq_tick function
will not compute or update the arch_freq_scale values.
However the scheduler will still read these values and use them.
The result is that the scheduler might perform unfair decisions based on stale
values.

This patch adds the step of setting the arch_freq_scale values for all
cpus to the default (max) value SCHED_CAPACITY_SCALE, Once all cpus
have the same arch_freq_scale value the scaling is meaningless.

Signed-off-by: Yair Podemsky <ypodemsk@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230110160206.75912-1-ypodemsk@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/aperfmperf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 1f60a2b27936..fdbb5f07448f 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -330,7 +330,16 @@ static void __init bp_init_freq_invariance(void)
 
 static void disable_freq_invariance_workfn(struct work_struct *work)
 {
+	int cpu;
+
 	static_branch_disable(&arch_scale_freq_key);
+
+	/*
+	 * Set arch_freq_scale to a default value on all cpus
+	 * This negates the effect of scaling
+	 */
+	for_each_possible_cpu(cpu)
+		per_cpu(arch_freq_scale, cpu) = SCHED_CAPACITY_SCALE;
 }
 
 static DECLARE_WORK(disable_freq_invariance_work,
-- 
2.39.0

