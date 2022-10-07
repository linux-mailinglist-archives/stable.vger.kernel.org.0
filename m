Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D53E5F74AE
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 09:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJGH1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 03:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJGH1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 03:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3704A754B8;
        Fri,  7 Oct 2022 00:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0CFBB82233;
        Fri,  7 Oct 2022 07:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4811DC433C1;
        Fri,  7 Oct 2022 07:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665127633;
        bh=45fGl6E/WyzGCzh0/ZS93asrw7p4r1/q5/jXsu+UgG8=;
        h=From:To:Cc:Subject:Date:From;
        b=PY2pZ/WEIIyVUdjWtvQhzPeW9PFCCZN3hrJACV7tWg2l8SAf4qOSMGAVsCcFKcobA
         ENkza4wK7DIQSi1Xnzffv6OLVsQpNAt2U7szWQKzWicXEbbPonCSEYnfr/nXa1vR41
         +w4j7GSZ2Tl85Cl9GNVvHSP9PcaOunhwlJbxDHgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.217
Date:   Fri,  7 Oct 2022 09:27:53 +0200
Message-Id: <166512767424534@kroah.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.217 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt          |   13 
 Documentation/process/code-of-conduct-interpretation.rst |    2 
 Makefile                                                 |    2 
 arch/x86/entry/calling.h                                 |   68 ++
 arch/x86/entry/entry_32.S                                |    2 
 arch/x86/entry/entry_64.S                                |   34 +
 arch/x86/entry/entry_64_compat.S                         |   11 
 arch/x86/include/asm/cpu_device_id.h                     |  132 +++++
 arch/x86/include/asm/cpufeatures.h                       |   13 
 arch/x86/include/asm/intel-family.h                      |    6 
 arch/x86/include/asm/msr-index.h                         |   10 
 arch/x86/include/asm/nospec-branch.h                     |   54 +-
 arch/x86/kernel/cpu/amd.c                                |   21 
 arch/x86/kernel/cpu/bugs.c                               |  365 +++++++++++----
 arch/x86/kernel/cpu/common.c                             |   61 +-
 arch/x86/kernel/cpu/match.c                              |   13 
 arch/x86/kernel/cpu/scattered.c                          |    1 
 arch/x86/kernel/process.c                                |    2 
 arch/x86/kvm/svm.c                                       |    1 
 arch/x86/kvm/vmx/nested.c                                |   32 -
 arch/x86/kvm/vmx/run_flags.h                             |    8 
 arch/x86/kvm/vmx/vmenter.S                               |  161 +++---
 arch/x86/kvm/vmx/vmx.c                                   |   72 +-
 arch/x86/kvm/vmx/vmx.h                                   |    5 
 arch/x86/kvm/x86.c                                       |    4 
 drivers/base/cpu.c                                       |    8 
 drivers/cpufreq/acpi-cpufreq.c                           |    1 
 drivers/cpufreq/amd_freq_sensitivity.c                   |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c              |    2 
 drivers/idle/intel_idle.c                                |   43 +
 fs/xfs/libxfs/xfs_attr.c                                 |    2 
 fs/xfs/libxfs/xfs_attr_leaf.c                            |    4 
 fs/xfs/libxfs/xfs_attr_leaf.h                            |   26 -
 fs/xfs/libxfs/xfs_attr_remote.c                          |   85 ++-
 fs/xfs/libxfs/xfs_attr_remote.h                          |    2 
 fs/xfs/libxfs/xfs_da_btree.h                             |   17 
 fs/xfs/libxfs/xfs_da_format.c                            |    1 
 fs/xfs/libxfs/xfs_da_format.h                            |   59 --
 fs/xfs/libxfs/xfs_dir2.h                                 |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h                            |   19 
 fs/xfs/libxfs/xfs_format.h                               |    7 
 fs/xfs/xfs_attr_inactive.c                               |  146 +-----
 fs/xfs/xfs_file.c                                        |    7 
 fs/xfs/xfs_inode.c                                       |   25 -
 fs/xfs/xfs_reflink.c                                     |    3 
 fs/xfs/xfs_super.c                                       |   48 -
 include/linux/cpu.h                                      |    2 
 include/linux/kvm_host.h                                 |    2 
 include/linux/mod_devicetable.h                          |    4 
 scripts/Makefile.extrawarn                               |    1 
 tools/arch/x86/include/asm/cpufeatures.h                 |    2 
 51 files changed, 1055 insertions(+), 557 deletions(-)

Alexandre Chartre (2):
      x86/bugs: Report AMD retbleed vulnerability
      x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
      x86/cpu/amd: Enumerate BTC_NO

Christoph Hellwig (3):
      xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
      xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
      xfs: move incore structures out of xfs_da_format.h

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Darrick J. Wong (7):
      xfs: introduce XFS_MAX_FILEOFF
      xfs: truncate should remove all blocks, not just to the end of the page cache
      xfs: fix s_maxbytes computation on 32-bit kernels
      xfs: refactor remote attr value buffer invalidation
      xfs: fix memory corruption during remote attr value buffer invalidation
      xfs: streamline xfs_attr3_leaf_inactive
      xfs: fix uninitialized variable in xfs_attr3_leaf_inactive

Greg Kroah-Hartman (2):
      Revert "drm/amdgpu: use dirty framebuffer helper"
      Linux 5.4.217

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
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (11):
      x86/kvm/vmx: Make noinstr clean
      x86/cpufeatures: Move RETPOLINE flags to word 11
      x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
      x86/entry: Remove skip_r11rcx
      x86/entry: Add kernel IBRS implementation
      x86/bugs: Optimize SPEC_CTRL MSR writes
      x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
      x86/bugs: Report Intel retbleed vulnerability
      intel_idle: Disable IBRS during long idle
      x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
      x86/common: Stamp out the stepping madness

Sami Tolvanen (1):
      Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Shuah Khan (1):
      docs: update mediator information in CoC docs

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

YueHaibing (1):
      xfs: remove unused variable 'done'

