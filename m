Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7FA3C511C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245092AbhGLHgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347374AbhGLHev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CDC460FF3;
        Mon, 12 Jul 2021 07:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075110;
        bh=sY+WEWnvf2Ll7xb8SHkHoORmkGKmyXaGESnYrbDIEUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNgTa4ppgA5tJNBoBmHUWQJR9IDkIJkXLFt7UDrvxJFRp7/THu27BS93XfoJ6u5I0
         CWQZ58jr22WT5r2zfNtzl+xQWlaEZNpH6UJLbeQ4XbbKdou7EDmHuYt5xa/QPy1GLi
         +O3N0HbZcWpHVLRMq1Y9nDoObzc6hyhZsEaV11fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.13 108/800] selftests/resctrl: Fix incorrect parsing of option "-t"
Date:   Mon, 12 Jul 2021 08:02:11 +0200
Message-Id: <20210712060928.214584545@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/resctrl/README          |    2 +-
 tools/testing/selftests/resctrl/resctrl_tests.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/resctrl/README
+++ b/tools/testing/selftests/resctrl/README
@@ -47,7 +47,7 @@ Parameter '-h' shows usage information.
 
 usage: resctrl_tests [-h] [-b "benchmark_cmd [options]"] [-t test list] [-n no_of_bits]
         -b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CMT default benchmark is builtin fill_buf
-        -t test list: run tests specified in the test list, e.g. -t mbm, mba, cmt, cat
+        -t test list: run tests specified in the test list, e.g. -t mbm,mba,cmt,cat
         -n no_of_bits: run cache tests using specified no of bits in cache bit mask
         -p cpu_no: specify CPU number to run the test. 1 is default
         -h: help
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -40,7 +40,7 @@ static void cmd_help(void)
 	printf("\t-b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CMT\n");
 	printf("\t   default benchmark is builtin fill_buf\n");
 	printf("\t-t test list: run tests specified in the test list, ");
-	printf("e.g. -t mbm, mba, cmt, cat\n");
+	printf("e.g. -t mbm,mba,cmt,cat\n");
 	printf("\t-n no_of_bits: run cache tests using specified no of bits in cache bit mask\n");
 	printf("\t-p cpu_no: specify CPU number to run the test. 1 is default\n");
 	printf("\t-h: help\n");
@@ -173,7 +173,7 @@ int main(int argc, char **argv)
 
 					return -1;
 				}
-				token = strtok(NULL, ":\t");
+				token = strtok(NULL, ",");
 			}
 			break;
 		case 'p':


