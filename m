Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B7D2EB44
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfE3DLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfE3DLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC5A5244D8;
        Thu, 30 May 2019 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185873;
        bh=mcd2FS0t0z1bCwO4klx+xNkmovjnhdydm2bFSiWeul0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdvcxNCXCDEM9Yyc43pcEkMLcomFkw/mKdUEDqYDWtlIusEN5GuX2HHHdbQSHe92/
         YkduuaQzLjfg54B7MuLgJTGTVyj0vyzu+5xcIdw0Qq6q1yGbXA3OEbPto6uK8med7q
         mhXU+whhEuRlxtP5GXnztHowRLUnpjy5b3GPi10A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 190/405] arm64: vdso: Fix clock_getres() for CLOCK_REALTIME
Date:   Wed, 29 May 2019 20:03:08 -0700
Message-Id: <20190530030550.629262924@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 81fb8736dd81da3fe94f28968dac60f392ec6746 ]

clock_getres() in the vDSO library has to preserve the same behaviour
of posix_get_hrtimer_res().

In particular, posix_get_hrtimer_res() does:

    sec = 0;
    ns = hrtimer_resolution;

where 'hrtimer_resolution' depends on whether or not high resolution
timers are enabled, which is a runtime decision.

The vDSO incorrectly returns the constant CLOCK_REALTIME_RES. Fix this
by exposing 'hrtimer_resolution' in the vDSO datapage and returning that
instead.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
[will: Use WRITE_ONCE(), move adr off COARSE path, renumber labels, use 'w' reg]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/vdso_datapage.h | 1 +
 arch/arm64/kernel/asm-offsets.c        | 2 +-
 arch/arm64/kernel/vdso.c               | 3 +++
 arch/arm64/kernel/vdso/gettimeofday.S  | 7 +++----
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/vdso_datapage.h b/arch/arm64/include/asm/vdso_datapage.h
index 2b9a63771eda8..f89263c8e11af 100644
--- a/arch/arm64/include/asm/vdso_datapage.h
+++ b/arch/arm64/include/asm/vdso_datapage.h
@@ -38,6 +38,7 @@ struct vdso_data {
 	__u32 tz_minuteswest;	/* Whacky timezone stuff */
 	__u32 tz_dsttime;
 	__u32 use_syscall;
+	__u32 hrtimer_res;
 };
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 7f40dcbdd51d0..e10e2a5d9ddcf 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -94,7 +94,7 @@ int main(void)
   DEFINE(CLOCK_REALTIME,	CLOCK_REALTIME);
   DEFINE(CLOCK_MONOTONIC,	CLOCK_MONOTONIC);
   DEFINE(CLOCK_MONOTONIC_RAW,	CLOCK_MONOTONIC_RAW);
-  DEFINE(CLOCK_REALTIME_RES,	MONOTONIC_RES_NSEC);
+  DEFINE(CLOCK_REALTIME_RES,	offsetof(struct vdso_data, hrtimer_res));
   DEFINE(CLOCK_REALTIME_COARSE,	CLOCK_REALTIME_COARSE);
   DEFINE(CLOCK_MONOTONIC_COARSE,CLOCK_MONOTONIC_COARSE);
   DEFINE(CLOCK_COARSE_RES,	LOW_RES_NSEC);
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 2d419006ad433..ec0bb588d7553 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -232,6 +232,9 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->wtm_clock_sec		= tk->wall_to_monotonic.tv_sec;
 	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
+	/* Read without the seqlock held by clock_getres() */
+	WRITE_ONCE(vdso_data->hrtimer_res, hrtimer_resolution);
+
 	if (!use_syscall) {
 		/* tkr_mono.cycle_last == tkr_raw.cycle_last */
 		vdso_data->cs_cycle_last	= tk->tkr_mono.cycle_last;
diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
index e8f60112818fc..856fee6d35129 100644
--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -308,13 +308,14 @@ ENTRY(__kernel_clock_getres)
 	ccmp	w0, #CLOCK_MONOTONIC_RAW, #0x4, ne
 	b.ne	1f
 
-	ldr	x2, 5f
+	adr	vdso_data, _vdso_data
+	ldr	w2, [vdso_data, #CLOCK_REALTIME_RES]
 	b	2f
 1:
 	cmp	w0, #CLOCK_REALTIME_COARSE
 	ccmp	w0, #CLOCK_MONOTONIC_COARSE, #0x4, ne
 	b.ne	4f
-	ldr	x2, 6f
+	ldr	x2, 5f
 2:
 	cbz	x1, 3f
 	stp	xzr, x2, [x1]
@@ -328,8 +329,6 @@ ENTRY(__kernel_clock_getres)
 	svc	#0
 	ret
 5:
-	.quad	CLOCK_REALTIME_RES
-6:
 	.quad	CLOCK_COARSE_RES
 	.cfi_endproc
 ENDPROC(__kernel_clock_getres)
-- 
2.20.1



