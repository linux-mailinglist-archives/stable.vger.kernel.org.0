Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0F37537C
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 14:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhEFMPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 08:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhEFMPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 08:15:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F9C061574;
        Thu,  6 May 2021 05:14:09 -0700 (PDT)
Date:   Thu, 06 May 2021 12:14:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620303247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfaRVv9h09XjjotgGmtiMgoAExs38y2tyZnER+tyaQM=;
        b=xvE83celZF9Yd+LmMGD3jkQaaB7UulTun6c/9kHfprJYxxJm7Xay+mJBnjZ/ojmMr6/dJN
        1WPxUbyjSxEYMBNIMHE8JjEjYwdzX+AjcjIvuRZZKozPPCYz6ijX2I/4MMX/bHMLYAvqa1
        htlVpcJWwtYEQViWyfQbKLjQT6sjLqoYmhoFsEXbGWfiX4LCK0VKhDX/S1lsqFHnF57ZS6
        +adpUEe8ceNoJh409MT8fpQjIHsOVG+gChta2GAZrReLsQ0OjtI+Evv8s6D8iZaCUxNzcL
        cGTWwFph30yDiCmkX01eXXd55jTSPReDPkgHF12+KSW0KPlidx1zFjSC7n0R2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620303247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfaRVv9h09XjjotgGmtiMgoAExs38y2tyZnER+tyaQM=;
        b=tBhIbH+tiVc20ne/oINww30o2QSLmGM0RTzoW7/ML5wIQs72hoNjwn2pWzJo5e65dUQQRK
        YnDRY4ddfTB0MhBQ==
From:   "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or*
 RDPID is supported
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210504225632.1532621-2-seanjc@google.com>
References: <20210504225632.1532621-2-seanjc@google.com>
MIME-Version: 1.0
Message-ID: <162030324711.29796.18380824416576531617.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b6b4fbd90b155a0025223df2c137af8a701d53b3
Gitweb:        https://git.kernel.org/tip/b6b4fbd90b155a0025223df2c137af8a701d53b3
Author:        Sean Christopherson <seanjc@google.com>
AuthorDate:    Tue, 04 May 2021 15:56:31 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 05 May 2021 21:50:14 +02:00

x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

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

---
 arch/x86/kernel/cpu/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6bdb69a..490bed0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1851,7 +1851,7 @@ static inline void setup_getcpu(int cpu)
 	unsigned long cpudata = vdso_encode_cpunode(cpu, early_cpu_to_node(cpu));
 	struct desc_struct d = { };
 
-	if (boot_cpu_has(X86_FEATURE_RDTSCP))
+	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
 		write_rdtscp_aux(cpudata);
 
 	/* Store CPU and node number in limit. */
