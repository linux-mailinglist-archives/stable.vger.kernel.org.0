Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE53442CD
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCVMpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhCVMnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B2F46199E;
        Mon, 22 Mar 2021 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416875;
        bh=ZpEdCe8QuqCUDcs5vE1hwzwaex3zGkU23O5Awm6ILJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjxFC9I72dF4wwon8BeYlE/miEi2SVz8bRK8HLHfZZmvXoJChRKP40sv/DXDre4Jo
         UdT3qz68XoCqJvNnX3WhI5xn6Xqxh4EPrUhwg+1BFvLeccjMZrLtoLv/Hj6SIDxJP5
         0t3AZD+4GWTGqNVVV6SID62XgTqe7aeqnK+dzqc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 157/157] x86/apic/of: Fix CPU devicetree-node lookups
Date:   Mon, 22 Mar 2021 13:28:34 +0100
Message-Id: <20210322121938.719266188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit dd926880da8dbbe409e709c1d3c1620729a94732 upstream.

Architectures that describe the CPU topology in devicetree and do not have
an identity mapping between physical and logical CPU ids must override the
default implementation of arch_match_cpu_phys_id().

Failing to do so breaks CPU devicetree-node lookups using of_get_cpu_node()
and of_cpu_device_node_get() which several drivers rely on. It also causes
the CPU struct devices exported through sysfs to point to the wrong
devicetree nodes.

On x86, CPUs are described in devicetree using their APIC ids and those
do not generally coincide with the logical ids, even if CPU0 typically
uses APIC id 0.

Add the missing implementation of arch_match_cpu_phys_id() so that CPU-node
lookups work also with SMP.

Apart from fixing the broken sysfs devicetree-node links this likely does
not affect current users of mainline kernels on x86.

Fixes: 4e07db9c8db8 ("x86/devicetree: Use CPU description from Device Tree")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210312092033.26317-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2317,6 +2317,11 @@ static int cpuid_to_apicid[] = {
 	[0 ... NR_CPUS - 1] = -1,
 };
 
+bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return phys_id == cpuid_to_apicid[cpu];
+}
+
 #ifdef CONFIG_SMP
 /**
  * apic_id_is_primary_thread - Check whether APIC ID belongs to a primary thread


