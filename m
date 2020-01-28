Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F025E14B9E7
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgA1OWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731591AbgA1OWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:22:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E57824681;
        Tue, 28 Jan 2020 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221350;
        bh=a3b8GTGMrmfY7nhd+ivfJZYIfMPdm75bJRxBWlYuFWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idv6L3JwQXi76ldqVNeW6zGHbrpjTgj7uE/TMYnyUcgJ892uLAefKF3Eryve2j5K9
         QLMAZ70Cto8ILdHpp/gus0Vn12iUF0mMzGTWET9tOiUwxAmkSxkG6xc41UqYIhUmvQ
         AP8MYTqKhBuDlOfiG2ZYDTVFXHbPViTrsVAAvEwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 153/271] powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild
Date:   Tue, 28 Jan 2020 15:05:02 +0100
Message-Id: <20200128135903.952405935@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index c641983bbdd68..0122d5ce0637d 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -867,4 +867,25 @@ void cacheinfo_cpu_offline(unsigned int cpu_id)
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
index a7b74d36acd71..2cdee87a482c5 100644
--- a/arch/powerpc/kernel/cacheinfo.h
+++ b/arch/powerpc/kernel/cacheinfo.h
@@ -5,4 +5,8 @@
 extern void cacheinfo_cpu_online(unsigned int cpu_id);
 extern void cacheinfo_cpu_offline(unsigned int cpu_id);
 
+/* Allow migration/suspend to tear down and rebuild the hierarchy. */
+extern void cacheinfo_teardown(void);
+extern void cacheinfo_rebuild(void);
+
 #endif /* _PPC_CACHEINFO_H */
-- 
2.20.1



