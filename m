Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B55414792
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhIVLRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhIVLPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 031C561211;
        Wed, 22 Sep 2021 11:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309213;
        bh=XIiTP+TI0mBRBF+fLQxeTpt7AgTcZwspSxlr/GbCXQU=;
        h=From:To:Cc:Subject:Date:From;
        b=FTWj5813tNyQy+S+BXRD3zmWbTFp6zbuXxQnpRQ3twtMLjsbY5oAA6Dg9aKEbcGCF
         wFkPfrdRd7p5yI3RQz0GkH5FC9n2DmRutjA53SvHRBFZJoX9YJdRcCEqpLEXSbna0W
         Al7K05V/+Lb7IcOhjz7OEIL4S/e3j46GEczl+m/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.7
Date:   Wed, 22 Sep 2021 13:13:11 +0200
Message-Id: <1632309191223168@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.7 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/arm/tegra.yaml            |    2 
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt         |    2 
 Makefile                                                    |    2 
 arch/arc/mm/cache.c                                         |    2 
 arch/arm64/kernel/fpsimd.c                                  |    2 
 arch/arm64/kvm/arm.c                                        |    8 
 arch/arm64/kvm/handle_exit.c                                |   23 +-
 arch/arm64/kvm/hyp/nvhe/host.S                              |   21 +-
 arch/arm64/kvm/reset.c                                      |   24 +-
 arch/powerpc/kernel/interrupt.c                             |   43 ++++
 arch/powerpc/kernel/interrupt_64.S                          |   41 ----
 arch/powerpc/kernel/mce.c                                   |   17 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                     |   36 +++
 arch/riscv/include/asm/page.h                               |    4 
 arch/riscv/mm/init.c                                        |    6 
 arch/s390/net/bpf_jit_comp.c                                |   70 +++----
 arch/s390/pci/pci_mmio.c                                    |    4 
 arch/x86/include/asm/uaccess.h                              |    4 
 arch/x86/kernel/cpu/mce/core.c                              |   43 +++-
 arch/x86/mm/init_64.c                                       |    6 
 arch/x86/mm/pat/memtype.c                                   |    7 
 arch/x86/xen/enlighten_pv.c                                 |    7 
 arch/x86/xen/mmu_pv.c                                       |    7 
 block/bfq-iosched.c                                         |   16 +
 block/blk-cgroup.c                                          |   10 -
 drivers/base/power/trace.c                                  |   10 +
 drivers/block/loop.c                                        |   75 ++++---
 drivers/block/loop.h                                        |    1 
 drivers/gpio/gpio-mpc8xxx.c                                 |   13 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c                  |   10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h                  |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                 |   10 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                  |   12 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c                    |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                     |   18 -
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                     |   12 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   24 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   18 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |   11 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c               |   16 +
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c         |   10 -
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                   |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c             |   24 ++
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c     |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c                      |   21 ++
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h                      |    2 
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c                    |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                       |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c                |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                       |   43 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                       |    1 
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c                     |    4 
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c                  |    8 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                       |    1 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                       |    4 
 drivers/gpu/drm/i915/display/intel_dp.c                     |    5 
 drivers/gpu/drm/i915/display/intel_dp_link_training.c       |    2 
 drivers/gpu/drm/radeon/radeon_kms.c                         |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                      |    2 
 drivers/hv/ring_buffer.c                                    |    1 
 drivers/mfd/ab8500-core.c                                   |    2 
 drivers/mfd/axp20x.c                                        |    3 
 drivers/mfd/db8500-prcmu.c                                  |   14 -
 drivers/mfd/lpc_sch.c                                       |    4 
 drivers/mfd/stmpe.c                                         |    4 
 drivers/mfd/tc3589x.c                                       |    2 
 drivers/mfd/tqmx86.c                                        |    2 
 drivers/mfd/wm8994-irq.c                                    |    2 
 drivers/mtd/mtdconcat.c                                     |   33 ++-
 drivers/mtd/nand/raw/cafe_nand.c                            |    4 
 drivers/net/dsa/b53/b53_common.c                            |   34 ++-
 drivers/net/dsa/b53/b53_priv.h                              |    1 
 drivers/net/dsa/bcm_sf2.c                                   |    2 
 drivers/net/dsa/lantiq_gswip.c                              |    6 
 drivers/net/dsa/qca8k.c                                     |   30 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c           |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   38 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c           |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c                |    3 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                   |    1 
 drivers/net/ethernet/chelsio/cxgb3/sge.c                    |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c             |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c  |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c     |   19 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                          |    8 
 drivers/net/ethernet/intel/ice/ice.h                        |    2 
 drivers/net/ethernet/intel/ice/ice_idc.c                    |    6 
 drivers/net/ethernet/intel/igc/igc_main.c                   |    4 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c             |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c    |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c         |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c        |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c           |    4 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c           |    5 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c  |    7 
 drivers/net/ethernet/netronome/nfp/flower/offload.c         |    3 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                   |    6 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c            |    1 
 drivers/net/ethernet/rdc/r6040.c                            |    9 
 drivers/net/ethernet/renesas/sh_eth.c                       |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c        |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   50 +----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |   44 ++++
 drivers/net/ipa/ipa_table.c                                 |    3 
 drivers/net/phy/dp83640_reg.h                               |    2 
 drivers/net/phy/phylink.c                                   |   82 ++++++++
 drivers/net/usb/cdc_mbim.c                                  |    5 
 drivers/net/usb/hso.c                                       |   11 -
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c                |   19 -
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h                |   20 ++
 drivers/ntb/test/ntb_msi_test.c                             |    4 
 drivers/ntb/test/ntb_perf.c                                 |    1 
 drivers/nvme/host/core.c                                    |   15 -
 drivers/nvme/host/tcp.c                                     |   20 +-
 drivers/pci/controller/Kconfig                              |    1 
 drivers/pci/controller/cadence/pci-j721e.c                  |   61 +++++-
 drivers/pci/controller/cadence/pcie-cadence-ep.c            |    4 
 drivers/pci/controller/cadence/pcie-cadence-host.c          |    3 
 drivers/pci/controller/cadence/pcie-cadence.c               |   16 +
 drivers/pci/controller/cadence/pcie-cadence.h               |   17 +
 drivers/pci/controller/dwc/pcie-tegra194.c                  |   32 +--
 drivers/pci/controller/pci-tegra.c                          |   13 -
 drivers/pci/controller/pcie-iproc-bcma.c                    |   16 -
 drivers/pci/controller/pcie-rcar-ep.c                       |    4 
 drivers/pci/hotplug/TODO                                    |    3 
 drivers/pci/hotplug/ibmphp_ebda.c                           |    5 
 drivers/pci/of.c                                            |    2 
 drivers/pci/pci.c                                           |    2 
 drivers/pci/pcie/ptm.c                                      |    4 
 drivers/pci/quirks.c                                        |   58 +++++
 drivers/remoteproc/qcom_wcnss.c                             |   49 +---
 drivers/remoteproc/qcom_wcnss.h                             |    4 
 drivers/remoteproc/qcom_wcnss_iris.c                        |  120 +++++++-----
 drivers/rtc/rtc-cmos.c                                      |    2 
 drivers/s390/char/sclp_early.c                              |    3 
 drivers/vhost/net.c                                         |   11 +
 drivers/video/backlight/ktd253-backlight.c                  |   75 +++++--
 drivers/watchdog/watchdog_dev.c                             |    8 
 drivers/xen/swiotlb-xen.c                                   |    5 
 fs/fuse/dev.c                                               |    4 
 fs/io_uring.c                                               |   33 ++-
 include/linux/pci.h                                         |    5 
 include/linux/pci_ids.h                                     |    3 
 include/linux/phylink.h                                     |    3 
 include/linux/sched.h                                       |    1 
 include/linux/skbuff.h                                      |    2 
 include/net/dsa.h                                           |    5 
 include/net/flow.h                                          |    4 
 include/uapi/linux/pkt_sched.h                              |    2 
 kernel/events/core.c                                        |    2 
 kernel/trace/trace_boot.c                                   |   15 -
 kernel/trace/trace_kprobe.c                                 |    6 
 kernel/trace/trace_probe.c                                  |   25 ++
 kernel/trace/trace_probe.h                                  |    1 
 kernel/trace/trace_uprobe.c                                 |    6 
 net/caif/chnl_net.c                                         |   19 -
 net/dccp/minisocks.c                                        |    2 
 net/dsa/dsa.c                                               |    5 
 net/dsa/dsa2.c                                              |   46 +++-
 net/dsa/dsa_priv.h                                          |    1 
 net/dsa/slave.c                                             |   12 -
 net/dsa/tag_rtl4_a.c                                        |    7 
 net/ethtool/ioctl.c                                         |    2 
 net/ipv4/cipso_ipv4.c                                       |   18 -
 net/ipv4/ip_gre.c                                           |    9 
 net/ipv4/nexthop.c                                          |    2 
 net/ipv4/tcp_input.c                                        |    2 
 net/ipv4/udp_tunnel_nic.c                                   |    2 
 net/ipv6/ip6_gre.c                                          |    2 
 net/ipv6/netfilter/nf_socket_ipv6.c                         |    4 
 net/l2tp/l2tp_core.c                                        |    4 
 net/mptcp/pm_netlink.c                                      |   10 -
 net/mptcp/protocol.c                                        |   97 ++++-----
 net/mptcp/protocol.h                                        |    1 
 net/netfilter/nft_ct.c                                      |    9 
 net/qrtr/qrtr.c                                             |    2 
 net/sched/sch_fq_codel.c                                    |   12 +
 net/tipc/socket.c                                           |   10 -
 net/unix/af_unix.c                                          |    2 
 scripts/clang-tools/gen_compile_commands.py                 |    1 
 tools/build/Makefile                                        |    2 
 tools/perf/Makefile.config                                  |    8 
 tools/perf/bench/inject-buildid.c                           |   52 +++--
 tools/perf/util/config.c                                    |    5 
 tools/perf/util/machine.c                                   |    1 
 tools/testing/selftests/net/altnames.sh                     |    2 
 tools/testing/selftests/net/mptcp/simult_flows.sh           |    4 
 190 files changed, 1620 insertions(+), 765 deletions(-)

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: Add 200ms assert delay

