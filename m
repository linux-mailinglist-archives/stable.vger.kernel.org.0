Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9768B21FC5D
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbgGNStu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbgGNStt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D88222E9;
        Tue, 14 Jul 2020 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752589;
        bh=8loZ5vzd7dqeVhEOYV35bNDjrOFzthtoyhQ0z6NnDlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1i1/wWUZcYOtxSjOMx9Qj4jpK0dKeMvPr6xiuonJMT97i9r3Me/+89GepIFVW+oy
         6nD2QkXiLCSIhHfgc6ZrUPQOTy9WPvK283SfBrcO7GKhvveupp4CUDYlqDASBr7XQh
         1jGras1NeHeUyhRLpNb/b++7W2uhQzBfDHJPfwsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Wood <swood@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/109] sched/core: Check cpus_mask, not cpus_ptr in __set_cpus_allowed_ptr(), to fix mask corruption
Date:   Tue, 14 Jul 2020 20:43:37 +0200
Message-Id: <20200714184107.153892295@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

[ Upstream commit fd844ba9ae59b51e34e77105d79f8eca780b3bd6 ]

This function is concerned with the long-term CPU mask, not the
transitory mask the task might have while migrate disabled.  Before
this patch, if a task was migrate-disabled at the time
__set_cpus_allowed_ptr() was called, and the new mask happened to be
equal to the CPU that the task was running on, then the mask update
would be lost.

Signed-off-by: Scott Wood <swood@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20200617121742.cpxppyi7twxmpin7@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7238ef445dafb..8b3e99d095ae0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1649,7 +1649,7 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
 		goto out;
 	}
 
-	if (cpumask_equal(p->cpus_ptr, new_mask))
+	if (cpumask_equal(&p->cpus_mask, new_mask))
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
-- 
2.25.1



