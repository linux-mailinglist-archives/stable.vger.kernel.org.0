Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD216DD92E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDKLQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjDKLQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:16:09 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78BD49E1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:15:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CA04766031AD
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 12:15:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681211745;
        bh=lyYOmrmdVRpPU4SHSyq/vn0Txp8gN1H+tDixvba7Sfw=;
        h=From:To:Subject:Date:From;
        b=F/29y7PE1NdzmJkidQkRPfYWG/ymwF4ZSFBsKAc3tvJmtuIpYsPjjmm1GSYmVf2Ch
         3zK04sjEjXbYBwIrX7T6gjz70NDYhrKPNzkEUWpkCaxzBlVhwREwN06+cbRSe1+BPB
         BOfraeQcAdaTRPNGTx6gmHVZCPl3hpqfFEFVqo/de1XckufzQu/qEnmf3FYZ8zLIV+
         KFL+Hr4qQ7EsVDxtIsYftyoxPq2IJL5M4zitnDK2yR2ByyPs+oauzDJRtoCt0woxmH
         FR10+pmG+659a0LyKVyKZCYUvdmpekUs0YLznp6LfA1Zp4eNtmiUdhZ21wik44qdGI
         1Ftc5tdwSPtVQ==
From:   =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>
To:     stable@vger.kernel.org
Subject: [PATCH] selftests: intel_pstate: ftime() is deprecated
Date:   Tue, 11 Apr 2023 13:15:33 +0200
Message-Id: <20230411111533.1442349-1-ricardo.canuelo@collabora.com>
X-Mailer: git-send-email 2.25.1
selftests: intel_pstate: ftime() is deprecated
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Reviewed-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304060514.ELO1BqLI-lkp@intel.com/
Cc: <stable@vger.kernel.org> # 5.10.x
---
 tools/testing/selftests/intel_pstate/aperf.c | 22 ++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/intel_pstate/aperf.c b/tools/testing/selftests/intel_pstate/aperf.c
index f6cd03a87493..a8acf3996973 100644
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
-- 
2.25.1

