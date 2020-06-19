Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC1C200BB3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgFSOgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387566AbgFSOgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A9120CC7;
        Fri, 19 Jun 2020 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577400;
        bh=sXl+Ns5JOxqJylekxpc8ie6/U3eKfS139lWdkI5jD24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW9O7RNOqKL7AxpAqszzrYDog6PD/bFFe3QJVI2noTnCePWJyD0PSX+D/SXOSOUSw
         /KvOcZ/SmBgydOS5i98RnzVpGhoVpwTS93KVoWR7819hRKsLRMCL4x7akbXgjxMznn
         Iv/fVaPPRllZ3M9dGOFp7RBOaLLYyihdLJqKa7Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Fredrik Strupe <fredrik@strupe.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 007/101] ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook
Date:   Fri, 19 Jun 2020 16:31:56 +0200
Message-Id: <20200619141614.398810825@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d54c53b7ab63..711d854ea13a 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -227,8 +227,8 @@ static struct undef_hook arm_break_hook = {
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