Alex Elder (1):
      net: ipa: initialize all filter table slots

Alexander Egorenkov (1):
      s390/sclp: fix Secure-IPL facility detection

Andrea Claudi (1):
      selftest: net: fix typo in altname test

Andy Shevchenko (1):
      PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Anshuman Khandual (1):
      KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size

Ansuel Smith (1):
      net: dsa: qca8k: fix kernel panic with legacy mdio mapping

Arnaldo Carvalho de Melo (2):
      perf config: Fix caching and memory leak in perf_home_perfconfig()
      perf bench inject-buildid: Handle writen() errors

Arnd Bergmann (1):
      drm/rockchip: cdn-dp-core: Make cdn_dp_core_resume __maybe_unused

Aya Levin (2):
      udp_tunnel: Fix udp_tunnel_nic work-queue type
      net/mlx5e: Fix mutual exclusion between CQE compression and HW TS

Baptiste Lepers (1):
      events: Reuse value read using READ_ONCE instead of re-reading it

Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Bjorn Andersson (1):
      remoteproc: qcom: wcnss: Fix race with iris probe

Chris Wilson (1):
      rtc: cmos: Disable irq around direct invocation of cmos_interrupt()

Christian König (1):
      drm/amdgpu: fix use after free during BO move

Christophe JAILLET (6):
      PCI: tegra: Fix OF node reference leak
      mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'
      gpio: mpc8xxx: Fix a resources leak in the error handling path of 'mpc8xxx_probe()'
      gpio: mpc8xxx: Fix a potential double iounmap call in 'mpc8xxx_probe()'
      gpio: mpc8xxx: Use 'devm_gpiochip_add_data()' to simplify the code and avoid a leak
      iwlwifi: pnvm: Fix a memory leak in 'iwl_pnvm_get_from_fs()'

