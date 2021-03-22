Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39FF3443B1
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCVMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231853AbhCVMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D8E0619A9;
        Mon, 22 Mar 2021 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417146;
        bh=tSUZUQmkYHuJQC7Q0EFW9fCvt0nN3Dgz96VAiF+uOew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGWVtxjqUS7Ir7U7P3Lx6Dlsua/5v4J20WnVYhz0oYipyRAN+od7T0S7GotDKCjW0
         45WdCmRNXCNh8WXhYUPotUmuUFdE8bOkI2nCMRslTaDNpE1XLikQRUcCbfwQdjZBNe
         zx1OVvpnXwazHkrnPfktbdXMMAXzhwSUeUR3iQ4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 43/43] x86/apic/of: Fix CPU devicetree-node lookups
Date:   Mon, 22 Mar 2021 13:28:57 +0100
Message-Id: <20210322121921.318099121@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
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
@@ -2279,6 +2279,11 @@ static int cpuid_to_apicid[] = {
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


