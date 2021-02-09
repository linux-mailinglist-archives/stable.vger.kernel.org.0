Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54568315252
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhBIPEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:04:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231520AbhBIPES (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 10:04:18 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119F2GH5137593;
        Tue, 9 Feb 2021 10:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=rHI33tG847HjDphUjKhRWnUDT4m38IL9WicV3JpW8dM=;
 b=WW+/i0DgtTaEkgxa8ruQYSwl8XSwbAlTjD4eHcZQ7dPfOg5gDiZ46Vb1l69R4hriYNG8
 BkPIIZua0ay6rMB38v3wSgqoe50nC+8YA7uMS9BJkejhUN5Jak78A6FYohFJZuoGGkiP
 sWyDmZaw8zrGuWYNrEGPef1mSlqKyUIkI92bOSIE1RUG1ZAwK5CWX/zDSSTvz5+M4auN
 bqeHQdDJwFiVW0jREB9li9oT1nR8nd74H4cy83Mb2Z7wIAu59vfifr3lmDyVsbbmefnB
 3bfEaOON+nLk2vYPZXoSJQu3HBW6Y5R3fZz1s4G20qNX/N0GZp78t2RyJepdLj8OKmBy TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kuktk2u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:02:46 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119F2Elj137448;
        Tue, 9 Feb 2021 10:02:46 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kuktk2ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:02:45 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119EvNW2000919;
        Tue, 9 Feb 2021 15:02:45 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 36hjr9781d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 15:02:45 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119F2igb26083812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 15:02:45 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1343AC05B;
        Tue,  9 Feb 2021 15:02:44 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC29CAC067;
        Tue,  9 Feb 2021 15:02:43 +0000 (GMT)
Received: from work-tp (unknown [9.65.218.248])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue,  9 Feb 2021 15:02:43 +0000 (GMT)
Date:   Tue, 9 Feb 2021 12:02:40 -0300
From:   Raoni Fassina Firmino <raoni@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] powerpc/64/signal: Fix regression in
 __kernel_sigtramp_rt64() semantics
Message-ID: <20210209150240.epboynhzuaia4qyr@work-tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090075
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Repeated the same tests as the upstream code on top of v5.10.14 and
v5.9.16, tested on powerpc64 and powerpc64le, with a glibc build and
running the affected glibc's testcase[2], inspected that glibc's
backtrace() now gives the correct result and gdb backtrace also keeps
working as before.

I believe this should be backported to releases 5.9 and 5.10 as
userspace is affected in this releases. I hope I had tagged this
correctly in the patch.

The commit message bellow is cherry-picked from the upstream commit, I
am not sure what should I do with the footer, I left it as-is and just
added a [rff: Backported] at the end.

---- 8< ----

commit 24321ac668e452a4942598533d267805f291fdc9 upstream.

This backport differ from the upstream patch in the way to set the
sigtramp offsets, after 5.10 VDSO symbols offsets are retrieved at
buildtime and before, in this patch it uses the runtime generated
offsets logic.

Commit 0138ba5783ae ("powerpc/64/signal: Balance return predictor
stack in signal trampoline") changed __kernel_sigtramp_rt64() VDSO and
trampoline code, and introduced a regression in the way glibc's
backtrace()[1] detects the signal-handler stack frame. Apart from the
practical implications, __kernel_sigtramp_rt64() was a VDSO function
with the semantics that it is a function you can call from userspace
to end a signal handling. Now this semantics are no longer valid.

I believe the aforementioned change affects all releases since 5.9.

This patch tries to fix both the semantics and practical aspect of
__kernel_sigtramp_rt64() returning it to the previous code, whilst
keeping the intended behaviour of 0138ba5783ae by adding a new symbol
to serve as the jump target from the kernel to the trampoline. Now the
trampoline has two parts, a new entry point and the old return point.

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2021-January/223194.html

Fixes: 0138ba5783ae ("powerpc/64/signal: Balance return predictor stack in signal trampoline")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Raoni Fassina Firmino <raoni@linux.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Minor tweaks to change log formatting, add stable tag]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210201200505.iz46ubcizipnkcxe@work-tp
[rff: Backported]
---
 arch/powerpc/kernel/vdso.c              |  2 +-
 arch/powerpc/kernel/vdso64/sigtramp.S   | 11 ++++++++++-
 arch/powerpc/kernel/vdso64/vdso64.lds.S |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 8dad44262e75..495ffc9cf5e2 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -475,7 +475,7 @@ static __init void vdso_setup_trampolines(struct lib32_elfinfo *v32,
 	 */
 
 #ifdef CONFIG_PPC64
-	vdso64_rt_sigtramp = find_function64(v64, "__kernel_sigtramp_rt64");
+	vdso64_rt_sigtramp = find_function64(v64, "__kernel_start_sigtramp_rt64");
 #endif
 	vdso32_sigtramp	   = find_function32(v32, "__kernel_sigtramp32");
 	vdso32_rt_sigtramp = find_function32(v32, "__kernel_sigtramp_rt32");
diff --git a/arch/powerpc/kernel/vdso64/sigtramp.S b/arch/powerpc/kernel/vdso64/sigtramp.S
index bbf68cd01088..2d4067561293 100644
--- a/arch/powerpc/kernel/vdso64/sigtramp.S
+++ b/arch/powerpc/kernel/vdso64/sigtramp.S
@@ -15,11 +15,20 @@
 
 	.text
 
+/*
+ * __kernel_start_sigtramp_rt64 and __kernel_sigtramp_rt64 together
+ * are one function split in two parts. The kernel jumps to the former
+ * and the signal handler indirectly (by blr) returns to the latter.
+ * __kernel_sigtramp_rt64 needs to point to the return address so
+ * glibc can correctly identify the trampoline stack frame.
+ */
 	.balign 8
 	.balign IFETCH_ALIGN_BYTES
-V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_start_sigtramp_rt64)
 .Lsigrt_start:
 	bctrl	/* call the handler */
+V_FUNCTION_END(__kernel_start_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
 	addi	r1, r1, __SIGNAL_FRAMESIZE
 	li	r0,__NR_rt_sigreturn
 	sc
diff --git a/arch/powerpc/kernel/vdso64/vdso64.lds.S b/arch/powerpc/kernel/vdso64/vdso64.lds.S
index 256fb9720298..bd120f590b9e 100644
--- a/arch/powerpc/kernel/vdso64/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso64/vdso64.lds.S
@@ -150,6 +150,7 @@ VERSION
 		__kernel_get_tbfreq;
 		__kernel_sync_dicache;
 		__kernel_sync_dicache_p5;
+		__kernel_start_sigtramp_rt64;
 		__kernel_sigtramp_rt64;
 		__kernel_getcpu;
 		__kernel_time;

base-commit: b0c8835fc649454c33371f4617111cb5d60463e1
-- 
2.26.2

