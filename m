Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6990C37BA08
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhELKJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhELKJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:09:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926AC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 03:08:03 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620814081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Ym9XXx83cdAcrF8H016MuLUulSMcw6zO1tA2ejlvuQ=;
        b=yfdPD4BS8tWtMLJPCl8URDpXW9sJ+yxsKXSea1rcbe11AIZ/7NFhqV0KQFP28itm58eNPe
        PUVVBe94VZCDsXN9OSLG8cIMSjU/BLS2mmEtkIr/8q2obJtJcO/qm61y/o0IqGOOBELa/w
        1Tp13o5ldykh0TZT9JjGcbH8VYp3V/lIggfF+R9K09zYlwyQOIMwhEk8p7C+S7F0Dguy0c
        WbavPyLlklalRvPQA9OpOTyTrgWkT+HcvC6n+X43uMY+M1WwF8vV++yk/RGQtFSzxFQJ3e
        FZ4q+cO9QNJ5AVapFRibdvo1cFewrm31fR65/AcqILiYRpJgY95cM4vbYME3+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620814081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Ym9XXx83cdAcrF8H016MuLUulSMcw6zO1tA2ejlvuQ=;
        b=WuYLFLciqDNxNPJlNxscKNK08LhS5DYFrquFAaqAEmM5NbgSs1AnHgG/Tht0Lm50909XgY
        TdsguLu8JdQ3OcBg==
To:     gregkh@linuxfoundation.org, seanjc@google.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported
In-Reply-To: <1620632578184221@kroah.com>
References: <1620632578184221@kroah.com>
Date:   Wed, 12 May 2021 12:08:00 +0200
Message-ID: <875yzofenz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit b6b4fbd90b155a0025223df2c137af8a701d53b3 upstream

Initialize MSR_TSC_AUX with CPU node information if RDTSCP or RDPID is
supported.  This fixes a bug where vdso_read_cpunode() will read garbage
via RDPID if RDPID is supported but RDTSCP is not.  While no known CPU
supports RDPID but not RDTSCP, both Intel's SDM and AMD's APM allow for
RDPID to exist without RDTSCP, e.g. it's technically a legal CPU model
for a virtual machine.

Note, technically MSR_TSC_AUX could be initialized if and only if RDPID
is supported since RDTSCP is currently not used to retrieve the CPU node.
But, the cost of the superfluous WRMSR is negigible, whereas leaving
MSR_TSC_AUX uninitialized is just asking for future breakage if someone
decides to utilize RDTSCP.

[ tglx: Backport for 4.14/4.19 ]

Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210504225632.1532621-2-seanjc@google.com
---
 arch/x86/entry/vdso/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -342,7 +342,7 @@ static void vgetcpu_cpu_init(void *arg)
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
 #endif
-	if (static_cpu_has(X86_FEATURE_RDTSCP))
+	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
 		write_rdtscp_aux((node << 12) | cpu);
 
 	/*
