Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DF53FDB87
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbhIAMmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344959AbhIAMkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E29610A8;
        Wed,  1 Sep 2021 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499781;
        bh=IyBs0Ttn5k1kj2OJJ3KtLLvVATiHqMBn2+zRTIXVeL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylGQXxjmUOD/zU0U/M4Y3F0buyxNmofLl4NR1Lu4Ex2sMrfMfF2y6d82j4kM0ynOY
         bkuV5seN68gJF/W+9V1+BnkhEMkMWV53DvnzWpsa/hw3S85ovxuLawNHZt+BCsqGVw
         bI/7ldwezixwcTOinLb7u9lbynqM4j357gFrsrGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Lv <Jianlin.Lv@arm.com>,
        John Garry <john.garry@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Guo Ren <guoren@kernel.org>, Kajol Jain <kjain@linux.ibm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, iecedge@gmail.com,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 083/103] perf tools: Fix arm64 build error with gcc-11
Date:   Wed,  1 Sep 2021 14:28:33 +0200
Message-Id: <20210901122303.343927141@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/arm/include/perf_regs.h     |    2 +-
 tools/perf/arch/arm64/include/perf_regs.h   |    2 +-
 tools/perf/arch/csky/include/perf_regs.h    |    2 +-
 tools/perf/arch/powerpc/include/perf_regs.h |    2 +-
 tools/perf/arch/riscv/include/perf_regs.h   |    2 +-
 tools/perf/arch/s390/include/perf_regs.h    |    2 +-
 tools/perf/arch/x86/include/perf_regs.h     |    2 +-
 tools/perf/util/perf_regs.h                 |    7 +++++++
 8 files changed, 14 insertions(+), 7 deletions(-)

--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -15,7 +15,7 @@ void perf_regs_load(u64 *regs);
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_ARM_R0:
--- a/tools/perf/arch/arm64/include/perf_regs.h
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -15,7 +15,7 @@ void perf_regs_load(u64 *regs);
 #define PERF_REG_IP	PERF_REG_ARM64_PC
 #define PERF_REG_SP	PERF_REG_ARM64_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_ARM64_X0:
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
--- a/tools/perf/arch/powerpc/include/perf_regs.h
+++ b/tools/perf/arch/powerpc/include/perf_regs.h
@@ -73,7 +73,7 @@ static const char *reg_names[] = {
 	[PERF_REG_POWERPC_SIER3] = "sier3",
 };
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	return reg_names[id];
 }
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
--- a/tools/perf/arch/s390/include/perf_regs.h
+++ b/tools/perf/arch/s390/include/perf_regs.h
@@ -14,7 +14,7 @@ void perf_regs_load(u64 *regs);
 #define PERF_REG_IP PERF_REG_S390_PC
 #define PERF_REG_SP PERF_REG_S390_R15
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_S390_R0:
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -23,7 +23,7 @@ void perf_regs_load(u64 *regs);
 #define PERF_REG_IP PERF_REG_X86_IP
 #define PERF_REG_SP PERF_REG_X86_SP
 
-static inline const char *perf_reg_name(int id)
+static inline const char *__perf_reg_name(int id)
 {
 	switch (id) {
 	case PERF_REG_X86_AX:
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -33,6 +33,13 @@ extern const struct sample_reg sample_re
 
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


