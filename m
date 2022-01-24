Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2581349947F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389021AbiAXUkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59758 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387145AbiAXUg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDB561506;
        Mon, 24 Jan 2022 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB22C340E5;
        Mon, 24 Jan 2022 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056586;
        bh=1XtZLBYLo8vRVDv6RwMfDJXo36eB71DbQs/OchA+8xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16H8C59woIAAolXgC7Zxhoop45LF4KPF4r2xvY3iaP1WIvuRgEltpJfoCGwcFqi6z
         3Rh0ax3QARyfQdbkkq550rFQMGkpf7JP4+hz4OUMEyG37TVL7bwZ914/ftPXqHjqm8
         r9vfXvIw0qCvcZTitp6bNHgnaO8kJvCFjIKiiLkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wander Lairson Costa <wander@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/846] rcutorture: Avoid soft lockup during cpu stall
Date:   Mon, 24 Jan 2022 19:40:49 +0100
Message-Id: <20220124184119.354074053@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 968696ace8f3f..f922937eb39ad 100644
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



