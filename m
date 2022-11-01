Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDCF61517F
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKASXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 14:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiKASXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 14:23:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8488F3C;
        Tue,  1 Nov 2022 11:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 701DDB81EB5;
        Tue,  1 Nov 2022 18:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA3C433D6;
        Tue,  1 Nov 2022 18:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667327017;
        bh=EbJZKIM6GDDovJC7Ng13vzFxeP1D++SvoPvdD4ZTq1c=;
        h=From:To:Cc:Subject:Date:From;
        b=2pwcDRoRYVTwtRzxuPTt43jEmwN7X3cwJcTy33Y55Kd9WabR8dOhccKFhNxJdEs2Z
         0P09gL+KQCjwCCdOPe5tGXCqZVlk3n9hKnto7q0O8WndNHsGeb7i3P2O4US+NG6r06
         DFGh2wv1CCKfwYiFixUmp8zKbD99G2w7KHiH6ODU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.297
Date:   Tue,  1 Nov 2022 19:24:13 +0100
Message-Id: <166732705422181@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.297 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst   |    8 
 Documentation/admin-guide/kernel-parameters.txt |   13 
 Makefile                                        |    2 
 arch/x86/entry/calling.h                        |   68 +++
 arch/x86/entry/entry_32.S                       |    2 
 arch/x86/entry/entry_64.S                       |   38 +-
 arch/x86/entry/entry_64_compat.S                |   12 
 arch/x86/include/asm/cpu_device_id.h            |  168 +++++++++
 arch/x86/include/asm/cpufeatures.h              |   16 
 arch/x86/include/asm/intel-family.h             |    6 
 arch/x86/include/asm/msr-index.h                |   14 
 arch/x86/include/asm/nospec-branch.h            |   48 +-
 arch/x86/kernel/cpu/amd.c                       |   21 -
 arch/x86/kernel/cpu/bugs.c                      |  415 +++++++++++++++++++-----
 arch/x86/kernel/cpu/common.c                    |   68 ++-
 arch/x86/kernel/cpu/match.c                     |   44 ++
 arch/x86/kernel/cpu/scattered.c                 |    1 
 arch/x86/kernel/process.c                       |    2 
 arch/x86/kvm/svm.c                              |    1 
 arch/x86/kvm/vmx.c                              |   51 ++
 drivers/base/cpu.c                              |    8 
 drivers/cpufreq/acpi-cpufreq.c                  |    1 
 drivers/cpufreq/amd_freq_sensitivity.c          |    1 
 drivers/idle/intel_idle.c                       |   45 ++
 include/linux/cpu.h                             |    2 
 include/linux/mod_devicetable.h                 |    4 
 tools/arch/x86/include/asm/cpufeatures.h        |    1 
 27 files changed, 898 insertions(+), 162 deletions(-)

Alexandre Chartre (2):
      x86/bugs: Report AMD retbleed vulnerability
      x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
      x86/cpu/amd: Enumerate BTC_NO

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Greg Kroah-Hartman (1):
      Linux 4.14.297

Ingo Molnar (1):
      x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header

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
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (9):
      x86/entry: Remove skip_r11rcx
      x86/cpufeatures: Move RETPOLINE flags to word 11
      x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
      x86/bugs: Optimize SPEC_CTRL MSR writes
      x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
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

