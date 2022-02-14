Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFB4B4A68
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346250AbiBNKYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346642AbiBNKXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:23:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F560A8F;
        Mon, 14 Feb 2022 01:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D86DCB80DBE;
        Mon, 14 Feb 2022 09:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21793C340E9;
        Mon, 14 Feb 2022 09:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832573;
        bh=5CgUbtEjWetjccIjMGSrNUZ2M+3dIRfWytZnM1eefAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+HyQrJsSxdsil6EuF+1Ng7oVG4dLVR76+FGGhSrn2m04/fNFRucvUyuB2nHVJHM4
         6nfZZJRpArj5vIgY1oNlTgkmpKr7Zb9hfZMBD50twYvMd0WMJRT3L5T+JCBVX06v2d
         uZppZLklGXu01umeLZsGKIvKBYM6i3A1w3LlQ+j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 040/203] s390/module: test loading modules with a lot of relocations
Date:   Mon, 14 Feb 2022 10:24:44 +0100
Message-Id: <20220214092511.569191366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 90c5318795eefa09a9f9aef8d18a904e24962b5c ]

Add a test in order to prevent regressions.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig                    | 15 +++++++++
 arch/s390/lib/Makefile               |  3 ++
 arch/s390/lib/test_modules.c         | 35 +++++++++++++++++++
 arch/s390/lib/test_modules.h         | 50 ++++++++++++++++++++++++++++
 arch/s390/lib/test_modules_helpers.c | 13 ++++++++
 5 files changed, 116 insertions(+)
 create mode 100644 arch/s390/lib/test_modules.c
 create mode 100644 arch/s390/lib/test_modules.h
 create mode 100644 arch/s390/lib/test_modules_helpers.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2a5bb4f29cfed..0344c68f3ffde 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -947,6 +947,9 @@ config S390_GUEST
 
 endmenu
 
+config S390_MODULES_SANITY_TEST_HELPERS
+	def_bool n
+
 menu "Selftests"
 
 config S390_UNWIND_SELFTEST
@@ -973,4 +976,16 @@ config S390_KPROBES_SANITY_TEST
 
 	  Say N if you are unsure.
 
+config S390_MODULES_SANITY_TEST
+	def_tristate n
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	prompt "Enable s390 specific modules tests"
+	select S390_MODULES_SANITY_TEST_HELPERS
+	help
+	  This option enables an s390 specific modules test. This option is
+	  not useful for distributions or general kernels, but only for
+	  kernel developers working on architecture code.
+
+	  Say N if you are unsure.
 endmenu
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 707cd4622c132..69feb8ed3312d 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -17,4 +17,7 @@ KASAN_SANITIZE_uaccess.o := n
 obj-$(CONFIG_S390_UNWIND_SELFTEST) += test_unwind.o
 CFLAGS_test_unwind.o += -fno-optimize-sibling-calls
 
+obj-$(CONFIG_S390_MODULES_SANITY_TEST) += test_modules.o
+obj-$(CONFIG_S390_MODULES_SANITY_TEST_HELPERS) += test_modules_helpers.o
+
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/arch/s390/lib/test_modules.c b/arch/s390/lib/test_modules.c
new file mode 100644
index 0000000000000..d056baa8fbb0c
--- /dev/null
+++ b/arch/s390/lib/test_modules.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <kunit/test.h>
+#include <linux/module.h>
+
+#include "test_modules.h"
+
+#define DECLARE_RETURN(i) int test_modules_return_ ## i(void)
+REPEAT_10000(DECLARE_RETURN);
+
+/*
+ * Test that modules with many relocations are loaded properly.
+ */
+static void test_modules_many_vmlinux_relocs(struct kunit *test)
+{
+	int result = 0;
+
+#define CALL_RETURN(i) result += test_modules_return_ ## i()
+	REPEAT_10000(CALL_RETURN);
+	KUNIT_ASSERT_EQ(test, result, 49995000);
+}
+
+static struct kunit_case modules_testcases[] = {
+	KUNIT_CASE(test_modules_many_vmlinux_relocs),
+	{}
+};
+
+static struct kunit_suite modules_test_suite = {
+	.name = "modules_test_s390",
+	.test_cases = modules_testcases,
+};
+
+kunit_test_suites(&modules_test_suite);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/s390/lib/test_modules.h b/arch/s390/lib/test_modules.h
new file mode 100644
index 0000000000000..43b5e4b4af3e4
--- /dev/null
+++ b/arch/s390/lib/test_modules.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef TEST_MODULES_H
+#define TEST_MODULES_H
+
+#define __REPEAT_10000_3(f, x) \
+	f(x ## 0); \
+	f(x ## 1); \
+	f(x ## 2); \
+	f(x ## 3); \
+	f(x ## 4); \
+	f(x ## 5); \
+	f(x ## 6); \
+	f(x ## 7); \
+	f(x ## 8); \
+	f(x ## 9)
+#define __REPEAT_10000_2(f, x) \
+	__REPEAT_10000_3(f, x ## 0); \
+	__REPEAT_10000_3(f, x ## 1); \
+	__REPEAT_10000_3(f, x ## 2); \
+	__REPEAT_10000_3(f, x ## 3); \
+	__REPEAT_10000_3(f, x ## 4); \
+	__REPEAT_10000_3(f, x ## 5); \
+	__REPEAT_10000_3(f, x ## 6); \
+	__REPEAT_10000_3(f, x ## 7); \
+	__REPEAT_10000_3(f, x ## 8); \
+	__REPEAT_10000_3(f, x ## 9)
+#define __REPEAT_10000_1(f, x) \
+	__REPEAT_10000_2(f, x ## 0); \
+	__REPEAT_10000_2(f, x ## 1); \
+	__REPEAT_10000_2(f, x ## 2); \
+	__REPEAT_10000_2(f, x ## 3); \
+	__REPEAT_10000_2(f, x ## 4); \
+	__REPEAT_10000_2(f, x ## 5); \
+	__REPEAT_10000_2(f, x ## 6); \
+	__REPEAT_10000_2(f, x ## 7); \
+	__REPEAT_10000_2(f, x ## 8); \
+	__REPEAT_10000_2(f, x ## 9)
+#define REPEAT_10000(f) \
+	__REPEAT_10000_1(f, 0); \
+	__REPEAT_10000_1(f, 1); \
+	__REPEAT_10000_1(f, 2); \
+	__REPEAT_10000_1(f, 3); \
+	__REPEAT_10000_1(f, 4); \
+	__REPEAT_10000_1(f, 5); \
+	__REPEAT_10000_1(f, 6); \
+	__REPEAT_10000_1(f, 7); \
+	__REPEAT_10000_1(f, 8); \
+	__REPEAT_10000_1(f, 9)
+
+#endif
diff --git a/arch/s390/lib/test_modules_helpers.c b/arch/s390/lib/test_modules_helpers.c
new file mode 100644
index 0000000000000..1670349a03eba
--- /dev/null
+++ b/arch/s390/lib/test_modules_helpers.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/export.h>
+
+#include "test_modules.h"
+
+#define DEFINE_RETURN(i) \
+	int test_modules_return_ ## i(void) \
+	{ \
+		return 1 ## i - 10000; \
+	} \
+	EXPORT_SYMBOL_GPL(test_modules_return_ ## i)
+REPEAT_10000(DEFINE_RETURN);
-- 
2.34.1



