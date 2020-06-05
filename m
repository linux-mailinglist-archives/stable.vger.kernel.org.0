Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E381EF772
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFEM0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgFEM0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BEDB20820;
        Fri,  5 Jun 2020 12:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359971;
        bh=tRHCmEH7orlPqUyp11NXKRnr/eVrmW2N7LMz09GKVnU=;
        h=From:To:Cc:Subject:Date:From;
        b=0owRiPGSogNBTokOEAcxgUGS8AWIxZYBAFOuByQ7yhYEKQx5NCbWRaVfhfgUfz8pG
         74w8VXoZauchfW/vKLjGXw2pp3x36Ki6o0GkX0LcvzjTA3RVwyBfKMoBFUg1FA8c9A
         9C7Su6ZyWoDQEBjXFH0NcXvzTnAd0WXUCYoboCD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fredrik Strupe <fredrik@strupe.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/8] ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook
Date:   Fri,  5 Jun 2020 08:26:02 -0400
Message-Id: <20200605122609.2882841-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fredrik Strupe <fredrik@strupe.net>

[ Upstream commit 3866f217aaa81bf7165c7f27362eee5d7919c496 ]

call_undef_hook() in traps.c applies the same instr_mask for both 16-bit
and 32-bit thumb instructions. If instr_mask then is only 16 bits wide
(0xffff as opposed to 0xffffffff), the first half-word of 32-bit thumb
instructions will be masked out. This makes the function match 32-bit
thumb instructions where the second half-word is equal to instr_val,
regardless of the first half-word.

The result in this case is that all undefined 32-bit thumb instructions
with the second half-word equal to 0xde01 (udf #1) work as breakpoints
and will raise a SIGTRAP instead of a SIGILL, instead of just the one
intended 16-bit instruction. An example of such an instruction is
0xeaa0de01, which is unallocated according to Arm ARM and should raise a
SIGILL, but instead raises a SIGTRAP.

This patch fixes the issue by setting all the bits in instr_mask, which
will still match the intended 16-bit thumb instruction (where the
upper half is always 0), but not any 32-bit thumb instructions.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Fredrik Strupe <fredrik@strupe.net>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/ptrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 58e3771e4c5b..368b4b404985 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -228,8 +228,8 @@ static struct undef_hook arm_break_hook = {
 };
 
 static struct undef_hook thumb_break_hook = {
-	.instr_mask	= 0xffff,
-	.instr_val	= 0xde01,
+	.instr_mask	= 0xffffffff,
+	.instr_val	= 0x0000de01,
 	.cpsr_mask	= PSR_T_BIT,
 	.cpsr_val	= PSR_T_BIT,
 	.fn		= break_trap,
-- 
2.25.1

