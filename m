Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86D331139D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhBEVdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhBEPAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13A0B65096;
        Fri,  5 Feb 2021 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534433;
        bh=1k89zJ8A96JGdWr76zVyXMF9THo+ALt0kI6fj1pLBis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQVxuHFVGOQFULPoloPZoMD39YeQB6rrhhDZQth0Rs5P5Ur8zw0UNq5GARm7P1ZBJ
         2CcuGqiQY/pV8X+B/zL9zfy4o7RiW0MsAjQdMOLywRU7+mTMoTtsemGaeomfPT1x94
         NtOUzettgQqiP8Ky1ZDOFUSULPphFJE63jJhOxCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/17] workqueue: Restrict affinity change to rescuer
Date:   Fri,  5 Feb 2021 15:08:11 +0100
Message-Id: <20210205140650.501956817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 640f17c82460e9724fd256f0a1f5d99e7ff0bda4 ]

create_worker() will already set the right affinity using
kthread_bind_mask(), this means only the rescuer will need to change
it's affinity.

Howveer, while in cpu-hot-unplug a regular task is not allowed to run
on online&&!active as it would be pushed away quite agressively. We
need KTHREAD_IS_PER_CPU to survive in that environment.

Therefore set the affinity after getting that magic flag.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210121103506.826629830@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cd98ef48345e1..78600f97ffa72 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1728,12 +1728,6 @@ static void worker_attach_to_pool(struct worker *worker,
 {
 	mutex_lock(&wq_pool_attach_mutex);
 
-	/*
-	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
-	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
-	 */
-	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
-
 	/*
 	 * The wq_pool_attach_mutex ensures %POOL_DISASSOCIATED remains
 	 * stable across this function.  See the comments above the flag
@@ -1742,6 +1736,9 @@ static void worker_attach_to_pool(struct worker *worker,
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
+	if (worker->rescue_wq)
+		set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+
 	list_add_tail(&worker->node, &pool->workers);
 	worker->pool = pool;
 
-- 
2.27.0



