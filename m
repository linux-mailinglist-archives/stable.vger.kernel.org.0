Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4F04E4E2E
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiCWI3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242694AbiCWI26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:28:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902537522B;
        Wed, 23 Mar 2022 01:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3310FB81E3D;
        Wed, 23 Mar 2022 08:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EAEC340E8;
        Wed, 23 Mar 2022 08:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024035;
        bh=wLINI9rlik5AUH40tSXUUvdzoTvezsPg+47XTMaLGSw=;
        h=From:To:Cc:Subject:Date:From;
        b=T0jyqUAmasO4Xbxx8+93cBiuqq1DlpkuKtZSxpncnZAyjjn/F5RGiIm+GTe8/gx5f
         zRsNOD4VQwaFOEzX+jPZ/2RjkVFwxCEATu1oU+NXN+FRA/2HVigzBYdzqxRrjDcn2n
         x9NQOGFMmGGlWq2ySfZITniUeyE1i2TmYkGV6VPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.236
Date:   Wed, 23 Mar 2022 09:27:11 +0100
Message-Id: <164802403112185@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.236 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/arm/boot/dts/rk3288.dtsi                 |    2 
 arch/arm/include/asm/kvm_host.h               |    7 
 arch/arm64/Kconfig                            |    9 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |    6 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |    6 
 arch/arm64/include/asm/assembler.h            |   34 ++
 arch/arm64/include/asm/cpu.h                  |    1 
 arch/arm64/include/asm/cpucaps.h              |    3 
 arch/arm64/include/asm/cpufeature.h           |   39 ++
 arch/arm64/include/asm/cputype.h              |   16 +
 arch/arm64/include/asm/fixmap.h               |    6 
 arch/arm64/include/asm/kvm_host.h             |    5 
 arch/arm64/include/asm/kvm_mmu.h              |    6 
 arch/arm64/include/asm/mmu.h                  |    8 
 arch/arm64/include/asm/sections.h             |    5 
 arch/arm64/include/asm/sysreg.h               |    5 
 arch/arm64/include/asm/vectors.h              |   74 +++++
 arch/arm64/kernel/cpu_errata.c                |  381 +++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c                |   21 +
 arch/arm64/kernel/cpuinfo.c                   |    1 
 arch/arm64/kernel/entry.S                     |  213 ++++++++++----
 arch/arm64/kernel/vmlinux.lds.S               |    2 
 arch/arm64/kvm/hyp/hyp-entry.S                |   64 ++++
 arch/arm64/kvm/hyp/switch.c                   |    8 
 arch/arm64/kvm/sys_regs.c                     |    2 
 arch/arm64/mm/mmu.c                           |   12 
 arch/ia64/kernel/acpi.c                       |    7 
 arch/mips/kernel/smp.c                        |    6 
 drivers/atm/eni.c                             |    2 
 drivers/atm/firestream.c                      |    2 
 drivers/crypto/qcom-rng.c                     |   17 -
 drivers/firmware/efi/apple-properties.c       |    2 
 drivers/firmware/efi/efi.c                    |    2 
 drivers/gpu/drm/panel/panel-simple.c          |    2 
 drivers/input/tablet/aiptek.c                 |   10 
 drivers/net/can/rcar/rcar_canfd.c             |    6 
 drivers/net/ethernet/sfc/mcdi.c               |    2 
 drivers/net/hyperv/netvsc_drv.c               |    3 
 drivers/usb/gadget/function/rndis.c           |    1 
 drivers/usb/gadget/udc/core.c                 |    3 
 fs/ocfs2/super.c                              |   22 -
 fs/sysfs/file.c                               |    3 
 include/linux/arm-smccc.h                     |    7 
 include/linux/if_arp.h                        |    1 
 include/linux/topology.h                      |    1 
 include/net/xfrm.h                            |    5 
 kernel/cgroup/cpuset.c                        |    8 
 kernel/sched/topology.c                       |   99 +++---
 lib/Kconfig                                   |    1 
 mm/migrate.c                                  |    8 
 net/dsa/dsa2.c                                |    1 
 net/ipv4/tcp.c                                |   10 
 net/key/af_key.c                              |    2 
 net/packet/af_packet.c                        |   11 
 net/sctp/sm_statefuns.c                       |  108 ++++---
 net/wireless/nl80211.c                        |    3 
 net/xfrm/xfrm_policy.c                        |   14 
 net/xfrm/xfrm_state.c                         |   15 -
 net/xfrm/xfrm_user.c                          |   27 -
 tools/perf/util/symbol.c                      |    2 
 tools/testing/selftests/vm/userfaultfd.c      |    1 
 virt/kvm/arm/psci.c                           |   12 
 63 files changed, 1111 insertions(+), 253 deletions(-)

