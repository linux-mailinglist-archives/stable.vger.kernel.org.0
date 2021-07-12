Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10263C4E07
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbhGLHQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:27441 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240471AbhGLHPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="209975955"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="209975955"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:12:51 -0700
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="501901343"
Received: from xshen14-linux.bj.intel.com ([10.238.155.105])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:12:48 -0700
From:   Xiaochen Shen <xiaochen.shen@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Cc:     shuah@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        reinette.chatre@intel.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, pei.p.jia@intel.com,
        xiaochen.shen@intel.com
Subject: [PATCH 5.12] selftests/resctrl: Fix incorrect parsing of option "-t"
Date:   Mon, 12 Jul 2021 15:55:23 +0800
Message-Id: <1626076523-924-1-git-send-email-xiaochen.shen@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <16260087708135@kroah.com>
References: <16260087708135@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1421ec684a43379b2aa3cfda20b03d38282dc990 upstream.

Resctrl test suite accepts command line argument "-t" to specify the
unit tests to run in the test list (e.g., -t mbm,mba,cmt,cat) as
documented in the help.

When calling strtok() to parse the option, the incorrect delimiters
argument ":\t" is used. As a result, passing "-t mbm,mba,cmt,cat" throws
an invalid option error.

Fix this by using delimiters argument "," instead of ":\t" for parsing
of unit tests list. At the same time, remove the unnecessary "spaces"
between the unit tests in help documentation to prevent confusion.

Fixes: 790bf585b0ee ("selftests/resctrl: Add Cache Allocation Technology (CAT) selftest")
Fixes: 78941183d1b1 ("selftests/resctrl: Add Cache QoS Monitoring (CQM) selftest")
Fixes: ecdbb911f22d ("selftests/resctrl: Add MBM test")
Fixes: 034c7678dd2c ("selftests/resctrl: Add README for resctrl tests")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/resctrl/README          | 2 +-
 tools/testing/selftests/resctrl/resctrl_tests.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/resctrl/README b/tools/testing/selftests/resctrl/README
index 6e5a0ff..20502cb 100644
--- a/tools/testing/selftests/resctrl/README
+++ b/tools/testing/selftests/resctrl/README
@@ -47,7 +47,7 @@ Parameter '-h' shows usage information.
 
 usage: resctrl_tests [-h] [-b "benchmark_cmd [options]"] [-t test list] [-n no_of_bits]
         -b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CQM default benchmark is builtin fill_buf
-        -t test list: run tests specified in the test list, e.g. -t mbm, mba, cqm, cat
+        -t test list: run tests specified in the test list, e.g. -t mbm,mba,cqm,cat
         -n no_of_bits: run cache tests using specified no of bits in cache bit mask
         -p cpu_no: specify CPU number to run the test. 1 is default
         -h: help
diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index ac22696..bd98746 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -40,7 +40,7 @@ static void cmd_help(void)
 	printf("\t-b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CQM");
 	printf("\t default benchmark is builtin fill_buf\n");
 	printf("\t-t test list: run tests specified in the test list, ");
-	printf("e.g. -t mbm, mba, cqm, cat\n");
+	printf("e.g. -t mbm,mba,cqm,cat\n");
 	printf("\t-n no_of_bits: run cache tests using specified no of bits in cache bit mask\n");
 	printf("\t-p cpu_no: specify CPU number to run the test. 1 is default\n");
 	printf("\t-h: help\n");
@@ -98,7 +98,7 @@ int main(int argc, char **argv)
 
 					return -1;
 				}
-				token = strtok(NULL, ":\t");
+				token = strtok(NULL, ",");
 			}
 			break;
 		case 'p':
-- 
1.8.3.1

