Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C4A40A001
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348566AbhIMWgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348581AbhIMWfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4420461222;
        Mon, 13 Sep 2021 22:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572464;
        bh=MXf4S0vzKac0hK17tnN+6U9uXKb+YFLSpgKQKzDLYDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lxkv1dOfp9hKtzNS9AoYKjFxGECxdeqoDYlH8ha/ATFBkS+qaj7+AYD679/rzMFFj
         FpXkvvqJU4neYfxPkCm8FPPKyfoUnnQB6tZoHTFHthhpcXW+FKOOVQn70B3e9qew9J
         9g4wbL8p1+nYaya5v0wgpDgzBsyUjI6wVx7tD8cdqmwKik/Up9fXQCRgZ1/2smihNL
         A8yy8zQWdHDUh/Hzck3KqkL+93UumyKw0zPwFYYs1INncgELqX+ElyQvaIYLikqI2V
         WTALzSKQyjp786cywTA7arwd7OYuMRGKyC2O6xOj1o2f4sp7tnGRXhEOXg4rcNHwXW
         95CWfmJnlzRaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 06/19] s390: add kmemleak annotation in stack_alloc()
Date:   Mon, 13 Sep 2021 18:34:02 -0400
Message-Id: <20210913223415.435654-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 436fc4feeabbf103d78d50a8e091b3aac28cc37f ]

kmemleak with enabled auto scanning reports that our stack allocation is
lost. This is because we're saving the pointer + STACK_INIT_OFFSET to
lowcore. When kmemleak now scans the objects, it thinks that this one is
lost because it can't find a corresponding pointer.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 93538e63fa03..442150c88278 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -50,6 +50,7 @@
 #include <linux/compat.h>
 #include <linux/start_kernel.h>
 #include <linux/hugetlb.h>
+#include <linux/kmemleak.h>
 
 #include <asm/boot_data.h>
 #include <asm/ipl.h>
@@ -310,9 +311,12 @@ void *restart_stack;
 unsigned long stack_alloc(void)
 {
 #ifdef CONFIG_VMAP_STACK
-	return (unsigned long)__vmalloc_node(THREAD_SIZE, THREAD_SIZE,
-			THREADINFO_GFP, NUMA_NO_NODE,
-			__builtin_return_address(0));
+	void *ret;
+
+	ret = __vmalloc_node(THREAD_SIZE, THREAD_SIZE, THREADINFO_GFP,
+			     NUMA_NO_NODE, __builtin_return_address(0));
+	kmemleak_not_leak(ret);
+	return (unsigned long)ret;
 #else
 	return __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER);
 #endif
-- 
2.30.2

