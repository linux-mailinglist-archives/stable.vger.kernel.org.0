Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965CBEA065
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfJ3P4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfJ3P4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:56:16 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC1E20656;
        Wed, 30 Oct 2019 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450975;
        bh=bwQbum9VhKjiV6wYsolq6/zxgIAJqakptpATf4eyNIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSFsFd/EBU6RRCBDaT8dU/nsXIyktq9jl5VKKhSwTrDla86Bymdr0mDx/PRxqMnr7
         WrTY7CvnlPmlH4Uo//BcOJ9hNp8UiDgI5xqktMV0I1mESFLW6MOyrfP9PtvGNj8iAz
         +0QomdV17u/joz1Se2tY28ag7AZ6wT4kTXXdanPI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 08/24] ARM: mm: fix alignment handler faults under memory pressure
Date:   Wed, 30 Oct 2019 11:55:39 -0400
Message-Id: <20191030155555.10494-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155555.10494-1-sashal@kernel.org>
References: <20191030155555.10494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2c96190e018bd..96b17a870b91d 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -768,6 +768,36 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
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
@@ -775,10 +805,10 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
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
@@ -787,15 +817,14 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
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
@@ -804,8 +833,7 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
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

