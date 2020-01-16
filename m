Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A7113F4CB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbgAPSvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387921AbgAPRIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E0A2467C;
        Thu, 16 Jan 2020 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194525;
        bh=qXcDlE2DPQQ8J4GRdU74EnWdqMEs2DTcyMuubdAScgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ6/xU5HnomLKJdntBOc1zNlHP70fCAQVEydrWy1N3Fn5U/gGxds4iqP7/TmC8aZC
         re9BF9MytLcjsI/PA9GTosKMONnOl772rRBdIzSA/y9qzI/zzuDduLlYZ2ZO4aSl6r
         2WNwEKP7xC3WVDa5TmDdxCQPPgrxcsmtZR8xDBbY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R . Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 415/671] powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild
Date:   Thu, 16 Jan 2020 12:00:53 -0500
Message-Id: <20200116170509.12787-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a8f20e5928e1..9edb45430133 100644
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
index 955f5e999f1b..52bd3fc6642d 100644
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

