Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801423C307A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhGJCfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235257AbhGJCel (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 538EB613D4;
        Sat, 10 Jul 2021 02:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884300;
        bh=UtV+5Mfb4ddK6eXEUtXr8DMtasuEylQWx52zy2Y8cig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOhgLIE88CqDShNV7G4TAej3ONiRkA2XyM4S3vqXKIkr6PzHCvVihmuZ//NM5oeZ7
         KGPTm96PJEbjjfNJce3d5RB2nyd7KM3EFRd5mDWPwVNTRm8QKsP/01viR8gFBjfJkb
         cx/tKpknqirmqX6FSPDQpIX0Sj0yty/vSZYxTggZdimV7YJSs01eqUO2d0XlVWzjDL
         gqSCxatWcYHBnLlB4ISsEjuP0hBQi5dc+7f19xdz1GUtwx2h1qKS1Zu+itJjRjKq4Y
         ywjlhTEL3WkDr2M/tgBVZT1u5mWp8nYuJ0oOry7PEkoqhs6XsDaKaeYXVa/9fWfzrJ
         z1b/D5hbRJhuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 45/63] s390/mem_detect: fix diag260() program check new psw handling
Date:   Fri,  9 Jul 2021 22:26:51 -0400
Message-Id: <20210710022709.3170675-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 86807f348f418a84970eebb8f9912a7eea16b497 ]

The __diag260() inline asm temporarily changes the program check new
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
 arch/s390/boot/mem_detect.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 62e7c13ce85c..032d68165216 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -70,24 +70,27 @@ static int __diag260(unsigned long rx1, unsigned long rx2)
 	register unsigned long _ry asm("4") = 0x10; /* storage configuration */
 	int rc = -1;				    /* fail */
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
 		"	diag	%[rx],%[ry],0x260\n"
 		"	ipm	%[rc]\n"
 		"	srl	%[rc],28\n"
-		"1:\n"
+		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
 		: "=&d" (reg1), "=&a" (reg2),
-		  [psw_pgm] "=Q" (S390_lowcore.program_new_psw),
+		  "+Q" (S390_lowcore.program_new_psw),
+		  "=Q" (old),
 		  [rc] "+&d" (rc), [ry] "+d" (_ry)
-		: [rx] "d" (_rx1), "d" (_rx2)
+		: [rx] "d" (_rx1), "d" (_rx2),
+		  [psw_old] "a" (&old),
+		  [psw_pgm] "a" (&S390_lowcore.program_new_psw)
 		: "cc", "memory");
-	S390_lowcore.program_new_psw = old;
 	return rc == 0 ? _ry : -1;
 }
 
-- 
2.30.2

