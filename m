Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4938A6CB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhETKac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236579AbhETK2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:28:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B10D561C35;
        Thu, 20 May 2021 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504266;
        bh=x1S1tk8e4qo3ieI9GVN1SbYi1rrOISifk0sPD6tKviQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADnrNaCY96oo2FWov9AxRPFn/RRvfw/ZK1pkQfHcXZWinzyd5nSXCE1nNc4leLpDu
         yKTALNsJxXO26ES/37WQIA5YDX70DOOZqf99xKRdFGY9Az1kNa535n0SH2iCTjrpVt
         H2V1W84B1DyYef5n4DjsiRMVQjZ62oUaft5T8Ze0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 133/323] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported
Date:   Thu, 20 May 2021 11:20:25 +0200
Message-Id: <20210520092124.668398382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -342,7 +342,7 @@ static void vgetcpu_cpu_init(void *arg)
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
 #endif
-	if (static_cpu_has(X86_FEATURE_RDTSCP))
+	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
 		write_rdtscp_aux((node << 12) | cpu);
 
 	/*


