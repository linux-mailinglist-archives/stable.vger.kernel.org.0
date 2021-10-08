Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF96142698B
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241437AbhJHLjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241849AbhJHLgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E856961374;
        Fri,  8 Oct 2021 11:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692745;
        bh=AhcoqVexCUMOfiSsDCMCrTVxJO2sFJcDKPAO9WoKXSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdegQSr9r4pJC3UiKXTTIYfOZ7R8wGRjl+5EAWZtpjoKcs1kzCS2sSaVJhQk3a3Ey
         YcD80iVKuTF7mC9t2aON8Ng6iJdXQNjrDuZeOCO9bcVts/2d4j2o41sYegN/EHKq8Z
         YB5+lE4FkAr4Vh6qSF/gK4o3c8QclUct42LHxt8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 25/48] selftests: kvm: move get_run_delay() into lib/test_util
Date:   Fri,  8 Oct 2021 13:28:01 +0200
Message-Id: <20211008112720.854234073@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



