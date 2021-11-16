Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0A145330C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhKPNpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:45:33 -0500
Received: from mout.gmx.net ([212.227.17.22]:52079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236924AbhKPNoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 08:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637070055;
        bh=nSsxstMFbDZcIOBwXnzEYeyZxarp8YK6zVfDpztqX/s=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Mo0i0IakG8STxchN9yOvA4Lan7tsKfGi3mN/Axjarqm3at0BxSxejntcy+b7DGtZZ
         6l8aLWV8uSrDIRTJSmpR/MM+BGldCDYdtEmT82AGEDpSFELvqNIh32+OvJRIEVHePI
         MnJ4A2YGbYSazlgsTQNIKvmfE+Par9IA/HyXlG6w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([92.116.177.193]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVeMG-1nEVQw3kBQ-00RXr4; Tue, 16
 Nov 2021 14:40:54 +0100
Date:   Tue, 16 Nov 2021 14:40:21 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Sven Schnelle <svens@stackframe.org>
Subject: [PATCH][stable] parisc/entry: fix trace test in syscall exit path
Message-ID: <YZO0xTfo0ZwzTQs+@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:XZjnO6+5ZpcQDp5vcf2tiTIVDME6JBsg/QLPBFJczQ+HYiFVzPx
 s2ujwqbaa6Qg5/14A/E9mW+PwJFA8tNsAcw7zDUvx7YXWa8Un+vG9nqCOTkqU4b/aB7zMi3
 xY+tG0HA1q0I+E9Uh5wdN/w5sl+BTDnkfXeW2CnBWDj9CGes4459E2u4OjjPAFe8LoHD31C
 /sJZynpjB6orctnZtnPRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QEi9uyc03Jo=:JmZL2w52Ziak/EqOsO9QGi
 e5Ysf2U0rysLbLJFyBrEJE9oXzqYAaKLkSK3lI+H1+TMnJYBr3C0tzuWdlf+0ffeo4D/9tRuR
 OOlrbaqAiyiKKQX5R3MqsLS/8vyTVhgTxK09VC+1QOeSUbWzF+i1L6yXTDpEc1u6fEy0TuNC5
 QdDGGLZID32/KdNSfojk4ykpBMWOTTn1Fz2P6e7bOwtY/FpXBizDccrpqpCpGPjG+mWW4pmD7
 cJY9qnYxEu4pOUVE4IkfZKXEeNAK5riNmAyngzBKFYNcj6MEvUYr+0XmSgQaCDF12bcLVjVk4
 y6Fp107IGgfhAd4OtNgu84qVotC6ZaK8sbdHdrG/dy62dEaz/pZZwMoFiLrIyJCRDq9L/oxaR
 ufUg8ssDqupKaQ+oOCWioO/MOA5CWVD0oxTZPfyZZJ6R1ioJvPmbrQGXncO1c7dF+lq+PB20U
 5guhGbZmVcLH42F0DwRP8waFV8iKZ+DNmASG2aWfbYgxGVm7wRW9FHQ80IGNOaSQTQx3vgYk5
 hxpO1PqCLUzTZoV1UHXS0BE9C5v9j4hp8uoCpaqLef57LQU7OJCVFjLfY74+EJtPINwsPM6Qi
 nDnwgxU56lIWkkdQw0+P6K1z42bPdLMhMMoHRrGUgya1eu5Lib67dZgVBl+iD5M8f2bhcMrj1
 hg1lA03GsbUazvmNH6G6tmLBE4oDjNfjFC4cStBM7V6rg88tyaGKCo9GXEV87U+E0zeDQxZxL
 +OEodRFG8ljuBazQbCxT25FUY7di5Hm4YGrNOjfcMHzCsKikPYn/fKCv0wKa7WIpqBk5DpClQ
 ESj5Bf7k4dhHRjJyjdcZCsk+GUlUZg7HR3+HNn2Gbuyzl3Pe4O/bOYFPQAekemCZYgqZ/Y5cI
 YeirAu0Srhk/HXYOylrHd1a/LdO23xpJ2cc45B6Wkngw4tpBbZsIbfcDeO86H7wB5NQE0SZxp
 ZrWdNq5ypG7m3QboQjWBM55kHQtN9ApfRnx87A2v2h7HLhEokCxFLd3SNqHJtDLzy72VwGlY/
 k9N4EgDzfWr9C2ucI1DwImGBD+kqVuqIBST2QGGVh5xh95rEa5CfrutTKByDizaOkhIUtwuwm
 4rZIilyRA/YHrY=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply this patch to the stable kernels up to v5.15.

It's basically upstream commit 3ec18fc7831e7d79e2d536dd1f3bc0d3ba425e8a,
adjusted so that it applies to the stable kernels.

It requires that upstream commit 8779e05ba8aaffec1829872ef9774a71f44f6580
is applied before, which shouldn't be a problem as it was tagged for
stable series in the original commmit already.

Thanks,
Helge
=2D-------

From: Sven Schnelle <svens@stackframe.org>
Date: Sat, 13 Nov 2021 20:41:17 +0100
Subject: [PATCH] parisc/entry: fix trace test in syscall exit path

Upstream commit: 3ec18fc7831e7d79e2d536dd1f3bc0d3ba425e8a

commit 8779e05ba8aa ("parisc: Fix ptrace check on syscall return")
fixed testing of TI_FLAGS. This uncovered a bug in the test mask.
syscall_restore_rfi is only used when the kernel needs to exit to
usespace with single or block stepping and the recovery counter
enabled. The test however used _TIF_SYSCALL_TRACE_MASK, which
includes a lot of bits that shouldn't be tested here.

Fix this by using TIF_SINGLESTEP and TIF_BLOCKSTEP directly.

I encountered this bug by enabling syscall tracepoints. Both in qemu and
on real hardware. As soon as i enabled the tracepoint (sys_exit_read,
but i guess it doesn't really matter which one), i got random page
faults in userspace almost immediately.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 2716e58b498b..437c8d31f390 100644
=2D-- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1835,7 +1835,7 @@ syscall_restore:

 	/* Are we being ptraced? */
 	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
-	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
+	ldi	_TIF_SINGLESTEP|_TIF_BLOCKSTEP,%r2
 	and,COND(=3D)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi

