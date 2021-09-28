Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11D241A7B6
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbhI1F6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239221AbhI1F6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE834611F2;
        Tue, 28 Sep 2021 05:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808587;
        bh=AhcoqVexCUMOfiSsDCMCrTVxJO2sFJcDKPAO9WoKXSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBU55OTh7ExlviP/bzAmhEXMmJbkLXv4p2BizcYkejwcQnrUY0WN/pXCE4zlN908K
         YnNyqyptty9UioTqxrsWKKLASRGx2FrSGpX9F1QFYNj/QH5IgdXwQNvOQLnXecuq0Y
         z4hfR3ra6qr8rZAqyzvHfYuoR4EZWotKq09L0X/YSMlpOrjfOyBxhiI0xjBBCZh8p/
         Y8Uu5D7+IPNZvA3lnwhyStTooTIabVN+EglPvSiVNNxQnQ5Q+MrTFnaLMVzWbTMj+S
         HoEIZeg7PQz30KHxS8RJ//0aAXkmGEu5cJtHw5wwPIjJCBiqxoi7RqzvUTMw2p3sMQ
         Ni/JdX1SXU14A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        bgardon@google.com, drjones@redhat.com, wangyanan55@huawei.com,
        axelrasmussen@google.com, dwmw@amazon.co.uk, seanjc@google.com,
        joao.m.martins@oracle.com, yangyingliang@huawei.com,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 26/40] selftests: kvm: move get_run_delay() into lib/test_util
Date:   Tue, 28 Sep 2021 01:55:10 -0400
Message-Id: <20210928055524.172051-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 20175d5eac5bb94a7a3719ef275337fc9abf26ac ]

get_run_delay() is defined static in xen_shinfo_test and steal_time test.
Move it to lib and remove code duplication.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/test_util.h   |  1 +
 tools/testing/selftests/kvm/lib/test_util.c       | 15 +++++++++++++++
 tools/testing/selftests/kvm/steal_time.c          | 15 ---------------
 .../selftests/kvm/x86_64/xen_shinfo_test.c        | 15 ---------------
 4 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d79be15dd3d2..c7409b9b4e5b 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -102,6 +102,7 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
 size_t get_backing_src_pagesz(uint32_t i);
 void backing_src_help(void);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
+long get_run_delay(void);
 
 /*
  * Whether or not the given source type is shared memory (as opposed to
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 938cd423643e..f80dd38a38b2 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <time.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
 #include <linux/mman.h>
 #include "linux/kernel.h"
 
@@ -303,3 +304,17 @@ enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
 	TEST_FAIL("Unknown backing src type: %s", type_name);
 	return -1;
 }
+
+long get_run_delay(void)
+{
+	char path[64];
+	long val[2];
+	FILE *fp;
+
+	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+	fp = fopen(path, "r");
+	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+	fclose(fp);
+
+	return val[1];
+}
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..51fe95a5c36a 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -10,7 +10,6 @@
 #include <sched.h>
 #include <pthread.h>
 #include <linux/kernel.h>
-#include <sys/syscall.h>
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
 
@@ -217,20 +216,6 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpuid)
 
 #endif
 
-static long get_run_delay(void)
-{
-	char path[64];
-	long val[2];
-	FILE *fp;
-
-	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
-	fp = fopen(path, "r");
-	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
-	fclose(fp);
-
-	return val[1];
-}
-
 static void *do_steal_time(void *arg)
 {
 	struct timespec ts, stop;
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 117bf49a3d79..eda0d2a51224 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -14,7 +14,6 @@
 #include <stdint.h>
 #include <time.h>
 #include <sched.h>
-#include <sys/syscall.h>
 
 #define VCPU_ID		5
 
@@ -98,20 +97,6 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-static long get_run_delay(void)
-{
-        char path[64];
-        long val[2];
-        FILE *fp;
-
-        sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
-        fp = fopen(path, "r");
-        fscanf(fp, "%ld %ld ", &val[0], &val[1]);
-        fclose(fp);
-
-        return val[1];
-}
-
 static int cmp_timespec(struct timespec *a, struct timespec *b)
 {
 	if (a->tv_sec > b->tv_sec)
-- 
2.33.0

