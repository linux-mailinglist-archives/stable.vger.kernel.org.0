Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BF5901AC
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbiHKP5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbiHKPzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E8C98D1C;
        Thu, 11 Aug 2022 08:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8345616DD;
        Thu, 11 Aug 2022 15:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6A2C433D7;
        Thu, 11 Aug 2022 15:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232799;
        bh=JA5jE552whOpwIh8D7G53fLsA4DC4GfqgNq/8kF8PUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luTp5/IKEpHaMX9x0pYoUJo2BjJcbyFzJUizQFOnxe0HyDrol7PBLdwKyodHjvhTs
         ChY2kNWBOHUGzyUwz2a+TrLLvARjixApmQktJlnYY46rxEw55e0fepcfTewG2MFBrU
         zZzQRsHPcA4iRw0Qzlxd42MhYU35GxktEEnlgvd/RNs0m+D4ec/ZFetRFRWdT0knzB
         lWl73hlkgnf2UjTq6wj4Tbk1gSAclUiOpBlWx9XAOP27LS1JR44n4vIEQ4ULJISpXz
         cyg8I2AkFzUM6wlaHjuEPgWC15yvdSzbPHX87UcIRiAhzlAgBB/jDaWKykDQEOlb2U
         rUGNfZstJaikQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dave@stgolabs.net,
        josh@joshtriplett.org, frederic@kernel.org,
        quic_neeraju@quicinc.com, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 39/93] refscale: Convert test_lock spinlock to raw_spinlock
Date:   Thu, 11 Aug 2022 11:41:33 -0400
Message-Id: <20220811154237.1531313-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

[ Upstream commit 7bf336fb8dac718febb7bf4fe79e1be0c5e4a631 ]

In kernels built with CONFIG_PREEMPT_RT=y, spinlocks are replaced by
rt_mutex, which can sleep.  This means that acquiring a non-raw spinlock
in a critical section where preemption is disabled can trigger the
following BUG:

BUG: scheduling while atomic: ref_scale_reade/76/0x00000002
Preemption disabled at:
ref_lock_section+0x16/0x80
Call Trace:
<TASK>
dump_stack_lvl+0x5b/0x82
dump_stack+0x10/0x12
__schedule_bug.cold+0x9c/0xad
__schedule+0x839/0xc00
schedule_rtlock+0x22/0x40
rtlock_slowlock_locked+0x460/0x1350
rt_spin_lock+0x61/0xe0
ref_lock_section+0x29/0x80
rcu_scale_one_reader+0x52/0x60
ref_scale_reader+0x28d/0x490
kthread+0x128/0x150
ret_from_fork+0x22/0x30
</TASK>

This commit therefore converts spinlock to raw_spinlock.

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/refscale.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/refscale.c b/kernel/rcu/refscale.c
index 5489ff7f478e..12ee5fd6404e 100644
--- a/kernel/rcu/refscale.c
+++ b/kernel/rcu/refscale.c
@@ -365,7 +365,7 @@ static struct ref_scale_ops rwsem_ops = {
 };
 
 // Definitions for global spinlock
-static DEFINE_SPINLOCK(test_lock);
+static DEFINE_RAW_SPINLOCK(test_lock);
 
 static void ref_lock_section(const int nloops)
 {
@@ -373,8 +373,8 @@ static void ref_lock_section(const int nloops)
 
 	preempt_disable();
 	for (i = nloops; i >= 0; i--) {
-		spin_lock(&test_lock);
-		spin_unlock(&test_lock);
+		raw_spin_lock(&test_lock);
+		raw_spin_unlock(&test_lock);
 	}
 	preempt_enable();
 }
@@ -385,9 +385,9 @@ static void ref_lock_delay_section(const int nloops, const int udl, const int nd
 
 	preempt_disable();
 	for (i = nloops; i >= 0; i--) {
-		spin_lock(&test_lock);
+		raw_spin_lock(&test_lock);
 		un_delay(udl, ndl);
-		spin_unlock(&test_lock);
+		raw_spin_unlock(&test_lock);
 	}
 	preempt_enable();
 }
@@ -407,8 +407,8 @@ static void ref_lock_irq_section(const int nloops)
 
 	preempt_disable();
 	for (i = nloops; i >= 0; i--) {
-		spin_lock_irqsave(&test_lock, flags);
-		spin_unlock_irqrestore(&test_lock, flags);
+		raw_spin_lock_irqsave(&test_lock, flags);
+		raw_spin_unlock_irqrestore(&test_lock, flags);
 	}
 	preempt_enable();
 }
@@ -420,9 +420,9 @@ static void ref_lock_irq_delay_section(const int nloops, const int udl, const in
 
 	preempt_disable();
 	for (i = nloops; i >= 0; i--) {
-		spin_lock_irqsave(&test_lock, flags);
+		raw_spin_lock_irqsave(&test_lock, flags);
 		un_delay(udl, ndl);
-		spin_unlock_irqrestore(&test_lock, flags);
+		raw_spin_unlock_irqrestore(&test_lock, flags);
 	}
 	preempt_enable();
 }
-- 
2.35.1

