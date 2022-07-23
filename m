Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64757EEEF
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiGWLOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 07:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiGWLOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 07:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EC92A40E;
        Sat, 23 Jul 2022 04:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A5CD611D5;
        Sat, 23 Jul 2022 11:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E01AC341C0;
        Sat, 23 Jul 2022 11:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658574852;
        bh=aCuZ0M+4YE8MKjBvTC0gvsyOg8TY7R5BmGA6TqYNNbY=;
        h=From:To:Cc:Subject:Date:From;
        b=PHI5NcbLMc0Eg3ognzkYaXlblpq3MYs4Ko+y9xpGYhIh0SCCaO+Uri/t4Z6DrR2+f
         3/hMl0wjAM0TFJR1GtYm3P7SOUy3KzGIQltz2gkUW9HXp1GnMnUWPrji5I6E1Sxigu
         75TRharK/IJrNYSQZM/nP9WK2YSNEDdKzQgr5HIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.57
Date:   Sat, 23 Jul 2022 13:14:08 +0200
Message-Id: <1658574849159138@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.57 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |   25 
 Makefile                                        |    9 
 arch/um/kernel/um_arch.c                        |    8 
 arch/x86/Kconfig                                |  103 ++-
 arch/x86/Makefile                               |    2 
 arch/x86/entry/Makefile                         |    2 
 arch/x86/entry/calling.h                        |   72 ++
 arch/x86/entry/entry.S                          |   22 
 arch/x86/entry/entry_32.S                       |    2 
 arch/x86/entry/entry_64.S                       |   88 ++-
 arch/x86/entry/entry_64_compat.S                |   21 
 arch/x86/entry/vdso/Makefile                    |    1 
 arch/x86/entry/vsyscall/vsyscall_emu_64.S       |    9 
 arch/x86/include/asm/GEN-for-each-reg.h         |   14 
 arch/x86/include/asm/alternative.h              |    2 
 arch/x86/include/asm/asm-prototypes.h           |   18 
 arch/x86/include/asm/cpufeatures.h              |   12 
 arch/x86/include/asm/disabled-features.h        |   21 
 arch/x86/include/asm/linkage.h                  |    8 
 arch/x86/include/asm/msr-index.h                |   13 
 arch/x86/include/asm/nospec-branch.h            |  134 ++--
 arch/x86/include/asm/static_call.h              |   17 
 arch/x86/include/asm/traps.h                    |    2 
 arch/x86/include/asm/unwind_hints.h             |   14 
 arch/x86/kernel/alternative.c                   |  260 ++++++++
 arch/x86/kernel/cpu/amd.c                       |   46 +
 arch/x86/kernel/cpu/bugs.c                      |  475 +++++++++++++---
 arch/x86/kernel/cpu/common.c                    |   61 +-
 arch/x86/kernel/cpu/cpu.h                       |    2 
 arch/x86/kernel/cpu/hygon.c                     |    6 
 arch/x86/kernel/cpu/scattered.c                 |    1 
 arch/x86/kernel/ftrace.c                        |    7 
 arch/x86/kernel/head_32.S                       |    1 
 arch/x86/kernel/head_64.S                       |    5 
 arch/x86/kernel/module.c                        |   15 
 arch/x86/kernel/process.c                       |    2 
 arch/x86/kernel/relocate_kernel_32.S            |   25 
 arch/x86/kernel/relocate_kernel_64.S            |   23 
 arch/x86/kernel/static_call.c                   |   49 +
 arch/x86/kernel/traps.c                         |   19 
 arch/x86/kernel/vmlinux.lds.S                   |   23 
 arch/x86/kvm/emulate.c                          |   33 -
 arch/x86/kvm/svm/vmenter.S                      |   18 
 arch/x86/kvm/vmx/nested.c                       |    2 
 arch/x86/kvm/vmx/run_flags.h                    |    8 
 arch/x86/kvm/vmx/vmenter.S                      |  164 ++---
 arch/x86/kvm/vmx/vmx.c                          |   76 +-
 arch/x86/kvm/vmx/vmx.h                          |    6 
 arch/x86/kvm/x86.c                              |    4 
 arch/x86/lib/memmove_64.S                       |    7 
 arch/x86/lib/retpoline.S                        |  133 ++--
 arch/x86/mm/mem_encrypt_boot.S                  |   10 
 arch/x86/net/bpf_jit_comp.c                     |  179 ++----
 arch/x86/net/bpf_jit_comp32.c                   |   22 
 arch/x86/platform/efi/efi_thunk_64.S            |    5 
 arch/x86/xen/setup.c                            |    6 
 arch/x86/xen/xen-asm.S                          |   30 -
 arch/x86/xen/xen-head.S                         |    5 
 arch/x86/xen/xen-ops.h                          |    6 
 drivers/base/cpu.c                              |    8 
 drivers/idle/intel_idle.c                       |   43 +
 include/linux/cpu.h                             |    2 
 include/linux/kvm_host.h                        |    2 
 include/linux/objtool.h                         |    9 
 scripts/Makefile.build                          |    1 
 scripts/link-vmlinux.sh                         |    3 
 security/Kconfig                                |   11 
 tools/arch/x86/include/asm/cpufeatures.h        |   12 
 tools/arch/x86/include/asm/disabled-features.h  |   21 
 tools/arch/x86/include/asm/msr-index.h          |   13 
 tools/include/linux/objtool.h                   |    9 
 tools/objtool/arch/x86/decode.c                 |  145 ----
 tools/objtool/builtin-check.c                   |    4 
 tools/objtool/check.c                           |  701 ++++++++++++++++++++----
 tools/objtool/elf.c                             |   84 --
 tools/objtool/include/objtool/arch.h            |    3 
 tools/objtool/include/objtool/builtin.h         |    2 
 tools/objtool/include/objtool/cfi.h             |    2 
 tools/objtool/include/objtool/check.h           |   10 
 tools/objtool/include/objtool/elf.h             |    9 
 tools/objtool/include/objtool/objtool.h         |    1 
 tools/objtool/objtool.c                         |    1 
 tools/objtool/orc_gen.c                         |   15 
 tools/objtool/special.c                         |    8 
 84 files changed, 2519 insertions(+), 953 deletions(-)

