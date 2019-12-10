Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B920119538
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfLJVMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbfLJVMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964752077B;
        Tue, 10 Dec 2019 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012341;
        bh=HXpil44N5GmNjtAl+3KxceguPapHwyWGDSjDexNxcz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZ6LBMwcraBffM3qH9NBwwVOIn1l77hZKbeSx0RaqUxOOPO0IioBaDNHEtSfJ8KOL
         vGvEvOT+5ubZ8/BBrwkjrfbVTwGwRTBE4QJJM6cW0BJicq1MDWuLlEzd3PT6jzHall
         os5qmCzyasKF0E39WKtBDWdSDqRSgl5wY4pMPocE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 272/350] s390/disassembler: don't hide instruction addresses
Date:   Tue, 10 Dec 2019 16:06:17 -0500
Message-Id: <20191210210735.9077-233-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 544f1d62e3e6c6e6d17a5e56f6139208acb5ff46 ]

Due to kptr_restrict, JITted BPF code is now displayed like this:

000000000b6ed1b2: ebdff0800024  stmg    %r13,%r15,128(%r15)
000000004cde2ba0: 41d0f040      la      %r13,64(%r15)
00000000fbad41b0: a7fbffa0      aghi    %r15,-96

Leaking kernel addresses to dmesg is not a concern in this case, because
this happens only when JIT debugging is explicitly activated, which only
root can do.

Use %px in this particular instance, and also to print an instruction
address in show_code and PCREL (e.g. brasl) arguments in print_insn.
While at present functionally equivalent to %016lx, %px is recommended
by Documentation/core-api/printk-formats.rst for such cases.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/dis.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index 7abe6ae261b42..f304802ecf7be 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -461,10 +461,11 @@ static int print_insn(char *buffer, unsigned char *code, unsigned long addr)
 				ptr += sprintf(ptr, "%%c%i", value);
 			else if (operand->flags & OPERAND_VR)
 				ptr += sprintf(ptr, "%%v%i", value);
-			else if (operand->flags & OPERAND_PCREL)
-				ptr += sprintf(ptr, "%lx", (signed int) value
-								      + addr);
-			else if (operand->flags & OPERAND_SIGNED)
+			else if (operand->flags & OPERAND_PCREL) {
+				void *pcrel = (void *)((int)value + addr);
+
+				ptr += sprintf(ptr, "%px", pcrel);
+			} else if (operand->flags & OPERAND_SIGNED)
 				ptr += sprintf(ptr, "%i", value);
 			else
 				ptr += sprintf(ptr, "%u", value);
@@ -536,7 +537,7 @@ void show_code(struct pt_regs *regs)
 		else
 			*ptr++ = ' ';
 		addr = regs->psw.addr + start - 32;
-		ptr += sprintf(ptr, "%016lx: ", addr);
+		ptr += sprintf(ptr, "%px: ", (void *)addr);
 		if (start + opsize >= end)
 			break;
 		for (i = 0; i < opsize; i++)
@@ -564,7 +565,7 @@ void print_fn_code(unsigned char *code, unsigned long len)
 		opsize = insn_length(*code);
 		if (opsize > len)
 			break;
-		ptr += sprintf(ptr, "%p: ", code);
+		ptr += sprintf(ptr, "%px: ", code);
 		for (i = 0; i < opsize; i++)
 			ptr += sprintf(ptr, "%02x", code[i]);
 		*ptr++ = '\t';
-- 
2.20.1

