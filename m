Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC086E62A1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDRMeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjDRMeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03551C670
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D7C9629EA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F69CC433EF;
        Tue, 18 Apr 2023 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821232;
        bh=eDfIysiHtif25dioZ0+Vprp78mJ4bfvV3avaGi5lWFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPimGmX6Jw4sN9GHWoxuGXwUouDvyYSjg97mUOVv+w21+9yRzUGmKl9qI5Eewlhzx
         +Favc4Yr9tVZzYDkKKJMtyrmflgcTjR7Mm8kNSucL4nNeOv5qEoV+VoyZffcE0Fgqe
         F1Ip3Hzc2T8qWVNlb5dw8glfPjschcqnQFsspKy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 048/124] selftests: intel_pstate: ftime() is deprecated
Date:   Tue, 18 Apr 2023 14:21:07 +0200
Message-Id: <20230418120311.584136970@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

commit fc4a3a1bf9ad799181e4d4ec9c2598c0405bc27d upstream.

Use clock_gettime() instead of deprecated ftime().

  aperf.c: In function ‘main’:
  aperf.c:58:2: warning: ‘ftime’ is deprecated [-Wdeprecated-declarations]
     58 |  ftime(&before);
        |  ^~~~~
  In file included from aperf.c:9:
  /usr/include/sys/timeb.h:39:12: note: declared here
     39 | extern int ftime (struct timeb *__timebuf)
        |            ^~~~~

Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304060514.ELO1BqLI-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/intel_pstate/aperf.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/intel_pstate/aperf.c
+++ b/tools/testing/selftests/intel_pstate/aperf.c
@@ -10,8 +10,12 @@
 #include <sched.h>
 #include <errno.h>
 #include <string.h>
+#include <time.h>
 #include "../kselftest.h"
 
+#define MSEC_PER_SEC	1000L
+#define NSEC_PER_MSEC	1000000L
+
 void usage(char *name) {
 	printf ("Usage: %s cpunum\n", name);
 }
@@ -22,7 +26,7 @@ int main(int argc, char **argv) {
 	long long tsc, old_tsc, new_tsc;
 	long long aperf, old_aperf, new_aperf;
 	long long mperf, old_mperf, new_mperf;
-	struct timeb before, after;
+	struct timespec before, after;
 	long long int start, finish, total;
 	cpu_set_t cpuset;
 
@@ -55,7 +59,10 @@ int main(int argc, char **argv) {
 		return 1;
 	}
 
-	ftime(&before);
+	if (clock_gettime(CLOCK_MONOTONIC, &before) < 0) {
+		perror("clock_gettime");
+		return 1;
+	}
 	pread(fd, &old_tsc,  sizeof(old_tsc), 0x10);
 	pread(fd, &old_aperf,  sizeof(old_mperf), 0xe7);
 	pread(fd, &old_mperf,  sizeof(old_aperf), 0xe8);
@@ -64,7 +71,10 @@ int main(int argc, char **argv) {
 		sqrt(i);
 	}
 
-	ftime(&after);
+	if (clock_gettime(CLOCK_MONOTONIC, &after) < 0) {
+		perror("clock_gettime");
+		return 1;
+	}
 	pread(fd, &new_tsc,  sizeof(new_tsc), 0x10);
 	pread(fd, &new_aperf,  sizeof(new_mperf), 0xe7);
 	pread(fd, &new_mperf,  sizeof(new_aperf), 0xe8);
@@ -73,11 +83,11 @@ int main(int argc, char **argv) {
 	aperf = new_aperf-old_aperf;
 	mperf = new_mperf-old_mperf;
 
-	start = before.time*1000 + before.millitm;
-	finish = after.time*1000 + after.millitm;
+	start = before.tv_sec*MSEC_PER_SEC + before.tv_nsec/NSEC_PER_MSEC;
+	finish = after.tv_sec*MSEC_PER_SEC + after.tv_nsec/NSEC_PER_MSEC;
 	total = finish - start;
 
-	printf("runTime: %4.2f\n", 1.0*total/1000);
+	printf("runTime: %4.2f\n", 1.0*total/MSEC_PER_SEC);
 	printf("freq: %7.0f\n", tsc / (1.0*aperf / (1.0 * mperf)) / total);
 	return 0;
 }


