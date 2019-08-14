Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217D28C8CD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfHNCeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbfHNCN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C283F214C6;
        Wed, 14 Aug 2019 02:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748836;
        bh=jFz9H79sZjWmVkHO5MLnulrsdTyKJipXmCmMda5fcvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPicoLpU8vdp4PVru8dNF6roqQZ7Z67CUGmIkOOV0+z4TBO4C8TcpTosmiCPbTTgG
         EaDgRwm7B/dGblHp6Dy24Z1780c7tUBQlJmi5t9WLozSoAJ++RTf+RE8IdhfQhuV8b
         QVi3JOxZZ4QQbr1BoCOXj9XhVLDt+Nn9PYbL0bJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 095/123] sched/psi: Reduce psimon FIFO priority
Date:   Tue, 13 Aug 2019 22:10:19 -0400
Message-Id: <20190814021047.14828-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 14f5c7b46a41a595fc61db37f55721714729e59e ]

PSI defaults to a FIFO-99 thread, reduce this to FIFO-1.

FIFO-99 is the very highest priority available to SCHED_FIFO and
it not a suitable default; it would indicate the psi work is the
most important work on the machine.

Since Real-Time tasks will have pre-allocated memory and locked it in
place, Real-Time tasks do not care about PSI. All it needs is to be
above OTHER.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7acc632c3b82b..7fe2c5fd26b54 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1051,7 +1051,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 
 	if (!rcu_access_pointer(group->poll_kworker)) {
 		struct sched_param param = {
-			.sched_priority = MAX_RT_PRIO - 1,
+			.sched_priority = 1,
 		};
 		struct kthread_worker *kworker;
 
-- 
2.20.1

