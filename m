Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2B2E396A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgL1NXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731785AbgL1NXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD78208BA;
        Mon, 28 Dec 2020 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161761;
        bh=vetFylCNhqBy9Hb0U/hW9ek/D9/LNGKncD0/iCRr3t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTG7SbIMlUUW6hSCCVyKdmctHVYhNXAlmpzJkwuMIpf2llHkGqEU8wL5mZvx4ZN7E
         gQv4lfpq18o1ufxrzK8wkRmWDLs/ZKCkMl4bcGynRUaTqtCq5FQKBNdJ0BHNkCiW+n
         6gr5gWn79iHBOslLY48TL69K79rsR+GwvlFAhR7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/346] arm64: syscall: exit userspace before unmasking exceptions
Date:   Mon, 28 Dec 2020 13:46:31 +0100
Message-Id: <20201228124923.277198210@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ca1314d73eed493c49bb1932c60a8605530db2e4 ]

In el0_svc_common() we unmask exceptions before we call user_exit(), and
so there's a window where an IRQ or debug exception can be taken while
RCU is not watching. In do_debug_exception() we account for this in via
debug_exception_{enter,exit}(), but in the el1_irq asm we do not and we
call trace functions which rely on RCU before we have a guarantee that
RCU is watching.

Let's avoid this by having el0_svc_common() exit userspace before
unmasking exceptions, matching what we do for all other EL0 entry paths.
We can use user_exit_irqoff() to avoid the pointless save/restore of IRQ
flags while we're sure exceptions are masked in DAIF.

The workaround for Cortex-A76 erratum 1463225 may trigger a debug
exception before this point, but the debug code invoked in this case is
safe even when RCU is not watching.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201130115950.22492-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 1457a0ba83dbc..f2d2dbbbfca20 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -102,8 +102,8 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	regs->syscallno = scno;
 
 	cortex_a76_erratum_1463225_svc_handler();
+	user_exit_irqoff();
 	local_daif_restore(DAIF_PROCCTX);
-	user_exit();
 
 	if (has_syscall_work(flags)) {
 		/* set default errno for user-issued syscall(-1) */
-- 
2.27.0



