Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1078493C7
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfFQVd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbfFQV0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6CC20657;
        Mon, 17 Jun 2019 21:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806764;
        bh=GqUyAZ9cYwihufHjE1YGKei3CfrDO+dxT/gyt1/kSXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1E9DimsWempKNAhGTl/xToClfsXJ8djTuwvvb2KXkF46Edop3Z40ODbbIWx1kwtCg
         HO2454+ROL6aykh3bVAGlY+nu66TaKWcCIrHtZAkjw5bBEsvqqW92kMQ0Kk00yeqI8
         Ay9lhzSFEsSuMr6jMW4WrW8pe1s6MBW+LGq6z2WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/75] selftests/timers: Add missing fflush(stdout) calls
Date:   Mon, 17 Jun 2019 23:10:00 +0200
Message-Id: <20190617210754.650176996@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe48319243a626c860fd666ca032daacc2ba84a5 ]

When running under a pipe, some timer tests would not report output in
real-time because stdout flushes were missing after printf()s that lacked
a newline. This adds them to restore real-time status output that humans
can enjoy.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/adjtick.c        | 1 +
 tools/testing/selftests/timers/leapcrash.c      | 1 +
 tools/testing/selftests/timers/mqueue-lat.c     | 1 +
 tools/testing/selftests/timers/nanosleep.c      | 1 +
 tools/testing/selftests/timers/nsleep-lat.c     | 1 +
 tools/testing/selftests/timers/raw_skew.c       | 1 +
 tools/testing/selftests/timers/set-tai.c        | 1 +
 tools/testing/selftests/timers/set-tz.c         | 2 ++
 tools/testing/selftests/timers/threadtest.c     | 1 +
 tools/testing/selftests/timers/valid-adjtimex.c | 2 ++
 10 files changed, 12 insertions(+)

diff --git a/tools/testing/selftests/timers/adjtick.c b/tools/testing/selftests/timers/adjtick.c
index 0caca3a06bd2..54d8d87f36b3 100644
--- a/tools/testing/selftests/timers/adjtick.c
+++ b/tools/testing/selftests/timers/adjtick.c
@@ -136,6 +136,7 @@ int check_tick_adj(long tickval)
 
 	eppm = get_ppm_drift();
 	printf("%lld usec, %lld ppm", systick + (systick * eppm / MILLION), eppm);
+	fflush(stdout);
 
 	tx1.modes = 0;
 	adjtimex(&tx1);
diff --git a/tools/testing/selftests/timers/leapcrash.c b/tools/testing/selftests/timers/leapcrash.c
index 830c462f605d..dc80728ed191 100644
--- a/tools/testing/selftests/timers/leapcrash.c
+++ b/tools/testing/selftests/timers/leapcrash.c
@@ -101,6 +101,7 @@ int main(void)
 		}
 		clear_time_state();
 		printf(".");
+		fflush(stdout);
 	}
 	printf("[OK]\n");
 	return ksft_exit_pass();
diff --git a/tools/testing/selftests/timers/mqueue-lat.c b/tools/testing/selftests/timers/mqueue-lat.c
index 1867db5d6f5e..7916cf5cc6ff 100644
--- a/tools/testing/selftests/timers/mqueue-lat.c
+++ b/tools/testing/selftests/timers/mqueue-lat.c
@@ -102,6 +102,7 @@ int main(int argc, char **argv)
 	int ret;
 
 	printf("Mqueue latency :                          ");
