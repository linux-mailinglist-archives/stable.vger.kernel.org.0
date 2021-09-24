Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1A417424
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbhIXNDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345553AbhIXNBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DD961278;
        Fri, 24 Sep 2021 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488044;
        bh=ulNZsQZOSbcz7LTORCX/qWu+Vrcw98h4L4qcPnkCnkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCe63a9nlppWRY0WVDctGagdBj8AlB4kuYtcfPl0UMVmqSIvbMRV0o7SVGElzt0HJ
         qtJcnJUiHC7eswJBZlNXTmvoHuWkMKO9DPlGVWGB4CGv478klaehgsymdk47oDJRU7
         xLwYCADBNuenFzqRdsF/TEuuX9tu16fO+CX9cZ74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/100] s390: add kmemleak annotation in stack_alloc()
Date:   Fri, 24 Sep 2021 14:44:10 +0200
Message-Id: <20210924124343.468223628@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ee23908f1b96..6f0d2d4dea74 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -50,6 +50,7 @@
 #include <linux/compat.h>
 #include <linux/start_kernel.h>
 #include <linux/hugetlb.h>
+#include <linux/kmemleak.h>
 
 #include <asm/boot_data.h>
 #include <asm/ipl.h>
@@ -312,9 +313,12 @@ void *restart_stack;
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
2.33.0



