Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F238A342
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhETJur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234152AbhETJsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1AB61476;
        Thu, 20 May 2021 09:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503292;
        bh=fumZsiVBofI0RCCMA6zRsxo2n840tAab0nQ7pIhcE80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4hDXhVkOo7ycZ2kcHG/voCumSx0wprZrl57T3lPXPE0OLybG2OFzIbYgXko3wSGs
         57qPUn6+mft2/PMOeC8CBxR4iimEcltem/8Dp6hKPLB1pF/DdLldOi7Y5nyhlnx1rs
         cxM0VMBFuTFvzRtWeWaOS0wMa1FYRoZ3OQR9MYXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 156/425] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported
Date:   Thu, 20 May 2021 11:18:45 +0200
Message-Id: <20210520092136.563735779@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit b6b4fbd90b155a0025223df2c137af8a701d53b3 upstream.

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

Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210504225632.1532621-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vdso/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -343,7 +343,7 @@ static void vgetcpu_cpu_init(void *arg)
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
 #endif
-	if (static_cpu_has(X86_FEATURE_RDTSCP))
+	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
 		write_rdtscp_aux((node << 12) | cpu);
 
 	/*


