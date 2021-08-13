Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAE3EB8DC
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241808AbhHMPRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242003AbhHMPOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DBD61106;
        Fri, 13 Aug 2021 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867663;
        bh=GnLiUCEFIhRUyu66/ERAEgKRe+I2rpqXXN68TmQHLqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQqBQTKJF7AD3krFS/3BzLx7/KkGbecMMLIC67UPh/z5NAv6iK/MsXPYdhnXJpnUc
         rYBxiGw06pmsJrBEqCA6TFpGBBrzVcFBbT2PDZ9iAJDhFv+Wv5SpTHwYAZIaCp7lik
         uFLJnDaIxE4tFubtnK5qUPBwi5h9/zInskDsnP3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.10 06/19] Revert "selftests/resctrl: Use resctrl/info for feature detection"
Date:   Fri, 13 Aug 2021 17:07:23 +0200
Message-Id: <20210813150522.835692058@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

This reverts commit 19eaad1400eab34e97ec4467cd2ab694d1caf20c which is
ee0415681eb661efa1eb2db7acc263f2c7df1e23 upstream.

This commit is not a stable candidate and was backported without needed
dependencies that results in the resctrl tests unable to compile.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/resctrl/resctrl.h   |    6 ---
 tools/testing/selftests/resctrl/resctrlfs.c |   50 +++++-----------------------
 2 files changed, 11 insertions(+), 45 deletions(-)

--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -28,10 +28,6 @@
 #define RESCTRL_PATH		"/sys/fs/resctrl"
 #define PHYS_ID_PATH		"/sys/devices/system/cpu/cpu"
 #define CBM_MASK_PATH		"/sys/fs/resctrl/info"
-#define L3_PATH			"/sys/fs/resctrl/info/L3"
-#define MB_PATH			"/sys/fs/resctrl/info/MB"
-#define L3_MON_PATH		"/sys/fs/resctrl/info/L3_MON"
-#define L3_MON_FEATURES_PATH	"/sys/fs/resctrl/info/L3_MON/mon_features"
 
 #define PARENT_EXIT(err_msg)			\
 	do {					\
@@ -83,7 +79,7 @@ int remount_resctrlfs(bool mum_resctrlfs
 int get_resource_id(int cpu_no, int *resource_id);
 int umount_resctrlfs(void);
 int validate_bw_report_request(char *bw_report);
-bool validate_resctrl_feature_request(const char *resctrl_val);
+bool validate_resctrl_feature_request(char *resctrl_val);
 char *fgrep(FILE *inf, const char *str);
 int taskset_benchmark(pid_t bm_pid, int cpu_no);
 void run_benchmark(int signum, siginfo_t *info, void *ucontext);
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -616,56 +616,26 @@ char *fgrep(FILE *inf, const char *str)
  * validate_resctrl_feature_request - Check if requested feature is valid.
  * @resctrl_val:	Requested feature
  *
- * Return: True if the feature is supported, else false
+ * Return: 0 on success, non-zero on failure
  */
-bool validate_resctrl_feature_request(const char *resctrl_val)
+bool validate_resctrl_feature_request(char *resctrl_val)
 {
-	struct stat statbuf;
+	FILE *inf = fopen("/proc/cpuinfo", "r");
 	bool found = false;
 	char *res;
-	FILE *inf;
 
-	if (!resctrl_val)
+	if (!inf)
 		return false;
 
-	if (remount_resctrlfs(false))
-		return false;
-
-	if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR))) {
-		if (!stat(L3_PATH, &statbuf))
-			return true;
-	} else if (!strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
-		if (!stat(MB_PATH, &statbuf))
-			return true;
-	} else if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)) ||
-		   !strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
-		if (!stat(L3_MON_PATH, &statbuf)) {
-			inf = fopen(L3_MON_FEATURES_PATH, "r");
-			if (!inf)
-				return false;
+	res = fgrep(inf, "flags");
 
-			if (!strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
-				res = fgrep(inf, "llc_occupancy");
-				if (res) {
-					found = true;
-					free(res);
-				}
-			}
+	if (res) {
+		char *s = strchr(res, ':');
 
-			if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR))) {
-				res = fgrep(inf, "mbm_total_bytes");
-				if (res) {
-					free(res);
-					res = fgrep(inf, "mbm_local_bytes");
-					if (res) {
-						found = true;
-						free(res);
-					}
-				}
-			}
-			fclose(inf);
-		}
+		found = s && !strstr(s, resctrl_val);
+		free(res);
 	}
+	fclose(inf);
 
 	return found;
 }