Alexandre Chartre (2):
      x86/bugs: Report AMD retbleed vulnerability
      x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
      x86/cpu/amd: Enumerate BTC_NO

Arnaldo Carvalho de Melo (2):
      tools arch x86: Sync the msr-index.h copy with the kernel sources
      tools headers cpufeatures: Sync with the kernel sources

Ben Hutchings (1):
      x86/xen: Fix initialisation in hypercall_page after rethunk

Greg Kroah-Hartman (1):
      Linux 5.15.57

Jiri Slaby (1):
      x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit

Josh Poimboeuf (12):
      x86/bugs: Do IBPB fallback check only once
      x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
      x86/speculation: Fix firmware entry SPEC_CTRL handling
      x86/speculation: Fix SPEC_CTRL write on SMT state change
      x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
      x86/speculation: Remove x86_spec_ctrl_mask
      objtool: Re-add UNWIND_HINT_{SAVE_RESTORE}
      KVM: VMX: Flatten __vmx_vcpu_run()
      KVM: VMX: Convert launched argument to flags
      KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
      KVM: VMX: Fix IBRS handling after vmexit
      x86/speculation: Fill RSB on vmexit for IBRS

Kim Phillips (3):
      x86/sev: Avoid using __x86_return_thunk
      x86/bugs: Enable STIBP for JMP2RET
      x86/bugs: Remove apostrophe typo

Konrad Rzeszutek Wilk (1):
      x86/kexec: Disable RET on kexec

Lai Jiangshan (4):
      x86/traps: Use pt_regs directly in fixup_bad_iret()
      x86/entry: Switch the stack after error_entry() returns
      x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()
      x86/entry: Don't call error_entry() for XENPV

Nathan Chancellor (1):
      x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Paolo Bonzini (1):
      KVM: emulate: do not adjust size of fastop and setcc subroutines

Pawan Gupta (3):
      x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
      x86/bugs: Add Cannon lake to RETBleed affected CPU list
      x86/speculation: Disable RRSBA behavior

Peter Zijlstra (50):
      objtool: Classify symbols
      objtool: Explicitly avoid self modifying code in .altinstr_replacement
      objtool: Shrink struct instruction
      objtool,x86: Replace alternatives with .retpoline_sites
      objtool: Introduce CFI hash
      x86/retpoline: Remove unused replacement symbols
      x86/asm: Fix register order
      x86/asm: Fixup odd GEN-for-each-reg.h usage
      x86/retpoline: Move the retpoline thunk declarations to nospec-branch.h
      x86/retpoline: Create a retpoline thunk array
      x86/alternative: Implement .retpoline_sites support
      x86/alternative: Handle Jcc __x86_indirect_thunk_\reg
      x86/alternative: Try inline spectre_v2=retpoline,amd
      x86/alternative: Add debug prints to apply_retpolines()
      bpf,x86: Simplify computing label offsets
      bpf,x86: Respect X86_FEATURE_RETPOLINE*
      objtool: Default ignore INT3 for unreachable
      x86/entry: Remove skip_r11rcx
      x86/kvm/vmx: Make noinstr clean
      x86/cpufeatures: Move RETPOLINE flags to word 11
      x86/retpoline: Cleanup some #ifdefery
      x86/retpoline: Swizzle retpoline thunk
      x86/retpoline: Use -mfunction-return
      x86: Undo return-thunk damage
      x86,objtool: Create .return_sites
      x86,static_call: Use alternative RET encoding
      x86/ftrace: Use alternative RET encoding
      x86/bpf: Use alternative RET encoding
      x86/kvm: Fix SETcc emulation for return thunks
      x86/vsyscall_emu/64: Don't use RET in vsyscall emulation
      x86: Use return-thunk in asm code
      x86/entry: Avoid very early RET
      objtool: Treat .text.__x86.* as noinstr
      x86: Add magic AMD return-thunk
      x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
      x86/bugs: Optimize SPEC_CTRL MSR writes
      x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
      x86/bugs: Report Intel retbleed vulnerability
      intel_idle: Disable IBRS during long idle
      objtool: Update Retpoline validation
      x86/xen: Rename SYS* entry points
      x86/xen: Add UNTRAIN_RET
      x86/bugs: Add retbleed=ibpb
      objtool: Add entry UNRET validation
      x86/cpu/amd: Add Spectral Chicken
      x86/common: Stamp out the stepping madness
      x86/retbleed: Add fine grained Kconfig knobs
      x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry
      um: Add missing apply_returns()
      x86: Use -mindirect-branch-cs-prefix for RETPOLINE builds

Thadeu Lima de Souza Cascardo (6):
      x86/realmode: build with -D__DISABLE_EXPORTS
      objtool: skip non-text sections when adding return-thunk sites
      x86/entry: Add kernel IBRS implementation
      x86/bugs: Do not enable IBPB-on-entry when IBPB is not supported
      efi/x86: use naked RET on mixed mode call wrapper
      x86/kvm: fix FASTOP_SIZE when return thunks are enabled

Thomas Gleixner (1):
      x86/static_call: Serialize __static_call_fixup() properly

