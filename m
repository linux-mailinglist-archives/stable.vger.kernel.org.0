Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF02B3CDF68
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbhGSPKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345026AbhGSPHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53856611F2;
        Mon, 19 Jul 2021 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709670;
        bh=mgudEMBHGEz15OedNNtUSAC+tW05dczxAYbP9/Nk0ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoXSFKr5hGQimW+u01YefZ1/dMxrql/xP1eaO0VgcySRRgKk+pnyO36YhB/BhN8ff
         fQ9PWlusot71j4NXi7BeYkG7m5SG4jYqY2I2sxrh2qvuWf38UIuV0iskt3cpziKmdH
         LeoO4D4Qk0ms2o61jW67vmotwdYuhqOV8lvcE36c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/149] s390/ipl_parm: fix program check new psw handling
Date:   Mon, 19 Jul 2021 16:52:38 +0200
Message-Id: <20210719144913.309995602@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 88c2510cecb7e2b518e3c4fdf3cf0e13ebe9377c ]

The __diag308() inline asm temporarily changes the program check new
psw to redirect a potential program check on the diag instruction.
Restoring of the program check new psw is done in C code behind the
inline asm.

This can be problematic, especially if the function is inlined, since
the compiler can reorder instructions in such a way that a different
instruction, which may result in a program check, might be executed
before the program check new psw has been restored.

To avoid such a scenario move restoring into the inline asm. For
consistency reasons move also saving of the original program check new
psw into the inline asm.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index 24ef67eb1cef..75905b548f69 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -27,22 +27,25 @@ static inline int __diag308(unsigned long subcode, void *addr)
 	register unsigned long _addr asm("0") = (unsigned long)addr;
 	register unsigned long _rc asm("1") = 0;
 	unsigned long reg1, reg2;
-	psw_t old = S390_lowcore.program_new_psw;
+	psw_t old;
 
 	asm volatile(
+		"	mvc	0(16,%[psw_old]),0(%[psw_pgm])\n"
 		"	epsw	%0,%1\n"
-		"	st	%0,%[psw_pgm]\n"
-		"	st	%1,%[psw_pgm]+4\n"
+		"	st	%0,0(%[psw_pgm])\n"
+		"	st	%1,4(%[psw_pgm])\n"
 		"	larl	%0,1f\n"
-		"	stg	%0,%[psw_pgm]+8\n"
+		"	stg	%0,8(%[psw_pgm])\n"
 		"	diag	%[addr],%[subcode],0x308\n"
-		"1:	nopr	%%r7\n"
+		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
 		: "=&d" (reg1), "=&a" (reg2),
-		  [psw_pgm] "=Q" (S390_lowcore.program_new_psw),
+		  "+Q" (S390_lowcore.program_new_psw),
+		  "=Q" (old),
 		  [addr] "+d" (_addr), "+d" (_rc)
-		: [subcode] "d" (subcode)
+		: [subcode] "d" (subcode),
+		  [psw_old] "a" (&old),
+		  [psw_pgm] "a" (&S390_lowcore.program_new_psw)
 		: "cc", "memory");
-	S390_lowcore.program_new_psw = old;
 	return _rc;
 }
 
-- 
2.30.2



