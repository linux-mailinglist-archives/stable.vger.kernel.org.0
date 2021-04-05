Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD313547C4
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhDEUqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:46:32 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:48705 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhDEUqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:46:31 -0400
Received: from [192.168.1.149] (cm-84.212.138.3.getinternet.no [84.212.138.3])
        (Authenticated sender: fredrik@strupe.net)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A7571100009;
        Mon,  5 Apr 2021 20:46:23 +0000 (UTC)
To:     patches@armlinux.org.uk
Cc:     stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        fredrik@strupe.net
From:   Fredrik Strupe <fredrik@strupe.net>
Subject: arm: uprobes: Don't hook on thumb instructions
Message-ID: <052249d4-da33-7154-0f0e-5b0a98db7f20@strupe.net>
Date:   Mon, 5 Apr 2021 22:46:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since uprobes is not supported for thumb, check that the thumb bit is
not set when matching the uprobes instruction hooks.

The Arm UDF instructions used for uprobes triggering
(UPROBE_SWBP_ARM_INSN and UPROBE_SS_ARM_INSN) coincidentally share the
same encoding as a pair of unallocated 32-bit thumb instructions (not
UDF) when the condition code is 0b1111 (0xf). This in effect makes it
possible to trigger the uprobes functionality from thumb, and at that
using two unallocated instructions which are not permanently undefined.

Signed-off-by: Fredrik Strupe <fredrik@strupe.net>
Cc: stable@vger.kernel.org
Fixes: c7edc9e326d5 ("ARM: add uprobes support")
---
 arch/arm/probes/uprobes/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/probes/uprobes/core.c b/arch/arm/probes/uprobes/core.c
index c4b49b322e8a..f5f790c6e5f8 100644
--- a/arch/arm/probes/uprobes/core.c
+++ b/arch/arm/probes/uprobes/core.c
@@ -204,7 +204,7 @@ unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
 static struct undef_hook uprobes_arm_break_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SWBP_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };
@@ -212,7 +212,7 @@ static struct undef_hook uprobes_arm_break_hook = {
 static struct undef_hook uprobes_arm_ss_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SS_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };
-- 
2.20.1

