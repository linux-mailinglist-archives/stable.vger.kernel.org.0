Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6D924B7C1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHTLEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbgHTKNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:13:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59D5206DA;
        Thu, 20 Aug 2020 10:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918392;
        bh=mRNhh1lWE0ACQJaCgePkAq8AsNjxTNJsNxwtcfDVRI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDEDLuEnfhqWtDR4R2sfe0IF+vhUHp8KkYEvQ3DS9PojI+OUShXNJi18Kj+kMv11X
         2/LjgPfBUKSEMCFa9oB5oW+kAR4SJNMBH/lN93WIV4KNdujAc7RauPx8Sc8+ZDILnb
         vAdGB/6t+MbwVU6cs1MMTehNzlznitVDA7N0lXcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shiganta@in.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/228] selftests/powerpc: Fix online CPU selection
Date:   Thu, 20 Aug 2020 11:21:38 +0200
Message-Id: <20200820091613.740372695@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit dfa03fff86027e58c8dba5c03ae68150d4e513ad ]

The size of the CPU affinity mask must be large enough for
systems with a very large number of CPUs. Otherwise, tests
which try to determine the first online CPU by calling
sched_getaffinity() will fail. This makes sure that the size
of the allocated affinity mask is dependent on the number of
CPUs as reported by get_nprocs_conf().

Fixes: 3752e453f6ba ("selftests/powerpc: Add tests of PMU EBBs")
Reported-by: Shirisha Ganta <shiganta@in.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a408c4b8e9a23bb39b539417a21eb0ff47bb5127.1596084858.git.sandipan@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/utils.c | 37 +++++++++++++++++--------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/powerpc/utils.c b/tools/testing/selftests/powerpc/utils.c
index d46916867a6fb..77db4f6ecf2f0 100644
--- a/tools/testing/selftests/powerpc/utils.c
+++ b/tools/testing/selftests/powerpc/utils.c
@@ -12,6 +12,7 @@
 #include <sched.h>
 #include <stdio.h>
 #include <sys/stat.h>
+#include <sys/sysinfo.h>
 #include <sys/types.h>
 #include <unistd.h>
 
@@ -81,26 +82,38 @@ void *get_auxv_entry(int type)
 
 int pick_online_cpu(void)
 {
-	cpu_set_t mask;
-	int cpu;
+	int ncpus, cpu = -1;
+	cpu_set_t *mask;
+	size_t size;
+
+	ncpus = get_nprocs_conf();
+	size = CPU_ALLOC_SIZE(ncpus);
+	mask = CPU_ALLOC(ncpus);
+	if (!mask) {
+		perror("malloc");
+		return -1;
+	}
 
-	CPU_ZERO(&mask);
+	CPU_ZERO_S(size, mask);
 
-	if (sched_getaffinity(0, sizeof(mask), &mask)) {
+	if (sched_getaffinity(0, size, mask)) {
 		perror("sched_getaffinity");
-		return -1;
+		goto done;
 	}
 
 	/* We prefer a primary thread, but skip 0 */
-	for (cpu = 8; cpu < CPU_SETSIZE; cpu += 8)
-		if (CPU_ISSET(cpu, &mask))
-			return cpu;
+	for (cpu = 8; cpu < ncpus; cpu += 8)
+		if (CPU_ISSET_S(cpu, size, mask))
+			goto done;
 
 	/* Search for anything, but in reverse */
-	for (cpu = CPU_SETSIZE - 1; cpu >= 0; cpu--)
-		if (CPU_ISSET(cpu, &mask))
-			return cpu;
+	for (cpu = ncpus - 1; cpu >= 0; cpu--)
+		if (CPU_ISSET_S(cpu, size, mask))
+			goto done;
 
 	printf("No cpus in affinity mask?!\n");
-	return -1;
+
+done:
+	CPU_FREE(mask);
+	return cpu;
 }
-- 
2.25.1



