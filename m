Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EAB26B57B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgIOXo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgIOOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6C522C9D;
        Tue, 15 Sep 2020 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179895;
        bh=hcNMlLT8WPC/BoQhX7eai5oBEzD7XRS4GeDsX0qQAqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxNfGsKaMRNEns+Dfi/kPYVExkGLMFldsZLqhGzEaK5Bhz20qjxeDYDAQ2chWxyuA
         GAirlXVsRgYg8wpbj+XA6hPxEmvrAkzAZJKn2qwAUJCLXGLN6vIMXUz3YgRdMtdlCO
         XxvNA/UV5qfbX7IsJON/iWqfDndUflKS24YN7YJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        John Stultz <john.stultz@linaro.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 009/177] selftests/timers: Turn off timeout setting
Date:   Tue, 15 Sep 2020 16:11:20 +0200
Message-Id: <20200915140654.086811005@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 5c1e4f7e9e49b6925b1fb5c507d2c614f3edb292 ]

The following 4 tests in timers can take longer than the default 45
seconds that added in commit 852c8cbf34d3 ("selftests/kselftest/runner.sh:
Add 45 second timeout per test") to run:
  * nsleep-lat - 2m7.350s
  * set-timer-lat - 2m0.66s
  * inconsistency-check - 1m45.074s
  * raw_skew - 2m0.013s

Thus they will be marked as failed with the current 45s setting:
  not ok 3 selftests: timers: nsleep-lat # TIMEOUT
  not ok 4 selftests: timers: set-timer-lat # TIMEOUT
  not ok 6 selftests: timers: inconsistency-check # TIMEOUT
  not ok 7 selftests: timers: raw_skew # TIMEOUT

Disable the timeout setting for timers can make these tests finish
properly:
  ok 3 selftests: timers: nsleep-lat
  ok 4 selftests: timers: set-timer-lat
  ok 6 selftests: timers: inconsistency-check
  ok 7 selftests: timers: raw_skew

https://bugs.launchpad.net/bugs/1864626
Fixes: 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second timeout per test")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/Makefile | 1 +
 tools/testing/selftests/timers/settings | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/timers/settings

diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 7656c7ce79d90..0e73a16874c4c 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -13,6 +13,7 @@ DESTRUCTIVE_TESTS = alarmtimer-suspend valid-adjtimex adjtick change_skew \
 
 TEST_GEN_PROGS_EXTENDED = $(DESTRUCTIVE_TESTS)
 
+TEST_FILES := settings
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/timers/settings b/tools/testing/selftests/timers/settings
new file mode 100644
index 0000000000000..e7b9417537fbc
--- /dev/null
+++ b/tools/testing/selftests/timers/settings
@@ -0,0 +1 @@
+timeout=0
-- 
2.25.1



