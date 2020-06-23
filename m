Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821022065C8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbgFWVdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388900AbgFWULi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7DCD20707;
        Tue, 23 Jun 2020 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943097;
        bh=7hjmVNYs1fMFtSxeFvZehOej53L8bR1/zAKWM8DOlyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJ95YSb9KduxgddiZOEioHPf/0vRm/2qlHD5GjO5V2UbiQ1WAMYjN0WUJLxtEq5ZL
         4tTNSXoiuzcuzZekxfp+LS834uIAwQ3ajE1CS01dUATWWp2cmn5/92U4rclKI0lk+K
         vLPds6yWj0ggDl4jeR1d2yGux+g5KmL2hbL9dBSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrei Vagin <avagin@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 258/477] selftests/timens: handle a case when alarm clocks are not supported
Date:   Tue, 23 Jun 2020 21:54:15 +0200
Message-Id: <20200623195419.765267864@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

[ Upstream commit 558ae0355a91c7d28fdf4c0011bee6ebb5118632 ]

This can happen if a testing node doesn't have RTC (real time clock)
hardware or it doesn't support alarms.

Fixes: 61c57676035d ("selftests/timens: Add Time Namespace test for supported clocks")
Acked-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reported-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timens/clock_nanosleep.c |  2 +-
 tools/testing/selftests/timens/timens.c          |  2 +-
 tools/testing/selftests/timens/timens.h          | 13 ++++++++++++-
 tools/testing/selftests/timens/timer.c           |  5 +++++
 tools/testing/selftests/timens/timerfd.c         |  5 +++++
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/timens/clock_nanosleep.c b/tools/testing/selftests/timens/clock_nanosleep.c
index 8e7b7c72ef65f..72d41b955fb22 100644
--- a/tools/testing/selftests/timens/clock_nanosleep.c
+++ b/tools/testing/selftests/timens/clock_nanosleep.c
@@ -119,7 +119,7 @@ int main(int argc, char *argv[])
 
 	ksft_set_plan(4);
 
-	check_config_posix_timers();
+	check_supported_timers();
 
 	if (unshare_timens())
 		return 1;
diff --git a/tools/testing/selftests/timens/timens.c b/tools/testing/selftests/timens/timens.c
index 098be7c83be3e..52b6a1185f52a 100644
--- a/tools/testing/selftests/timens/timens.c
+++ b/tools/testing/selftests/timens/timens.c
@@ -155,7 +155,7 @@ int main(int argc, char *argv[])
 
 	nscheck();
 
-	check_config_posix_timers();
+	check_supported_timers();
 
 	ksft_set_plan(ARRAY_SIZE(clocks) * 2);
 
diff --git a/tools/testing/selftests/timens/timens.h b/tools/testing/selftests/timens/timens.h
index e09e7e39bc52f..d4fc52d471462 100644
--- a/tools/testing/selftests/timens/timens.h
+++ b/tools/testing/selftests/timens/timens.h
@@ -14,15 +14,26 @@
 #endif
 
 static int config_posix_timers = true;
+static int config_alarm_timers = true;
 
-static inline void check_config_posix_timers(void)
+static inline void check_supported_timers(void)
 {
+	struct timespec ts;
+
 	if (timer_create(-1, 0, 0) == -1 && errno == ENOSYS)
 		config_posix_timers = false;
+
+	if (clock_gettime(CLOCK_BOOTTIME_ALARM, &ts) == -1 && errno == EINVAL)
+		config_alarm_timers = false;
 }
 
 static inline bool check_skip(int clockid)
 {
+	if (!config_alarm_timers && clockid == CLOCK_BOOTTIME_ALARM) {
+		ksft_test_result_skip("CLOCK_BOOTTIME_ALARM isn't supported\n");
+		return true;
+	}
+
 	if (config_posix_timers)
 		return false;
 
diff --git a/tools/testing/selftests/timens/timer.c b/tools/testing/selftests/timens/timer.c
index 96dba11ebe446..5e7f0051bd7be 100644
--- a/tools/testing/selftests/timens/timer.c
+++ b/tools/testing/selftests/timens/timer.c
@@ -22,6 +22,9 @@ int run_test(int clockid, struct timespec now)
 	timer_t fd;
 	int i;
 
+	if (check_skip(clockid))
+		return 0;
+
 	for (i = 0; i < 2; i++) {
 		struct sigevent sevp = {.sigev_notify = SIGEV_NONE};
 		int flags = 0;
@@ -74,6 +77,8 @@ int main(int argc, char *argv[])
 
 	nscheck();
 
+	check_supported_timers();
+
 	ksft_set_plan(3);
 
 	clock_gettime(CLOCK_MONOTONIC, &mtime_now);
diff --git a/tools/testing/selftests/timens/timerfd.c b/tools/testing/selftests/timens/timerfd.c
index eff1ec5ff215b..9edd43d6b2c13 100644
--- a/tools/testing/selftests/timens/timerfd.c
+++ b/tools/testing/selftests/timens/timerfd.c
@@ -28,6 +28,9 @@ int run_test(int clockid, struct timespec now)
 	long long elapsed;
 	int fd, i;
 
+	if (check_skip(clockid))
+		return 0;
+
 	if (tclock_gettime(clockid, &now))
 		return pr_perror("clock_gettime(%d)", clockid);
 
@@ -81,6 +84,8 @@ int main(int argc, char *argv[])
 
 	nscheck();
 
+	check_supported_timers();
+
 	ksft_set_plan(3);
 
 	clock_gettime(CLOCK_MONOTONIC, &mtime_now);
-- 
2.25.1



