Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AE0378451
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhEJKvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhEJKtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D6E614A5;
        Mon, 10 May 2021 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643123;
        bh=22q0HzCFur93djRF17R4vrmvF7gsmw+Eqk7okMaFdSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai8g1OZcgKDGe694tdnXvE+EXGBQ9LkMwo93l7VN4wLA8ub3jnq4rBP66FEdHhQQE
         6vVjAm/y7AoD71Nz1fjDPVf9sBClrQAoq84HivGVB4Hfflfyy3QHlwXBJWgU01HCyo
         V1Gp80nucv8fA/q0s5/92naJgsNnafvbbQ2SJ5cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/299] selftests/resctrl: Clean up resctrl features check
Date:   Mon, 10 May 2021 12:19:17 +0200
Message-Id: <20210510102010.245628134@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 2428673638ea28fa93d2a38b1c3e8d70122b00ee ]

Checking resctrl features call strcmp() to compare feature strings
(e.g. "mba", "cat" etc). The checkings are error prone and don't have
good coding style. Define the constant strings in macros and call
strncmp() to solve the potential issues.

Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/cache.c       |  8 +++----
 tools/testing/selftests/resctrl/cat_test.c    |  2 +-
 tools/testing/selftests/resctrl/cqm_test.c    |  2 +-
 tools/testing/selftests/resctrl/fill_buf.c    |  4 ++--
 tools/testing/selftests/resctrl/mba_test.c    |  2 +-
 tools/testing/selftests/resctrl/mbm_test.c    |  2 +-
 tools/testing/selftests/resctrl/resctrl.h     |  5 +++++
 .../testing/selftests/resctrl/resctrl_tests.c | 12 +++++-----
 tools/testing/selftests/resctrl/resctrl_val.c | 22 +++++++++----------
 tools/testing/selftests/resctrl/resctrlfs.c   | 17 +++++++-------
 10 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/selftests/resctrl/cache.c
index 38dbf4962e33..5922cc1b0386 100644
--- a/tools/testing/selftests/resctrl/cache.c
+++ b/tools/testing/selftests/resctrl/cache.c
@@ -182,7 +182,7 @@ int measure_cache_vals(struct resctrl_val_param *param, int bm_pid)
 	/*
 	 * Measure cache miss from perf.
 	 */
