Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013E23CE0DB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346895AbhGSPSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346612AbhGSPO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C494D60FE9;
        Mon, 19 Jul 2021 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710134;
        bh=OU7RHW8RCJ20JtwD/Ek2scsCmITqJZlaW4FZJH/iKEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg8vWmwcqCUwa+kuNhoO0qv4typnX24YPDyUVyNOhUkX7knLYEwlnMWFSrZEX2vLs
         d/zAsjuOcsr2l380wb9OPctKk/RemUlIencaIoZYFKV7Qz1YcY+ML1E4ItZUsmDEi+
         oihAEA260S5IGPNwV4IIuV8HAZRqbh5ICCXHSj0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/243] s390/mem_detect: fix tprot() program check new psw handling
Date:   Mon, 19 Jul 2021 16:51:59 +0200
Message-Id: <20210719144943.799030742@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit da9057576785aaab52e706e76c0475c85b77ec14 ]

The tprot() inline asm temporarily changes the program check new psw
to redirect a potential program check on the diag instruction.
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
 arch/s390/boot/mem_detect.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 032d68165216..85049541c191 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -115,24 +115,30 @@ static int diag260(void)
 
 static int tprot(unsigned long addr)
 {
-	unsigned long pgm_addr;
+	unsigned long reg1, reg2;
 	int rc = -EFAULT;
-	psw_t old = S390_lowcore.program_new_psw;
+	psw_t old;
 
-	S390_lowcore.program_new_psw.mask = __extract_psw();
 	asm volatile(
-		"	larl	%[pgm_addr],1f\n"
-		"	stg	%[pgm_addr],%[psw_pgm_addr]\n"
+		"	mvc	0(16,%[psw_old]),0(%[psw_pgm])\n"
+		"	epsw	%[reg1],%[reg2]\n"
+		"	st	%[reg1],0(%[psw_pgm])\n"
+		"	st	%[reg2],4(%[psw_pgm])\n"
+		"	larl	%[reg1],1f\n"
+		"	stg	%[reg1],8(%[psw_pgm])\n"
 		"	tprot	0(%[addr]),0\n"
 		"	ipm	%[rc]\n"
 		"	srl	%[rc],28\n"
-		"1:\n"
-		: [pgm_addr] "=&d"(pgm_addr),
-		  [psw_pgm_addr] "=Q"(S390_lowcore.program_new_psw.addr),
-		  [rc] "+&d"(rc)
-		: [addr] "a"(addr)
+		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
+		: [reg1] "=&d" (reg1),
+		  [reg2] "=&a" (reg2),
+		  [rc] "+&d" (rc),
+		  "=Q" (S390_lowcore.program_new_psw.addr),
+		  "=Q" (old)
+		: [psw_old] "a" (&old),
+		  [psw_pgm] "a" (&S390_lowcore.program_new_psw),
+		  [addr] "a" (addr)
 		: "cc", "memory");
-	S390_lowcore.program_new_psw = old;
 	return rc;
 }
 
-- 
2.30.2



