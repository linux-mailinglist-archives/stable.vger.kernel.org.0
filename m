Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8233CE274
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348549AbhGSPa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349322AbhGSP0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 609C360200;
        Mon, 19 Jul 2021 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710830;
        bh=ZP9KQES+HDuOGeyqR9cpbVw/7pbTbMeag+0gntsBwL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2wpunK7fWWd0GtZVs46T60+11B6NdHz8wCBUITGc7vCp6m7phJ/4m1tzLhnHY6TY
         BA0jTurchCAak0M4K6o7exVPLfZ9JaB4LDAZB7A5o0fBIqomU9kWWEJrkS48HIV8BU
         kZYGAT6Gs9GGFZdX0KKWaqFkwgNWxnP+XzTly1dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 123/351] s390/mem_detect: fix diag260() program check new psw handling
Date:   Mon, 19 Jul 2021 16:51:09 +0200
Message-Id: <20210719144948.547557005@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 40168e59abd3..3f093556dc3b 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -69,24 +69,27 @@ static int __diag260(unsigned long rx1, unsigned long rx2)
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



