Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B4F1F44D5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgFISIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:08:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41430 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388173AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p0-KM; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-006Vxl-C7; Tue, 09 Jun 2020 19:05:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Gross" <mgross@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>, "Borislav Petkov" <bp@suse.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
Date:   Tue, 09 Jun 2020 19:04:49 +0100
Message-ID: <lsq.1591725832.534120483@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 58/61] x86/speculation: Add SRBDS vulnerability and
 mitigation documentation
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Gross <mgross@linux.intel.com>

commit 7222a1b5b87417f22265c92deea76a6aecd0fb0f upstream.

Add documentation for the SRBDS vulnerability and its mitigation.

 [ bp: Massage.
   jpoimboe: sysfs table strings. ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 .../special-register-buffer-data-sampling.rst | 148 ++++++++++++++++++
 1 file changed, 148 insertions(+)
 create mode 100644 Documentation/hw-vuln/special-register-buffer-data-sampling.rst

--- /dev/null
+++ b/Documentation/hw-vuln/special-register-buffer-data-sampling.rst
@@ -0,0 +1,148 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+SRBDS - Special Register Buffer Data Sampling
+=============================================
+
+SRBDS is a hardware vulnerability that allows MDS :doc:`mds` techniques to
+infer values returned from special register accesses.  Special register
+accesses are accesses to off core registers.  According to Intel's evaluation,
+the special register reads that have a security expectation of privacy are
+RDRAND, RDSEED and SGX EGETKEY.
+
+When RDRAND, RDSEED and EGETKEY instructions are used, the data is moved
+to the core through the special register mechanism that is susceptible
+to MDS attacks.
+
+Affected processors
+--------------------
+Core models (desktop, mobile, Xeon-E3) that implement RDRAND and/or RDSEED may
+be affected.
+
+A processor is affected by SRBDS if its Family_Model and stepping is
+in the following list, with the exception of the listed processors
+exporting MDS_NO while Intel TSX is available yet not enabled. The
+latter class of processors are only affected when Intel TSX is enabled
+by software using TSX_CTRL_MSR otherwise they are not affected.
+
+  =============  ============  ========
+  common name    Family_Model  Stepping
+  =============  ============  ========
+  Haswell        06_3CH        All
+  Haswell_L      06_45H        All
+  Haswell_G      06_46H        All
+
+  Broadwell_G    06_47H        All
+  Broadwell      06_3DH        All
+
+  Skylake_L      06_4EH        All
+  Skylake        06_5EH        All
+
+  Kabylake_L     06_8EH        <=0xC
+
+  Kabylake       06_9EH        <=0xD
+  =============  ============  ========
+
+Related CVEs
+------------
+
+The following CVE entry is related to this SRBDS issue:
+
+    ==============  =====  =====================================
+    CVE-2020-0543   SRBDS  Special Register Buffer Data Sampling
+    ==============  =====  =====================================
+
+Attack scenarios
+----------------
+An unprivileged user can extract values returned from RDRAND and RDSEED
+executed on another core or sibling thread using MDS techniques.
+
+
+Mitigation mechanism
+-------------------
+Intel will release microcode updates that modify the RDRAND, RDSEED, and
+EGETKEY instructions to overwrite secret special register data in the shared
+staging buffer before the secret data can be accessed by another logical
+processor.
+
+During execution of the RDRAND, RDSEED, or EGETKEY instructions, off-core
+accesses from other logical processors will be delayed until the special
+register read is complete and the secret data in the shared staging buffer is
+overwritten.
+
+This has three effects on performance:
+
+#. RDRAND, RDSEED, or EGETKEY instructions have higher latency.
+
+#. Executing RDRAND at the same time on multiple logical processors will be
+   serialized, resulting in an overall reduction in the maximum RDRAND
+   bandwidth.
+
+#. Executing RDRAND, RDSEED or EGETKEY will delay memory accesses from other
+   logical processors that miss their core caches, with an impact similar to
+   legacy locked cache-line-split accesses.
+
+The microcode updates provide an opt-out mechanism (RNGDS_MITG_DIS) to disable
+the mitigation for RDRAND and RDSEED instructions executed outside of Intel
+Software Guard Extensions (Intel SGX) enclaves. On logical processors that
+disable the mitigation using this opt-out mechanism, RDRAND and RDSEED do not
+take longer to execute and do not impact performance of sibling logical
+processors memory accesses. The opt-out mechanism does not affect Intel SGX
+enclaves (including execution of RDRAND or RDSEED inside an enclave, as well
+as EGETKEY execution).
+
+IA32_MCU_OPT_CTRL MSR Definition
+--------------------------------
+Along with the mitigation for this issue, Intel added a new thread-scope
+IA32_MCU_OPT_CTRL MSR, (address 0x123). The presence of this MSR and
+RNGDS_MITG_DIS (bit 0) is enumerated by CPUID.(EAX=07H,ECX=0).EDX[SRBDS_CTRL =
+9]==1. This MSR is introduced through the microcode update.
+
+Setting IA32_MCU_OPT_CTRL[0] (RNGDS_MITG_DIS) to 1 for a logical processor
+disables the mitigation for RDRAND and RDSEED executed outside of an Intel SGX
+enclave on that logical processor. Opting out of the mitigation for a
+particular logical processor does not affect the RDRAND and RDSEED mitigations
+for other logical processors.
+
+Note that inside of an Intel SGX enclave, the mitigation is applied regardless
+of the value of RNGDS_MITG_DS.
+
+Mitigation control on the kernel command line
+---------------------------------------------
+The kernel command line allows control over the SRBDS mitigation at boot time
+with the option "srbds=".  The option for this is:
+
+  ============= =============================================================
+  off           This option disables SRBDS mitigation for RDRAND and RDSEED on
+                affected platforms.
+  ============= =============================================================
+
+SRBDS System Information
+-----------------------
+The Linux kernel provides vulnerability status information through sysfs.  For
+SRBDS this can be accessed by the following sysfs file:
+/sys/devices/system/cpu/vulnerabilities/srbds
+
+The possible values contained in this file are:
+
+ ============================== =============================================
+ Not affected                   Processor not vulnerable
+ Vulnerable                     Processor vulnerable and mitigation disabled
+ Vulnerable: No microcode       Processor vulnerable and microcode is missing
+                                mitigation
+ Mitigation: Microcode          Processor is vulnerable and mitigation is in
+                                effect.
+ Mitigation: TSX disabled       Processor is only vulnerable when TSX is
+                                enabled while this system was booted with TSX
+                                disabled.
+ Unknown: Dependent on
+ hypervisor status              Running on virtual guest processor that is
+                                affected but with no way to know if host
+                                processor is mitigated or vulnerable.
+ ============================== =============================================
+
+SRBDS Default mitigation
+------------------------
+This new microcode serializes processor access during execution of RDRAND,
+RDSEED ensures that the shared buffer is overwritten before it is released for
+reuse.  Use the "srbds=off" kernel command line to disable the mitigation for
+RDRAND and RDSEED.

