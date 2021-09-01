Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A8D3FDC69
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344480AbhIAMur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344153AbhIAMrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E49AE61181;
        Wed,  1 Sep 2021 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500014;
        bh=Xeinv4sBDNBrp2RkisG5hr/dvM4wPTkpnO7wSLSDEEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uxz944siCvc7nW7KOgw8MPmWLeyzO4Em/IXAfIlzPqpSgQswCy71DORh7VECvphV
         O7qHSrTlmUKj2Pn/FqENaBvxXeyuxXAZbbOkdewOHEGOGYFRaFOMIOAKsNOrMCSrB/
         Pmfuiu3arbyUpPDTqsZZaX662o8dPEOGdpF5RjaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/113] sched: Fix get_push_task() vs migrate_disable()
Date:   Wed,  1 Sep 2021 14:28:26 +0200
Message-Id: <20210901122304.360361281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit e681dcbaa4b284454fecd09617f8b24231448446 ]

push_rt_task() attempts to move the currently running task away if the
next runnable task has migration disabled and therefore is pinned on the
current CPU.

The current task is retrieved via get_push_task() which only checks for
nr_cpus_allowed == 1, but does not check whether the task has migration
disabled and therefore cannot be moved either. The consequence is a
pointless invocation of the migration thread which correctly observes
that the task cannot be moved.

Return NULL if the task has migration disabled and cannot be moved to
another CPU.

Fixes: a7c81556ec4d3 ("sched: Fix migrate_disable() vs rt/dl balancing")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210826133738.yiotqbtdaxzjsnfj@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 35f7efed75c4..f2bc99ca01e5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1977,6 +1977,9 @@ static inline struct task_struct *get_push_task(struct rq *rq)
 	if (p->nr_cpus_allowed == 1)
 		return NULL;
 
+	if (p->migration_disabled)
+		return NULL;
+
 	rq->push_busy = true;
 	return get_task_struct(p);
 }
-- 
2.30.2



