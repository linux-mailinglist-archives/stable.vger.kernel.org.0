Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05C33831CF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhEQOlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240462AbhEQOiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1620A611EE;
        Mon, 17 May 2021 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261082;
        bh=4f5ImuLCx27GIWpCDz8Y4TtSbqGDF6WydHXlpM/QCWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeYKcOhZNRONGJJGpGNSaS731DbgBZ+h5eeTjNqXl6p6eL3qw+YkWAzDey3jKWCi1
         NygLvFDociixr/0jHKdECJBUWF5LmCZcHMZ4rURjhwpfnJSG6TL5cMC32SHiOZNMUF
         EPUJp4ue3D46JFem1KJwTdYponF3BwQZ6TAs/MxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 303/363] sched/fair: Fix clearing of has_idle_cores flag in select_idle_cpu()
Date:   Mon, 17 May 2021 16:02:49 +0200
Message-Id: <20210517140312.840169767@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

[ Upstream commit 02dbb7246c5bbbbe1607ebdc546ba5c454a664b1 ]

In commit:

  9fe1f127b913 ("sched/fair: Merge select_idle_core/cpu()")

in select_idle_cpu(), we check if an idle core is present in the LLC
of the target CPU via the flag "has_idle_cores". We look for the idle
core in select_idle_cores(). If select_idle_cores() isn't able to find
an idle core/CPU, we need to unset the has_idle_cores flag in the LLC
of the target to prevent other CPUs from going down this route.

However, the current code is unsetting it in the LLC of the current
CPU instead of the target CPU. This patch fixes this issue.

Fixes: 9fe1f127b913 ("sched/fair: Merge select_idle_core/cpu()")
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Link: https://lore.kernel.org/r/1620746169-13996-1-git-send-email-ego@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index edcabae5c658..a073a839cd06 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6212,7 +6212,7 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, bool
 	}
 
 	if (has_idle_core)
-		set_idle_cores(this, false);
+		set_idle_cores(target, false);
 
 	if (sched_feat(SIS_PROP) && !has_idle_core) {
 		time = cpu_clock(this) - time;
-- 
2.30.2



