Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1C3F1953
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbhHSMbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14277 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhHSMbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gr3yf16r9z87rt;
        Thu, 19 Aug 2021 20:30:50 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:58 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:57 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Jianlin Lv <Jianlin.Lv@arm.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        "Guo Ren" <guoren@kernel.org>, Kajol Jain <kjain@linux.ibm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, <iecedge@gmail.com>,
        <linux-csky@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 4/6] perf tools: Fix arm64 build error with gcc-11
Date:   Thu, 19 Aug 2021 20:19:10 +0800
Message-ID: <1629375552-51897-5-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianlin Lv <Jianlin.Lv@arm.com>

commit 067012974c8ae31a8886046df082aeba93592972 upstream.

gcc version: 11.0.0 20210208 (experimental) (GCC)

Following build error on arm64:

.......
In function ‘printf’,
    inlined from ‘regs_dump__printf’ at util/session.c:1141:3,
    inlined from ‘regs__printf’ at util/session.c:1169:2:
/usr/include/aarch64-linux-gnu/bits/stdio2.h:107:10: \
  error: ‘%-5s’ directive argument is null [-Werror=format-overflow=]

107 |   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, \
                __va_arg_pack ());

......
In function ‘fprintf’,
  inlined from ‘perf_sample__fprintf_regs.isra’ at \
    builtin-script.c:622:14:
/usr/include/aarch64-linux-gnu/bits/stdio2.h:100:10: \
    error: ‘%5s’ directive argument is null [-Werror=format-overflow=]
  100 |   return __fprintf_chk (__stream, __USE_FORTIFY_LEVEL - 1, __fmt,
  101 |                         __va_arg_pack ());

cc1: all warnings being treated as errors
.......

This patch fixes Wformat-overflow warnings. Add helper function to
convert NULL to "unknown".

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: iecedge@gmail.com
Cc: linux-csky@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Link: http://lore.kernel.org/lkml/20210218031245.2078492-1-Jianlin.Lv@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 tools/perf/arch/arm/include/perf_regs.h     | 2 +-
 tools/perf/arch/arm64/include/perf_regs.h   | 2 +-
 tools/perf/arch/csky/include/perf_regs.h    | 2 +-
 tools/perf/arch/powerpc/include/perf_regs.h | 2 +-
 tools/perf/arch/riscv/include/perf_regs.h   | 2 +-
 tools/perf/arch/s390/include/perf_regs.h    | 2 +-
 tools/perf/arch/x86/include/perf_regs.h     | 2 +-
 tools/perf/util/perf_regs.h                 | 7 +++++++
 8 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index ed20e02..4085419 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -15,7 +15,7 @@
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_ARM_R0:
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
index baaa5e6..fa3e0745 100644
--- a/tools/perf/arch/arm64/include/perf_regs.h
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -15,7 +15,7 @@
 #define PERF_REG_IP	PERF_REG_ARM64_PC
 #define PERF_REG_SP	PERF_REG_ARM64_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_ARM64_X0:
diff --git a/tools/perf/arch/csky/include/perf_regs.h b/tools/perf/arch/csky/include/perf_regs.h
index 8f336ea..25ac3bd 100644
--- a/tools/perf/arch/csky/include/perf_regs.h
+++ b/tools/perf/arch/csky/include/perf_regs.h
@@ -15,7 +15,7 @@
 #define PERF_REG_IP	PERF_REG_CSKY_PC
 #define PERF_REG_SP	PERF_REG_CSKY_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_CSKY_A0:
diff --git a/tools/perf/arch/powerpc/include/perf_regs.h b/tools/perf/arch/powerpc/include/perf_regs.h
index 63f3ac9..004bed2 100644
--- a/tools/perf/arch/powerpc/include/perf_regs.h
+++ b/tools/perf/arch/powerpc/include/perf_regs.h
@@ -73,7 +73,7 @@
 	[PERF_REG_POWERPC_SIER3] = "sier3",
 };
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	return reg_names[id];
 }
diff --git a/tools/perf/arch/riscv/include/perf_regs.h b/tools/perf/arch/riscv/include/perf_regs.h
index 7a8bcde..6b02a76 100644
--- a/tools/perf/arch/riscv/include/perf_regs.h
+++ b/tools/perf/arch/riscv/include/perf_regs.h
@@ -19,7 +19,7 @@
 #define PERF_REG_IP	PERF_REG_RISCV_PC
 #define PERF_REG_SP	PERF_REG_RISCV_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_RISCV_PC:
diff --git a/tools/perf/arch/s390/include/perf_regs.h b/tools/perf/arch/s390/include/perf_regs.h
index bcfbaed..ce30315 100644
--- a/tools/perf/arch/s390/include/perf_regs.h
+++ b/tools/perf/arch/s390/include/perf_regs.h
@@ -14,7 +14,7 @@
 #define PERF_REG_IP PERF_REG_S390_PC
 #define PERF_REG_SP PERF_REG_S390_R15
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_S390_R0:
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index b732133..cddc4cd 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -23,7 +23,7 @@
 #define PERF_REG_IP PERF_REG_X86_IP
 #define PERF_REG_SP PERF_REG_X86_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_X86_AX:
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index a454991..eeac181 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -33,6 +33,13 @@ enum {
 
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
 
+static inline const char *perf_reg_name(int id)
+{
+	const char *reg_name = __perf_reg_name(id);
+
+	return reg_name ?: "unknown";
+}
+
 #else
 #define PERF_REGS_MASK	0
 #define PERF_REGS_MAX	0
-- 
1.7.12.4

