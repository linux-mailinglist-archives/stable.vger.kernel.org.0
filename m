Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4119E34DA8B
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhC2WWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231989AbhC2WWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E637B61997;
        Mon, 29 Mar 2021 22:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056536;
        bh=cnb7QmwLhbTC+fXxQj2F60KkxDx49/PFfA8DcT71/pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I14eiUwTgZd5+bJaugcWt5TaC+a7fLQ91oq/42RTVEKuPzsE9h98dyLuvN8oVRCAl
         hKIDSIUbKIavQUbZaY5J3EAXokx9TSYTKncJNp6Rg3XovOFhmoxnVM3a/Qek9MRp/A
         e5Y6/gN2BVcJYAKTQG1fYqceNYWIoHISk1VJbdrRuUuPN32HJvhN90JUnaDFCQ5vGm
         9ER9l6E5HXfEvvpwdCwrp/dXnU5bAVoXm12Gd7QtoRCnzQ1ZvR9onYzUABMizIWKy5
         UyP+VUBgUJyQ/lIybW1RJKUbGJk2k+jTKElcSP+2386hcMk6iR3YKnxmHIf317qo6c
         tpXrmb6hOPlNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 34/38] ia64: fix format strings for err_inject
Date:   Mon, 29 Mar 2021 18:21:29 -0400
Message-Id: <20210329222133.2382393-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit 95d44a470a6814207d52dd6312203b0f4ef12710 ]

Fix warning with %lx / u64 mismatch:

  arch/ia64/kernel/err_inject.c: In function 'show_resources':
  arch/ia64/kernel/err_inject.c:62:22: warning:
    format '%lx' expects argument of type 'long unsigned int',
    but argument 3 has type 'u64' {aka 'long long unsigned int'}
     62 |  return sprintf(buf, "%lx", name[cpu]);   \
        |                      ^~~~~~~

Link: https://lkml.kernel.org/r/20210313104312.1548232-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/err_inject.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/kernel/err_inject.c b/arch/ia64/kernel/err_inject.c
index 8b5b8e6bc9d9..dd5bfed52031 100644
--- a/arch/ia64/kernel/err_inject.c
+++ b/arch/ia64/kernel/err_inject.c
@@ -59,7 +59,7 @@ show_##name(struct device *dev, struct device_attribute *attr,	\
 		char *buf)						\
 {									\
 	u32 cpu=dev->id;						\
-	return sprintf(buf, "%lx\n", name[cpu]);			\
+	return sprintf(buf, "%llx\n", name[cpu]);			\
 }
 
 #define store(name)							\
@@ -86,9 +86,9 @@ store_call_start(struct device *dev, struct device_attribute *attr,
 
 #ifdef ERR_INJ_DEBUG
 	printk(KERN_DEBUG "pal_mc_err_inject for cpu%d:\n", cpu);
-	printk(KERN_DEBUG "err_type_info=%lx,\n", err_type_info[cpu]);
-	printk(KERN_DEBUG "err_struct_info=%lx,\n", err_struct_info[cpu]);
-	printk(KERN_DEBUG "err_data_buffer=%lx, %lx, %lx.\n",
+	printk(KERN_DEBUG "err_type_info=%llx,\n", err_type_info[cpu]);
+	printk(KERN_DEBUG "err_struct_info=%llx,\n", err_struct_info[cpu]);
+	printk(KERN_DEBUG "err_data_buffer=%llx, %llx, %llx.\n",
 			  err_data_buffer[cpu].data1,
 			  err_data_buffer[cpu].data2,
 			  err_data_buffer[cpu].data3);
@@ -117,8 +117,8 @@ store_call_start(struct device *dev, struct device_attribute *attr,
 
 #ifdef ERR_INJ_DEBUG
 	printk(KERN_DEBUG "Returns: status=%d,\n", (int)status[cpu]);
-	printk(KERN_DEBUG "capabilities=%lx,\n", capabilities[cpu]);
-	printk(KERN_DEBUG "resources=%lx\n", resources[cpu]);
+	printk(KERN_DEBUG "capabilities=%llx,\n", capabilities[cpu]);
+	printk(KERN_DEBUG "resources=%llx\n", resources[cpu]);
 #endif
 	return size;
 }
@@ -131,7 +131,7 @@ show_virtual_to_phys(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	unsigned int cpu=dev->id;
-	return sprintf(buf, "%lx\n", phys_addr[cpu]);
+	return sprintf(buf, "%llx\n", phys_addr[cpu]);
 }
 
 static ssize_t
@@ -145,7 +145,7 @@ store_virtual_to_phys(struct device *dev, struct device_attribute *attr,
 	ret = get_user_pages_fast(virt_addr, 1, FOLL_WRITE, NULL);
 	if (ret<=0) {
 #ifdef ERR_INJ_DEBUG
-		printk("Virtual address %lx is not existing.\n",virt_addr);
+		printk("Virtual address %llx is not existing.\n", virt_addr);
 #endif
 		return -EINVAL;
 	}
@@ -163,7 +163,7 @@ show_err_data_buffer(struct device *dev,
 {
 	unsigned int cpu=dev->id;
 
-	return sprintf(buf, "%lx, %lx, %lx\n",
+	return sprintf(buf, "%llx, %llx, %llx\n",
 			err_data_buffer[cpu].data1,
 			err_data_buffer[cpu].data2,
 			err_data_buffer[cpu].data3);
@@ -178,13 +178,13 @@ store_err_data_buffer(struct device *dev,
 	int ret;
 
 #ifdef ERR_INJ_DEBUG
-	printk("write err_data_buffer=[%lx,%lx,%lx] on cpu%d\n",
+	printk("write err_data_buffer=[%llx,%llx,%llx] on cpu%d\n",
 		 err_data_buffer[cpu].data1,
 		 err_data_buffer[cpu].data2,
 		 err_data_buffer[cpu].data3,
 		 cpu);
 #endif
-	ret=sscanf(buf, "%lx, %lx, %lx",
+	ret = sscanf(buf, "%llx, %llx, %llx",
 			&err_data_buffer[cpu].data1,
 			&err_data_buffer[cpu].data2,
 			&err_data_buffer[cpu].data3);
-- 
2.30.1

