Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4649337884F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhEJLVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhEJLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B24613D3;
        Mon, 10 May 2021 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644756;
        bh=T54aLA5wD0D6/LLW3960542PD7sKXeumim8pBYl7Fos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPwrnewayjP/PbYkKjoKWQPrBEPKnABqeM/UPfRRNSZ1aCaknP/M8U0dnf0S6tZil
         bF+VjTGPzFkgltFqK7THtkq2MhYq0FuN6EUSROPnH3ohORQKQjMzfQ7J+rwcGR6ZjM
         SjJpBDLn3utjzyAOUXVEkbfEwnXJOOw18slZLkWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 211/384] selftests/resctrl: Use resctrl/info for feature detection
Date:   Mon, 10 May 2021 12:20:00 +0200
Message-Id: <20210510102021.850812603@linuxfoundation.org>
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

[ Upstream commit ee0415681eb661efa1eb2db7acc263f2c7df1e23 ]

Resctrl test suite before running any unit test (like cmt, cat, mbm and
mba) should first check if the feature is enabled (by kernel and not just
supported by H/W) on the platform or not.
validate_resctrl_feature_request() is supposed to do that. This function
intends to grep for relevant flags in /proc/cpuinfo but there are several
issues here

1. validate_resctrl_feature_request() calls fgrep() to get flags from
   /proc/cpuinfo. But, fgrep() can only return a string with maximum of 255
   characters and hence the complete cpu flags are never returned.
2. The substring search logic is also busted. If strstr() finds requested
   resctrl feature in the cpu flags, it returns pointer to the first
   occurrence. But, the logic negates the return value of strstr() and
   hence validate_resctrl_feature_request() returns false if the feature is
   present in the cpu flags and returns true if the feature is not present.
3. validate_resctrl_feature_request() checks if a resctrl feature is
   reported in /proc/cpuinfo flags or not. Having a cpu flag means that the
   H/W supports the feature, but it doesn't mean that the kernel enabled
   it. A user could selectively enable only a subset of resctrl features
   using kernel command line arguments. Hence, /proc/cpuinfo isn't a
   reliable source to check if a feature is enabled or not.

The 3rd issue being the major one and fixing it requires changing the way
validate_resctrl_feature_request() works. Since, /proc/cpuinfo isn't the
right place to check if a resctrl feature is enabled or not, a more
appropriate place is /sys/fs/resctrl/info directory. Change
validate_resctrl_feature_request() such that,

1. For cat, check if /sys/fs/resctrl/info/L3 directory is present or not
2. For mba, check if /sys/fs/resctrl/info/MB directory is present or not
3. For cmt, check if /sys/fs/resctrl/info/L3_MON directory is present and
   check if /sys/fs/resctrl/info/L3_MON/mon_features has llc_occupancy
4. For mbm, check if /sys/fs/resctrl/info/L3_MON directory is present and
   check if /sys/fs/resctrl/info/L3_MON/mon_features has
   mbm_<total/local>_bytes

Please note that only L3_CAT, L3_CMT, MBA and MBM are supported. CDP and L2
variants can be added later.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl.h   |  6 ++-
 tools/testing/selftests/resctrl/resctrlfs.c | 52 ++++++++++++++++-----
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 36da6136af96..9dcc96e1ad3d 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -28,6 +28,10 @@
 #define RESCTRL_PATH		"/sys/fs/resctrl"
 #define PHYS_ID_PATH		"/sys/devices/system/cpu/cpu"
 #define CBM_MASK_PATH		"/sys/fs/resctrl/info"
+#define L3_PATH			"/sys/fs/resctrl/info/L3"
+#define MB_PATH			"/sys/fs/resctrl/info/MB"
+#define L3_MON_PATH		"/sys/fs/resctrl/info/L3_MON"
+#define L3_MON_FEATURES_PATH	"/sys/fs/resctrl/info/L3_MON/mon_features"
 
 #define PARENT_EXIT(err_msg)			\
 	do {					\
@@ -79,7 +83,7 @@ int remount_resctrlfs(bool mum_resctrlfs);
 int get_resource_id(int cpu_no, int *resource_id);
 int umount_resctrlfs(void);
 int validate_bw_report_request(char *bw_report);
-bool validate_resctrl_feature_request(char *resctrl_val);
+bool validate_resctrl_feature_request(const char *resctrl_val);
 char *fgrep(FILE *inf, const char *str);
 int taskset_benchmark(pid_t bm_pid, int cpu_no);
 void run_benchmark(int signum, siginfo_t *info, void *ucontext);
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 4174e48e06d1..b57170f53861 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -616,26 +616,56 @@ char *fgrep(FILE *inf, const char *str)
  * validate_resctrl_feature_request - Check if requested feature is valid.
  * @resctrl_val:	Requested feature
  *
- * Return: 0 on success, non-zero on failure
+ * Return: True if the feature is supported, else false
  */
-bool validate_resctrl_feature_request(char *resctrl_val)
+bool validate_resctrl_feature_request(const char *resctrl_val)
 {
-	FILE *inf = fopen("/proc/cpuinfo", "r");
+	struct stat statbuf;
 	bool found = false;
 	char *res;
+	FILE *inf;
 
-	if (!inf)
+	if (!resctrl_val)
 		return false;
 
-	res = fgrep(inf, "flags");
-
-	if (res) {
-		char *s = strchr(res, ':');
+	if (remount_resctrlfs(false))
+		return false;
 
-		found = s && !strstr(s, resctrl_val);
-		free(res);
+	if (!strncmp(resctrl_val, CAT_STR, sizeof(CAT_STR))) {
+		if (!stat(L3_PATH, &statbuf))
+			return true;
+	} else if (!strncmp(resctrl_val, MBA_STR, sizeof(MBA_STR))) {
+		if (!stat(MB_PATH, &statbuf))
+			return true;
+	} else if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR)) ||
+		   !strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
+		if (!stat(L3_MON_PATH, &statbuf)) {
+			inf = fopen(L3_MON_FEATURES_PATH, "r");
+			if (!inf)
+				return false;
+
+			if (!strncmp(resctrl_val, CMT_STR, sizeof(CMT_STR))) {
+				res = fgrep(inf, "llc_occupancy");
+				if (res) {
+					found = true;
+					free(res);
+				}
+			}
+
+			if (!strncmp(resctrl_val, MBM_STR, sizeof(MBM_STR))) {
+				res = fgrep(inf, "mbm_total_bytes");
+				if (res) {
+					free(res);
+					res = fgrep(inf, "mbm_local_bytes");
+					if (res) {
+						found = true;
+						free(res);
+					}
+				}
+			}
+			fclose(inf);
+		}
 	}
-	fclose(inf);
 
 	return found;
 }
-- 
2.30.2