-	if (!strcmp(param->resctrl_val, "cat")) {
+	if (!strncmp(param->resctrl_val, CAT_STR, sizeof(CAT_STR))) {
 		ret = get_llc_perf(&llc_perf_miss);
 		if (ret < 0)
 			return ret;
@@ -192,7 +192,7 @@ int measure_cache_vals(struct resctrl_val_param *param, int bm_pid)
 	/*
 	 * Measure llc occupancy from resctrl.
 	 */
-	if (!strcmp(param->resctrl_val, "cqm")) {
+	if (!strncmp(param->resctrl_val, CQM_STR, sizeof(CQM_STR))) {
 		ret = get_llc_occu_resctrl(&llc_occu_resc);
 		if (ret < 0)
 			return ret;
@@ -234,7 +234,7 @@ int cat_val(struct resctrl_val_param *param)
 	if (ret)
 		return ret;
 
-	if ((strcmp(resctrl_val, "cat") == 0)) {
+	if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR))) {
 		ret = initialize_llc_perf();
 		if (ret)
 			return ret;
@@ -242,7 +242,7 @@ int cat_val(struct resctrl_val_param *param)
 
 	/* Test runs until the callback setup() tells the test to stop. */
 	while (1) {
-		if (strcmp(resctrl_val, "cat") == 0) {
+		if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR))) {
 			ret = param->setup(1, param);
 			if (ret) {
 				ret = 0;
diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index bdeeb5772592..20823725daca 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -164,7 +164,7 @@ int cat_perf_miss_val(int cpu_no, int n, char *cache_type)
 		return -1;
 
 	struct resctrl_val_param param = {
-		.resctrl_val	= "cat",
+		.resctrl_val	= CAT_STR,
 		.cpu_no		= cpu_no,
 		.mum_resctrlfs	= 0,
 		.setup		= cat_setup,
diff --git a/tools/testing/selftests/resctrl/cqm_test.c b/tools/testing/selftests/resctrl/cqm_test.c
index de33d1c0466e..271752e9ef5b 100644
--- a/tools/testing/selftests/resctrl/cqm_test.c
+++ b/tools/testing/selftests/resctrl/cqm_test.c
@@ -145,7 +145,7 @@ int cqm_resctrl_val(int cpu_no, int n, char **benchmark_cmd)
 	}
 
 	struct resctrl_val_param param = {
-		.resctrl_val	= "cqm",
+		.resctrl_val	= CQM_STR,
 		.ctrlgrp	= "c1",
 		.mongrp		= "m1",
 		.cpu_no		= cpu_no,
diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index 79c611c99a3d..51e5cf22632f 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -115,7 +115,7 @@ static int fill_cache_read(unsigned char *start_ptr, unsigned char *end_ptr,
 
 	while (1) {
 		ret = fill_one_span_read(start_ptr, end_ptr);
-		if (!strcmp(resctrl_val, "cat"))
+		if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR)))
 			break;
 	}
 
@@ -134,7 +134,7 @@ static int fill_cache_write(unsigned char *start_ptr, unsigned char *end_ptr,
 {
 	while (1) {
 		fill_one_span_write(start_ptr, end_ptr);
-		if (!strcmp(resctrl_val, "cat"))
+		if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR)))
 			break;
 	}
 
diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index 7bf8eaa6204b..6449fbd96096 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -141,7 +141,7 @@ void mba_test_cleanup(void)
 int mba_schemata_change(int cpu_no, char *bw_report, char **benchmark_cmd)
 {
 	struct resctrl_val_param param = {
-		.resctrl_val	= "mba",
+		.resctrl_val	= MBA_STR,
 		.ctrlgrp	= "c1",
 		.mongrp		= "m1",
 		.cpu_no		= cpu_no,
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 4700f7453f81..ec6cfe01c9c2 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -114,7 +114,7 @@ void mbm_test_cleanup(void)
 int mbm_bw_change(int span, int cpu_no, char *bw_report, char **benchmark_cmd)
 {
 	struct resctrl_val_param param = {
-		.resctrl_val	= "mbm",
+		.resctrl_val	= MBM_STR,
 		.ctrlgrp	= "c1",
 		.mongrp		= "m1",
 		.span		= span,
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 12b77182cb44..36da6136af96 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -62,6 +62,11 @@ struct resctrl_val_param {
 	int		(*setup)(int num, ...);
 };
 
+#define MBM_STR			"mbm"
+#define MBA_STR			"mba"
+#define CQM_STR			"cqm"
+#define CAT_STR			"cat"
+
 extern pid_t bm_pid, ppid;
 extern int tests_run;
 
diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index 425cc85ac883..4b109a59f72d 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -85,13 +85,13 @@ int main(int argc, char **argv)
 			cqm_test = false;
 			cat_test = false;
 			while (token) {
-				if (!strcmp(token, "mbm")) {
+				if (!strncmp(token, MBM_STR, sizeof(MBM_STR))) {
 					mbm_test = true;
-				} else if (!strcmp(token, "mba")) {
+				} else if (!strncmp(token, MBA_STR, sizeof(MBA_STR))) {
 					mba_test = true;
-				} else if (!strcmp(token, "cqm")) {
+				} else if (!strncmp(token, CQM_STR, sizeof(CQM_STR))) {
 					cqm_test = true;
-				} else if (!strcmp(token, "cat")) {
+				} else if (!strncmp(token, CAT_STR, sizeof(CAT_STR))) {
 					cat_test = true;
 				} else {
 					printf("invalid argument\n");
@@ -161,7 +161,7 @@ int main(int argc, char **argv)
 	if (!is_amd && mbm_test) {
 		printf("# Starting MBM BW change ...\n");
 		if (!has_ben)
-			sprintf(benchmark_cmd[5], "%s", "mba");
+			sprintf(benchmark_cmd[5], "%s", MBA_STR);
 		res = mbm_bw_change(span, cpu_no, bw_report, benchmark_cmd);
 		printf("%sok MBM: bw change\n", res ? "not " : "");
 		mbm_test_cleanup();
@@ -181,7 +181,7 @@ int main(int argc, char **argv)
 	if (cqm_test) {
 		printf("# Starting CQM test ...\n");
 		if (!has_ben)
-			sprintf(benchmark_cmd[5], "%s", "cqm");
+			sprintf(benchmark_cmd[5], "%s", CQM_STR);
 		res = cqm_resctrl_val(cpu_no, no_of_bits, benchmark_cmd);
 		printf("%sok CQM: test\n", res ? "not " : "");
 		cqm_test_cleanup();
diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 520fea3606d1..aed71fd0713b 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -397,10 +397,10 @@ static void initialize_mem_bw_resctrl(const char *ctrlgrp, const char *mongrp,
 		return;
 	}
 
-	if (strcmp(resctrl_val, "mbm") == 0)
+	if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)))
 		set_mbm_path(ctrlgrp, mongrp, resource_id);
 
-	if ((strcmp(resctrl_val, "mba") == 0)) {
+	if (!strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
 		if (ctrlgrp)
 			sprintf(mbm_total_path, CON_MBM_LOCAL_BYTES_PATH,
 				RESCTRL_PATH, ctrlgrp, resource_id);
@@ -524,7 +524,7 @@ static void initialize_llc_occu_resctrl(const char *ctrlgrp, const char *mongrp,
 		return;
 	}
 
-	if (strcmp(resctrl_val, "cqm") == 0)
+	if (!strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)))
 		set_cqm_path(ctrlgrp, mongrp, resource_id);
 }
 
@@ -579,8 +579,8 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 	if (strcmp(param->filename, "") == 0)
 		sprintf(param->filename, "stdio");
 
-	if ((strcmp(resctrl_val, "mba")) == 0 ||
-	    (strcmp(resctrl_val, "mbm")) == 0) {
+	if (!strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR)) ||
+	    !strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR))) {
 		ret = validate_bw_report_request(param->bw_report);
 		if (ret)
 			return ret;
@@ -674,15 +674,15 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 	if (ret)
 		goto out;
 
-	if ((strcmp(resctrl_val, "mbm") == 0) ||
-	    (strcmp(resctrl_val, "mba") == 0)) {
+	if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)) ||
+	    !strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
 		ret = initialize_mem_bw_imc();
 		if (ret)
 			goto out;
 
 		initialize_mem_bw_resctrl(param->ctrlgrp, param->mongrp,
 					  param->cpu_no, resctrl_val);
-	} else if (strcmp(resctrl_val, "cqm") == 0)
+	} else if (!strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)))
 		initialize_llc_occu_resctrl(param->ctrlgrp, param->mongrp,
 					    param->cpu_no, resctrl_val);
 
