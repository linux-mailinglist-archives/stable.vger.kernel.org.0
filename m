Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2644FD628
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfKOGXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfKOGXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:23:01 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70ADE20637;
        Fri, 15 Nov 2019 06:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798979;
        bh=i8eMNl+f+lf65lXu6rfiVgo7iExiLMaCuUh6yGCBirU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPG4qF/xLo8GG4Fdwc66ci7RiO86hxBmyYimpyq2HDtRDOv5tcrDWtCxVdmHmEiia
         nQ8BcCzOMLML3B5XSjKES6etg8L2mT5PrMazW52klAAClTvZ+OziUCrR0rmd2PJV/M
         0JKGGh6ko8bg7sGnOOpnO7UmpDGB8KglgvF73Ue4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Gomez Iglesias <antonio.gomez.iglesias@intel.com>,
        Nelson DSouza <nelson.dsouza@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 31/31] Documentation: Add ITLB_MULTIHIT documentation
Date:   Fri, 15 Nov 2019 14:21:00 +0800
Message-Id: <20191115062020.451931132@linuxfoundation.org>
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

From: "Gomez Iglesias, Antonio" <antonio.gomez.iglesias@intel.com>

commit 7f00cc8d4a51074eb0ad4c3f16c15757b1ddfb7d upstream.

Add the initial ITLB_MULTIHIT documentation.

[ tglx: Add it to the index so it gets actually built. ]

Signed-off-by: Antonio Gomez Iglesias <antonio.gomez.iglesias@intel.com>
Signed-off-by: Nelson D'Souza <nelson.dsouza@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/index.rst    |    1 
 Documentation/hw-vuln/multihit.rst |  163 +++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)
 create mode 100644 Documentation/hw-vuln/multihit.rst

--- a/Documentation/hw-vuln/index.rst
+++ b/Documentation/hw-vuln/index.rst
@@ -12,3 +12,4 @@ are configurable at compile, boot or run
    l1tf
    mds
    tsx_async_abort
