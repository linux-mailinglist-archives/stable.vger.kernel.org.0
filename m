Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3556F1481F5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391219AbgAXLYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391401AbgAXLYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BC2206D4;
        Fri, 24 Jan 2020 11:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865047;
        bh=6quDXAEcDFWwvkH1NVh1WWRbSlIvzWXMFot7EM9sOwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu1ufpgckEGtYnSImXtgvQxlNjp2owSkd8NlUzqq5Ru7ngCpI6UX1Kykr3hne++DF
         wcL5aqHPHT4B+xdz/T2HW9awbS2NS+XeOpRGkf7RHNWKNXCahyKxkDnFdKgQbyjD5L
         FGyGdpOliRdjMLjhRdvEiGuemGJ+OMAY9wcQPar0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 430/639] powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild
Date:   Fri, 24 Jan 2020 10:30:00 +0100
Message-Id: <20200124093140.873383873@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit d4aa219a074a5abaf95a756b9f0d190b5c03a945 ]

Allow external callers to force the cacheinfo code to release all its
references to cache nodes, e.g. before processing device tree updates
post-migration, and to rebuild the hierarchy afterward.

CPU online/offline must be blocked by callers; enforce this.

Fixes: 410bccf97881 ("powerpc/pseries: Partition migration in the kernel")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/cacheinfo.c | 21 +++++++++++++++++++++
 arch/powerpc/kernel/cacheinfo.h |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index a8f20e5928e13..9edb454301336 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -865,4 +865,25 @@ void cacheinfo_cpu_offline(unsigned int cpu_id)
 	if (cache)
 		cache_cpu_clear(cache, cpu_id);
 }
+
+void cacheinfo_teardown(void)
+{
+	unsigned int cpu;
+
+	lockdep_assert_cpus_held();
+
+	for_each_online_cpu(cpu)
+		cacheinfo_cpu_offline(cpu);
+}
+
+void cacheinfo_rebuild(void)
+{
+	unsigned int cpu;
+
+	lockdep_assert_cpus_held();
+
+	for_each_online_cpu(cpu)
+		cacheinfo_cpu_online(cpu);
+}
+
 #endif /* (CONFIG_PPC_PSERIES && CONFIG_SUSPEND) || CONFIG_HOTPLUG_CPU */
diff --git a/arch/powerpc/kernel/cacheinfo.h b/arch/powerpc/kernel/cacheinfo.h
index 955f5e999f1b8..52bd3fc6642da 100644
--- a/arch/powerpc/kernel/cacheinfo.h
+++ b/arch/powerpc/kernel/cacheinfo.h
@@ -6,4 +6,8 @@
 extern void cacheinfo_cpu_online(unsigned int cpu_id);
 extern void cacheinfo_cpu_offline(unsigned int cpu_id);
 
+/* Allow migration/suspend to tear down and rebuild the hierarchy. */
+extern void cacheinfo_teardown(void);
+extern void cacheinfo_rebuild(void);
+
 #endif /* _PPC_CACHEINFO_H */
-- 
2.20.1



