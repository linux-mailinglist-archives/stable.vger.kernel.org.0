Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41487FF304
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfKPPnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbfKPPnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:04 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098062077B;
        Sat, 16 Nov 2019 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918983;
        bh=hi6mJMVKv1MtVb2EHx6lfLPaOf6PJf+kSEYgHZKgl5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Adup1n/oNG/y69rQUzI0bFMHDWALzR8dQja8gsp+NXoKImRzxrrNzjUAZgIzDA/by
         Ky5f3b+FLOIyOKqdl49VOmyjlplK0iENM0ZeBJT3AUDNGQpECxca+2pv8DR/+azAFZ
         d7I3sAo2dxQKTwHQwSVefQwb3y8Y35iFid1fH4lI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 091/237] powerpc/pseries: Export raw per-CPU VPA data via debugfs
Date:   Sat, 16 Nov 2019 10:38:46 -0500
Message-Id: <20191116154113.7417-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aravinda Prasad <aravinda@linux.vnet.ibm.com>

[ Upstream commit c6c26fb55e8e4b3fc376be5611685990a17de27a ]

This patch exports the raw per-CPU VPA data via debugfs.
A per-CPU file is created which exports the VPA data of
that CPU to help debug some of the VPA related issues or
to analyze the per-CPU VPA related statistics.

v3: Removed offline CPU check.

v2: Included offline CPU check and other review comments.

Signed-off-by: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lpar.c | 54 +++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index ea602f7f97ce1..49e3a88b6a0c1 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -48,6 +48,7 @@
 #include <asm/kexec.h>
 #include <asm/fadump.h>
 #include <asm/asm-prototypes.h>
+#include <asm/debugfs.h>
 
 #include "pseries.h"
 
@@ -1032,3 +1033,56 @@ static int __init reserve_vrma_context_id(void)
 	return 0;
 }
 machine_device_initcall(pseries, reserve_vrma_context_id);
+
+#ifdef CONFIG_DEBUG_FS
+/* debugfs file interface for vpa data */
+static ssize_t vpa_file_read(struct file *filp, char __user *buf, size_t len,
+			      loff_t *pos)
+{
+	int cpu = (long)filp->private_data;
+	struct lppaca *lppaca = &lppaca_of(cpu);
+
+	return simple_read_from_buffer(buf, len, pos, lppaca,
+				sizeof(struct lppaca));
+}
+
+static const struct file_operations vpa_fops = {
+	.open		= simple_open,
+	.read		= vpa_file_read,
+	.llseek		= default_llseek,
+};
+
+static int __init vpa_debugfs_init(void)
+{
+	char name[16];
+	long i;
+	static struct dentry *vpa_dir;
+
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
+		return 0;
+
+	vpa_dir = debugfs_create_dir("vpa", powerpc_debugfs_root);
+	if (!vpa_dir) {
+		pr_warn("%s: can't create vpa root dir\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* set up the per-cpu vpa file*/
+	for_each_possible_cpu(i) {
+		struct dentry *d;
+
+		sprintf(name, "cpu-%ld", i);
+
+		d = debugfs_create_file(name, 0400, vpa_dir, (void *)i,
+					&vpa_fops);
+		if (!d) {
+			pr_warn("%s: can't create per-cpu vpa file\n",
+					__func__);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+machine_arch_initcall(pseries, vpa_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
-- 
2.20.1