+	fflush(stdout);
 
 	ret = mqueue_lat_test();
 	if (ret < 0) {
diff --git a/tools/testing/selftests/timers/nanosleep.c b/tools/testing/selftests/timers/nanosleep.c
index 8adb0bb51d4d..71b5441c2fd9 100644
--- a/tools/testing/selftests/timers/nanosleep.c
+++ b/tools/testing/selftests/timers/nanosleep.c
@@ -142,6 +142,7 @@ int main(int argc, char **argv)
 			continue;
 
 		printf("Nanosleep %-31s ", clockstring(clockid));
+		fflush(stdout);
 
 		length = 10;
 		while (length <= (NSEC_PER_SEC * 10)) {
diff --git a/tools/testing/selftests/timers/nsleep-lat.c b/tools/testing/selftests/timers/nsleep-lat.c
index c3c3dc10db17..eb3e79ed7b4a 100644
--- a/tools/testing/selftests/timers/nsleep-lat.c
+++ b/tools/testing/selftests/timers/nsleep-lat.c
@@ -155,6 +155,7 @@ int main(int argc, char **argv)
 			continue;
 
 		printf("nsleep latency %-26s ", clockstring(clockid));
+		fflush(stdout);
 
 		length = 10;
 		while (length <= (NSEC_PER_SEC * 10)) {
diff --git a/tools/testing/selftests/timers/raw_skew.c b/tools/testing/selftests/timers/raw_skew.c
index dcf73c5dab6e..b41d8dd0c40c 100644
--- a/tools/testing/selftests/timers/raw_skew.c
+++ b/tools/testing/selftests/timers/raw_skew.c
@@ -112,6 +112,7 @@ int main(int argv, char **argc)
 		printf("WARNING: ADJ_OFFSET in progress, this will cause inaccurate results\n");
 
 	printf("Estimating clock drift: ");
+	fflush(stdout);
 	sleep(120);
 
 	get_monotonic_and_raw(&mon, &raw);
diff --git a/tools/testing/selftests/timers/set-tai.c b/tools/testing/selftests/timers/set-tai.c
index 70fed27d8fd3..8c4179ee2ca2 100644
--- a/tools/testing/selftests/timers/set-tai.c
+++ b/tools/testing/selftests/timers/set-tai.c
@@ -55,6 +55,7 @@ int main(int argc, char **argv)
 	printf("tai offset started at %i\n", ret);
 
 	printf("Checking tai offsets can be properly set: ");
+	fflush(stdout);
 	for (i = 1; i <= 60; i++) {
 		ret = set_tai(i);
 		ret = get_tai();
diff --git a/tools/testing/selftests/timers/set-tz.c b/tools/testing/selftests/timers/set-tz.c
index 877fd5532fee..62bd33eb16f0 100644
--- a/tools/testing/selftests/timers/set-tz.c
+++ b/tools/testing/selftests/timers/set-tz.c
@@ -65,6 +65,7 @@ int main(int argc, char **argv)
 	printf("tz_minuteswest started at %i, dst at %i\n", min, dst);
 
 	printf("Checking tz_minuteswest can be properly set: ");
+	fflush(stdout);
 	for (i = -15*60; i < 15*60; i += 30) {
 		ret = set_tz(i, dst);
 		ret = get_tz_min();
@@ -76,6 +77,7 @@ int main(int argc, char **argv)
 	printf("[OK]\n");
 
 	printf("Checking invalid tz_minuteswest values are caught: ");
+	fflush(stdout);
 
 	if (!set_tz(-15*60-1, dst)) {
 		printf("[FAILED] %i didn't return failure!\n", -15*60-1);
diff --git a/tools/testing/selftests/timers/threadtest.c b/tools/testing/selftests/timers/threadtest.c
index 759c9c06f1a0..cf3e48919874 100644
--- a/tools/testing/selftests/timers/threadtest.c
+++ b/tools/testing/selftests/timers/threadtest.c
@@ -163,6 +163,7 @@ int main(int argc, char **argv)
 	strftime(buf, 255, "%a, %d %b %Y %T %z", localtime(&start));
 	printf("%s\n", buf);
 	printf("Testing consistency with %i threads for %ld seconds: ", thread_count, runtime);
+	fflush(stdout);
 
 	/* spawn */
 	for (i = 0; i < thread_count; i++)
diff --git a/tools/testing/selftests/timers/valid-adjtimex.c b/tools/testing/selftests/timers/valid-adjtimex.c
index d9d3ab93b31a..5397de708d3c 100644
--- a/tools/testing/selftests/timers/valid-adjtimex.c
+++ b/tools/testing/selftests/timers/valid-adjtimex.c
@@ -123,6 +123,7 @@ int validate_freq(void)
 	/* Set the leap second insert flag */
 
 	printf("Testing ADJ_FREQ... ");
+	fflush(stdout);
 	for (i = 0; i < NUM_FREQ_VALID; i++) {
 		tx.modes = ADJ_FREQUENCY;
 		tx.freq = valid_freq[i];
@@ -250,6 +251,7 @@ int set_bad_offset(long sec, long usec, int use_nano)
 int validate_set_offset(void)
 {
 	printf("Testing ADJ_SETOFFSET... ");
+	fflush(stdout);
 
 	/* Test valid values */
 	if (set_offset(NSEC_PER_SEC - 1, 1))
-- 
2.20.1



