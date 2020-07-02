Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AADB2117FE
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgGBBYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgGBBYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:24:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B83320A8B;
        Thu,  2 Jul 2020 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653040;
        bh=HaAsKCWBBL9WhNvqzM/UEu6YzDDzbzsYTbpsywnQiY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8KZmcnxZSZDMddWJOm4jdvH8ipATT5WNxOIjZ1hdf7f3cNl89hLJu6cRWSir3iwM
         BaCc+PEh8DdMpXnm1jJnQoz/m4caPt5khSYpM41X0DY1BkGxRpTXHkpZ2lqrmgoNix
         GmjkotdGGoCDSKp82+mw5OowzGUlBcTMTwgxZPgU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Wood <swood@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 53/53] sched/core: Check cpus_mask, not cpus_ptr in __set_cpus_allowed_ptr(), to fix mask corruption
Date:   Wed,  1 Jul 2020 21:22:02 -0400
Message-Id: <20200702012202.2700645-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5eccfb816d23b..5f8130c27c7ab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1637,7 +1637,7 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
 		goto out;
 	}
 
-	if (cpumask_equal(p->cpus_ptr, new_mask))
+	if (cpumask_equal(&p->cpus_mask, new_mask))
 		goto out;
 
 	/*
-- 
2.25.1

