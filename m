Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742D5378849
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhEJLVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236821AbhEJLKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88CA613D6;
        Mon, 10 May 2021 11:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644746;
        bh=tUIDDDqeNXJUgmAPa6kLdcp9Jo0AeRYDEfVFI6u/9XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeZ98SONKQ/H36P2+T/0O8BkVhC1TWS0WSaxgEoiOCxmpvqhTwcUXBQaL8apxQYXr
         Ex94rPF1mZIIWsxAaG3jNWGz+JXDeg9UUfxEOm96H4wsor4t4Y0bMFCUYknXNhmJ/s
         MCBrARjQbw3WdZM8lJ1GjzNTKHQPwrQKcxRY/Tq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 207/384] selftests/resctrl: Fix compilation issues for global variables
Date:   Mon, 10 May 2021 12:19:56 +0200
Message-Id: <20210510102021.720588310@linuxfoundation.org>
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

[ Upstream commit 8236c51d85a64643588505a6791e022cc8d84864 ]

Reinette reported following compilation issue on Fedora 32, gcc version
10.1.1

/usr/bin/ld: cqm_test.o:<src_dir>/cqm_test.c:22: multiple definition of
`cache_size'; cat_test.o:<src_dir>/cat_test.c:23: first defined here

The same issue is reported for long_mask, cbm_mask, count_of_bits etc
variables as well. Compiler isn't happy because these variables are
defined globally in two .c files namely cqm_test.c and cat_test.c and
the compiler during compilation finds that the variable is already
defined (multiple definition error).

Taking a closer look at the usage of these variables reveals that these
variables are used only locally in functions such as cqm_resctrl_val()
(defined in cqm_test.c) and cat_perf_miss_val() (defined in cat_test.c).
These variables are not shared between those functions. So, there is no
need for these variables to be global. Hence, fix this issue by making
them static variables.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/cat_test.c  | 10 +++++-----
 tools/testing/selftests/resctrl/cqm_test.c  | 10 +++++-----
 tools/testing/selftests/resctrl/resctrl.h   |  2 +-
 tools/testing/selftests/resctrl/resctrlfs.c | 10 +++++-----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 5da43767b973..bdeeb5772592 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -17,10 +17,10 @@
 #define MAX_DIFF_PERCENT	4
 #define MAX_DIFF		1000000
 
-int count_of_bits;
-char cbm_mask[256];
-unsigned long long_mask;
-unsigned long cache_size;
+static int count_of_bits;
+static char cbm_mask[256];
+static unsigned long long_mask;
+static unsigned long cache_size;
 
 /*
  * Change schemata. Write schemata to specified
@@ -136,7 +136,7 @@ int cat_perf_miss_val(int cpu_no, int n, char *cache_type)
 		return -1;
 
 	/* Get default cbm mask for L3/L2 cache */
-	ret = get_cbm_mask(cache_type);
+	ret = get_cbm_mask(cache_type, cbm_mask);
 	if (ret)
 		return ret;
 
diff --git a/tools/testing/selftests/resctrl/cqm_test.c b/tools/testing/selftests/resctrl/cqm_test.c
index 5e7308ac63be..de33d1c0466e 100644
--- a/tools/testing/selftests/resctrl/cqm_test.c
+++ b/tools/testing/selftests/resctrl/cqm_test.c
@@ -16,10 +16,10 @@
 #define MAX_DIFF		2000000
 #define MAX_DIFF_PERCENT	15
 
-int count_of_bits;
-char cbm_mask[256];
-unsigned long long_mask;
-unsigned long cache_size;
+static int count_of_bits;
+static char cbm_mask[256];
+static unsigned long long_mask;
+static unsigned long cache_size;
 
 static int cqm_setup(int num, ...)
 {
@@ -125,7 +125,7 @@ int cqm_resctrl_val(int cpu_no, int n, char **benchmark_cmd)
 	if (!validate_resctrl_feature_request("cqm"))
 		return -1;
 
-	ret = get_cbm_mask("L3");
+	ret = get_cbm_mask("L3", cbm_mask);
 	if (ret)
 		return ret;
 
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 39bf59c6b9c5..959c71e39bdc 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -92,7 +92,7 @@ void tests_cleanup(void);
 void mbm_test_cleanup(void);
 int mba_schemata_change(int cpu_no, char *bw_report, char **benchmark_cmd);
 void mba_test_cleanup(void);
-int get_cbm_mask(char *cache_type);
+int get_cbm_mask(char *cache_type, char *cbm_mask);
 int get_cache_size(int cpu_no, char *cache_type, unsigned long *cache_size);
 void ctrlc_handler(int signum, siginfo_t *info, void *ptr);
 int cat_val(struct resctrl_val_param *param);
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 19c0ec4045a4..2a16100c9c3f 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -49,8 +49,6 @@ static int find_resctrl_mount(char *buffer)
 	return -ENOENT;
 }
 
-char cbm_mask[256];
-
 /*
  * remount_resctrlfs - Remount resctrl FS at /sys/fs/resctrl
  * @mum_resctrlfs:	Should the resctrl FS be remounted?
@@ -205,16 +203,18 @@ int get_cache_size(int cpu_no, char *cache_type, unsigned long *cache_size)
 /*
  * get_cbm_mask - Get cbm mask for given cache
  * @cache_type:	Cache level L2/L3
- *
- * Mask is stored in cbm_mask which is global variable.
+ * @cbm_mask:	cbm_mask returned as a string
  *
  * Return: = 0 on success, < 0 on failure.
  */
-int get_cbm_mask(char *cache_type)
+int get_cbm_mask(char *cache_type, char *cbm_mask)
 {
 	char cbm_mask_path[1024];
 	FILE *fp;
 
+	if (!cbm_mask)
+		return -1;
+
 	sprintf(cbm_mask_path, "%s/%s/cbm_mask", CBM_MASK_PATH, cache_type);
 
 	fp = fopen(cbm_mask_path, "r");
-- 
2.30.2



