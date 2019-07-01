Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D397F1F26D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfEOLMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfEOLMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757FA20862;
        Wed, 15 May 2019 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918726;
        bh=Uc1iyKVGm5/JJ14rY9Xpfh/2EEQzLtdUjcA3gnTTXPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9Pom+TQ6SVSdOWzwJKvNRwSEmVSZtdFsoZpABgK0hM+/GHfkxVJfWCr7t/+jnORR
         SAPbIspjbTGfN/A3xRut8aAWoZD4GKEZg2AFaZizG160/85U7BglGT5KOmI/Zzpq6u
         SQlAWOugaW3iVD+Bi8NkBKrSBDFeKzg+GwQmQipk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 241/266] Documentation: Add MDS vulnerability documentation
Date:   Wed, 15 May 2019 12:55:48 +0200
Message-Id: <20190515090731.157143722@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 5999bbe7a6ea3c62029532ec84dc06003a1fa258 upstream.

Add the initial MDS vulnerability documentation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4:
 - Drop the index updates
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/mds.rst       |  307 ++++++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    2 
 2 files changed, 309 insertions(+)
 create mode 100644 Documentation/hw-vuln/mds.rst

--- /dev/null
+++ b/Documentation/hw-vuln/mds.rst
@@ -0,0 +1,307 @@
+MDS - Microarchitectural Data Sampling
+======================================
+
+Microarchitectural Data Sampling is a hardware vulnerability which allows
+unprivileged speculative access to data which is available in various CPU
+internal buffers.
+
+Affected processors
+-------------------
+
+This vulnerability affects a wide range of Intel processors. The
+vulnerability is not present on:
+
+   - Processors from AMD, Centaur and other non Intel vendors
+
+   - Older processor models, where the CPU family is < 6
+
+   - Some Atoms (Bonnell, Saltwell, Goldmont, GoldmontPlus)
+
+   - Intel processors which have the ARCH_CAP_MDS_NO bit set in the
+     IA32_ARCH_CAPABILITIES MSR.
+
+Whether a processor is affected or not can be read out from the MDS
+vulnerability file in sysfs. See :ref:`mds_sys_info`.
+
+Not all processors are affected by all variants of MDS, but the mitigation
+is identical for all of them so the kernel treats them as a single
+vulnerability.
+
+Related CVEs
+------------
+
+The following CVE entries are related to the MDS vulnerability:
+
+   ==============  =====  ==============================================
+   CVE-2018-12126  MSBDS  Microarchitectural Store Buffer Data Sampling
+   CVE-2018-12130  MFBDS  Microarchitectural Fill Buffer Data Sampling
+   CVE-2018-12127  MLPDS  Microarchitectural Load Port Data Sampling
+   ==============  =====  ==============================================
+
+Problem
+-------
+
+When performing store, load, L1 refill operations, processors write data
+into temporary microarchitectural structures (buffers). The data in the
+buffer can be forwarded to load operations as an optimization.
+
+Under certain conditions, usually a fault/assist caused by a load
+operation, data unrelated to the load memory address can be speculatively
+forwarded from the buffers. Because the load operation causes a fault or
+assist and its result will be discarded, the forwarded data will not cause
+incorrect program execution or state changes. But a malicious operation
+may be able to forward this speculative data to a disclosure gadget which
+allows in turn to infer the value via a cache side channel attack.
+
+Because the buffers are potentially shared between Hyper-Threads cross
+Hyper-Thread attacks are possible.
+
+Deeper technical information is available in the MDS specific x86
+architecture section: :ref:`Documentation/x86/mds.rst <mds>`.
+
+
+Attack scenarios
+----------------
+
+Attacks against the MDS vulnerabilities can be mounted from malicious non
+priviledged user space applications running on hosts or guest. Malicious
+guest OSes can obviously mount attacks as well.
+
+Contrary to other speculation based vulnerabilities the MDS vulnerability
+does not allow the attacker to control the memory target address. As a
+consequence the attacks are purely sampling based, but as demonstrated with
+the TLBleed attack samples can be postprocessed successfully.
+
+Web-Browsers
+^^^^^^^^^^^^
+
+  It's unclear whether attacks through Web-Browsers are possible at
+  all. The exploitation through Java-Script is considered very unlikely,
+  but other widely used web technologies like Webassembly could possibly be
+  abused.
+
+
+.. _mds_sys_info:
+
+MDS system information
+-----------------------
+
+The Linux kernel provides a sysfs interface to enumerate the current MDS
+status of the system: whether the system is vulnerable, and which
+mitigations are active. The relevant sysfs file is:
+
+/sys/devices/system/cpu/vulnerabilities/mds
+
+The possible values in this file are:
+
+  =========================================   =================================
+  'Not affected'				The processor is not vulnerable
+
+  'Vulnerable'					The processor is vulnerable,
+						but no mitigation enabled
+
+  'Vulnerable: Clear CPU buffers attempted'	The processor is vulnerable but
+						microcode is not updated.
+						The mitigation is enabled on a
+						best effort basis.
+						See :ref:`vmwerv`
+
+  'Mitigation: CPU buffer clear'		The processor is vulnerable and the
+						CPU buffer clearing mitigation is
+						enabled.
+  =========================================   =================================
+
+If the processor is vulnerable then the following information is appended
+to the above information:
+
+    ========================  ============================================
+    'SMT vulnerable'          SMT is enabled
+    'SMT mitigated'           SMT is enabled and mitigated
+    'SMT disabled'            SMT is disabled
+    'SMT Host state unknown'  Kernel runs in a VM, Host SMT state unknown
+    ========================  ============================================
+
+.. _vmwerv:
+
+Best effort mitigation mode
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  If the processor is vulnerable, but the availability of the microcode based
+  mitigation mechanism is not advertised via CPUID the kernel selects a best
+  effort mitigation mode.  This mode invokes the mitigation instructions
+  without a guarantee that they clear the CPU buffers.
+
+  This is done to address virtualization scenarios where the host has the
+  microcode update applied, but the hypervisor is not yet updated to expose
+  the CPUID to the guest. If the host has updated microcode the protection
+  takes effect otherwise a few cpu cycles are wasted pointlessly.
+
+  The state in the mds sysfs file reflects this situation accordingly.
+
+
+Mitigation mechanism
+-------------------------
+
+The kernel detects the affected CPUs and the presence of the microcode
+which is required.
+
+If a CPU is affected and the microcode is available, then the kernel
+enables the mitigation by default. The mitigation can be controlled at boot
+time via a kernel command line option. See
+:ref:`mds_mitigation_control_command_line`.
+
+.. _cpu_buffer_clear:
+
+CPU buffer clearing
+^^^^^^^^^^^^^^^^^^^
+
+  The mitigation for MDS clears the affected CPU buffers on return to user
+  space and when entering a guest.
+
+  If SMT is enabled it also clears the buffers on idle entry when the CPU
+  is only affected by MSBDS and not any other MDS variant, because the
+  other variants cannot be protected against cross Hyper-Thread attacks.
+
+  For CPUs which are only affected by MSBDS the user space, guest and idle
+  transition mitigations are sufficient and SMT is not affected.
+
+.. _virt_mechanism:
+
+Virtualization mitigation
+^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  The protection for host to guest transition depends on the L1TF
+  vulnerability of the CPU:
+
+  - CPU is affected by L1TF:
+
+    If the L1D flush mitigation is enabled and up to date microcode is
+    available, the L1D flush mitigation is automatically protecting the
+    guest transition.
+
+    If the L1D flush mitigation is disabled then the MDS mitigation is
+    invoked explicit when the host MDS mitigation is enabled.
+
+    For details on L1TF and virtualization see:
+    :ref:`Documentation/hw-vuln//l1tf.rst <mitigation_control_kvm>`.
+
+  - CPU is not affected by L1TF:
+
+    CPU buffers are flushed before entering the guest when the host MDS
+    mitigation is enabled.
+
+  The resulting MDS protection matrix for the host to guest transition:
+
+  ============ ===== ============= ============ =================
+   L1TF         MDS   VMX-L1FLUSH   Host MDS     MDS-State
+
+   Don't care   No    Don't care    N/A          Not affected
+
+   Yes          Yes   Disabled      Off          Vulnerable
+
+   Yes          Yes   Disabled      Full         Mitigated
+
+   Yes          Yes   Enabled       Don't care   Mitigated
+
+   No           Yes   N/A           Off          Vulnerable
+
+   No           Yes   N/A           Full         Mitigated
+  ============ ===== ============= ============ =================
+
+  This only covers the host to guest transition, i.e. prevents leakage from
+  host to guest, but does not protect the guest internally. Guests need to
+  have their own protections.
+
+.. _xeon_phi:
+
+XEON PHI specific considerations
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  The XEON PHI processor family is affected by MSBDS which can be exploited
+  cross Hyper-Threads when entering idle states. Some XEON PHI variants allow
+  to use MWAIT in user space (Ring 3) which opens an potential attack vector
+  for malicious user space. The exposure can be disabled on the kernel
+  command line with the 'ring3mwait=disable' command line option.
+
+  XEON PHI is not affected by the other MDS variants and MSBDS is mitigated
+  before the CPU enters a idle state. As XEON PHI is not affected by L1TF
+  either disabling SMT is not required for full protection.
+
+.. _mds_smt_control:
+
+SMT control
+^^^^^^^^^^^
+
+  All MDS variants except MSBDS can be attacked cross Hyper-Threads. That
+  means on CPUs which are affected by MFBDS or MLPDS it is necessary to
+  disable SMT for full protection. These are most of the affected CPUs; the
+  exception is XEON PHI, see :ref:`xeon_phi`.
+
+  Disabling SMT can have a significant performance impact, but the impact
+  depends on the type of workloads.
+
+  See the relevant chapter in the L1TF mitigation documentation for details:
+  :ref:`Documentation/hw-vuln/l1tf.rst <smt_control>`.
+
+
+.. _mds_mitigation_control_command_line:
+
+Mitigation control on the kernel command line
+---------------------------------------------
+
+The kernel command line allows to control the MDS mitigations at boot
+time with the option "mds=". The valid arguments for this option are:
+
+  ============  =============================================================
+  full		If the CPU is vulnerable, enable all available mitigations
+		for the MDS vulnerability, CPU buffer clearing on exit to
+		userspace and when entering a VM. Idle transitions are
+		protected as well if SMT is enabled.
+
+		It does not automatically disable SMT.
+
+  off		Disables MDS mitigations completely.
+
+  ============  =============================================================
+
+Not specifying this option is equivalent to "mds=full".
+
+
+Mitigation selection guide
+--------------------------
+
+1. Trusted userspace
+^^^^^^^^^^^^^^^^^^^^
+
+   If all userspace applications are from a trusted source and do not
+   execute untrusted code which is supplied externally, then the mitigation
+   can be disabled.
+
+
+2. Virtualization with trusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   The same considerations as above versus trusted user space apply.
+
+3. Virtualization with untrusted guests
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+   The protection depends on the state of the L1TF mitigations.
+   See :ref:`virt_mechanism`.
+
+   If the MDS mitigation is enabled and SMT is disabled, guest to host and
+   guest to guest attacks are prevented.
+
+.. _mds_default_mitigations:
+
+Default mitigations
+-------------------
+
+  The kernel default mitigations for vulnerable processors are:
+
+  - Enable CPU buffer clearing
+
+  The kernel does not by default enforce the disabling of SMT, which leaves
+  SMT systems vulnerable when running untrusted code. The same rationale as
+  for L1TF applies.
+  See :ref:`Documentation/hw-vuln//l1tf.rst <default_mitigations>`.
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2057,6 +2057,8 @@ bytes respectively. Such letter suffixes
 			Not specifying this option is equivalent to
 			mds=full.
 
+			For details see: Documentation/hw-vuln/mds.rst
+
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.