+   multihit.rst
--- /dev/null
+++ b/Documentation/hw-vuln/multihit.rst
@@ -0,0 +1,163 @@
+iTLB multihit
+=============
+
+iTLB multihit is an erratum where some processors may incur a machine check
+error, possibly resulting in an unrecoverable CPU lockup, when an
+instruction fetch hits multiple entries in the instruction TLB. This can
+occur when the page size is changed along with either the physical address
+or cache type. A malicious guest running on a virtualized system can
+exploit this erratum to perform a denial of service attack.
+
+
+Affected processors
+-------------------
+
+Variations of this erratum are present on most Intel Core and Xeon processor
+models. The erratum is not present on:
+
+   - non-Intel processors
+
+   - Some Atoms (Airmont, Bonnell, Goldmont, GoldmontPlus, Saltwell, Silvermont)
+
+   - Intel processors that have the PSCHANGE_MC_NO bit set in the
+     IA32_ARCH_CAPABILITIES MSR.
+
+
+Related CVEs
+------------
+
+The following CVE entry is related to this issue:
+
+   ==============  =================================================
+   CVE-2018-12207  Machine Check Error Avoidance on Page Size Change
+   ==============  =================================================
+
+
+Problem
+-------
+
+Privileged software, including OS and virtual machine managers (VMM), are in
+charge of memory management. A key component in memory management is the control
+of the page tables. Modern processors use virtual memory, a technique that creates
+the illusion of a very large memory for processors. This virtual space is split
+into pages of a given size. Page tables translate virtual addresses to physical
+addresses.
+
+To reduce latency when performing a virtual to physical address translation,
+processors include a structure, called TLB, that caches recent translations.
+There are separate TLBs for instruction (iTLB) and data (dTLB).
+
+Under this errata, instructions are fetched from a linear address translated
+using a 4 KB translation cached in the iTLB. Privileged software modifies the
+paging structure so that the same linear address using large page size (2 MB, 4
+MB, 1 GB) with a different physical address or memory type.  After the page
+structure modification but before the software invalidates any iTLB entries for
+the linear address, a code fetch that happens on the same linear address may
+cause a machine-check error which can result in a system hang or shutdown.
+
+
+Attack scenarios
+----------------
+
+Attacks against the iTLB multihit erratum can be mounted from malicious
+guests in a virtualized system.
+
+
+iTLB multihit system information
+--------------------------------
+
+The Linux kernel provides a sysfs interface to enumerate the current iTLB
+multihit status of the system:whether the system is vulnerable and which
+mitigations are active. The relevant sysfs file is:
+
+/sys/devices/system/cpu/vulnerabilities/itlb_multihit
+
+The possible values in this file are:
+
+.. list-table::
+
+     * - Not affected
+       - The processor is not vulnerable.
+     * - KVM: Mitigation: Split huge pages
+       - Software changes mitigate this issue.
+     * - KVM: Vulnerable
+       - The processor is vulnerable, but no mitigation enabled
+
+
+Enumeration of the erratum
+--------------------------------
+
+A new bit has been allocated in the IA32_ARCH_CAPABILITIES (PSCHANGE_MC_NO) msr
+and will be set on CPU's which are mitigated against this issue.
+
+   =======================================   ===========   ===============================
+   IA32_ARCH_CAPABILITIES MSR                Not present   Possibly vulnerable,check model
+   IA32_ARCH_CAPABILITIES[PSCHANGE_MC_NO]    '0'           Likely vulnerable,check model
+   IA32_ARCH_CAPABILITIES[PSCHANGE_MC_NO]    '1'           Not vulnerable
+   =======================================   ===========   ===============================
+
+
+Mitigation mechanism
+-------------------------
+
+This erratum can be mitigated by restricting the use of large page sizes to
+non-executable pages.  This forces all iTLB entries to be 4K, and removes
+the possibility of multiple hits.
+
+In order to mitigate the vulnerability, KVM initially marks all huge pages
+as non-executable. If the guest attempts to execute in one of those pages,
+the page is broken down into 4K pages, which are then marked executable.
+
+If EPT is disabled or not available on the host, KVM is in control of TLB
+flushes and the problematic situation cannot happen.  However, the shadow
+EPT paging mechanism used by nested virtualization is vulnerable, because
+the nested guest can trigger multiple iTLB hits by modifying its own
+(non-nested) page tables.  For simplicity, KVM will make large pages
+non-executable in all shadow paging modes.
+
+Mitigation control on the kernel command line and KVM - module parameter
+------------------------------------------------------------------------
+
+The KVM hypervisor mitigation mechanism for marking huge pages as
+non-executable can be controlled with a module parameter "nx_huge_pages=".
+The kernel command line allows to control the iTLB multihit mitigations at
+boot time with the option "kvm.nx_huge_pages=".
+
+The valid arguments for these options are:
+
+  ==========  ================================================================
+  force       Mitigation is enabled. In this case, the mitigation implements
+              non-executable huge pages in Linux kernel KVM module. All huge
+              pages in the EPT are marked as non-executable.
+              If a guest attempts to execute in one of those pages, the page is
+              broken down into 4K pages, which are then marked executable.
+
+  off	      Mitigation is disabled.
+
+  auto        Enable mitigation only if the platform is affected and the kernel
+              was not booted with the "mitigations=off" command line parameter.
+	      This is the default option.
+  ==========  ================================================================
+
+
+Mitigation selection guide
+--------------------------
+
+1. No virtualization in use
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   The system is protected by the kernel unconditionally and no further
+   action is required.
+
+2. Virtualization with trusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   If the guest comes from a trusted source, you may assume that the guest will
+   not attempt to maliciously exploit these errata and no further action is
+   required.
+
+3. Virtualization with untrusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+   If the guest comes from an untrusted source, the guest host kernel will need
+   to apply iTLB multihit mitigation via the kernel command line or kvm
+   module parameter.


