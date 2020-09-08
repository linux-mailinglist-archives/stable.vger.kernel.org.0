Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE42618A6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgIHR6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731233AbgIHQM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C1E247DB;
        Tue,  8 Sep 2020 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580296;
        bh=LEXzpf0Yr1MJMeyZOqHXNeywTob//8NuwXE8+HwZI8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpsCUYKdm0jF8SJb/dCoRrjom57YFYzFP7EKGWaHZdDrU+bTJEt10IMg3G0pPBXHk
         ehf0XAAVuRue1r4etvAWph3EIhVcrXiYTPzTiUboJbICwPJtmdIOcw7QlzBhuWmCSE
         RTl+4UBtPbVVSXdMcaYWtH8vTfO26QJvIpPfPpAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marco Elver <elver@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/65] cpuidle: Fixup IRQ state
Date:   Tue,  8 Sep 2020 17:25:53 +0200
Message-Id: <20200908152217.457938642@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



