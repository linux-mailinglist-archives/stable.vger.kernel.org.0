Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F283D4AFA56
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiBISga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbiBISgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322ECC05CBAB;
        Wed,  9 Feb 2022 10:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2F4EB821BD;
        Wed,  9 Feb 2022 18:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F1DC340ED;
        Wed,  9 Feb 2022 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431762;
        bh=LqAIqUeUEKgW92UTw1yJ3kk8qc1HcfhyXlsTFk6oZNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ou8R3fwhaKtmfVL9Lp0A9Ow6K9yspg7eejKEBXQs6lD+dK8fC5iT99S2MOITbJJFj
         XNJyviUKABfpdwzYHgfmlv/kWhd4O756HksT9+nrldJjjTZpsczwZOfivJZUEku2zO
         YuusqJMqOwZN6jesY0ismgAAimxzL3nD2GxuN1HX/XGo4c2Vr+31tOYX+c+oW1FWEy
         YYI4yRuWbY6A+70bRwH3M+bzcDQsmcn9cB/Uqou+PKdBqShJHel1Eg9voZ2vosV9s1
         SXsYdJAzGk9iRa0QaOv0YN9D3Ih3yRv6sSXUUDjtU1O8s0ggYqzSWhcBYlOzkVTb3h
         87qhteDE/mnCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 26/42] kselftest: Fix vdso_test_abi return status
Date:   Wed,  9 Feb 2022 13:32:58 -0500
Message-Id: <20220209183335.46545-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit ec049891b2dc16591813eacaddc476b3d27c8c14 ]

vdso_test_abi contains a batch of tests that verify the validity of the
vDSO ABI.

When a vDSO symbol is not found the relevant test is skipped reporting
KSFT_SKIP. All the tests return values are then added in a single
variable which is checked to verify failures. This approach can have
side effects which result in reporting the wrong kselftest exit status.

Fix vdso_test_abi verifying the return code of each test separately.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_abi.c | 135 +++++++++----------
 1 file changed, 62 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_abi.c b/tools/testing/selftests/vDSO/vdso_test_abi.c
index 3d603f1394af4..883ca85424bc5 100644
--- a/tools/testing/selftests/vDSO/vdso_test_abi.c
+++ b/tools/testing/selftests/vDSO/vdso_test_abi.c
@@ -33,110 +33,114 @@ typedef long (*vdso_clock_gettime_t)(clockid_t clk_id, struct timespec *ts);
 typedef long (*vdso_clock_getres_t)(clockid_t clk_id, struct timespec *ts);
 typedef time_t (*vdso_time_t)(time_t *t);
 
