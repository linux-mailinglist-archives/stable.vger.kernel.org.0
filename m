Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61704FD9F7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354213AbiDLHid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353580AbiDLHZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413F43AE4;
        Tue, 12 Apr 2022 00:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED0460B2E;
        Tue, 12 Apr 2022 07:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C05C385A6;
        Tue, 12 Apr 2022 07:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746907;
        bh=YiaJDBbTcuhQHMi1q1uJq5SwFO2vcgROG+bHHXW7V2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOaR6hY8Bc/z49kFiI34yVD2ajrvI1bMOFP2Euqu9jCap5cnEH763JsPtgfHZVh3A
         jmK9INguS4RS9kePAID5BFi4zZT9r5FDYESFz8TP7xSjDW8ziDogLitxCltWwlNLtN
         jvPCgXGzU3g8kzPipAzxTcOb3bk/ZPwrw1jL0nPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 174/285] arch/arm64: Fix topology initialization for core scheduling
Date:   Tue, 12 Apr 2022 08:30:31 +0200
Message-Id: <20220412062948.690247666@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Phil Auld <pauld@redhat.com>

[ Upstream commit 5524cbb1bfcdff0cad0aaa9f94e6092002a07259 ]

Arm64 systems rely on store_cpu_topology() to call update_siblings_masks()
to transfer the toplogy to the various cpu masks. This needs to be done
before the call to notify_cpu_starting() which tells the scheduler about
each cpu found, otherwise the core scheduling data structures are setup
in a way that does not match the actual topology.

With smt_mask not setup correctly we bail on `cpumask_weight(smt_mask) == 1`
for !leaders in:

 notify_cpu_starting()
   cpuhp_invoke_callback_range()
     sched_cpu_starting()
       sched_core_cpu_starting()

which leads to rq->core not being correctly set for !leader-rq's.

Without this change stress-ng (which enables core scheduling in its prctl
tests in newer versions -- i.e. with PR_SCHED_CORE support) causes a warning
and then a crash (trimmed for legibility):

[ 1853.805168] ------------[ cut here ]------------
[ 1853.809784] task_rq(b)->core != rq->core
[ 1853.809792] WARNING: CPU: 117 PID: 0 at kernel/sched/fair.c:11102 cfs_prio_less+0x1b4/0x1c4
...
[ 1854.015210] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
...
[ 1854.231256] Call trace:
[ 1854.233689]  pick_next_task+0x3dc/0x81c
[ 1854.237512]  __schedule+0x10c/0x4cc
[ 1854.240988]  schedule_idle+0x34/0x54

Fixes: 9edeaea1bc45 ("sched: Core-wide rq->lock")
Signed-off-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20220331153926.25742-1-pauld@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 27df5c1e6baa..3b46041f2b97 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -234,6 +234,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * Log the CPU info before it is marked online and might get read.
 	 */
 	cpuinfo_store_cpu();
+	store_cpu_topology(cpu);
 
 	/*
 	 * Enable GIC and timers.
@@ -242,7 +243,6 @@ asmlinkage notrace void secondary_start_kernel(void)
 
 	ipi_setup(cpu);
 
-	store_cpu_topology(cpu);
 	numa_add_cpu(cpu);
 
 	/*
-- 
2.35.1



