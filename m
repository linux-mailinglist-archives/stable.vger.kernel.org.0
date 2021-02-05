Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCF3110F1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhBERfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbhBERdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:33:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCFCC06178A;
        Fri,  5 Feb 2021 11:15:14 -0800 (PST)
Date:   Fri, 05 Feb 2021 19:15:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612552513;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeBofFEAXxs91lUNgZRi8mOjh7QyCz8iKk9h+ob1osY=;
        b=Xxxl1hKoHIv7jQ625CvPLY7jlPUbR5aEFaOHHV/PfQWgHA+b+xgjdYDruFLcnVuaYCDn7n
        uyQzOMLCapvRBjOqeEz8g0xtORysvptjOC/zXKIAq32aH5gQW5NL5XaEbL4qzGRY0OAkUw
        s88R5XdC4UoEMRTxx9qXxx3EbA9/jjVG8klrFP0PIgocwM9N/+7vGSSMdRStyCZ3T4bkIf
        dAFE8m6IE59roygCA6DWxjjeXIC8d+XzmVWQU1JakHeqUd+HF5u1A8ChOALaUrdua2t0kL
        NxN4LapvlxIQTcAlA/bD1eF7KWVTcfNNWrKn7G7EnGwgsnAFrlQL+E5deHNxdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612552513;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeBofFEAXxs91lUNgZRi8mOjh7QyCz8iKk9h+ob1osY=;
        b=y0up98m1JFsO8wF+44eCK2FsvHSR3WZ6+1jh8FZoR4nb8nKE2mL1YDOzn8DQWJ4Kq6fCpl
        8EokMp2Zh58cQYCA==
From:   "tip-bot2 for Lai Jiangshan" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/debug: Prevent data breakpoints on cpu_dr7
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210204152708.21308-2-jiangshanlai@gmail.com>
References: <20210204152708.21308-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Message-ID: <161255251192.23325.17821582532132807593.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     3943abf2dbfae9ea4d2da05c1db569a0603f76da
Gitweb:        https://git.kernel.org/tip/3943abf2dbfae9ea4d2da05c1db569a0603f76da
Author:        Lai Jiangshan <laijs@linux.alibaba.com>
AuthorDate:    Thu, 04 Feb 2021 23:27:07 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 05 Feb 2021 20:13:12 +01:00

x86/debug: Prevent data breakpoints on cpu_dr7

local_db_save() is called at the start of exc_debug_kernel(), reads DR7 and
disables breakpoints to prevent recursion.

When running in a guest (X86_FEATURE_HYPERVISOR), local_db_save() reads the
per-cpu variable cpu_dr7 to check whether a breakpoint is active or not
before it accesses DR7.

A data breakpoint on cpu_dr7 therefore results in infinite #DB recursion.

Disallow data breakpoints on cpu_dr7 to prevent that.

Fixes: 84b6a3491567a("x86/entry: Optimize local_db_save() for virt")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210204152708.21308-2-jiangshanlai@gmail.com

---
 arch/x86/kernel/hw_breakpoint.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 012ed82..668a4a6 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -307,6 +307,14 @@ static inline bool within_cpu_entry(unsigned long addr, unsigned long end)
 				(unsigned long)&per_cpu(cpu_tlbstate, cpu),
 				sizeof(struct tlb_state)))
 			return true;
+
+		/*
+		 * When in guest (X86_FEATURE_HYPERVISOR), local_db_save()
+		 * will read per-cpu cpu_dr7 before clear dr7 register.
+		 */
+		if (within_area(addr, end, (unsigned long)&per_cpu(cpu_dr7, cpu),
+				sizeof(cpu_dr7)))
+			return true;
 	}
 
 	return false;