-static int vdso_test_gettimeofday(void)
+#define VDSO_TEST_PASS_MSG()	"\n%s(): PASS\n", __func__
+#define VDSO_TEST_FAIL_MSG(x)	"\n%s(): %s FAIL\n", __func__, x
+#define VDSO_TEST_SKIP_MSG(x)	"\n%s(): SKIP: Could not find %s\n", __func__, x
+
+static void vdso_test_gettimeofday(void)
 {
 	/* Find gettimeofday. */
 	vdso_gettimeofday_t vdso_gettimeofday =
 		(vdso_gettimeofday_t)vdso_sym(version, name[0]);
 
 	if (!vdso_gettimeofday) {
-		printf("Could not find %s\n", name[0]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[0]));
+		return;
 	}
 
 	struct timeval tv;
 	long ret = vdso_gettimeofday(&tv, 0);
 
 	if (ret == 0) {
-		printf("The time is %lld.%06lld\n",
-		       (long long)tv.tv_sec, (long long)tv.tv_usec);
+		ksft_print_msg("The time is %lld.%06lld\n",
+			       (long long)tv.tv_sec, (long long)tv.tv_usec);
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[0]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[0]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_clock_gettime(clockid_t clk_id)
+static void vdso_test_clock_gettime(clockid_t clk_id)
 {
 	/* Find clock_gettime. */
 	vdso_clock_gettime_t vdso_clock_gettime =
 		(vdso_clock_gettime_t)vdso_sym(version, name[1]);
 
 	if (!vdso_clock_gettime) {
-		printf("Could not find %s\n", name[1]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[1]));
+		return;
 	}
 
 	struct timespec ts;
 	long ret = vdso_clock_gettime(clk_id, &ts);
 
 	if (ret == 0) {
-		printf("The time is %lld.%06lld\n",
-		       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_print_msg("The time is %lld.%06lld\n",
+			       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[1]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[1]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_time(void)
+static void vdso_test_time(void)
 {
 	/* Find time. */
 	vdso_time_t vdso_time =
 		(vdso_time_t)vdso_sym(version, name[2]);
 
 	if (!vdso_time) {
-		printf("Could not find %s\n", name[2]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[2]));
+		return;
 	}
 
 	long ret = vdso_time(NULL);
 
 	if (ret > 0) {
-		printf("The time in hours since January 1, 1970 is %lld\n",
+		ksft_print_msg("The time in hours since January 1, 1970 is %lld\n",
 				(long long)(ret / 3600));
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[2]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[2]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_clock_getres(clockid_t clk_id)
+static void vdso_test_clock_getres(clockid_t clk_id)
 {
+	int clock_getres_fail = 0;
+
 	/* Find clock_getres. */
 	vdso_clock_getres_t vdso_clock_getres =
 		(vdso_clock_getres_t)vdso_sym(version, name[3]);
 
 	if (!vdso_clock_getres) {
-		printf("Could not find %s\n", name[3]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[3]));
+		return;
 	}
 
 	struct timespec ts, sys_ts;
 	long ret = vdso_clock_getres(clk_id, &ts);
 
 	if (ret == 0) {
-		printf("The resolution is %lld %lld\n",
-		       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_print_msg("The vdso resolution is %lld %lld\n",
+			       (long long)ts.tv_sec, (long long)ts.tv_nsec);
 	} else {
-		printf("%s failed\n", name[3]);
-		return KSFT_FAIL;
+		clock_getres_fail++;
 	}
 
 	ret = syscall(SYS_clock_getres, clk_id, &sys_ts);
 
-	if ((sys_ts.tv_sec != ts.tv_sec) || (sys_ts.tv_nsec != ts.tv_nsec)) {
-		printf("%s failed\n", name[3]);
-		return KSFT_FAIL;
-	}
+	ksft_print_msg("The syscall resolution is %lld %lld\n",
+			(long long)sys_ts.tv_sec, (long long)sys_ts.tv_nsec);
 
-	return KSFT_PASS;
+	if ((sys_ts.tv_sec != ts.tv_sec) || (sys_ts.tv_nsec != ts.tv_nsec))
+		clock_getres_fail++;
+
+	if (clock_getres_fail > 0) {
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[3]));
+	} else {
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
+	}
 }
 
 const char *vdso_clock_name[12] = {
@@ -158,36 +162,23 @@ const char *vdso_clock_name[12] = {
  * This function calls vdso_test_clock_gettime and vdso_test_clock_getres
  * with different values for clock_id.
  */
-static inline int vdso_test_clock(clockid_t clock_id)
+static inline void vdso_test_clock(clockid_t clock_id)
 {
-	int ret0, ret1;
-
-	ret0 = vdso_test_clock_gettime(clock_id);
-	/* A skipped test is considered passed */
-	if (ret0 == KSFT_SKIP)
-		ret0 = KSFT_PASS;
-
-	ret1 = vdso_test_clock_getres(clock_id);
-	/* A skipped test is considered passed */
-	if (ret1 == KSFT_SKIP)
-		ret1 = KSFT_PASS;
+	ksft_print_msg("\nclock_id: %s\n", vdso_clock_name[clock_id]);
 
-	ret0 += ret1;
+	vdso_test_clock_gettime(clock_id);
 
-	printf("clock_id: %s", vdso_clock_name[clock_id]);
-
-	if (ret0 > 0)
-		printf(" [FAIL]\n");
-	else
-		printf(" [PASS]\n");
-
-	return ret0;
+	vdso_test_clock_getres(clock_id);
 }
 
+#define VDSO_TEST_PLAN	16
+
 int main(int argc, char **argv)
 {
 	unsigned long sysinfo_ehdr = getauxval(AT_SYSINFO_EHDR);
-	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(VDSO_TEST_PLAN);
 
 	if (!sysinfo_ehdr) {
 		printf("AT_SYSINFO_EHDR is not present!\n");
@@ -201,44 +192,42 @@ int main(int argc, char **argv)
 
 	vdso_init_from_sysinfo_ehdr(getauxval(AT_SYSINFO_EHDR));
 
-	ret = vdso_test_gettimeofday();
+	vdso_test_gettimeofday();
 
 #if _POSIX_TIMERS > 0
 
 #ifdef CLOCK_REALTIME
-	ret += vdso_test_clock(CLOCK_REALTIME);
+	vdso_test_clock(CLOCK_REALTIME);
 #endif
 
 #ifdef CLOCK_BOOTTIME
-	ret += vdso_test_clock(CLOCK_BOOTTIME);
+	vdso_test_clock(CLOCK_BOOTTIME);
 #endif
 
 #ifdef CLOCK_TAI
-	ret += vdso_test_clock(CLOCK_TAI);
+	vdso_test_clock(CLOCK_TAI);
 #endif
 
 #ifdef CLOCK_REALTIME_COARSE
-	ret += vdso_test_clock(CLOCK_REALTIME_COARSE);
+	vdso_test_clock(CLOCK_REALTIME_COARSE);
 #endif
 
 #ifdef CLOCK_MONOTONIC
-	ret += vdso_test_clock(CLOCK_MONOTONIC);
+	vdso_test_clock(CLOCK_MONOTONIC);
 #endif
 
 #ifdef CLOCK_MONOTONIC_RAW
-	ret += vdso_test_clock(CLOCK_MONOTONIC_RAW);
+	vdso_test_clock(CLOCK_MONOTONIC_RAW);
 #endif
 
 #ifdef CLOCK_MONOTONIC_COARSE
-	ret += vdso_test_clock(CLOCK_MONOTONIC_COARSE);
+	vdso_test_clock(CLOCK_MONOTONIC_COARSE);
 #endif
 
 #endif
 
-	ret += vdso_test_time();
-
-	if (ret > 0)
-		return KSFT_FAIL;
+	vdso_test_time();
 
-	return KSFT_PASS;
+	ksft_print_cnts();
+	return ksft_get_fail_cnt() == 0 ? KSFT_PASS : KSFT_FAIL;
 }
-- 
2.34.1

