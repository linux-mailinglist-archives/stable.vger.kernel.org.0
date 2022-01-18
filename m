Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F54915A5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245255AbiARC3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343713AbiARC0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD3C061794;
        Mon, 17 Jan 2022 18:25:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 334506104B;
        Tue, 18 Jan 2022 02:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C5C36AF3;
        Tue, 18 Jan 2022 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472711;
        bh=lt6mIJfzkqvFPg0u6qu+wckvaEO9qenNedKzRuOJshc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOQk48UNsMjTotl+e18vkk2mK5zNK8mreMUzs7ln0ejpzhO22wCnTTB4gfE6ZuJdF
         5CAOzDt0d1NRvNmHm2rB6rewcqKigRoPsy80EBf6cdWNtGVCPpGXTjxHumWJDMnQVN
         iFjJNsv9uUmQC1pfOAn9X/kQMWqeQ1YwhxtyRMOQgIJY4jNPIT94gEig55nNcZdg35
         1AnQ/VBI2mAdEjgVEWvvmaLJxXRK1GoPRM2/r+xMWuiGnhrrXF1BjWiohsNJacAObP
         Dj2VvNxKDP9UvGtnbhPrrONYdVKlyFdFcndi9EtVjccvkBCHSZuZDtwy3sDAUA55CG
         T+zqwFtENq+9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wander Lairson Costa <wander@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dave@stgolabs.net,
        josh@joshtriplett.org, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 107/217] rcutorture: Avoid soft lockup during cpu stall
Date:   Mon, 17 Jan 2022 21:17:50 -0500
Message-Id: <20220118021940.1942199-107-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 5ff7c9f9d7e3e0f6db5b81945fa11b69d62f433a ]

If we use the module stall_cpu option, we may get a soft lockup warning
in case we also don't pass the stall_cpu_block option.

Introduce the stall_no_softlockup option to avoid a soft lockup on
cpu stall even if we don't use the stall_cpu_block option.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 8b410d982990c..05e4d6c28d1f5 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -46,6 +46,7 @@
 #include <linux/oom.h>
 #include <linux/tick.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/nmi.h>
 
 #include "rcu.h"
 
@@ -109,6 +110,8 @@ torture_param(int, shutdown_secs, 0, "Shutdown time (s), <= zero to disable.");
 torture_param(int, stall_cpu, 0, "Stall duration (s), zero to disable.");
 torture_param(int, stall_cpu_holdoff, 10,
 	     "Time to wait before starting stall (s).");
+torture_param(bool, stall_no_softlockup, false,
+	     "Avoid softlockup warning during cpu stall.");
 torture_param(int, stall_cpu_irqsoff, 0, "Disable interrupts while stalling.");
 torture_param(int, stall_cpu_block, 0, "Sleep while stalling.");
 torture_param(int, stall_gp_kthread, 0,
@@ -2052,6 +2055,8 @@ static int rcu_torture_stall(void *args)
 #else
 				schedule_timeout_uninterruptible(HZ);
 #endif
+			} else if (stall_no_softlockup) {
+				touch_softlockup_watchdog();
 			}
 		if (stall_cpu_irqsoff)
 			local_irq_enable();
-- 
2.34.1

