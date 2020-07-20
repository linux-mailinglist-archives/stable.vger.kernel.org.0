Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5C226C49
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgGTQsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729273AbgGTPip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D1322CAF;
        Mon, 20 Jul 2020 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259525;
        bh=nlf0xoHKRhA4cA8SL1DRGKekbuRXwZoHO/n7WMX/hQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdyTR/0Cfzi6a5+Les8Sgqvr0hFsiZcSBOOEEQiMb0QlSQ2+sUMH7/1hn6ZcDfZ+a
         g2fuf00Sg/KtWZ3KpdkNvZL+AUwSSmcJgYL37Nmpsh/E47CggYKaiHydkUQcshy9M1
         LXHM7S0JtNTDd9x2kdoVb0tSbj6gpLNPg3pK4dl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Douglas Anderson <dianders@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/58] arm64: kgdb: Fix single-step exception handling oops
Date:   Mon, 20 Jul 2020 17:36:25 +0200
Message-Id: <20200720152747.610199679@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit 8523c006264df65aac7d77284cc69aac46a6f842 ]

After entering kdb due to breakpoint, when we execute 'ss' or 'go' (will
delay installing breakpoints, do single-step first), it won't work
correctly, and it will enter kdb due to oops.

It's because the reason gotten in kdb_stub() is not as expected, and it
seems that the ex_vector for single-step should be 0, like what arch
powerpc/sh/parisc has implemented.

Before the patch:
Entering kdb (current=0xffff8000119e2dc0, pid 0) on processor 0 due to Keyboard Entry
[0]kdb> bp printk
Instruction(i) BP #0 at 0xffff8000101486cc (printk)
    is enabled   addr at ffff8000101486cc, hardtype=0 installed=0

[0]kdb> g

/ # echo h > /proc/sysrq-trigger

Entering kdb (current=0xffff0000fa878040, pid 266) on processor 3 due to Breakpoint @ 0xffff8000101486cc
[3]kdb> ss

Entering kdb (current=0xffff0000fa878040, pid 266) on processor 3 Oops: (null)
due to oops @ 0xffff800010082ab8
CPU: 3 PID: 266 Comm: sh Not tainted 5.7.0-rc4-13839-gf0e5ad491718 #6
Hardware name: linux,dummy-virt (DT)
pstate: 00000085 (nzcv daIf -PAN -UAO)
pc : el1_irq+0x78/0x180
lr : __handle_sysrq+0x80/0x190
sp : ffff800015003bf0
x29: ffff800015003d20 x28: ffff0000fa878040
x27: 0000000000000000 x26: ffff80001126b1f0
x25: ffff800011b6a0d8 x24: 0000000000000000
x23: 0000000080200005 x22: ffff8000101486cc
x21: ffff800015003d30 x20: 0000ffffffffffff
x19: ffff8000119f2000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000
x9 : 0000000000000000 x8 : ffff800015003e50
x7 : 0000000000000002 x6 : 00000000380b9990
x5 : ffff8000106e99e8 x4 : ffff0000fadd83c0
x3 : 0000ffffffffffff x2 : ffff800011b6a0d8
x1 : ffff800011b6a000 x0 : ffff80001130c9d8
Call trace:
 el1_irq+0x78/0x180
 printk+0x0/0x84
 write_sysrq_trigger+0xb0/0x118
 proc_reg_write+0xb4/0xe0
 __vfs_write+0x18/0x40
 vfs_write+0xb0/0x1b8
 ksys_write+0x64/0xf0
 __arm64_sys_write+0x14/0x20
 el0_svc_common.constprop.2+0xb0/0x168
 do_el0_svc+0x20/0x98
 el0_sync_handler+0xec/0x1a8
 el0_sync+0x140/0x180

[3]kdb>

After the patch:
Entering kdb (current=0xffff8000119e2dc0, pid 0) on processor 0 due to Keyboard Entry
[0]kdb> bp printk
Instruction(i) BP #0 at 0xffff8000101486cc (printk)
    is enabled   addr at ffff8000101486cc, hardtype=0 installed=0

[0]kdb> g

/ # echo h > /proc/sysrq-trigger

Entering kdb (current=0xffff0000fa852bc0, pid 268) on processor 0 due to Breakpoint @ 0xffff8000101486cc
[0]kdb> g

Entering kdb (current=0xffff0000fa852bc0, pid 268) on processor 0 due to Breakpoint @ 0xffff8000101486cc
[0]kdb> ss

Entering kdb (current=0xffff0000fa852bc0, pid 268) on processor 0 due to SS trap @ 0xffff800010082ab8
[0]kdb>

Fixes: 44679a4f142b ("arm64: KGDB: Add step debugging support")
Signed-off-by: Wei Li <liwei391@huawei.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200509214159.19680-2-liwei391@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/kgdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index f72743dc070d9..606c21760f23e 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -238,7 +238,7 @@ static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned int esr)
 	if (user_mode(regs))
 		return DBG_HOOK_ERROR;
 
-	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 	return DBG_HOOK_HANDLED;
 }
 
-- 
2.25.1



