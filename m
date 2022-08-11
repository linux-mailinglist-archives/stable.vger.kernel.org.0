Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821FD58FFF9
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiHKPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiHKPfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EF6979CD;
        Thu, 11 Aug 2022 08:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B30F6163F;
        Thu, 11 Aug 2022 15:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632A7C4347C;
        Thu, 11 Aug 2022 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231987;
        bh=1Qs2y2PbMIKhwKxTrR95enieoWHXEukink0FVZNM5gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNF3DSUh8YeEan6sreapfeL8vC12QPZgfW7dkaQ4K4ATkoGOwbCQZEmLT4GldvTC0
         9fvi38c4xWAX6GjCMwrb2yVx1BNswGUOu27yZ0n7a6kDXsA50z4MrM3BncbEfhx8+p
         QCaeUbdEBo0TkRtfCshd9BjOHlueRr5YxLmI9q/78fySdL9fdz56fxST2QuQmogEN1
         L0+boc9lxxQwGfUddPDVXaaVM22Nu8eDZ5a1x/1pZvEYBIti4f7uWgAILqPD1W4yLP
         Ywb8T9KxneVbcp+UDSub+QL10l0q1tlqLOBGppSdQdZ5VnmGfGkU/WeNP69styWy3C
         U2Yd1HPGhNIeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dave@stgolabs.net,
        josh@joshtriplett.org, frederic@kernel.org,
        quic_neeraju@quicinc.com, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 041/105] rcuscale: Fix smp_processor_id()-in-preemptible warnings
Date:   Thu, 11 Aug 2022 11:27:25 -0400
Message-Id: <20220811152851.1520029-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit 92366810644d5675043c792abb70eaf974a77384 ]

Systems built with CONFIG_DEBUG_PREEMPT=y can trigger the following
BUG while running the rcuscale performance test:

BUG: using smp_processor_id() in preemptible [00000000] code: rcu_scale_write/69
CPU: 0 PID: 66 Comm: rcu_scale_write Not tainted 5.18.0-rc7-next-20220517-yoctodev-standard+
caller is debug_smp_processor_id+0x17/0x20
Call Trace:
<TASK>
dump_stack_lvl+0x49/0x5e
dump_stack+0x10/0x12
check_preemption_disabled+0xdf/0xf0
debug_smp_processor_id+0x17/0x20
rcu_scale_writer+0x2b5/0x580
kthread+0x177/0x1b0
ret_from_fork+0x22/0x30
</TASK>

Reproduction method:
runqemu kvm slirp nographic qemuparams="-m 4096 -smp 8" bootparams="isolcpus=2,3
nohz_full=2,3 rcu_nocbs=2,3 rcutree.dump_tree=1 rcuscale.shutdown=false
rcuscale.gp_async=true" -d

The problem is that the rcu_scale_writer() kthreads fail to set the
PF_NO_SETAFFINITY flags, which causes is_percpu_thread() to assume
that the kthread's affinity might change at any time, thus the BUG
noted above.

This commit therefore causes rcu_scale_writer() to set PF_NO_SETAFFINITY
in its kthread's ->flags field, thus preventing this BUG.

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 277a5bfb37d4..3ef02d4a8108 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -419,6 +419,7 @@ rcu_scale_writer(void *arg)
 	VERBOSE_SCALEOUT_STRING("rcu_scale_writer task started");
 	WARN_ON(!wdpp);
 	set_cpus_allowed_ptr(current, cpumask_of(me % nr_cpu_ids));
+	current->flags |= PF_NO_SETAFFINITY;
 	sched_set_fifo_low(current);
 
 	if (holdoff)
-- 
2.35.1

