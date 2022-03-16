Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A014DB1A3
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348584AbiCPNio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351390AbiCPNih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:38:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE27466C9D;
        Wed, 16 Mar 2022 06:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25A89CE1EEB;
        Wed, 16 Mar 2022 13:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43052C340F0;
        Wed, 16 Mar 2022 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647437826;
        bh=L8ZRVb3PJxM19Qw0k5sFRMAaS3ttu/OtfvqbOnHvBKg=;
        h=From:To:Cc:Subject:Date:From;
        b=vHno9upKVLL15R7TWnPNtZp5iw2846tCY3NAc0kO9puhFUbc3yXANC+MIP8W4mx9F
         /irVCJPMt1Trg7dBy58oYpOwJHWMyXV9QQiVZ6LpQ/5ATFlFt1FUuP0x6oNKsZMQcJ
         LO61DaeTCBevZ4weOuzitTXBTv3g+mfbGBxIvCIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.15
Date:   Wed, 16 Mar 2022 14:36:48 +0100
Message-Id: <16474378089456@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.15 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                |    2 
 arch/arm/boot/dts/bcm2711.dtsi                          |    1 
 arch/arm/include/asm/spectre.h                          |    6 
 arch/arm/kernel/entry-armv.S                            |    4 
 arch/arm64/Kconfig                                      |    3 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts  |    8 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            |    2 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                    |   48 +-
 arch/arm64/include/asm/mte-kasan.h                      |    1 
 arch/arm64/include/asm/pgtable-prot.h                   |    4 
 arch/arm64/include/asm/pgtable.h                        |   11 
 arch/arm64/mm/mmap.c                                    |   17 
 arch/riscv/Kconfig.erratas                              |    1 
 arch/riscv/Kconfig.socs                                 |    4 
 arch/riscv/boot/dts/canaan/k210.dtsi                    |    3 
 arch/riscv/kernel/module.c                              |   21 
 arch/x86/kernel/cpu/sgx/encl.c                          |   57 ++
 arch/x86/kernel/e820.c                                  |   41 +
 arch/x86/kernel/kdebugfs.c                              |   37 +
 arch/x86/kernel/ksysfs.c                                |   77 ++-
 arch/x86/kernel/kvm.c                                   |    9 
 arch/x86/kernel/module.c                                |   13 
 arch/x86/kernel/setup.c                                 |   34 +
 arch/x86/kernel/traps.c                                 |    1 
 arch/x86/kvm/x86.c                                      |    7 
 arch/x86/mm/ioremap.c                                   |   57 ++
 drivers/block/virtio_blk.c                              |   20 
 drivers/clk/qcom/dispcc-sc7180.c                        |    5 
 drivers/clk/qcom/dispcc-sc7280.c                        |    5 
 drivers/clk/qcom/dispcc-sm8250.c                        |    5 
 drivers/clk/qcom/gdsc.c                                 |   26 -
 drivers/clk/qcom/gdsc.h                                 |    8 
 drivers/gpio/gpio-ts4900.c                              |   24 -
 drivers/gpio/gpiolib-acpi.c                             |    6 
 drivers/gpio/gpiolib.c                                  |   20 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c             |    2 
 drivers/gpu/drm/i915/display/intel_psr.c                |   16 
 drivers/gpu/drm/i915/i915_reg.h                         |    1 
 drivers/gpu/drm/panel/Kconfig                           |    1 
 drivers/gpu/drm/sun4i/sun8i_mixer.h                     |    8 
 drivers/gpu/drm/vc4/vc4_hdmi.c                          |    8 
 drivers/gpu/drm/vc4/vc4_hdmi.h                          |    1 
 drivers/hid/hid-elo.c                                   |    7 
 drivers/hid/hid-nintendo.c                              |    4 
 drivers/hid/hid-thrustmaster.c                          |    6 
 drivers/hid/hid-vivaldi.c                               |    2 
 drivers/hwmon/pmbus/pmbus_core.c                        |    5 
 drivers/isdn/hardware/mISDN/hfcpci.c                    |    6 
 drivers/isdn/mISDN/dsp_pipeline.c                       |    6 
 drivers/mmc/host/meson-gx-mmc.c                         |   15 
 drivers/net/dsa/mt7530.c                                |    2 
 drivers/net/ethernet/arc/emac_mdio.c                    |    5 
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c      |    7 
 drivers/net/ethernet/cadence/macb_main.c                |   25 +
 drivers/net/ethernet/freescale/gianfar_ethtool.c        |    1 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c          |    6 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c      |   57 --
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h      |    5 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c         |   40 +
 drivers/net/ethernet/intel/ice/ice.h                    |    1 
 drivers/net/ethernet/intel/ice/ice_ethtool.c            |    2 
 drivers/net/ethernet/intel/ice/ice_main.c               |   31 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c        |   18 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h        |    3 
 drivers/net/ethernet/marvell/prestera/prestera_main.c   |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           |   15 
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c        |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c        |   11 
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    3 
 drivers/net/ethernet/nxp/lpc_eth.c                      |    5 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c             |   18 
 drivers/net/ethernet/qlogic/qed/qed_vf.c                |    7 
 drivers/net/ethernet/ti/cpts.c                          |    4 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c           |    4 
 drivers/net/hamradio/6pack.c                            |    4 
 drivers/net/phy/dp83822.c                               |    2 
 drivers/net/phy/meson-gxl.c                             |   31 -
 drivers/net/usb/smsc95xx.c                              |   28 -
 drivers/net/xen-netback/xenbus.c                        |   14 
 drivers/nfc/port100.c                                   |    2 
 drivers/nvme/host/tcp.c                                 |   63 ++
 drivers/of/fdt.c                                        |    2 
 drivers/pci/quirks.c                                    |   14 
 drivers/pinctrl/intel/pinctrl-tigerlake.c               |    1 
 drivers/soc/mediatek/mt8192-mmsys.h                     |    3 
 drivers/spi/spi-rockchip.c                              |   13 
 drivers/staging/gdm724x/gdm_lte.c                       |    5 
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c           |    7 
 drivers/staging/rtl8723bs/core/rtw_recv.c               |   10 
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c            |   22 
 drivers/staging/rtl8723bs/core/rtw_xmit.c               |   16 
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c          |    2 
 drivers/usb/dwc3/dwc3-pci.c                             |    4 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                       |   16 
 drivers/vdpa/vdpa_user/iova_domain.c                    |    2 
 drivers/vdpa/virtio_pci/vp_vdpa.c                       |    2 
 drivers/vhost/iotlb.c                                   |   11 
 drivers/vhost/vhost.c                                   |    7 
 drivers/virtio/virtio.c                                 |   40 -
 fs/btrfs/block-group.c                                  |    9 
 fs/btrfs/ctree.c                                        |   98 +++-
 fs/btrfs/ctree.h                                        |   14 
 fs/btrfs/disk-io.c                                      |    4 
 fs/btrfs/relocation.c                                   |   13 
 fs/btrfs/send.c                                         |  357 +++++++++++++---
 fs/btrfs/transaction.c                                  |    4 
 fs/fuse/dev.c                                           |   12 
 fs/fuse/file.c                                          |    1 
 fs/fuse/fuse_i.h                                        |    1 
 fs/fuse/ioctl.c                                         |    9 
 fs/pipe.c                                               |   11 
 include/linux/mlx5/mlx5_ifc.h                           |    5 
 include/linux/netdevice.h                               |    1 
 include/linux/nvme-tcp.h                                |    1 
 include/linux/virtio.h                                  |    1 
 include/linux/virtio_config.h                           |    3 
 include/linux/watch_queue.h                             |    3 
 include/net/esp.h                                       |    2 
 kernel/dma/swiotlb.c                                    |   22 
 kernel/trace/trace.c                                    |   10 
 kernel/trace/trace_osnoise.c                            |   84 ++-
 kernel/trace/trace_selftest.c                           |    6 
 kernel/watch_queue.c                                    |   15 
 mm/gup.c                                                |   57 --
 net/ax25/af_ax25.c                                      |    7 
 net/core/net-sysfs.c                                    |    2 
 net/core/skbuff.c                                       |   26 -
 net/ipv4/esp4.c                                         |    5 
 net/ipv4/esp4_offload.c                                 |    3 
 net/ipv4/udp_offload.c                                  |   27 +
 net/ipv6/addrconf.c                                     |    2 
 net/ipv6/esp6.c                                         |    5 
 net/ipv6/esp6_offload.c                                 |    3 
 net/sctp/diag.c                                         |    9 
 net/tipc/bearer.c                                       |   12 
 net/tipc/link.c                                         |    9 
 tools/perf/util/parse-events.c                          |    6 
 tools/testing/selftests/bpf/prog_tests/timer_crash.c    |   32 +
 tools/testing/selftests/bpf/progs/timer_crash.c         |   54 ++
 tools/testing/selftests/memfd/memfd_test.c              |    1 
 tools/testing/selftests/net/pmtu.sh                     |   21 
 tools/testing/selftests/vm/map_fixed_noreplace.c        |   49 +-
 virt/kvm/kvm_main.c                                     |    4 
 145 files changed, 1651 insertions(+), 645 deletions(-)