Curtis Klein (1):
      watchdog: Fix NULL pointer dereference when releasing cdev

Dan Carpenter (2):
      net: qrtr: revert check in qrtr_endpoint_post()
      PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Daniel Wagner (1):
      nvme: avoid race in shutdown namespace removal

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

Dave Ertman (1):
      ice: Correctly deal with PFs that do not support RDMA

David Heidelberg (1):
      dt-bindings: arm: Fix Toradex compatible typo

David Hildenbrand (1):
      s390/pci_mmio: fully validate the VMA before calling follow_pte()

David Thompson (1):
      mlxbf_gige: clear valid_polarity upon open

Dinghao Liu (2):
      PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Dror Moshe (1):
      iwlwifi: move get pnvm file name to a separate function

Edwin Peer (2):
      bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
      bnxt_en: fix stored FW_PSID version masks

Eli Cohen (1):
      net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert

Eric Dumazet (3):
      net-caif: avoid user-triggerable WARN_ON(1)
      net/af_unix: fix a data-race in unix_dgram_poll
      fq_codel: reject silly quantum parameters

Ernst Sjöstrand (1):
      drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan (2):
      PCI: Add AMD GPU multi-function power dependencies
      drm/amd/pm: fix runpm hang when amdgpu loaded prior to sound driver

Florian Fainelli (2):
      r6040: Restore MDIO clock frequency after MAC reset
      net: dsa: bcm_sf2: Fix array overrun in bcm_sf2_num_active_ports()

