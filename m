Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F4B1378DB
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgAJWDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgAJWDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:03:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA93020721;
        Fri, 10 Jan 2020 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693791;
        bh=NbGATb5s7hBwbGFwF2RTukJhnBKMnGwdp/jYrhC7C2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcCY4uy0on65Oux66F7zUt/tSUsqaxQhbByOgv0BbtmaaiE7LtOaTXdOyGiqaKv20
         zbWike2tdV/fZjEuOAlKskFSjQnX4fmIM3LOecwYuk3Lb4VTDap2N7+f3Vbbxs99Au
         aMvOIEGm/Ll7sg5HbCz2wRHRdaMZlU5OLqy5Kexs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Paul Burton <paulburton@kernel.org>,
        mips-creator-ci20-dev@googlegroups.com,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 02/26] mips: Fix gettimeofday() in the vdso library
Date:   Fri, 10 Jan 2020 17:02:44 -0500
Message-Id: <20200110220308.27784-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220308.27784-1-sashal@kernel.org>
References: <20200110220308.27784-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 7d2aa4bb90f5f6f1b8de8848c26042403f2d7bf9 ]

The libc provides a discovery mechanism for vDSO library and its
symbols. When a symbol is not exposed by the vDSOs the libc falls back
on the system calls.

With the introduction of the unified vDSO library on mips this behavior
is not honored anymore by the kernel in the case of gettimeofday().

The issue has been noticed and reported due to a dhclient failure on the
CI20 board:

root@letux:~# dhclient
../../../../lib/isc/unix/time.c:200: Operation not permitted
root@letux:~#

Restore the original behavior fixing gettimeofday() in the vDSO library.

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com> # CI20 with JZ4780
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: mips-creator-ci20-dev@googlegroups.com
Cc: letux-kernel@openphoenux.org
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/vdso/gettimeofday.h | 13 -------------
 arch/mips/vdso/vgettimeofday.c            | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/mips/include/asm/vdso/gettimeofday.h b/arch/mips/include/asm/vdso/gettimeofday.h
index b08825531e9f..0ae9b4cbc153 100644
--- a/arch/mips/include/asm/vdso/gettimeofday.h
+++ b/arch/mips/include/asm/vdso/gettimeofday.h
@@ -26,8 +26,6 @@
 
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
 
-#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
-
 static __always_inline long gettimeofday_fallback(
 				struct __kernel_old_timeval *_tv,
 				struct timezone *_tz)
@@ -48,17 +46,6 @@ static __always_inline long gettimeofday_fallback(
 	return error ? -ret : ret;
 }
 
-#else
-
-static __always_inline long gettimeofday_fallback(
-				struct __kernel_old_timeval *_tv,
-				struct timezone *_tz)
-{
-	return -1;
-}
-
-#endif
-
 static __always_inline long clock_gettime_fallback(
 					clockid_t _clkid,
 					struct __kernel_timespec *_ts)
diff --git a/arch/mips/vdso/vgettimeofday.c b/arch/mips/vdso/vgettimeofday.c
index 6ebdc37c89fc..6b83b6376a4b 100644
--- a/arch/mips/vdso/vgettimeofday.c
+++ b/arch/mips/vdso/vgettimeofday.c
@@ -17,12 +17,22 @@ int __vdso_clock_gettime(clockid_t clock,
 	return __cvdso_clock_gettime32(clock, ts);
 }
 
+#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
+
+/*
+ * This is behind the ifdef so that we don't provide the symbol when there's no
+ * possibility of there being a usable clocksource, because there's nothing we
+ * can do without it. When libc fails the symbol lookup it should fall back on
+ * the standard syscall path.
+ */
 int __vdso_gettimeofday(struct __kernel_old_timeval *tv,
 			struct timezone *tz)
 {
 	return __cvdso_gettimeofday(tv, tz);
 }
 
+#endif /* CONFIG_MIPS_CLOCK_VSYSCALL */
+
 int __vdso_clock_getres(clockid_t clock_id,
 			struct old_timespec32 *res)
 {
@@ -43,12 +53,22 @@ int __vdso_clock_gettime(clockid_t clock,
 	return __cvdso_clock_gettime(clock, ts);
 }
 
+#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
+
+/*
+ * This is behind the ifdef so that we don't provide the symbol when there's no
+ * possibility of there being a usable clocksource, because there's nothing we
+ * can do without it. When libc fails the symbol lookup it should fall back on
+ * the standard syscall path.
+ */
 int __vdso_gettimeofday(struct __kernel_old_timeval *tv,
 			struct timezone *tz)
 {
 	return __cvdso_gettimeofday(tv, tz);
 }
 
+#endif /* CONFIG_MIPS_CLOCK_VSYSCALL */
+
 int __vdso_clock_getres(clockid_t clock_id,
 			struct __kernel_timespec *res)
 {
-- 
2.20.1

