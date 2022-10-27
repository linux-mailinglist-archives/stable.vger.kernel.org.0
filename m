Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B282610384
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 22:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbiJ0U4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 16:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiJ0U4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 16:56:05 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7068AAA371;
        Thu, 27 Oct 2022 13:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666903692; x=1698439692;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=HuLIveWIy4LWjQN948FP1SQTsicVwWdw9U0yxS8CL+k=;
  b=HC+uDrFJjSUCaBiiExFnv1+2xCseGr58XBUAJgPujgZN7+9j2jv3bL1i
   YL8tpPz9EE7UtheyNS/LtAsvVfHODMtUCZQYNgOO5uSXvnxlZs2n7wxb/
   20O+AzaODl6bOyPpTrdl6X8tmcGB/fh8jMvExqh6Fzl3LQsQwTY3MD3sv
   w=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="145136195"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:48:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id B077C803FC;
        Thu, 27 Oct 2022 20:48:10 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:48:10 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:48:10 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 00/34] Retbleed & PBRSB Mitigations
Date:   Thu, 27 Oct 2022 13:48:01 -0700
Message-ID: <20221027204801.13146-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backport adds support for Retbleed and PBRSB mitigations for Intel parts.

Some AMD parts are added to simplify context however support for IBPB or UNRET
is not included in this series. The reporting of whether a cpu is affected
should be correct however.

Most patches applied cleanly or required only context changes, the major
difference between this series and upstream is the fact that the kvm entry
path is in inline asm in the 4.14 tree and so this had to be accommodated
in patches:
 - x86/speculation: Fill RSB on vmexit for IBRS
 - x86/speculation: Add RSB VM Exit protections

This series is unsurprisingly very similar to that for the 5.4 backport [1].

Boot tested on a variety of Intel and AMD systems.

Tested correct reporting of vulnerabilities and mitigation selection on Skylake,
Cascade Lake, Ice Lake and Zen3 parts.

[1] https://lore.kernel.org/stable/20221003131038.12645-1-cascardo@canonical.com/

Alexandre Chartre (2):
  x86/bugs: Report AMD retbleed vulnerability
  x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
  x86/cpu/amd: Enumerate BTC_NO

Daniel Sneddon (1):
  x86/speculation: Add RSB VM Exit protections

Ingo Molnar (1):
  x86/cpufeature: Fix various quality problems in the
    <asm/cpu_device_hd.h> header

Josh Poimboeuf (8):
  x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
  x86/speculation: Fix firmware entry SPEC_CTRL handling
  x86/speculation: Fix SPEC_CTRL write on SMT state change
  x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
  x86/speculation: Remove x86_spec_ctrl_mask
  KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
  KVM: VMX: Fix IBRS handling after vmexit
  x86/speculation: Fill RSB on vmexit for IBRS

Kan Liang (1):
  x86/cpufeature: Add facility to check for min microcode revisions

Mark Gross (1):
  x86/cpu: Add a steppings field to struct x86_cpu_id

Nathan Chancellor (1):
  x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Pawan Gupta (5):
  x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
  x86/speculation: Add LFENCE to RSB fill sequence
  x86/bugs: Add Cannon lake to RETBleed affected CPU list
  x86/speculation: Disable RRSBA behavior
  x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS
    parts

Peter Zijlstra (9):
  x86/entry: Remove skip_r11rcx
  x86/cpufeatures: Move RETPOLINE flags to word 11
  x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
  x86/bugs: Optimize SPEC_CTRL MSR writes
  x86/bugs: Split spectre_v2_select_mitigation() and
    spectre_v2_user_select_mitigation()
  x86/bugs: Report Intel retbleed vulnerability
  entel_idle: Disable IBRS during long idle
  x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
  x86/common: Stamp out the stepping madness

Suraj Jitindar Singh (1):
  Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"

Thadeu Lima de Souza Cascardo (1):
  x86/entry: Add kernel IBRS implementation

Thomas Gleixner (2):
  x86/devicetable: Move x86 specific macro out of generic code
  x86/cpu: Add consistent CPU match macros

 Documentation/admin-guide/hw-vuln/spectre.rst |   8 +
 .../admin-guide/kernel-parameters.txt         |  13 +
 arch/x86/entry/calling.h                      |  68 ++-
 arch/x86/entry/entry_32.S                     |   2 -
 arch/x86/entry/entry_64.S                     |  38 +-
 arch/x86/entry/entry_64_compat.S              |  12 +-
 arch/x86/include/asm/cpu_device_id.h          | 168 ++++++-
 arch/x86/include/asm/cpufeatures.h            |  16 +-
 arch/x86/include/asm/intel-family.h           |   6 +
 arch/x86/include/asm/msr-index.h              |  14 +
 arch/x86/include/asm/nospec-branch.h          |  48 +-
 arch/x86/kernel/cpu/amd.c                     |  21 +-
 arch/x86/kernel/cpu/bugs.c                    | 415 +++++++++++++++---
 arch/x86/kernel/cpu/common.c                  |  68 ++-
 arch/x86/kernel/cpu/match.c                   |  44 +-
 arch/x86/kernel/cpu/scattered.c               |   1 +
 arch/x86/kernel/process.c                     |   2 +-
 arch/x86/kvm/svm.c                            |   1 +
 arch/x86/kvm/vmx.c                            |  51 ++-
 drivers/base/cpu.c                            |   8 +
 drivers/cpufreq/acpi-cpufreq.c                |   1 +
 drivers/cpufreq/amd_freq_sensitivity.c        |   1 +
 drivers/idle/intel_idle.c                     |  45 +-
 include/linux/cpu.h                           |   2 +
 include/linux/mod_devicetable.h               |   4 +-
 tools/arch/x86/include/asm/cpufeatures.h      |   1 +
 26 files changed, 897 insertions(+), 161 deletions(-)

-- 
2.17.1

