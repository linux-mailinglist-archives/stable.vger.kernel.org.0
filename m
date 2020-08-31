Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB8E257CDC
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgHaPbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgHaPbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A888521655;
        Mon, 31 Aug 2020 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887906;
        bh=LEXzpf0Yr1MJMeyZOqHXNeywTob//8NuwXE8+HwZI8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZATA1DhIiaYK2nobtRN3xHpkmhEJYrVbQGzXEBz8qLE0aRnD71N5uCz1dPQSR8X3
         3OK+DiMoAzXWChMgtowi0Pgq26cXKHfdEhZtxb6Niuh39T2RUTREc7k4w8PJTf/SuL
         yqV8Vok0UAlrdj87uGpNyLfQQA3tprCqeR1eArW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Marco Elver <elver@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/9] cpuidle: Fixup IRQ state
Date:   Mon, 31 Aug 2020 11:31:34 -0400
Message-Id: <20200831153136.1024676-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153136.1024676-1-sashal@kernel.org>
References: <20200831153136.1024676-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 49d9c5936314e44d314c605c39cce0fd947f9c3a ]

Match the pattern elsewhere in this file.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lkml.kernel.org/r/20200821085348.251340558@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ed4df58a855e1..da9eb38d79d9c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -144,7 +144,8 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
 	 */
 	stop_critical_timings();
 	drv->states[index].enter_s2idle(dev, drv, index);
-	WARN_ON(!irqs_disabled());
+	if (WARN_ON_ONCE(!irqs_disabled()))
+		local_irq_disable();
 	/*
 	 * timekeeping_resume() that will be called by tick_unfreeze() for the
 	 * first CPU executing it calls functions containing RCU read-side
-- 
2.25.1

