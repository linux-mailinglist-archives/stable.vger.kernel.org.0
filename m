Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91030579E6B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242351AbiGSNBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243158AbiGSNAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AEF61D9D;
        Tue, 19 Jul 2022 05:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2DDFB81B82;
        Tue, 19 Jul 2022 12:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA20C341C6;
        Tue, 19 Jul 2022 12:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233541;
        bh=8NIaevjtI0s0RjPU5IVi91zMEW1XGTRJCsJb33BsGM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMURXzd7ncYBp8IJ7zlu7WFw9uYvSRn5m0TmWvQwQfQF7ggAvirXY/tiO2WsbMemd
         CcNIFL/MZtpFxmLoDla3RUpH8dpqfA2ss6bHCT/L/weMq60hdC3N9Ye5zEtwBmdMy/
         CkoM9w12tfq71ohh5aVDSYBo2PRoxuh6j2OrtTAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        "C. Erastus Toe" <ctoe@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 157/231] s390/nospec: build expoline.o for modules_prepare target
Date:   Tue, 19 Jul 2022 13:54:02 +0200
Message-Id: <20220719114727.483669255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit c4e789572557aa147b13bf7fe09cc99663ed0cf5 ]

When CONFIG_EXPOLINE_EXTERN is used expoline thunks are generated
from arch/s390/lib/expoline.S and postlinked into every module.
This is also true for external modules. Add expoline.o build to
the modules_prepare target.

Fixes: 1d2ad084800e ("s390/nospec: add an option to use thunk-extern")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Tested-by: C. Erastus Toe <ctoe@redhat.com>
Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://lore.kernel.org/r/patch-1.thread-d13b6c.git-a2387a74dc49.your-ad-here.call-01656331067-ext-4899@work.hours
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile                      | 8 +++++++-
 arch/s390/lib/Makefile                  | 3 ++-
 arch/s390/lib/expoline/Makefile         | 3 +++
 arch/s390/lib/{ => expoline}/expoline.S | 0
 4 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/lib/expoline/Makefile
 rename arch/s390/lib/{ => expoline}/expoline.S (100%)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index eba70d585cb2..5b7e761b2d50 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -80,7 +80,7 @@ endif
 
 ifdef CONFIG_EXPOLINE
   ifdef CONFIG_EXPOLINE_EXTERN
-    KBUILD_LDFLAGS_MODULE += arch/s390/lib/expoline.o
+    KBUILD_LDFLAGS_MODULE += arch/s390/lib/expoline/expoline.o
     CC_FLAGS_EXPOLINE := -mindirect-branch=thunk-extern
     CC_FLAGS_EXPOLINE += -mfunction-return=thunk-extern
   else
@@ -162,6 +162,12 @@ vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/s390/kernel/vdso64 include/generated/vdso64-offsets.h
 	$(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
 		$(build)=arch/s390/kernel/vdso32 include/generated/vdso32-offsets.h)
+
+ifdef CONFIG_EXPOLINE_EXTERN
+modules_prepare: expoline_prepare
+expoline_prepare: prepare0
+	$(Q)$(MAKE) $(build)=arch/s390/lib/expoline arch/s390/lib/expoline/expoline.o
+endif
 endif
 
 # Don't use tabs in echo arguments
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 5d415b3db6d1..580d2e3265cb 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -7,7 +7,6 @@ lib-y += delay.o string.o uaccess.o find.o spinlock.o
 obj-y += mem.o xor.o
 lib-$(CONFIG_KPROBES) += probes.o
 lib-$(CONFIG_UPROBES) += probes.o
-obj-$(CONFIG_EXPOLINE_EXTERN) += expoline.o
 obj-$(CONFIG_S390_KPROBES_SANITY_TEST) += test_kprobes_s390.o
 test_kprobes_s390-objs += test_kprobes_asm.o test_kprobes.o
 
@@ -22,3 +21,5 @@ obj-$(CONFIG_S390_MODULES_SANITY_TEST) += test_modules.o
 obj-$(CONFIG_S390_MODULES_SANITY_TEST_HELPERS) += test_modules_helpers.o
 
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
+
+obj-$(CONFIG_EXPOLINE_EXTERN) += expoline/
diff --git a/arch/s390/lib/expoline/Makefile b/arch/s390/lib/expoline/Makefile
new file mode 100644
index 000000000000..854631d9cb03
--- /dev/null
+++ b/arch/s390/lib/expoline/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y += expoline.o
diff --git a/arch/s390/lib/expoline.S b/arch/s390/lib/expoline/expoline.S
similarity index 100%
rename from arch/s390/lib/expoline.S
rename to arch/s390/lib/expoline/expoline.S
-- 
2.35.1