Alan Stern (1):
      usb: gadget: Fix use-after-free bug by not setting udc->dev.driver

Alexander Lobakin (1):
      MIPS: smp: fill in sibling and core maps earlier

Anshuman Khandual (1):
      arm64: Add Cortex-X2 CPU part definition

Brian Masney (1):
      crypto: qcom-rng - ensure buffer for generate is completely filled

Chengming Zhou (1):
      kselftest/vm: fix tests build with old libc

Corentin Labbe (1):
      ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Dan Carpenter (1):
      usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Dietmar Eggemann (1):
      sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Eric Dumazet (2):
      tcp: make tcp_read_sock() more robust
      net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Greg Kroah-Hartman (1):
      Linux 4.19.236

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity

James Morse (18):
      arm64: entry.S: Add ventry overflow sanity checks
      arm64: entry: Make the trampoline cleanup optional
      arm64: entry: Free up another register on kpti's tramp_exit path
      arm64: entry: Move the trampoline data page before the text page
      arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
      arm64: entry: Don't assume tramp_vectors is the start of the vectors
      arm64: entry: Move trampoline macros out of ifdef'd section
      arm64: entry: Make the kpti trampoline's kpti sequence optional
      arm64: entry: Allow the trampoline text to occupy multiple pages
      arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
      arm64: entry: Add vectors that have the bhb mitigation sequences
      arm64: entry: Add macro for reading symbol addresses from the trampoline
      arm64: Add percpu vectors for EL1
      arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2
      KVM: arm64: Add templates for BHB mitigation sequences
      arm64: Mitigate spectre style branch history side channels
      KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
      arm64: Use the clearbhb instruction in mitigations

Jia-Ju Bai (1):
      atm: firestream: check the return value of ioremap() in fs_init()

Jiasheng Jiang (2):
      atm: eni: Add check for dma_map_single
      hv_netvsc: Add check for kvmalloc_array

Joey Gouly (1):
      arm64: add ID_AA64ISAR2_EL1 sys register

Joseph Qi (1):
      ocfs2: fix crash when initialize filecheck kobj fails

Julian Braha (1):
      ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Kai Lueke (1):
      Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Lucas Wei (1):
      fs: sysfs_emit: Remove PAGE_SIZE alignment check

Marek Vasut (1):
      drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings

Miaoqian Lin (1):
      net: dsa: Add missing of_node_put() in dsa_port_parse_of

Michael Petlan (1):
      perf symbols: Fix symbol size calculation condition

Nicolas Dichtel (1):
      net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Niels Dossche (1):
      sfc: extend the locking on mcdi->seqno

Pavel Skripkin (1):
      Input: aiptek - properly check endpoint type

Randy Dunlap (1):
      efi: fix return value of __setup handlers

Rob Herring (1):
      arm64: Add part number for Arm Cortex-A77

Sascha Hauer (1):
      arm64: dts: rockchip: reorder rk3399 hdmi clocks

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Suzuki K Poulose (1):
      arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

Valentin Schneider (2):
      sched/topology: Make sched_init_numa() use a set for the deduplicating sort
      ia64: ensure proper NUMA distance and possible map initialization

Xin Long (2):
      sctp: fix the processing for INIT chunk
      sctp: fix the processing for INIT_ACK chunk

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

Zhang Qiao (1):
      cpuset: Fix unsafe lock order between cpuset lock and cpuslock

liqiong (1):
      mm: fix dereference a null pointer in migrate[_huge]_page_move_mapping()

