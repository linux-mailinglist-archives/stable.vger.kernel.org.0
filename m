Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476E9311082
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhBERQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhBEQAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C38B465072;
        Fri,  5 Feb 2021 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534383;
        bh=vm3Tf6PgpV/aRtwZ30Tdo+AbhfaHVugwMLr19Vq/+6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0IHYjXfVo/P2KRJhMqG/4yeI4U/Xg/dbhvSmaSIhTbHglKjhsvYKDTYAcV4r9DsO
         lT4ewVRp9UiYsUnxZ40uCsyXjq/LQeWy1ns9O7pGrZxM45ihjBdpDU0+ketBafwUcO
         dCmYm+Un7lnHi3FbfF7USegeoYLokek24XyshdFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/32] workqueue: Restrict affinity change to rescuer
Date:   Fri,  5 Feb 2021 15:07:47 +0100
Message-Id: <20210205140653.708479216@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
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
index 28e52657e0930..29c36c0290623 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1847,12 +1847,6 @@ static void worker_attach_to_pool(struct worker *worker,
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
@@ -1861,6 +1855,9 @@ static void worker_attach_to_pool(struct worker *worker,
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
+	if (worker->rescue_wq)
+		set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+
 	list_add_tail(&worker->node, &pool->workers);
 	worker->pool = pool;
 
-- 
2.27.0



