Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49F3F7D96
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfKKS6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfKKS6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA3521655;
        Mon, 11 Nov 2019 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498693;
        bh=c73pM0vMfB+nZzLpqXcyf8WgkHue4kWXssjUlDgME5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyWXGoqv917xMNMv9FPxldo8lUrIwkUUBU8lwct6VhjC3sAidO54rBIghe+1P95bq
         8xab4n12FSl2aI/gDoHEwVr6Buk+NPxoIhh1qpX/Ag7Nv3Wr1WGQV1tzM0CC+RbmP7
         7+MSiHS8e/HPZGe9sGhego8IevAdwmj5IqqfDmlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 191/193] timekeeping/vsyscall: Update VDSO data unconditionally
Date:   Mon, 11 Nov 2019 19:29:33 +0100
Message-Id: <20191111181515.176484931@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 52338415cf4d4064ae6b8dd972dadbda841da4fa ]

The update of the VDSO data is depending on __arch_use_vsyscall() returning
True. This is a leftover from the attempt to map the features of various
architectures 1:1 into generic code.

The usage of __arch_use_vsyscall() in the actual vsyscall implementations
got dropped and replaced by the requirement for the architecture code to
return U64_MAX if the global clocksource is not usable in the VDSO.

But the __arch_use_vsyscall() check in the update code stayed which causes
the VDSO data to be stale or invalid when an architecture actually
implements that function and returns False when the current clocksource is
not usable in the VDSO.

As a consequence the VDSO implementations of clock_getres(), time(),
clock_gettime(CLOCK_.*_COARSE) operate on invalid data and return bogus
information.

Remove the __arch_use_vsyscall() check from the VDSO update function and
update the VDSO data unconditionally.

[ tglx: Massaged changelog and removed the now useless implementations in
  	asm-generic/ARM64/MIPS ]

Fixes: 44f57d788e7deecb50 ("timekeeping: Provide a generic update_vsyscall() implementation")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1571887709-11447-1-git-send-email-chenhc@lemote.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/vdso/vsyscall.h | 7 -------
 include/asm-generic/vdso/vsyscall.h    | 7 -------
 kernel/time/vsyscall.c                 | 9 +++------
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 0c731bfc7c8c7..0c20a7c1bee50 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -30,13 +30,6 @@ int __arm64_get_clock_mode(struct timekeeper *tk)
 }
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
-static __always_inline
-int __arm64_use_vsyscall(struct vdso_data *vdata)
-{
-	return !vdata[CS_HRES_COARSE].clock_mode;
-}
-#define __arch_use_vsyscall __arm64_use_vsyscall
-
 static __always_inline
 void __arm64_update_vsyscall(struct vdso_data *vdata, struct timekeeper *tk)
 {
diff --git a/include/asm-generic/vdso/vsyscall.h b/include/asm-generic/vdso/vsyscall.h
index e94b19782c92f..ce41032086193 100644
--- a/include/asm-generic/vdso/vsyscall.h
+++ b/include/asm-generic/vdso/vsyscall.h
@@ -25,13 +25,6 @@ static __always_inline int __arch_get_clock_mode(struct timekeeper *tk)
 }
 #endif /* __arch_get_clock_mode */
 
-#ifndef __arch_use_vsyscall
-static __always_inline int __arch_use_vsyscall(struct vdso_data *vdata)
-{
-	return 1;
-}
-#endif /* __arch_use_vsyscall */
-
 #ifndef __arch_update_vsyscall
 static __always_inline void __arch_update_vsyscall(struct vdso_data *vdata,
 						   struct timekeeper *tk)
diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index 4bc37ac3bb052..5ee0f77094107 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -110,8 +110,7 @@ void update_vsyscall(struct timekeeper *tk)
 	nsec		= nsec + tk->wall_to_monotonic.tv_nsec;
 	vdso_ts->sec	+= __iter_div_u64_rem(nsec, NSEC_PER_SEC, &vdso_ts->nsec);
 
-	if (__arch_use_vsyscall(vdata))
-		update_vdso_data(vdata, tk);
+	update_vdso_data(vdata, tk);
 
 	__arch_update_vsyscall(vdata, tk);
 
@@ -124,10 +123,8 @@ void update_vsyscall_tz(void)
 {
 	struct vdso_data *vdata = __arch_get_k_vdso_data();
 
-	if (__arch_use_vsyscall(vdata)) {
-		vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
-		vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
-	}
+	vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
+	vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
 
 	__arch_sync_vdso_data(vdata);
 }
-- 
2.20.1