Alex Deucher (1):
      PCI: Mark all AMD Navi10 and Navi14 GPU ATS as broken

Alexey Khoroshilov (1):
      mISDN: Fix memory leak in dsp_pipeline_build()

Andy Shevchenko (2):
      gpiolib: acpi: Convert ACPI value of debounce to microseconds
      pinctrl: tigerlake: Revert "Add Alder Lake-M ACPI ID"

Aneesh Kumar K.V (1):
      selftest/vm: fix map_fixed_noreplace test failure

AngeloGioacchino Del Regno (1):
      soc: mediatek: mt8192-mmsys: Fix dither to dsi0 path's input sel

Anirudh Rayabharam (1):
      vhost: fix hung thread due to erroneous iotlb entries

Anton Romanov (1):
      kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, reduce TIR indication

Bjorn Andersson (1):
      arm64: dts: qcom: sm8350: Correct UFS symbol clocks

Catalin Marinas (1):
      arm64: Ensure execute-only permissions are not allowed without EPAN

Christophe JAILLET (1):
      ice: Don't use GFP_KERNEL in atomic context

Christophe Leroy (1):
      tracing: Fix selftest config check for function graph start up test

Clément Léger (1):
      net: phy: DP83822: clear MISR2 register to disable interrupts

Dan Carpenter (1):
      staging: gdm724x: fix use after free in gdm_lte_rx()

