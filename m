Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0C37423B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbhEEQqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234935AbhEEQnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C6A616EC;
        Wed,  5 May 2021 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232495;
        bh=IjQ16PaiznQ+DmnopLdAcuaE4WZWyIOLV2kE1mYF6KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGVTDQ5owRSMZRLf446ePHSSuriH3edY5nxxx0rTmscJus52AmluUywBDUF/lx+aj
         Ym5pWfwwQhaPBECD2QHQkht4fadNExvokSkS8AZZ6FzQxqhJcUDhUGSa71QLky+UKh
         uekF9z6UawNKPadB8Gq22a3CrG8A96MC4k5d5gguH50EtacBzwvRqwvLlX0OBAS3hG
         sHyeThWyhi6Ox6CA4oAFtTF9239y9gzF98OcDqdy8QGSyQY2yqD4uQJs7r92bQm+rE
         Jkf1icdEYfrrpJPHkaky55JFO4sMsutDD5OaFrEoS2EyoXM8Vzh5iOzFZCrk0Y13XE
         FLiTTB2eclRaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell Currey <ruscur@russell.cc>, Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 029/104] selftests/powerpc: Fix L1D flushing tests for Power10
Date:   Wed,  5 May 2021 12:32:58 -0400
Message-Id: <20210505163413.3461611-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit 3a72c94ebfb1f171eba0715998010678a09ec796 ]

The rfi_flush and entry_flush selftests work by using the PM_LD_MISS_L1
perf event to count L1D misses.  The value of this event has changed
over time:

- Power7 uses 0x400f0
- Power8 and Power9 use both 0x400f0 and 0x3e054
- Power10 uses only 0x3e054

Rather than relying on raw values, configure perf to count L1D read
misses in the most explicit way available.

This fixes the selftests to work on systems without 0x400f0 as
PM_LD_MISS_L1, and should change no behaviour for systems that the tests
already worked on.

The only potential downside is that referring to a specific perf event
requires PMU support implemented in the kernel for that platform.

Signed-off-by: Russell Currey <ruscur@russell.cc>
Acked-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210223070227.2916871-1-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/security/entry_flush.c | 2 +-
 tools/testing/selftests/powerpc/security/flush_utils.h | 4 ++++
 tools/testing/selftests/powerpc/security/rfi_flush.c   | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/security/entry_flush.c b/tools/testing/selftests/powerpc/security/entry_flush.c
index 78cf914fa321..68ce377b205e 100644
--- a/tools/testing/selftests/powerpc/security/entry_flush.c
+++ b/tools/testing/selftests/powerpc/security/entry_flush.c
@@ -53,7 +53,7 @@ int entry_flush_test(void)
 
 	entry_flush = entry_flush_orig;
 
-	fd = perf_event_open_counter(PERF_TYPE_RAW, /* L1d miss */ 0x400f0, -1);
+	fd = perf_event_open_counter(PERF_TYPE_HW_CACHE, PERF_L1D_READ_MISS_CONFIG, -1);
 	FAIL_IF(fd < 0);
 
 	p = (char *)memalign(zero_size, CACHELINE_SIZE);
diff --git a/tools/testing/selftests/powerpc/security/flush_utils.h b/tools/testing/selftests/powerpc/security/flush_utils.h
index 07a5eb301466..7a3d60292916 100644
--- a/tools/testing/selftests/powerpc/security/flush_utils.h
+++ b/tools/testing/selftests/powerpc/security/flush_utils.h
@@ -9,6 +9,10 @@
 
 #define CACHELINE_SIZE 128
 
+#define PERF_L1D_READ_MISS_CONFIG	((PERF_COUNT_HW_CACHE_L1D) | 		\
+					(PERF_COUNT_HW_CACHE_OP_READ << 8) |	\
+					(PERF_COUNT_HW_CACHE_RESULT_MISS << 16))
+
 void syscall_loop(char *p, unsigned long iterations,
 		  unsigned long zero_size);
 
diff --git a/tools/testing/selftests/powerpc/security/rfi_flush.c b/tools/testing/selftests/powerpc/security/rfi_flush.c
index 7565fd786640..f73484a6470f 100644
--- a/tools/testing/selftests/powerpc/security/rfi_flush.c
+++ b/tools/testing/selftests/powerpc/security/rfi_flush.c
@@ -54,7 +54,7 @@ int rfi_flush_test(void)
 
 	rfi_flush = rfi_flush_orig;
 
-	fd = perf_event_open_counter(PERF_TYPE_RAW, /* L1d miss */ 0x400f0, -1);
+	fd = perf_event_open_counter(PERF_TYPE_HW_CACHE, PERF_L1D_READ_MISS_CONFIG, -1);
 	FAIL_IF(fd < 0);
 
 	p = (char *)memalign(zero_size, CACHELINE_SIZE);
-- 
2.30.2

