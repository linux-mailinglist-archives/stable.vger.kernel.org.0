Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B89FD62D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKOGWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfKOGV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:59 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB1E2053B;
        Fri, 15 Nov 2019 06:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798919;
        bh=xQGPlnZNgMac2zqZMDOFZsefS7uj2U/f0RNaF7SFnHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJMIHU1W29neuY5VtuD8/WDcRzxNpG89w476/SvbvXJARYgi63HtcFUDcBpNfY49D
         ISqy+11QoRgmEUVqVPetDhLABd9t5JAPV4ctLoTj5KEEDuIRgk0ny0sxb5zJ5ZkplC
         Moz+qUv2GZIj2d2+EpB/q4shjr7G9Bb36+z7dQqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 11/31] kvm/x86: Export MDS_NO=0 to guests when TSX is enabled
Date:   Fri, 15 Nov 2019 14:20:40 +0800
Message-Id: <20191115062013.701053129@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit e1d38b63acd843cfdd4222bf19a26700fd5c699e upstream.

Export the IA32_ARCH_CAPABILITIES MSR bit MDS_NO=0 to guests on TSX
Async Abort(TAA) affected hosts that have TSX enabled and updated
microcode. This is required so that the guests don't complain,

  "Vulnerable: Clear CPU buffers attempted, no microcode"

when the host has the updated microcode to clear CPU buffers.

Microcode update also adds support for MSR_IA32_TSX_CTRL which is
enumerated by the ARCH_CAP_TSX_CTRL bit in IA32_ARCH_CAPABILITIES MSR.
Guests can't do this check themselves when the ARCH_CAP_TSX_CTRL bit is
not exported to the guests.

In this case export MDS_NO=0 to the guests. When guests have
CPUID.MD_CLEAR=1, they deploy MDS mitigation which also mitigates TAA.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1050,6 +1050,25 @@ u64 kvm_get_arch_capabilities(void)
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
 		data |= ARCH_CAP_MDS_NO;
 
+	/*
+	 * On TAA affected systems, export MDS_NO=0 when:
+	 *	- TSX is enabled on the host, i.e. X86_FEATURE_RTM=1.
+	 *	- Updated microcode is present. This is detected by
+	 *	  the presence of ARCH_CAP_TSX_CTRL_MSR and ensures
+	 *	  that VERW clears CPU buffers.
+	 *
+	 * When MDS_NO=0 is exported, guests deploy clear CPU buffer
+	 * mitigation and don't complain:
+	 *
+	 *	"Vulnerable: Clear CPU buffers attempted, no microcode"
+	 *
+	 * If TSX is disabled on the system, guests are also mitigated against
+	 * TAA and clear CPU buffer mitigation is not required for guests.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
+	    (data & ARCH_CAP_TSX_CTRL_MSR))
+		data &= ~ARCH_CAP_MDS_NO;
+
 	return data;
 }
 


