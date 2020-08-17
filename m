Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6662246F28
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgHQRn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbgHQQP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:15:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A4D720657;
        Mon, 17 Aug 2020 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680922;
        bh=HNP5YsjeYvCkibwf/vdkO3tJFp2J2CqqDwIev630yO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fg0/sIRyd5NSOZA0VWveMx40qjSXUzYIm4NkZn934SymRj0pGCP0O2MqpkXQQxxuE
         2ZRbY+x5Scb6YWQu0eJm0TVn96LBmEMMbizLRl255NaPYiO/sgpaLjGD2UFbjtBaSb
         mwREOsJUIVeK+Fiw6bklzW/Sp0SNjzr43wVrWdiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shiganta@in.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/168] selftests/powerpc: Fix online CPU selection
Date:   Mon, 17 Aug 2020 17:17:23 +0200
Message-Id: <20200817143739.286039772@linuxfoundation.org>
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
index aa8fc1e6365bf..ba0959d454b3c 100644
--- a/tools/testing/selftests/powerpc/utils.c
+++ b/tools/testing/selftests/powerpc/utils.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/sysinfo.h>
 #include <sys/types.h>
 #include <sys/utsname.h>
 #include <unistd.h>
@@ -83,28 +84,40 @@ void *get_auxv_entry(int type)
 
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
 
 bool is_ppc64le(void)
-- 
2.25.1



