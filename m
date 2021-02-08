Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B893137FD
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhBHPfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:35:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhBHPaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B6F64ED2;
        Mon,  8 Feb 2021 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797430;
        bh=1tgGhcLc+jYFzdUPphBAPSNPF7jH8HDiSa5BXeX4B2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/n/30C8iKjqzGjNtBKMD6tYC4uja6ht9bWs1NODi60gedURPdtcICfiE4X8me0eE
         hacaDqnLuTxjXzv2lHG0q3MHp+VKEtWaw8eouhWIJOZVKcdETKysnyGZftYYU9wLgQ
         jm1kDWj5a5FHq+0kjOPe+2uXpKEz+xyF7Zu+LtA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 108/120] x86/debug: Prevent data breakpoints on __per_cpu_offset
Date:   Mon,  8 Feb 2021 16:01:35 +0100
Message-Id: <20210208145822.689200218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit c4bed4b96918ff1d062ee81fdae4d207da4fa9b0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/hw_breakpoint.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -269,6 +269,20 @@ static inline bool within_cpu_entry(unsi
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


