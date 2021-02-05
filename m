Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5D3110EE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhBERfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhBERdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:33:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F3C061788;
        Fri,  5 Feb 2021 11:15:14 -0800 (PST)
Date:   Fri, 05 Feb 2021 19:15:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612552513;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QDNpNdj5yezfFVol+aHDqgIG1pwnCEAQJzOUvn9V6k=;
        b=Q7kwF+NXNnjsxTUvLW0pLBdejd/J2GatBjV5T1xsc1y7mkpFZ/jlJIW2bwTPgrd2eeV6AW
        3Adw+V3u0kD/SZryEC49HTEo3w+dZ62b9Gyw3LFAQg3V8bd8/pemm2EfP374/aoXfA3AUB
        FDmO4yMHygVwXzxcP/QubdSeG6bYh1a9CbQsBJk7zrBguqn3PdN29Mp7c2c1iZeg5ne/C8
        MHup8R0CI43QBVj7J3gIxHvoPiLANu1wmJoglHmm3DpfdrenB1pnv1U3/UZI3UY/5twlEZ
        K637Tz8TfgoNyqAwmRqNO8yl2z1qE1OjyPgGrRaWXn7gv4RUeXO8sQH+4/yCeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612552513;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QDNpNdj5yezfFVol+aHDqgIG1pwnCEAQJzOUvn9V6k=;
        b=yjagk2ZX0nNkcqX3OIDrsdB5mZJmnxwE6ULqP34EEWjK+U9cMU4WwjWA6/1Ab3eyOH8zAr
        vwPyFwfoa/jpNEBA==
From:   "tip-bot2 for Lai Jiangshan" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/debug: Prevent data breakpoints on __per_cpu_offset
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210204152708.21308-1-jiangshanlai@gmail.com>
References: <20210204152708.21308-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Message-ID: <161255251223.23325.14171515880734146510.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     c4bed4b96918ff1d062ee81fdae4d207da4fa9b0
Gitweb:        https://git.kernel.org/tip/c4bed4b96918ff1d062ee81fdae4d207da4fa9b0
Author:        Lai Jiangshan <laijs@linux.alibaba.com>
AuthorDate:    Thu, 04 Feb 2021 23:27:06 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 05 Feb 2021 20:13:11 +01:00

x86/debug: Prevent data breakpoints on __per_cpu_offset

When FSGSBASE is enabled, paranoid_entry() fetches the per-CPU GSBASE value
via __per_cpu_offset or pcpu_unit_offsets.

When a data breakpoint is set on __per_cpu_offset[cpu] (read-write
operation), the specific CPU will be stuck in an infinite #DB loop.

RCU will try to send an NMI to the specific CPU, but it is not working
either since NMI also relies on paranoid_entry(). Which means it's
undebuggable.

Fixes: eaad981291ee3("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210204152708.21308-1-jiangshanlai@gmail.com

---
 arch/x86/kernel/hw_breakpoint.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 6694c0f..012ed82 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -269,6 +269,20 @@ static inline bool within_cpu_entry(unsigned long addr, unsigned long end)
 			CPU_ENTRY_AREA_TOTAL_SIZE))
 		return true;
 
+	/*
+	 * When FSGSBASE is enabled, paranoid_entry() fetches the per-CPU
+	 * GSBASE value via __per_cpu_offset or pcpu_unit_offsets.
+	 */
+#ifdef CONFIG_SMP
+	if (within_area(addr, end, (unsigned long)__per_cpu_offset,
+			sizeof(unsigned long) * nr_cpu_ids))
+		return true;
+#else
+	if (within_area(addr, end, (unsigned long)&pcpu_unit_offsets,
+			sizeof(pcpu_unit_offsets)))
+		return true;
+#endif
+
 	for_each_possible_cpu(cpu) {
 		/* The original rw GDT is being used after load_direct_gdt() */
 		if (within_area(addr, end, (unsigned long)get_cpu_gdt_rw(cpu),