@@ -710,8 +710,8 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 
 	/* Test runs until the callback setup() tells the test to stop. */
 	while (1) {
-		if ((strcmp(resctrl_val, "mbm") == 0) ||
-		    (strcmp(resctrl_val, "mba") == 0)) {
+		if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)) ||
+		    !strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
 			ret = param->setup(1, param);
 			if (ret) {
 				ret = 0;
@@ -721,7 +721,7 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 			ret = measure_vals(param, &bw_resc_start);
 			if (ret)
 				break;
-		} else if (strcmp(resctrl_val, "cqm") == 0) {
+		} else if (!strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR))) {
 			ret = param->setup(1, param);
 			if (ret) {
 				ret = 0;
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 2a16100c9c3f..4174e48e06d1 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -334,7 +334,7 @@ void run_benchmark(int signum, siginfo_t *info, void *ucontext)
 		operation = atoi(benchmark_cmd[4]);
 		sprintf(resctrl_val, "%s", benchmark_cmd[5]);
 
-		if (strcmp(resctrl_val, "cqm") != 0)
+		if (strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)))
 			buffer_span = span * MB;
 		else
 			buffer_span = span;
@@ -459,8 +459,8 @@ int write_bm_pid_to_resctrl(pid_t bm_pid, char *ctrlgrp, char *mongrp,
 		goto out;
 
 	/* Create mon grp and write pid into it for "mbm" and "cqm" test */
-	if ((strcmp(resctrl_val, "cqm") == 0) ||
-	    (strcmp(resctrl_val, "mbm") == 0)) {
+	if (!strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)) ||
+	    !strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR))) {
 		if (strlen(mongrp)) {
 			sprintf(monitorgroup_p, "%s/mon_groups", controlgroup);
 			sprintf(monitorgroup, "%s/%s", monitorgroup_p, mongrp);
@@ -505,9 +505,9 @@ int write_schemata(char *ctrlgrp, char *schemata, int cpu_no, char *resctrl_val)
 	int resource_id, ret = 0;
 	FILE *fp;
 
-	if ((strcmp(resctrl_val, "mba") != 0) &&
-	    (strcmp(resctrl_val, "cat") != 0) &&
-	    (strcmp(resctrl_val, "cqm") != 0))
+	if (strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR)) &&
+	    strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR)) &&
+	    strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)))
 		return -ENOENT;
 
 	if (!schemata) {
@@ -528,9 +528,10 @@ int write_schemata(char *ctrlgrp, char *schemata, int cpu_no, char *resctrl_val)
 	else
 		sprintf(controlgroup, "%s/schemata", RESCTRL_PATH);
 
-	if (!strcmp(resctrl_val, "cat") || !strcmp(resctrl_val, "cqm"))
+	if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR)) ||
+	    !strncmp(resctrl_val, CQM_STR, sizeof(CQM_STR)))
 		sprintf(schema, "%s%d%c%s", "L3:", resource_id, '=', schemata);
-	if (strcmp(resctrl_val, "mba") == 0)
+	if (!strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR)))
 		sprintf(schema, "%s%d%c%s", "MB:", resource_id, '=', schemata);
 
 	fp = fopen(controlgroup, "w");
-- 
2.30.2



