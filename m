Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F12E3ABD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403966AbgL1Nkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403959AbgL1Nkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D358D22582;
        Mon, 28 Dec 2020 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162798;
        bh=Oa20sEDdC1IawuHUg97xmiqF754hoTkKfQRSveJVtAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWkJ5ybXF0uBhgGgaAN28pjpzBY/aXFsEDMIUqGIL7pGu8r77kFUXqfNjJqdH5jIz
         I3m5gUGMMM3WfOpOHevO7kwjwhMHkQ6kAy++FbjRPmnh25yhZgvjXKsu+bprlxv4Oq
         lxUdx+r1xAcgm+KNESV8vgn86lSMrpa0QsEHbuGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/453] kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling
Date:   Mon, 28 Dec 2020 13:44:34 +0100
Message-Id: <20201228124939.089523372@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 8ff00399b153440c1c83e20c43020385b416415b ]

powerpc/64s keeps a counter in the mm which counts bits set in
mm_cpumask as well as other things. This means it can't use generic code
to clear bits out of the mask and doesn't adjust the arch specific
counter.

Add an arch override that allows powerpc/64s to use
clear_tasks_mm_cpumask().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201126102530.691335-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 7527825ac7daa..fa0e5727b4d9c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -815,6 +815,10 @@ void __init cpuhp_threads_init(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+#ifndef arch_clear_mm_cpumask_cpu
+#define arch_clear_mm_cpumask_cpu(cpu, mm) cpumask_clear_cpu(cpu, mm_cpumask(mm))
+#endif
+
 /**
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id
@@ -850,7 +854,7 @@ void clear_tasks_mm_cpumask(int cpu)
 		t = find_lock_task_mm(p);
 		if (!t)
 			continue;
-		cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
+		arch_clear_mm_cpumask_cpu(cpu, t->mm);
 		task_unlock(t);
 	}
 	rcu_read_unlock();
-- 
2.27.0