Ganesh Goudar (1):
      powerpc/mce: Fix access error in mce handler

Geert Uytterhoeven (1):
      PCI: controller: PCI_IXP4XX should depend on ARCH_IXP4XX

George Cherian (1):
      PCI: Add ACS quirks for Cavium multi-function devices

Greg Kroah-Hartman (1):
      Linux 5.14.7

Hans de Goede (1):
      mfd: axp20x: Update AXP288 volatile ranges

Harry Wentland (1):
      drm/amd/display: Get backlight from PWM if DMCU is not initialized

Heiner Kallweit (1):
      cxgb3: fix oops on module removal

Hersen Wu (1):
      drm/amd/display: dsc mst 2 4K displays go dark with 2 lane HBR3

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Ilya Leoshkevich (3):
      s390/bpf: Fix optimizing out zero-extensions
      s390/bpf: Fix 64-bit subtraction of the -0x80000000 constant
      s390/bpf: Fix branch shortening during codegen pass

Jakub Kicinski (1):
      PCI/PTM: Remove error message at boot

James Clark (1):
      tools build: Fix feature detect clean for out of source builds

James Zhu (3):
      drm/amdgpu: add amdgpu_amdkfd_resume_iommu
      drm/amdgpu: move iommu_resume before ip init/resume
      drm/amdkfd: separate kfd_iommu_resume from kfd_resume

Jan Beulich (2):
      swiotlb-xen: avoid double free
      swiotlb-xen: fix late init retry

Jan Kiszka (1):
      watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate

Jeff Moyer (1):
      x86/pat: Pass valid address to sanitize_phys()

Jens Axboe (2):
      io_uring: ensure symmetry in handling iter types in loop_rw_iter()
      io_uring: allow retry for O_NONBLOCK if async is supported

Jiaran Zhang (2):
      net: hns3: fix the timing issue of VF clearing interrupt sources
      net: hns3: fix the exception when query imp info

Joakim Zhang (3):
      net: stmmac: fix MAC not working when system resume back with WoL active
      net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
      net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP

Juergen Gross (3):
      xen: reset legacy rtc flag for PV domU
      xen: fix usage of pmd_populate in mremap for pv guests
      PM: base: power: don't try to use non-existing RTC for storing data

Kai-Heng Feng (1):
      drm/i915/dp: Use max params for panels < eDP 1.4

Keith Busch (1):
      nvme-tcp: fix io_work priority inversion

Kenneth Feng (1):
      drm/amd/pm: fix the issue of uploading powerplay table

Kenneth Lee (1):
      riscv: fix the global name pfn_base confliction error

Kishon Vijay Abraham I (3):
      PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool
      PCI: j721e: Add PCIe support for J7200
      PCI: j721e: Add PCIe support for AM64

Kortan (1):
      gen_compile_commands: fix missing 'sys' package

Lee Shawn C (1):
      drm/i915/dp: return proper DPRX link training result

Li Huafei (1):
      perf unwind: Do not overwrite FEATURE_CHECK_LDFLAGS-libunwind-{x86,aarch64}

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Linus Walleij (3):
      mfd: db8500-prcmu: Adjust map to reality
      backlight: ktd253: Stabilize backlight
      net: dsa: tag_rtl4_a: Fix egress tags

Lucas Stach (8):
      drm/etnaviv: return context from etnaviv_iommu_context_get
      drm/etnaviv: put submit prev MMU context when it exists
      drm/etnaviv: stop abusing mmu_context as FE running marker
      drm/etnaviv: keep MMU context across runtime suspend/resume
      drm/etnaviv: exec and MMU state is lost when resetting the GPU
      drm/etnaviv: fix MMU context leak on GPU reset
      drm/etnaviv: reference MMU context when setting up hardware state
      drm/etnaviv: add missing MMU context put when reaping MMU mapping

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Marc Zyngier (1):
      mfd: Don't use irq_create_mapping() to resolve a mapping

Mark Brown (1):
      arm64/sve: Use correct size when reinitialising SVE state

Masami Hiramatsu (2):
      tracing/probes: Reject events which have the same name of existing one
      tracing/boot: Fix a hist trigger dependency for boot time tracing

Mat Martineau (1):
      mptcp: Only send extra TCP acks in eligible socket states

Matthias Schiffer (1):
      mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set

Matthieu Baerts (1):
      selftests: mptcp: clean tmp files in simult_flows

Michael Chan (3):
      bnxt_en: Fix asic.rev in devlink dev info command
      bnxt_en: Fix possible unintended driver initiated error recovery
      bnxt_en: Fix error recovery regression