Daniel Bristot de Oliveira (2):
      tracing/osnoise: Make osnoise_main to sleep for microseconds
      tracing/osnoise: Do not unregister events twice

Dave Ertman (1):
      ice: Fix error with handling of bonding MTU

David Howells (8):
      watch_queue: Fix filter limit check
      watch_queue, pipe: Free watchqueue state after clearing pipe ring
      watch_queue: Fix to release page in ->release()
      watch_queue: Fix to always request a pow-of-2 pipe ring size
      watch_queue: Fix the alloc bitmap size to reflect notes allocated
      watch_queue: Free the alloc bitmap when the watch_queue is torn down
      watch_queue: Fix lack of barrier/sync/lock between post and read
      watch_queue: Make comment about setting ->defunct more accurate

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Dmitry Torokhov (1):
      HID: vivaldi: fix sysfs attributes leak

Duoming Zhou (2):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device
      drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()

Emil Renner Berthing (1):
      riscv: Fix auipc+jalr relocation range checks

Eric Dumazet (2):
      net: gro: move skb_gro_receive_list to udp_offload.c
      sctp: fix kernel-infoleak for SCTP sockets

Fabio Estevam (1):
      smsc95xx: Ignore -ENODEV errors when device is unplugged

Filipe Manana (1):
      btrfs: make send work with concurrent block group relocation

Greg Kroah-Hartman (1):
      Linux 5.16.15

Guchun Chen (1):
      drm/amdgpu: bypass tiling flag check in virtual display case (v2)

Guillaume Nault (2):
      selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
      selftests: pmtu.sh: Kill nettest processes launched in subshell.

Halil Pasic (2):
      swiotlb: fix info leak with DMA_FROM_DEVICE
      swiotlb: rework "fix info leak with DMA_FROM_DEVICE"

Hans de Goede (1):
      staging: rtl8723bs: Fix access-point mode deadlock

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Raptor Lake-S

Heiner Kallweit (2):
      net: phy: meson-gxl: fix interrupt handling in forced mode
      net: phy: meson-gxl: improve link-up behavior

Jacob Keller (2):
      i40e: stop disabling VFs due to PF error responses
      ice: stop disabling VFs due to PF error responses

Jarkko Sakkinen (1):
      x86/sgx: Free backing memory after faulting the enclave page

Jason Wang (1):
      vhost: allow batching hint without size

Jedrzej Jagielski (1):
      ice: Fix curr_link_speed advertised speed

Jeremy Linton (1):
      net: bcmgenet: Don't claim WOL when its not available

Jernej Skrabec (1):
      drm/sun4i: mixer: Fix P010 and P210 format numbers

Jia-Ju Bai (3):
      HID: nintendo: check the return value of alloc_workqueue()
      isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jianglei Nie (1):
      net: arc_emac: Fix use after free in arc_mdio_probe()

Jiasheng Jiang (2):
      net: ethernet: ti: cpts: Handle error for clk_enable
      net: ethernet: lpc_eth: Handle error for clk_enable

Jiri Kosina (1):
      HID: elo: Revert USB reference counting

Jisheng Zhang (1):
      riscv: alternative only works on !XIP_KERNEL

Joel Stanley (1):
      ARM: dts: aspeed: Fix AST2600 quad spi group

Jon Lin (2):
      spi: rockchip: Fix error in getting num-cs property
      spi: rockchip: terminate dma transmission when slave abort

