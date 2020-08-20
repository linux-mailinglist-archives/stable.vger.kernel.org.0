Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E5424BCC2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgHTMwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgHTJnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492E822CAF;
        Thu, 20 Aug 2020 09:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916619;
        bh=DW+/asn9SL3tnwFrOH3enyhqWRJzJS/BBM0HEdCf5Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6/xk/uEYKIkGlTLaSRryOcud4IHQZz2d1LJh3BOI8fslObWmH3JohhRmbEJM+AVL
         3wVxV8gH2sTe76kuUW4bwx79Bqou5IBX4FGqpqp3hZrGfE7NXL4tL0hDY5XgL46mPH
         jzeHQzkuEe4f9XrCn3Gg5Ar4gUF08ACYBYEtBrtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nelson Dsouza <nelson.dsouza@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 162/204] x86/bugs/multihit: Fix mitigation reporting when VMX is not in use
Date:   Thu, 20 Aug 2020 11:20:59 +0200
Message-Id: <20200820091614.312388768@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit f29dfa53cc8ae6ad93bae619bcc0bf45cab344f7 ]

On systems that have virtualization disabled or unsupported, sysfs
mitigation for X86_BUG_ITLB_MULTIHIT is reported incorrectly as:

  $ cat /sys/devices/system/cpu/vulnerabilities/itlb_multihit
  KVM: Vulnerable

System is not vulnerable to DoS attack from a rogue guest when
virtualization is disabled or unsupported in the hardware. Change the
mitigation reporting for these cases.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Reported-by: Nelson Dsouza <nelson.dsouza@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/0ba029932a816179b9d14a30db38f0f11ef1f166.1594925782.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/hw-vuln/multihit.rst | 4 ++++
 arch/x86/kernel/cpu/bugs.c                     | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/multihit.rst b/Documentation/admin-guide/hw-vuln/multihit.rst
index ba9988d8bce50..140e4cec38c33 100644
--- a/Documentation/admin-guide/hw-vuln/multihit.rst
+++ b/Documentation/admin-guide/hw-vuln/multihit.rst
@@ -80,6 +80,10 @@ The possible values in this file are:
        - The processor is not vulnerable.
      * - KVM: Mitigation: Split huge pages
        - Software changes mitigate this issue.
+     * - KVM: Mitigation: VMX unsupported
+       - KVM is not vulnerable because Virtual Machine Extensions (VMX) is not supported.
+     * - KVM: Mitigation: VMX disabled
+       - KVM is not vulnerable because Virtual Machine Extensions (VMX) is disabled.
      * - KVM: Vulnerable
        - The processor is vulnerable, but no mitigation enabled
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index b53dcff21438c..8c963ea39f9df 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -31,6 +31,7 @@
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
 #include <asm/hypervisor.h>
+#include <asm/tlbflush.h>
 
 #include "cpu.h"
 
@@ -1556,7 +1557,12 @@ static ssize_t l1tf_show_state(char *buf)
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
-	if (itlb_multihit_kvm_mitigation)
+	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !boot_cpu_has(X86_FEATURE_VMX))
+		return sprintf(buf, "KVM: Mitigation: VMX unsupported\n");
+	else if (!(cr4_read_shadow() & X86_CR4_VMXE))
+		return sprintf(buf, "KVM: Mitigation: VMX disabled\n");
+	else if (itlb_multihit_kvm_mitigation)
 		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
 	else
 		return sprintf(buf, "KVM: Vulnerable\n");
-- 
2.25.1