Michael Petlan (1):
      perf machine: Initialize srcline string member in add_location struct

Mike Rapoport (1):
      x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Miklos Szeredi (1):
      fuse: fix use after free in fuse_read_interrupt()

Ming Lei (1):
      io_uring: retry in case of short read on block device

Miquel Raynal (1):
      dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Nadeem Athani (1):
      PCI: cadence: Add quirk flag to set minimum delay in LTSSM Detect.Quiet state

Nicholas Kazlauskas (1):
      drm/amd/display: Fix white screen page fault for gpuvm

Nicholas Piggin (3):
      powerpc/64s: system call scv tabort fix for corrupt irq soft-mask state
      KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers
      powerpc/64s: system call rfscv workaround for TM bugs

Nirmoy Das (2):
      drm/amdgpu: use IS_ERR for debugfs APIs
      drm/radeon: pass drm dev radeon_agp_head_init directly

Oliver Upton (2):
      KVM: arm64: Fix read-side race on updates to vcpu reset state
      KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Om Prakash Singh (2):
      PCI: tegra194: Fix handling BME_CHGED event
      PCI: tegra194: Fix MSI-X programming

Paolo Abeni (3):
      igc: fix tunnel offloading
      vhost_net: fix OoB on sendmsg() failure.
      mptcp: fix possible divide by zero

Paolo Valente (1):
      block, bfq: honor already-setup queue merges

Pavel Skripkin (1):
      netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

Rafał Miłecki (3):
      net: dsa: b53: Fix calculating number of switch ports
      net: dsa: b53: Set correct number of ports in the DSA struct
      net: dsa: b53: Fix IMP port setup on BCM5301x

Randy Dunlap (3):
      ptp: dp83640: don't define PAGE0
      ARC: export clear_user_page() for modules
      mfd: lpc_sch: Rename GPIOBASE to prevent build error

Rob Herring (2):
      PCI: of: Don't fail devm_pci_alloc_host_bridge() on missing 'ranges'
      PCI: iproc: Fix BCMA probe resource handling

Russell King (Oracle) (1):
      net: phylink: add suspend/resume support

Ryoga Saito (1):
      Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

Saeed Mahameed (2):
      ethtool: Fix rxnfc copy to user buffer overflow
      net/mlx5: FWTrace, cancel work on alloc pd error flow

Shai Malin (1):
      qed: Handle management FW error

Smadar Fuks (1):
      octeontx2-af: Add additional register check to rvu_poll_reg()

Sukadev Bhattiprolu (1):
      ibmvnic: check failover_pending in login response

Tetsuo Handa (2):
      flow: fix object-size-mismatch warning in flowi{4,6}_to_flowi_common()
      loop: reduce the loop_ctl_mutex scope

Tony Luck (1):
      x86/mce: Avoid infinite loop for copy from user recovery

Vishal Aslot (1):
      PCI: ibmphp: Fix double unmap of io_mem

Vitaly Kuznetsov (1):
      Drivers: hv: vmbus: Fix kernel crash upon unbinding a device from uio_hv_generic driver

Vladimir Oltean (2):
      net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
      net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports

Wasim Khan (1):
      PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms

Will Deacon (2):
      x86/uaccess: Fix 32-bit __get_user_asm_u64() when CC_HAS_ASM_GOTO_OUTPUT=y
      KVM: arm64: Make hyp_panic() more robust when protected mode is enabled

Willem de Bruijn (2):
      ip_gre: validate csum_start only on pull
      ip6_gre: Revert "ip6_gre: add validation for csum_start"

Xin Long (1):
      tipc: fix an use-after-free issue in tipc_recvmsg

Xiyu Yang (1):
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yanfei Xu (1):
      blkcg: fix memory leak in blk_iolatency_init

Yang Li (3):
      ethtool: Fix an error code in cxgb2.c
      NTB: Fix an error code in ntb_msit_probe()
      NTB: perf: Fix an error code in perf_setup_inbuf()

Yoshihiro Shimoda (1):
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Yufeng Mo (3):
      net: hns3: pad the short tunnel frame before sending to hardware
      net: hns3: change affinity_mask to numa node range
      net: hns3: disable mac in flr process

Zhihao Cheng (2):
      mtd: mtdconcat: Judge callback existence based on the master
      mtd: mtdconcat: Check _read, _write callbacks existence before assignment

Ziyang Xuan (1):
      net: hso: add failure handler for add_net_device

zhaoxiao (1):
      stmmac: dwmac-loongson:Fix missing return value

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

王贇 (1):
      net: remove the unnecessary check in cipso_v4_doi_free

