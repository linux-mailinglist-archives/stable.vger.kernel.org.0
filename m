Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEEB6A291F
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 11:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBYKqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 05:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBYKqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 05:46:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C61969A;
        Sat, 25 Feb 2023 02:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE02EB80907;
        Sat, 25 Feb 2023 10:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D441C433D2;
        Sat, 25 Feb 2023 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677321998;
        bh=l7lNNtolgroynpkNPe1ElYTdr9uN6kJ7wOBCihN37DI=;
        h=From:To:Cc:Subject:Date:From;
        b=YiqPeKK8Q8r6yGyDJXYvGERWnLGphyU2MNvVoPjyGtKNsFhrI3s9kM8Qj62Z729Rr
         4qLs35zJblWzYkft0BDZ0HzeiTAbvhvCP5Yr2QWnDAgq64O21thcsnurxFZecpH/8w
         VSFGmhtRAZm+KyLXphYX9B69KoxOp2MJTWjMEDb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.14
Date:   Sat, 25 Feb 2023 11:46:32 +0100
Message-Id: <1677321992228178@kroah.com>
X-Mailer: git-send-email 2.39.2
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

I'm announcing the release of the 6.1.14 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/perf/hisi-pcie-pmu.rst         |   22 -
 MAINTAINERS                                              |    2 
 Makefile                                                 |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi       |   44 +++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi       |   44 +++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi              |   20 +
 arch/powerpc/kernel/vmlinux.lds.S                        |    6 
 arch/powerpc/mm/book3s64/radix_pgtable.c                 |   13 +
 arch/s390/kernel/vmlinux.lds.S                           |    2 
 arch/sh/kernel/vmlinux.lds.S                             |    1 
 arch/x86/include/asm/text-patching.h                     |   31 ++
 arch/x86/kernel/alternative.c                            |   59 +++-
 arch/x86/kernel/kprobes/core.c                           |   38 --
 arch/x86/kernel/static_call.c                            |   49 +++
 arch/x86/kvm/svm/svm.c                                   |   10 
 arch/x86/kvm/vmx/nested.c                                |   11 
 arch/x86/kvm/vmx/vmx.c                                   |    6 
 arch/x86/kvm/x86.c                                       |    4 
 arch/x86/kvm/xen.c                                       |   30 ++
 drivers/bluetooth/btusb.c                                |   84 ++++++
 drivers/clk/x86/Kconfig                                  |    5 
 drivers/clk/x86/clk-cgu-pll.c                            |   23 -
 drivers/clk/x86/clk-cgu.c                                |  106 ++------
 drivers/clk/x86/clk-cgu.h                                |   46 +--
 drivers/clk/x86/clk-lgm.c                                |   18 -
 drivers/gpu/drm/drm_edid.c                               |    3 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                    |    4 
 drivers/gpu/drm/i915/i915_pci.c                          |    1 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c        |   33 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h            |    1 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     |  195 +++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.h            |   12 
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c     |   17 +
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h     |   56 ++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c |   26 ++
 drivers/net/wireless/ath/ath11k/qmi.c                    |    6 
 drivers/net/wireless/marvell/mwifiex/sdio.c              |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    |    8 
 drivers/platform/x86/amd/pmf/Kconfig                     |    1 
 drivers/platform/x86/nvidia-wmi-ec-backlight.c           |    6 
 drivers/scsi/hisi_sas/hisi_sas_main.c                    |    8 
 drivers/scsi/libsas/sas_ata.c                            |   25 +
 drivers/scsi/libsas/sas_expander.c                       |    4 
 drivers/scsi/libsas/sas_internal.h                       |    2 
 drivers/spi/spi-mt65xx.c                                 |   10 
 fs/ext4/sysfs.c                                          |    7 
 include/asm-generic/vmlinux.lds.h                        |    5 
 include/linux/nospec.h                                   |    4 
 include/linux/psi_types.h                                |    1 
 include/linux/random.h                                   |    6 
 include/scsi/sas_ata.h                                   |    6 
 kernel/bpf/core.c                                        |    3 
 kernel/sched/psi.c                                       |   62 ++++
 lib/usercopy.c                                           |    7 
 scripts/head-object-list.txt                             |    2 
 security/Kconfig.hardening                               |    3 
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c     |    5 
 57 files changed, 962 insertions(+), 244 deletions(-)

Ankit Nautiyal (1):
      drm/edid: Fix minimum bpc supported with DSC1.2 for HDMI sink

Bitterblue Smith (1):
      wifi: rtl8xxxu: gen2: Turn on the rate control

Dave Hansen (1):
      uaccess: Add speculation barrier to copy_from_user()

Eric Biggers (1):
      randstruct: disable Clang 15 support

Greg Kroah-Hartman (1):
      Linux 6.1.14

Hans de Goede (1):
      platform/x86: nvidia-wmi-ec-backlight: Add force module parameter

Jason A. Donenfeld (1):
      random: always mix cycle counter in add_latent_entropy()

Jie Zhan (2):
      scsi: libsas: Add smp_ata_check_ready_type()
      scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset

Jim Mattson (1):
      KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

Jisheng Zhang (1):
      riscv: remove special treatment for the link order of head.o

Kees Cook (1):
      ext4: Fix function prototype mismatch for ext4_feat_ktype

Linus Torvalds (1):
      bpf: add missing header file include

Lucas De Marchi (1):
      drm/i915: Remove __maybe_unused from mtl_info

Lucas Stach (1):
      drm/etnaviv: don't truncate physical page address

Lukas Wunner (1):
      wifi: mwifiex: Add missing compatible string for SD8787

Marc Kleine-Budde (1):
      can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Masahiro Yamada (3):
      arm64: remove special treatment for the link order of head.o
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (3):
      powerpc/64s/radix: Fix RWX mapping with relocated kernel
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Paolo Bonzini (2):
      KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
      selftests: kvm: move declaration at the beginning of main()

Paul Moore (1):
      audit: update the mailing list in MAINTAINERS

Peter Zijlstra (3):
      x86/alternatives: Introduce int3_emulate_jcc()
      x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions
      x86/static_call: Add support for Jcc tail-calls

Rahul Tanwar (5):
      clk: mxl: Switch from direct readl/writel based IO to regmap based IO
      clk: mxl: Remove redundant spinlocks
      clk: mxl: Add option to override gate clks
      clk: mxl: Fix a clk entry by adding relevant flags
      clk: mxl: syscon_node_to_regmap() returns error pointers

Ricardo Ribalda (2):
      spi: mediatek: Enable irq when pdata is ready
      spi: mediatek: Enable irq before the spi registration

Sean Anderson (2):
      powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
      powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Sean Christopherson (2):
      KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
      KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid

Shengyu Qu (1):
      Bluetooth: btusb: Add more device IDs for WCN6855

Shyam Sundar S K (1):
      platform/x86/amd/pmf: Add depends on CONFIG_POWER_SUPPLY

Suren Baghdasaryan (1):
      sched/psi: Stop relying on timer_pending() for poll_work rescheduling

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

Wen Gong (1):
      wifi: ath11k: fix warning in dma_free_coherent() of memory chunks while recovery

Yicong Yang (1):
      docs: perf: Fix PMU instance name of hisi-pcie-pmu

Yu Xiao (2):
      nfp: ethtool: support reporting link modes
      nfp: ethtool: fix the bug of setting unsupported port speed

