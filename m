Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C4246C66
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgHQQPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbgHQQPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D407622CF7;
        Mon, 17 Aug 2020 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680917;
        bh=8vYg9VB/+RQNMzlHch8gpYo0lzW65j9Y2L692K7Wbcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0jBv+XEFHYGaBxptnDg117jqSP0M9C/aRbA8hgvgmwHvJwJrsLbZZr0eG5Dwpcs0
         5dyB0g8c5D5CAs6Or4nxi8BgA5adPREZSFu260WMia0fIciRr+m7amxgtWwxlBknr/
         OKOGNabFl+lFe/PENyXt2SFKOe/JoFs+DFc1z2Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shiganta@in.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Harish <harish@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/168] selftests/powerpc: Fix CPU affinity for child process
Date:   Mon, 17 Aug 2020 17:17:21 +0200
Message-Id: <20200817143739.184679793@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harish <harish@linux.ibm.com>

[ Upstream commit 854eb5022be04f81e318765f089f41a57c8e5d83 ]

On systems with large number of cpus, test fails trying to set
affinity by calling sched_setaffinity() with smaller size for affinity
mask. This patch fixes it by making sure that the size of allocated
affinity mask is dependent on the number of CPUs as reported by
get_nprocs().

Fixes: 00b7ec5c9cf3 ("selftests/powerpc: Import Anton's context_switch2 benchmark")
Reported-by: Shirisha Ganta <shiganta@in.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Harish <harish@linux.ibm.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Reviewed-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200609081423.529664-1-harish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../powerpc/benchmarks/context_switch.c       | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/powerpc/benchmarks/context_switch.c b/tools/testing/selftests/powerpc/benchmarks/context_switch.c
index 87f1f0252299f..9ec7674697b1e 100644
--- a/tools/testing/selftests/powerpc/benchmarks/context_switch.c
+++ b/tools/testing/selftests/powerpc/benchmarks/context_switch.c
@@ -23,6 +23,7 @@
 #include <limits.h>
 #include <sys/time.h>
 #include <sys/syscall.h>
+#include <sys/sysinfo.h>
 #include <sys/types.h>
 #include <sys/shm.h>
 #include <linux/futex.h>
@@ -108,8 +109,9 @@ static void start_thread_on(void *(*fn)(void *), void *arg, unsigned long cpu)
 
 static void start_process_on(void *(*fn)(void *), void *arg, unsigned long cpu)
 {
-	int pid;
-	cpu_set_t cpuset;
+	int pid, ncpus;
+	cpu_set_t *cpuset;
+	size_t size;
 
 	pid = fork();
 	if (pid == -1) {
@@ -120,14 +122,23 @@ static void start_process_on(void *(*fn)(void *), void *arg, unsigned long cpu)
 	if (pid)
 		return;
 
-	CPU_ZERO(&cpuset);
-	CPU_SET(cpu, &cpuset);
+	ncpus = get_nprocs();
+	size = CPU_ALLOC_SIZE(ncpus);
+	cpuset = CPU_ALLOC(ncpus);
+	if (!cpuset) {
+		perror("malloc");
+		exit(1);
+	}
+	CPU_ZERO_S(size, cpuset);
+	CPU_SET_S(cpu, size, cpuset);
 
-	if (sched_setaffinity(0, sizeof(cpuset), &cpuset)) {
+	if (sched_setaffinity(0, size, cpuset)) {
 		perror("sched_setaffinity");
+		CPU_FREE(cpuset);
 		exit(1);
 	}
 
+	CPU_FREE(cpuset);
 	fn(arg);
 
 	exit(0);
-- 
2.25.1



