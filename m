Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F171737884E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbhEJLVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236946AbhEJLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B32161430;
        Mon, 10 May 2021 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644761;
        bh=ac/ECm5ssDNwfZVOirucWzBGrSsQR/PGlfv7yDn6bOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KafK9oaBmhCQREJz7Iwx4mUsAwpg5MBrPa6H6PlhgZBEFSMpQff10ZQ5D0PcMCOlw
         T12/7EI3iqPgmFTLCpAaOZYwLGgZe92wGFoRyYVTFO+bC67h6g6mNu1V3kFh0slwO6
         Cr/KSdTYctuk5Qfn83Jwh8bGtANoDciTVfxORsb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 213/384] selftests/resctrl: Fix checking for < 0 for unsigned values
Date:   Mon, 10 May 2021 12:20:02 +0200
Message-Id: <20210510102021.912458307@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 1205b688c92558a04d8dd4cbc2b213e0fceba5db ]

Dan reported following static checker warnings

tools/testing/selftests/resctrl/resctrl_val.c:545 measure_vals()
warn: 'bw_imc' unsigned <= 0

tools/testing/selftests/resctrl/resctrl_val.c:549 measure_vals()
warn: 'bw_resc_end' unsigned <= 0

These warnings are reported because
1. measure_vals() declares 'bw_imc' and 'bw_resc_end' as unsigned long
   variables
2. Return value of get_mem_bw_imc() and get_mem_bw_resctrl() are assigned
   to 'bw_imc' and 'bw_resc_end' respectively
3. The returned values are checked for <= 0 to see if the calls failed

Checking for < 0 for an unsigned value doesn't make any sense.

Fix this issue by changing the implementation of get_mem_bw_imc() and
get_mem_bw_resctrl() such that they now accept reference to a variable
and set the variable appropriately upon success and return 0, else return
< 0 on error.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 41 +++++++++++--------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 5478c23c62ba..8df557894059 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -300,9 +300,9 @@ static int initialize_mem_bw_imc(void)
  * Memory B/W utilized by a process on a socket can be calculated using
  * iMC counters. Perf events are used to read these counters.
  *
- * Return: >= 0 on success. < 0 on failure.
+ * Return: = 0 on success. < 0 on failure.
  */
-static float get_mem_bw_imc(int cpu_no, char *bw_report)
+static int get_mem_bw_imc(int cpu_no, char *bw_report, float *bw_imc)
 {
 	float reads, writes, of_mul_read, of_mul_write;
 	int imc, j, ret;
@@ -373,13 +373,18 @@ static float get_mem_bw_imc(int cpu_no, char *bw_report)
 		close(imc_counters_config[imc][WRITE].fd);
 	}
 
-	if (strcmp(bw_report, "reads") == 0)
-		return reads;
+	if (strcmp(bw_report, "reads") == 0) {
+		*bw_imc = reads;
+		return 0;
+	}
 
-	if (strcmp(bw_report, "writes") == 0)
-		return writes;
+	if (strcmp(bw_report, "writes") == 0) {
+		*bw_imc = writes;
+		return 0;
+	}
 
-	return (reads + writes);
+	*bw_imc = reads + writes;
+	return 0;
 }
 
 void set_mbm_path(const char *ctrlgrp, const char *mongrp, int resource_id)
@@ -438,9 +443,8 @@ static void initialize_mem_bw_resctrl(const char *ctrlgrp, const char *mongrp,
  * 1. If con_mon grp is given, then read from it
  * 2. If con_mon grp is not given, then read from root con_mon grp
  */
-static unsigned long get_mem_bw_resctrl(void)
+static int get_mem_bw_resctrl(unsigned long *mbm_total)
 {
-	unsigned long mbm_total = 0;
 	FILE *fp;
 
 	fp = fopen(mbm_total_path, "r");
@@ -449,7 +453,7 @@ static unsigned long get_mem_bw_resctrl(void)
 
 		return -1;
 	}
-	if (fscanf(fp, "%lu", &mbm_total) <= 0) {
+	if (fscanf(fp, "%lu", mbm_total) <= 0) {
 		perror("Could not get mbm local bytes");
 		fclose(fp);
 
@@ -457,7 +461,7 @@ static unsigned long get_mem_bw_resctrl(void)
 	}
 	fclose(fp);
 
-	return mbm_total;
+	return 0;
 }
 
 pid_t bm_pid, ppid;
@@ -549,7 +553,8 @@ static void initialize_llc_occu_resctrl(const char *ctrlgrp, const char *mongrp,
 static int
 measure_vals(struct resctrl_val_param *param, unsigned long *bw_resc_start)
 {
-	unsigned long bw_imc, bw_resc, bw_resc_end;
+	unsigned long bw_resc, bw_resc_end;
+	float bw_imc;
 	int ret;
 
 	/*
@@ -559,13 +564,13 @@ measure_vals(struct resctrl_val_param *param, unsigned long *bw_resc_start)
 	 * Compare the two values to validate resctrl value.
 	 * It takes 1sec to measure the data.
 	 */
-	bw_imc = get_mem_bw_imc(param->cpu_no, param->bw_report);
-	if (bw_imc <= 0)
-		return bw_imc;
+	ret = get_mem_bw_imc(param->cpu_no, param->bw_report, &bw_imc);
+	if (ret < 0)
+		return ret;
 
-	bw_resc_end = get_mem_bw_resctrl();
-	if (bw_resc_end <= 0)
-		return bw_resc_end;
+	ret = get_mem_bw_resctrl(&bw_resc_end);
+	if (ret < 0)
+		return ret;
 
 	bw_resc = (bw_resc_end - *bw_resc_start) / MB;
 	ret = print_results_bw(param->filename, bm_pid, bw_imc, bw_resc);
-- 
2.30.2



