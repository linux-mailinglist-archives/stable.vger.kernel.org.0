Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580393E9B6C
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 01:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhHKXyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 19:54:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:48862 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHKXyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 19:54:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="214976734"
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="214976734"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 16:54:27 -0700
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="676474435"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 16:54:27 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     stable@vger.kernel.org
Cc:     fenghua.yu@intel.com, skhan@linuxfoundation.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, xiaochen.shen@intel.com,
        tony.luck@intel.com, Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.10] Revert "selftests/resctrl: Use resctrl/info for feature detection"
Date:   Wed, 11 Aug 2021 16:54:21 -0700
Message-Id: <dde8f92f6ea1c12b3d0f1c1d83a195e0dea781d1.1628725515.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 19eaad1400eab34e97ec4467cd2ab694d1caf20c which is
ee0415681eb661efa1eb2db7acc263f2c7df1e23 upstream.

This commit is not a stable candidate and was backported without needed
dependencies that results in the resctrl tests unable to compile.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

The same commit is present in v5.12.y where it also causes the
resctrl tests to fail to compile. I did not submit a revert against v5.12.y
because it is EOL.

 tools/testing/selftests/resctrl/resctrl.h   |  6 +--
 tools/testing/selftests/resctrl/resctrlfs.c | 52 +++++----------------
 2 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 9dcc96e1ad3d..36da6136af96 100644
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
@@ -83,7 +79,7 @@ int remount_resctrlfs(bool mum_resctrlfs);
 int get_resource_id(int cpu_no, int *resource_id);
 int umount_resctrlfs(void);
 int validate_bw_report_request(char *bw_report);
-bool validate_resctrl_feature_request(const char *resctrl_val);
+bool validate_resctrl_feature_request(char *resctrl_val);
 char *fgrep(FILE *inf, const char *str);
 int taskset_benchmark(pid_t bm_pid, int cpu_no);
 void run_benchmark(int signum, siginfo_t *info, void *ucontext);
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index b57170f53861..4174e48e06d1 100644
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
+	res = fgrep(inf, "flags");
 
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
-
-			if (!strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
-				res = fgrep(inf, "llc_occupancy");
-				if (res) {
-					found = true;
-					free(res);
-				}
-			}
-
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
+	if (res) {
+		char *s = strchr(res, ':');
+
+		found = s && !strstr(s, resctrl_val);
+		free(res);
 	}
+	fclose(inf);
 
 	return found;
 }
-- 
2.25.1

