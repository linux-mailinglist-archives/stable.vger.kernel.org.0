Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF6F3C30BA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhGJCgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234005AbhGJCf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44AF61402;
        Sat, 10 Jul 2021 02:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884348;
        bh=cWHiH12FvTJFDthkEwrs//hjGIjPEoNDcrBkmfawt0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7NuQI/q4eYygFd5b+fkETJuL6NJp3Jv6Xolg1kgV/u/woJg+4AJbepf45QjeqLqr
         BjxjH4HgY4iGBU6F203c4t7EnKuZVsG1rYP5rwLL3+CwRXsoaTJdkxjdd2Gxm6tcsa
         +TMQlboXGzEOztuEGB6wyyYgrQn6GuEFH55MRSuNeRimXT8Rmw0Opp1SqZx1Jga0Ma
         PGlNjfjymiY1iY339Ur/0DkNqP9am3j39JYsQN2NBydfPOQBXWOAN3CpJ4GEgY57cS
         B0YDPkWpRwHEDBp0aQ08k09MH4oaPcKk/GfHYdlAsz9rchAxlbTi274KKnEE8vU9dG
         DOjjGAwwSk50A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/39] selftests: timers: rtcpie: skip test if default RTC device does not exist
Date:   Fri,  9 Jul 2021 22:31:44 -0400
Message-Id: <20210710023204.3171428-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 0d3e5a057992bdc66e4dca2ca50b77fa4a7bd90e ]

This test will require /dev/rtc0, the default RTC device, or one
specified by user to run. Since this default RTC is not guaranteed to
exist on all of the devices, so check its existence first, otherwise
skip this test with the kselftest skip code 4.

Without this patch this test will fail like this on a s390x zVM:
$ selftests: timers: rtcpie
$ /dev/rtc0: No such file or directory
not ok 1 selftests: timers: rtcpie # exit=22

With this patch:
$ selftests: timers: rtcpie
$ Default RTC /dev/rtc0 does not exist. Test Skipped!
not ok 9 selftests: timers: rtcpie # SKIP

Fixed up change log so "With this patch" text doesn't get dropped.
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/rtcpie.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/rtcpie.c b/tools/testing/selftests/timers/rtcpie.c
index 47b5bad1b393..4ef2184f1558 100644
--- a/tools/testing/selftests/timers/rtcpie.c
+++ b/tools/testing/selftests/timers/rtcpie.c
@@ -18,6 +18,8 @@
 #include <stdlib.h>
 #include <errno.h>
 
+#include "../kselftest.h"
+
 /*
  * This expects the new RTC class driver framework, working with
  * clocks that will often not be clones of what the PC-AT had.
@@ -35,8 +37,14 @@ int main(int argc, char **argv)
 	switch (argc) {
 	case 2:
 		rtc = argv[1];
-		/* FALLTHROUGH */
+		break;
 	case 1:
+		fd = open(default_rtc, O_RDONLY);
+		if (fd == -1) {
+			printf("Default RTC %s does not exist. Test Skipped!\n", default_rtc);
+			exit(KSFT_SKIP);
+		}
+		close(fd);
 		break;
 	default:
 		fprintf(stderr, "usage:  rtctest [rtcdev] [d]\n");
-- 
2.30.2

