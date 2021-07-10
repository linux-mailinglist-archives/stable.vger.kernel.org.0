Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AFE3C2F07
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhGJCaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234474AbhGJC32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1520A61409;
        Sat, 10 Jul 2021 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883994;
        bh=gfmQPhuheg6CmzwqvqF1tZkKqQBYwpU926EpPpZX7Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si+05z4kM9U/vP7FtMtbxOx15Z6tvtPzI2gYNnbsWYZPTtF6zC6NzJlFGaqy2qF2Y
         XKjTlDsEZGy3on9YTAXOofH1bUNzjIKFDv99c6Rwz0x5whlhFFQ/bMjA017A7vaucM
         NdvnE9GmEC/Tp8OznuOzKILI+m02IGCMwSCfGRfFa/IUiz9Ydf/7IWYryUUSy36nZg
         89/CjOEUjV393eZoFVIvwgzgUi6T3MW2wHI770Z+R6v0IDVjGLYIA57jMkW62lza/7
         5UjYLDY4xDRqQO1uLBZqMc+fIlhv4AkdWZt5W1Bjr+vEEhl6gbEv85TRp5Eqz6/ts/
         8Ra+fCQd5DvkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 70/93] s390/ipl_parm: fix program check new psw handling
Date:   Fri,  9 Jul 2021 22:24:04 -0400
Message-Id: <20210710022428.3169839-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f94b91d72620..c56bbf58a945 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -28,22 +28,25 @@ static inline int __diag308(unsigned long subcode, void *addr)
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

