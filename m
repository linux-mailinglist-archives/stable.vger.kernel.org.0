Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00AFD647
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfKOGXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfKOGWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:35 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7682620801;
        Fri, 15 Nov 2019 06:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798953;
        bh=yQgj9nUSMXhIRzKf4KtPw/6VPqUrJf/LMAp1p/aV+Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0w4ij/mUOmSd9kmGU+FQjxrCgaBpDGHyoED0/QnHYaWs7WrfUHe48UWzspBbdSAkf
         eLyaecO2DSs1erS2bADMl+Fk5w9yPgdeu5cQpohecSLyySWj0Zai0z9zhsHF5tK/l8
         x7TR4dwzfkQX/ihSZOyq+V1M4fh7of0RxMzmow/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 06/31] x86/msr: Add the IA32_TSX_CTRL MSR
Date:   Fri, 15 Nov 2019 14:20:35 +0800
Message-Id: <20191115062011.497215220@linuxfoundation.org>
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

commit c2955f270a84762343000f103e0640d29c7a96f3 upstream.

Transactional Synchronization Extensions (TSX) may be used on certain
processors as part of a speculative side channel attack.  A microcode
update for existing processors that are vulnerable to this attack will
add a new MSR - IA32_TSX_CTRL to allow the system administrator the
option to disable TSX as one of the possible mitigations.

The CPUs which get this new MSR after a microcode upgrade are the ones
which do not set MSR_IA32_ARCH_CAPABILITIES.MDS_NO (bit 5) because those
CPUs have CPUID.MD_CLEAR, i.e., the VERW implementation which clears all
CPU buffers takes care of the TAA case as well.

  [ Note that future processors that are not vulnerable will also
    support the IA32_TSX_CTRL MSR. ]

Add defines for the new IA32_TSX_CTRL MSR and its bits.

TSX has two sub-features:

1. Restricted Transactional Memory (RTM) is an explicitly-used feature
   where new instructions begin and end TSX transactions.
2. Hardware Lock Elision (HLE) is implicitly used when certain kinds of
   "old" style locks are used by software.

Bit 7 of the IA32_ARCH_CAPABILITIES indicates the presence of the
IA32_TSX_CTRL MSR.

There are two control bits in IA32_TSX_CTRL MSR:

  Bit 0: When set, it disables the Restricted Transactional Memory (RTM)
         sub-feature of TSX (will force all transactions to abort on the
	 XBEGIN instruction).

  Bit 1: When set, it disables the enumeration of the RTM and HLE feature
         (i.e. it will make CPUID(EAX=7).EBX{bit4} and
	  CPUID(EAX=7).EBX{bit11} read as 0).

The other TSX sub-feature, Hardware Lock Elision (HLE), is
unconditionally disabled by the new microcode but still enumerated
as present by CPUID(EAX=7).EBX{bit4}, unless disabled by
IA32_TSX_CTRL_MSR[1] - TSX_CTRL_CPUID_CLEAR.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -77,6 +77,7 @@
 						  * Microarchitectural Data
 						  * Sampling (MDS) vulnerabilities.
 						  */
+#define ARCH_CAP_TSX_CTRL_MSR		BIT(7)	/* MSR for TSX control is available. */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -87,6 +88,10 @@
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
 
+#define MSR_IA32_TSX_CTRL		0x00000122
+#define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
+#define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
+
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
 #define MSR_IA32_SYSENTER_EIP		0x00000176


