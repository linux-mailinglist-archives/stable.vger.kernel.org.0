Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A441A10B901
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfK0Us6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbfK0Us4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C4621787;
        Wed, 27 Nov 2019 20:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887735;
        bh=4BQXjHM/0DWtFo2HhpXrBkKVLPTEKmgwg598UQ4Nidk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TFp+AGxhod+gJ1u8jzkWJIaruaU29mMmqG2byFbCVz9WP6eCWRUDOmsc1CI9kHJ3
         1e1O7RYo2tBWGhJcrPUhCuNbt/nHdb9QmfSSpcRkV31cOVvrkjXxm+dINi/9CQDHO7
         2pjlophn8n+RJIhzQPQfoeL8MXPqcH82Kk2nxR2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/211] powerpc/pseries: Export raw per-CPU VPA data via debugfs
Date:   Wed, 27 Nov 2019 21:30:07 +0100
Message-Id: <20191127203100.827988123@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eb738ef577926..c0ae3847b8db5 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -48,6 +48,7 @@
 #include <asm/kexec.h>
 #include <asm/fadump.h>
 #include <asm/asm-prototypes.h>
+#include <asm/debugfs.h>
 
 #include "pseries.h"
 
@@ -1036,3 +1037,56 @@ static int __init reserve_vrma_context_id(void)
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



