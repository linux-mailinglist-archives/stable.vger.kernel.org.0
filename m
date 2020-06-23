Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628B4205931
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387644AbgFWRgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387600AbgFWRgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5258C20706;
        Tue, 23 Jun 2020 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933804;
        bh=q3h5egUTDUu4nchMMHNC5L2+LU1fvxivBpyhRBRbWHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipd3N5HHlhy28yiUaEx3aOckdCLSJaLcWZz1VIrJ4ux8UPZYZqL8dk4cqeiie9Kub
         qlgR0N+5I5tKrCP3S6AlDSAQNI/zD8RYBOKNtsAtQBPsf4Ssf3F2YdsE9HsJ0n/cW5
         JJMLlBVyQwDK+FDYmoDwYHGIh8uLvu+/ZoLViG5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/15] s390/vdso: fix vDSO clock_getres()
Date:   Tue, 23 Jun 2020 13:36:26 -0400
Message-Id: <20200623173630.1355971-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173630.1355971-1-sashal@kernel.org>
References: <20200623173630.1355971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 478237a595120a18e9b52fd2c57a6e8b7a01e411 ]

clock_getres in the vDSO library has to preserve the same behaviour
of posix_get_hrtimer_res().

In particular, posix_get_hrtimer_res() does:
    sec = 0;
    ns = hrtimer_resolution;
and hrtimer_resolution depends on the enablement of the high
resolution timers that can happen either at compile or at run time.

Fix the s390 vdso implementation of clock_getres keeping a copy of
hrtimer_resolution in vdso data and using that directly.

Link: https://lkml.kernel.org/r/20200324121027.21665-1-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[heiko.carstens@de.ibm.com: use llgf for proper zero extension]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/vdso.h           |  1 +
 arch/s390/kernel/asm-offsets.c         |  2 +-
 arch/s390/kernel/time.c                |  1 +
 arch/s390/kernel/vdso64/clock_getres.S | 10 +++++-----
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index 169d7604eb804..f3ba84fa9bd18 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -36,6 +36,7 @@ struct vdso_data {
 	__u32 tk_shift;			/* Shift used for xtime_nsec	0x60 */
 	__u32 ts_dir;			/* TOD steering direction	0x64 */
 	__u64 ts_end;			/* TOD steering end		0x68 */
+	__u32 hrtimer_res;		/* hrtimer resolution		0x70 */
 };
 
 struct vdso_per_cpu_data {
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 66e830f1c7bfe..e9d09f6e81d25 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -75,6 +75,7 @@ int main(void)
 	OFFSET(__VDSO_TK_SHIFT, vdso_data, tk_shift);
 	OFFSET(__VDSO_TS_DIR, vdso_data, ts_dir);
 	OFFSET(__VDSO_TS_END, vdso_data, ts_end);
+	OFFSET(__VDSO_CLOCK_REALTIME_RES, vdso_data, hrtimer_res);
 	OFFSET(__VDSO_ECTG_BASE, vdso_per_cpu_data, ectg_timer_base);
 	OFFSET(__VDSO_ECTG_USER, vdso_per_cpu_data, ectg_user_time);
 	OFFSET(__VDSO_CPU_NR, vdso_per_cpu_data, cpu_nr);
@@ -86,7 +87,6 @@ int main(void)
 	DEFINE(__CLOCK_REALTIME_COARSE, CLOCK_REALTIME_COARSE);
 	DEFINE(__CLOCK_MONOTONIC_COARSE, CLOCK_MONOTONIC_COARSE);
 	DEFINE(__CLOCK_THREAD_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID);
-	DEFINE(__CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
 	DEFINE(__CLOCK_COARSE_RES, LOW_RES_NSEC);
 	BLANK();
 	/* idle data offsets */
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index e8766beee5ad8..8ea9db599d38d 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -310,6 +310,7 @@ void update_vsyscall(struct timekeeper *tk)
 
 	vdso_data->tk_mult = tk->tkr_mono.mult;
 	vdso_data->tk_shift = tk->tkr_mono.shift;
+	vdso_data->hrtimer_res = hrtimer_resolution;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/s390/kernel/vdso64/clock_getres.S b/arch/s390/kernel/vdso64/clock_getres.S
index 081435398e0a1..0c79caa32b592 100644
--- a/arch/s390/kernel/vdso64/clock_getres.S
+++ b/arch/s390/kernel/vdso64/clock_getres.S
@@ -17,12 +17,14 @@
 	.type  __kernel_clock_getres,@function
 __kernel_clock_getres:
 	CFI_STARTPROC
-	larl	%r1,4f
+	larl	%r1,3f
+	lg	%r0,0(%r1)
 	cghi	%r2,__CLOCK_REALTIME_COARSE
 	je	0f
 	cghi	%r2,__CLOCK_MONOTONIC_COARSE
 	je	0f
-	larl	%r1,3f
+	larl	%r1,_vdso_data
+	llgf	%r0,__VDSO_CLOCK_REALTIME_RES(%r1)
 	cghi	%r2,__CLOCK_REALTIME
 	je	0f
 	cghi	%r2,__CLOCK_MONOTONIC
@@ -36,7 +38,6 @@ __kernel_clock_getres:
 	jz	2f
 0:	ltgr	%r3,%r3
 	jz	1f				/* res == NULL */
-	lg	%r0,0(%r1)
 	xc	0(8,%r3),0(%r3)			/* set tp->tv_sec to zero */
 	stg	%r0,8(%r3)			/* store tp->tv_usec */
 1:	lghi	%r2,0
@@ -45,6 +46,5 @@ __kernel_clock_getres:
 	svc	0
 	br	%r14
 	CFI_ENDPROC
-3:	.quad	__CLOCK_REALTIME_RES
-4:	.quad	__CLOCK_COARSE_RES
+3:	.quad	__CLOCK_COARSE_RES
 	.size	__kernel_clock_getres,.-__kernel_clock_getres
-- 
2.25.1

