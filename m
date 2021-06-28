Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB463B6034
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhF1OWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233327AbhF1OWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B015561C76;
        Mon, 28 Jun 2021 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889968;
        bh=+TRSkwqynGvow4YcvPMYfb1aTa2wCIrpixh1uDyMy6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyouYkqBbM5sO8B3OgTNplTha5M7FRN45092wSfLhPQ6gzRoRfv4Me4uTbGgZ0Rkn
         uNZK0QZFKhld7mO4OhL3LFtOStsycqwMl6SjFFEW96B9XVtItOP+bWHMOR0iGIr1Fr
         /cr4GzvNuZ7DHT6WjiqUCE3MJg9wCJvF2YqTI480QNLerCaeA8i5FO8bR/Cp1434wo
         aya870bah8pUwKK1idNzA5okgvsN0cM1v07vf5LQBSw/MDq8O45lBeMugXRyJO0G1f
         Lf4QspTLiX07kd5DAZ9lrLWYuIGgj9LXv7mHyRYiL/OdXtTdClSfKxiCVxcuBlHcKc
         /QCYXASwErLWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>, stable@kernel.org,
        Marius Hillenbrand <mhillen@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 069/110] s390/topology: clear thread/group maps for offline cpus
Date:   Mon, 28 Jun 2021 10:17:47 -0400
Message-Id: <20210628141828.31757-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 9e3d62d55bf455d4f9fdf2ede5c8756410c64102 upstream.

The current code doesn't clear the thread/group maps for offline
CPUs. This may cause kernel crashes like the one bewlow in common
code that assumes if a CPU has sibblings it is online.

Unable to handle kernel pointer dereference in virtual kernel address space

Call Trace:
 [<000000013a4b8c3c>] blk_mq_map_swqueue+0x10c/0x388
([<000000013a4b8bcc>] blk_mq_map_swqueue+0x9c/0x388)
 [<000000013a4b9300>] blk_mq_init_allocated_queue+0x448/0x478
 [<000000013a4b9416>] blk_mq_init_queue+0x4e/0x90
 [<000003ff8019d3e6>] loop_add+0x106/0x278 [loop]
 [<000003ff801b8148>] loop_init+0x148/0x1000 [loop]
 [<0000000139de4924>] do_one_initcall+0x3c/0x1e0
 [<0000000139ef449a>] do_init_module+0x6a/0x2a0
 [<0000000139ef61bc>] __do_sys_finit_module+0xa4/0xc0
 [<0000000139de9e6e>] do_syscall+0x7e/0xd0
 [<000000013a8e0aec>] __do_syscall+0xbc/0x110
 [<000000013a8ee2e8>] system_call+0x78/0xa0

Fixes: 52aeda7accb6 ("s390/topology: remove offline CPUs from CPU topology masks")
Cc: <stable@kernel.org> # 5.7+
Reported-by: Marius Hillenbrand <mhillen@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/topology.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index bfcc327acc6b..26aa2614ee35 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -66,7 +66,10 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 {
 	static cpumask_t mask;
 
-	cpumask_copy(&mask, cpumask_of(cpu));
+	cpumask_clear(&mask);
+	if (!cpu_online(cpu))
+		goto out;
+	cpumask_set_cpu(cpu, &mask);
 	switch (topology_mode) {
 	case TOPOLOGY_MODE_HW:
 		while (info) {
@@ -83,10 +86,10 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	default:
 		fallthrough;
 	case TOPOLOGY_MODE_SINGLE:
-		cpumask_copy(&mask, cpumask_of(cpu));
 		break;
 	}
 	cpumask_and(&mask, &mask, cpu_online_mask);
+out:
 	cpumask_copy(dst, &mask);
 }
 
@@ -95,7 +98,10 @@ static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 	static cpumask_t mask;
 	int i;
 
-	cpumask_copy(&mask, cpumask_of(cpu));
+	cpumask_clear(&mask);
+	if (!cpu_online(cpu))
+		goto out;
+	cpumask_set_cpu(cpu, &mask);
 	if (topology_mode != TOPOLOGY_MODE_HW)
 		goto out;
 	cpu -= cpu % (smp_cpu_mtid + 1);
-- 
2.30.2

