Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84930F54C4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfKHSxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbfKHSxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88987218AE;
        Fri,  8 Nov 2019 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239217;
        bh=0bQe948ftx6P4hbTLJm624vlLfbcA0R1ysh4srYT92c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae/QLM+9d39Tx6I3uDaoBuI97gUHNmcGp2P9n78jU0YMqb41nU62MFk+m80uOi8Nh
         7733JVnZ00bTyGCg3EEdmfI0fQmfsJp+D0vhjbMpP9oMqRKs9056Y2zjUZ/x6hjRAa
         31UM23pvgRFgoOg9gfQmTb1gcwLN6on0dhT0bURA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/75] ARM: mm: fix alignment handler faults under memory pressure
Date:   Fri,  8 Nov 2019 19:49:23 +0100
Message-Id: <20191108174713.215864380@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 67e15fa5b487adb9b78a92789eeff2d6ec8f5cee ]

When the system has high memory pressure, the page containing the
instruction may be paged out.  Using probe_kernel_address() means that
if the page is swapped out, the resulting page fault will not be
handled because page faults are disabled by this function.

Use get_user() to read the instruction instead.

Reported-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Fixes: b255188f90e2 ("ARM: fix scheduling while atomic warning in alignment handling code")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/alignment.c | 44 +++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 7d5f4c736a16b..cd18eda014c24 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -767,6 +767,36 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 	return NULL;
 }
 
+static int alignment_get_arm(struct pt_regs *regs, u32 *ip, unsigned long *inst)
+{
+	u32 instr = 0;
+	int fault;
+
+	if (user_mode(regs))
+		fault = get_user(instr, ip);
+	else
+		fault = probe_kernel_address(ip, instr);
+
+	*inst = __mem_to_opcode_arm(instr);
+
+	return fault;
+}
+
+static int alignment_get_thumb(struct pt_regs *regs, u16 *ip, u16 *inst)
+{
+	u16 instr = 0;
+	int fault;
+
+	if (user_mode(regs))
+		fault = get_user(instr, ip);
+	else
+		fault = probe_kernel_address(ip, instr);
+
+	*inst = __mem_to_opcode_thumb16(instr);
+
+	return fault;
+}
+
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
@@ -774,10 +804,10 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	unsigned long instr = 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *regs);
 	unsigned int type;
-	unsigned int fault;
 	u16 tinstr = 0;
 	int isize = 4;
 	int thumb2_32b = 0;
+	int fault;
 
 	if (interrupts_enabled(regs))
 		local_irq_enable();
@@ -786,15 +816,14 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
 	if (thumb_mode(regs)) {
 		u16 *ptr = (u16 *)(instrptr & ~1);
-		fault = probe_kernel_address(ptr, tinstr);
-		tinstr = __mem_to_opcode_thumb16(tinstr);
+
+		fault = alignment_get_thumb(regs, ptr, &tinstr);
 		if (!fault) {
 			if (cpu_architecture() >= CPU_ARCH_ARMv7 &&
 			    IS_T32(tinstr)) {
 				/* Thumb-2 32-bit */
-				u16 tinst2 = 0;
-				fault = probe_kernel_address(ptr + 1, tinst2);
-				tinst2 = __mem_to_opcode_thumb16(tinst2);
+				u16 tinst2;
+				fault = alignment_get_thumb(regs, ptr + 1, &tinst2);
 				instr = __opcode_thumb32_compose(tinstr, tinst2);
 				thumb2_32b = 1;
 			} else {
@@ -803,8 +832,7 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 			}
 		}
 	} else {
-		fault = probe_kernel_address((void *)instrptr, instr);
-		instr = __mem_to_opcode_arm(instr);
+		fault = alignment_get_arm(regs, (void *)instrptr, &instr);
 	}
 
 	if (fault) {
-- 
2.20.1



