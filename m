Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775024A8D75
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354192AbiBCUbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33742 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239266AbiBCUat (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 770F8B835A6;
        Thu,  3 Feb 2022 20:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535E0C340F2;
        Thu,  3 Feb 2022 20:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920247;
        bh=5CgUbtEjWetjccIjMGSrNUZ2M+3dIRfWytZnM1eefAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZpNriAo6r/m8ICebt94eaUNYn1HMXd/EYqkrEEpOvK1gwdqOfyo6VUwU17SaujBW
         2TgVcTn6pJnHkwJIzuXM/5/psbYYYBhbIgOB03Li9TFzpkyUUTvymvkFKcnKM5C5Ei
         4m4SxD3h5vwWQk0kASOr5//aXGzHFtnEVC05uxoYT0+aSwEQl4KCeWHhSJrzA4tWTp
         l0fuoYa+a9p7bQ+xWsAIGVBNnyznuDrSQuMwMkgn/SJTCJCiqDPPG0huCZ4W2uJFnd
         8WmlPPDyyc78THCS1vNbBvN1dWbcgtnbzxRdBZR1QY3MNOVPG2au4+Z2kL0xYsLIzK
         uZ8m+6AzqwWaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, svens@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 23/52] s390/module: test loading modules with a lot of relocations
Date:   Thu,  3 Feb 2022 15:29:17 -0500
Message-Id: <20220203202947.2304-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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

