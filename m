Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE75F30B3
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJCNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJCNK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:10:59 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA7F2B604;
        Mon,  3 Oct 2022 06:10:56 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8569742EBB;
        Mon,  3 Oct 2022 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802654;
        bh=pZq2v/Fr9QFxLOTWEDq1WB4VU4sCkAuj/nGLJx+itTg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=XTpg/94iEmrq43Sntjf0xz2rx0LLEmosm4ljk9d6J9G1o0vPGrqTsO8B30MDnTmyL
         iEoJrSYiy9UdjYQohZWyKgGdNqRXNe8Fn2pKhMdyr/HbY9UoZPJBtD32EEDXeGH8/Y
         CG85pJAXtrl61BV8Qf52Qg5sFQpHC+jYuJHzuLRecTv1N+Ynj4cFINCRORlgm2QVWE
         cPsSj0cM76IzcnE/RMC/c1lZy6DkIXwkt9DoNixpTpZUuUYYB30aPW4BFV9Loxjonl
         IibReHs2leKzsvued1HqMhMA7dBb1LCSE8V19itBndQH8Ojc192DCPV6rXSG28ccmL
         DMOL1ticS5www==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 00/37] IBRS support // Retbleed mitigations
Date:   Mon,  3 Oct 2022 10:10:01 -0300
Message-Id: <20221003131038.12645-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backport introduces IBRS support to 5.4.y in order to mitigate Retbleed on
Intel parts. Though some very small pieces for AMD have been picked up as well,
"UNRET" mitigations are not backported, nor IBPB. It is expected, though, that
the backport will report AMD systems as vulnerable or not affected, depending
on the parts and the BTC_NO bit.

One note here is that the PBRSB mitigation was backported previously to the 5.4
series, and this would have made things a little bit more complicated. So, I
reverted it and applied it later on.

This has been boot-tested and smoke-tested on a bunch of AMD and Intel systems.

Alexandre Chartre (2):
  x86/bugs: Report AMD retbleed vulnerability
  x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
  x86/cpu/amd: Enumerate BTC_NO

Daniel Sneddon (1):
  x86/speculation: Add RSB VM Exit protections

Josh Poimboeuf (9):
  x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
  x86/speculation: Fix firmware entry SPEC_CTRL handling
  x86/speculation: Fix SPEC_CTRL write on SMT state change
  x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
  x86/speculation: Remove x86_spec_ctrl_mask
  KVM: VMX: Flatten __vmx_vcpu_run()
  KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
  KVM: VMX: Fix IBRS handling after vmexit
  x86/speculation: Fill RSB on vmexit for IBRS

Mark Gross (1):
  x86/cpu: Add a steppings field to struct x86_cpu_id

Nathan Chancellor (1):
  x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Pawan Gupta (4):
  x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
  x86/bugs: Add Cannon lake to RETBleed affected CPU list
  x86/speculation: Disable RRSBA behavior
  x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS
    parts

Peter Zijlstra (11):
  x86/kvm/vmx: Make noinstr clean
  x86/cpufeatures: Move RETPOLINE flags to word 11
  x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
  x86/entry: Remove skip_r11rcx
  x86/entry: Add kernel IBRS implementation
  x86/bugs: Optimize SPEC_CTRL MSR writes
  x86/bugs: Split spectre_v2_select_mitigation() and
    spectre_v2_user_select_mitigation()
  x86/bugs: Report Intel retbleed vulnerability
  intel_idle: Disable IBRS during long idle
  x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
  x86/common: Stamp out the stepping madness

Thadeu Lima de Souza Cascardo (3):
  Revert "x86/speculation: Add RSB VM Exit protections"
  Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
  KVM: VMX: Convert launched argument to flags

Thomas Gleixner (2):
  x86/devicetable: Move x86 specific macro out of generic code
  x86/cpu: Add consistent CPU match macros

Uros Bizjak (2):
  KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S
  KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw

 .../admin-guide/kernel-parameters.txt         |  13 +
 arch/x86/entry/calling.h                      |  68 +++-
 arch/x86/entry/entry_32.S                     |   2 -
 arch/x86/entry/entry_64.S                     |  34 +-
 arch/x86/entry/entry_64_compat.S              |  11 +-
 arch/x86/include/asm/cpu_device_id.h          | 132 ++++++-
 arch/x86/include/asm/cpufeatures.h            |  13 +-
 arch/x86/include/asm/intel-family.h           |   6 +
 arch/x86/include/asm/msr-index.h              |  10 +
 arch/x86/include/asm/nospec-branch.h          |  54 +--
 arch/x86/kernel/cpu/amd.c                     |  21 +-
 arch/x86/kernel/cpu/bugs.c                    | 365 ++++++++++++++----
 arch/x86/kernel/cpu/common.c                  |  61 +--
 arch/x86/kernel/cpu/match.c                   |  13 +-
 arch/x86/kernel/cpu/scattered.c               |   1 +
 arch/x86/kernel/process.c                     |   2 +-
 arch/x86/kvm/svm.c                            |   1 +
 arch/x86/kvm/vmx/nested.c                     |  32 +-
 arch/x86/kvm/vmx/run_flags.h                  |   8 +
 arch/x86/kvm/vmx/vmenter.S                    | 161 ++++----
 arch/x86/kvm/vmx/vmx.c                        |  72 ++--
 arch/x86/kvm/vmx/vmx.h                        |   5 +
 arch/x86/kvm/x86.c                            |   4 +-
 drivers/base/cpu.c                            |   8 +
 drivers/cpufreq/acpi-cpufreq.c                |   1 +
 drivers/cpufreq/amd_freq_sensitivity.c        |   1 +
 drivers/idle/intel_idle.c                     |  43 ++-
 include/linux/cpu.h                           |   2 +
 include/linux/kvm_host.h                      |   2 +-
 include/linux/mod_devicetable.h               |   4 +-
 tools/arch/x86/include/asm/cpufeatures.h      |   2 +-
 31 files changed, 840 insertions(+), 312 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/run_flags.h

-- 
2.34.1

