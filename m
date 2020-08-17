Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F19A247098
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390482AbgHQSMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbgHQQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C322173E;
        Mon, 17 Aug 2020 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680437;
        bh=LH5OljGL6OqdSL/Pn1EtWwpyw0uQjok4ZbN8mzzeWYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDEx5Wbai2hqi+6w3SPt0xTYYjVyCshJ3p3ukm2Om4S5R8Ydv6ma8DDs4F1womqa5
         aS8GG3DkB9Xyuso0GS0HsHoiOUAU5gp/KW6v3hr2lQrNdtpy24oGcNIfZw/5yT6fM2
         huYN3LP47h1f9gdUMsERcjvkBvzK2kl8Zi1DEVmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shiganta@in.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/270] selftests/powerpc: Fix online CPU selection
Date:   Mon, 17 Aug 2020 17:16:27 +0200
Message-Id: <20200817143805.084570904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index c02d24835db46..176102eca994c 100644
--- a/tools/testing/selftests/powerpc/utils.c
+++ b/tools/testing/selftests/powerpc/utils.c
@@ -16,6 +16,7 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
+#include <sys/sysinfo.h>
 #include <sys/types.h>
 #include <sys/utsname.h>
 #include <unistd.h>
@@ -88,28 +89,40 @@ void *get_auxv_entry(int type)
 
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