Jouni Högander (1):
      drm/i915/psr: Set "SF Partial Frame Enable" also on full update

Konrad Dybcio (1):
      arm64: dts: qcom: sm8350: Describe GCC dependency clocks

Kumar Kartikeya Dwivedi (1):
      selftests/bpf: Add test for bpf_timer overwriting crash

Li Huafei (1):
      x86/traps: Mark do_int3() NOKPROBE_SYMBOL

Linus Torvalds (1):
      mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

Marek Marczykowski-Górecki (2):
      Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mark Featherston (1):
      gpio: ts4900: Do not set DAT and OE together

Maxime Ripard (2):
      ARM: boot: dts: bcm2711: Fix HVS register range
      drm/vc4: hdmi: Unregister codec device on unbind

Miaoqian Lin (3):
      ethernet: Fix error handling in xemaclite_of_probe
      net: marvell: prestera: Add missing of_node_put() in prestera_switch_set_base_mac_addr
      gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Michael S. Tsirkin (2):
      virtio: unexport virtio_finalize_features
      virtio: acknowledge all features before access

Michal Maloszewski (1):
      iavf: Fix handling of vlan strip virtual channel messages

Mike Kravetz (1):
      selftests/memfd: clean up mapping in mfd_fail_write

Miklos Szeredi (2):
      fuse: fix fileattr op failure
      fuse: fix pipe buffer lifetime for direct_io

Mohammad Kabat (1):
      net/mlx5: Fix size field in bufferx_reg struct

Moshe Shemesh (1):
      net/mlx5: Fix a race on command flush flow

Nicolas Saenz Julienne (1):
      tracing/osnoise: Force quiescent states while tracing

Niels Dossche (1):
      ipv6: prevent a possible race condition with lifetimes

Nikhil Gupta (1):
      of/fdt: move elfcorehdr reservation early for crash dump kernel

Niklas Cassel (1):
      riscv: dts: k210: fix broken IRQs on hart1

Pali Rohár (2):
      arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias
      arm64: dts: marvell: armada-37xx: Remap IO space to bus address 0x0

Paul Semel (1):
      arm64: kasan: fix include error in MTE functions

Pavel Skripkin (2):
      HID: hid-thrustmaster: fix OOB read in thrustmaster_interrupts
      NFC: port100: fix use-after-free in port100_send_complete

Peter Zijlstra (1):
      x86/module: Fix the paravirt vs alternative order

Randy Dunlap (1):
      ARM: Spectre-BHB: provide empty stub for non-config

Robert Hancock (1):
      net: macb: Fix lost RX packet wakeup race in NAPI receive

Roi Dayan (1):
      net/mlx5e: Lag, Only handle events from highest priority multipath entry

Rong Chen (1):
      mmc: meson: Fix usage of meson_mmc_post_req()

Ross Philipson (2):
      x86/boot: Fix memremap of setup_indirect structures
      x86/boot: Add setup_indirect support in early_memremap_is_setup_data()

Russell King (Oracle) (2):
      net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()
      ARM: fix Thumb2 regression with Spectre BHB

Shreeya Patel (1):
      gpio: Return EPROBE_DEFER if gc->to_irq is NULL

Si-Wei Liu (1):
      vdpa/mlx5: add validation for VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command

Steffen Klassert (2):
      esp: Fix possible buffer overflow in ESP transformation
      esp: Fix BEET mode inter address family tunneling on GSO

Sven Schnelle (1):
      tracing: Ensure trace buffer is at least 4096 bytes large

Taniya Das (2):
      clk: qcom: gdsc: Add support to update GDSC transition delay
      clk: qcom: dispcc: Update the transition delay for MDSS GDSC

Thomas Zimmermann (1):
      drm/panel: Select DRM_DP_HELPER for DRM_PANEL_EDP

Tom Rix (1):
      qed: return status of qed_iov_get_link

Tung Nguyen (2):
      tipc: fix kernel panic when enabling bearer
      tipc: fix incorrect order of state message data sanity check

Varun Prakash (1):
      nvme-tcp: send H2CData PDUs based on MAXH2CDATA

Vikash Chandola (1):
      hwmon: (pmbus) Clear pmbus fault/warning bits after read

Wanpeng Li (2):
      KVM: Fix lockdep false negative during host resume
      x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU

Xie Yongji (3):
      vduse: Fix returning wrong type in vduse_domain_alloc_iova()
      virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero
      virtio-blk: Remove BUG_ON() in virtio_queue_rq()

Zhang Min (1):
      vdpa: fix use-after-free on vp_vdpa_remove

Zhengjun Xing (1):
      perf parse: Fix event parser error for hybrid systems

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

