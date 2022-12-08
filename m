Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14904646D21
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLHKim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLHKiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:38:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1E38BD39;
        Thu,  8 Dec 2022 02:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6C2B81BF1;
        Thu,  8 Dec 2022 10:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17947C433C1;
        Thu,  8 Dec 2022 10:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495653;
        bh=USG9OKQOsZQG2b/bqapBulSW2nx6s6Ic33g8L3OH+LE=;
        h=From:To:Cc:Subject:Date:From;
        b=Q/HI6R9B/qh1+UcOVci001oU3lgqQ5/40i5lP3SnjtgU9jHGqpzmmFMJ5P+cksW8H
         7IxJImDt7PV8v5u9gOdmRgJrFdvIsibe02kBEq9SOeQ2VVmFHC1uroFlRsTPrpaZpo
         fMned4RtLXscKNPMTXW/SxrBadmhmWfR9meIQ/mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.12
Date:   Thu,  8 Dec 2022 11:34:09 +0100
Message-Id: <1670495650110110@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.12 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                           |    2 
 arch/arm/boot/dts/at91rm9200.dtsi                                  |    2 
 arch/powerpc/net/bpf_jit_comp32.c                                  |   52 +---
 arch/riscv/include/asm/asm.h                                       |    1 
 arch/riscv/include/asm/efi.h                                       |    6 
 arch/riscv/include/asm/pgalloc.h                                   |   11 
 arch/riscv/kernel/entry.S                                          |   13 +
 arch/riscv/kernel/machine_kexec.c                                  |   35 ++
 arch/riscv/kernel/setup.c                                          |    9 
 arch/riscv/kernel/traps.c                                          |   18 +
 arch/riscv/kernel/vdso/Makefile                                    |    1 
 arch/x86/include/asm/nospec-branch.h                               |    2 
 arch/x86/kernel/cpu/bugs.c                                         |   21 +
 arch/x86/kernel/process.c                                          |    2 
 drivers/acpi/numa/hmat.c                                           |   27 +-
 drivers/char/tpm/tpm-interface.c                                   |    5 
 drivers/clk/at91/at91rm9200.c                                      |    2 
 drivers/clk/qcom/gcc-sc8280xp.c                                    |    6 
 drivers/clk/qcom/gdsc.c                                            |   70 +----
 drivers/clk/qcom/gdsc.h                                            |    2 
 drivers/clk/samsung/clk-exynos7885.c                               |    4 
 drivers/clocksource/arm_arch_timer.c                               |    7 
 drivers/clocksource/timer-riscv.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                   |   12 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h                        |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                             |   60 +----
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                            |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                            |   17 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                            |   53 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h                            |   14 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c                            |    3 
 drivers/gpu/drm/amd/display/Kconfig                                |    7 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |  111 ++++++---
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h |  117 ++++++----
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    5 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                     |    3 
 drivers/gpu/drm/i915/gt/intel_gt.c                                 |    9 
 drivers/gpu/drm/i915/gt/intel_gt_requests.c                        |    2 
 drivers/hwmon/asus-ec-sensors.c                                    |    2 
 drivers/hwmon/coretemp.c                                           |    9 
 drivers/hwmon/i5500_temp.c                                         |    2 
 drivers/hwmon/ibmpex.c                                             |    1 
 drivers/hwmon/ina3221.c                                            |    4 
 drivers/hwmon/ltc2947-core.c                                       |    2 
 drivers/i2c/busses/i2c-imx.c                                       |    6 
 drivers/i2c/busses/i2c-npcm7xx.c                                   |   11 
 drivers/i2c/busses/i2c-qcom-geni.c                                 |    1 
 drivers/i2c/i2c-core-base.c                                        |    9 
 drivers/iio/health/afe4403.c                                       |    5 
 drivers/iio/health/afe4404.c                                       |   12 -
 drivers/iio/light/Kconfig                                          |    2 
 drivers/input/touchscreen/raydium_i2c_ts.c                         |    4 
 drivers/iommu/intel/dmar.c                                         |    1 
 drivers/iommu/intel/iommu.c                                        |    4 
 drivers/media/common/videobuf2/frame_vector.c                      |   68 +----
 drivers/mmc/core/core.c                                            |    9 
 drivers/mmc/core/mmc_test.c                                        |    3 
 drivers/mmc/host/mtk-sd.c                                          |    6 
 drivers/mmc/host/sdhci-esdhc-imx.c                                 |    2 
 drivers/mmc/host/sdhci-sprd.c                                      |    4 
 drivers/mmc/host/sdhci.c                                           |   61 ++++-
 drivers/mmc/host/sdhci.h                                           |    2 
 drivers/net/can/can327.c                                           |    4 
 drivers/net/can/cc770/cc770_isa.c                                  |   10 
 drivers/net/can/m_can/m_can.c                                      |    2 
 drivers/net/can/m_can/m_can_pci.c                                  |    9 
 drivers/net/can/sja1000/sja1000_isa.c                              |   10 
 drivers/net/can/usb/etas_es58x/es58x_core.c                        |    5 
 drivers/net/dsa/lan9303-core.c                                     |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c                |    5 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c                   |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_main.h                   |    2 
 drivers/net/ethernet/intel/e100.c                                  |    5 
 drivers/net/ethernet/intel/fm10k/fm10k_main.c                      |   10 
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |   11 
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |    9 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                  |   10 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h                  |    8 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |    7 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c                  |    9 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c        |    5 
 drivers/net/ethernet/ni/nixge.c                                    |   29 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                |    4 
 drivers/net/ethernet/renesas/ravb_main.c                           |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                  |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |   12 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                           |    2 
 drivers/net/mdio/fwnode_mdio.c                                     |    2 
 drivers/net/ntb_netdev.c                                           |    9 
 drivers/net/phy/phy_device.c                                       |    2 
 drivers/net/tun.c                                                  |    4 
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c                         |   26 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol.h                          |    2 
 drivers/nvme/host/core.c                                           |    2 
 drivers/nvme/host/multipath.c                                      |    3 
 drivers/nvmem/rmem.c                                               |    4 
 drivers/of/property.c                                              |    4 
 drivers/pinctrl/intel/pinctrl-intel.c                              |   27 ++
 drivers/pinctrl/pinctrl-single.c                                   |    2 
 fs/afs/fs_probe.c                                                  |    4 
 fs/afs/server.c                                                    |    2 
 fs/btrfs/qgroup.c                                                  |    9 
 fs/ksmbd/vfs.c                                                     |    6 
 fs/nfsd/vfs.c                                                      |    4 
 fs/nilfs2/dat.c                                                    |    7 
 fs/read_write.c                                                    |   19 +
 include/linux/damon.h                                              |   37 +--
 include/linux/fs.h                                                 |    8 
 include/linux/mmc/mmc.h                                            |    2 
 include/net/sctp/stream_sched.h                                    |    2 
 ipc/sem.c                                                          |    3 
 kernel/bpf/bpf_local_storage.c                                     |    2 
 kernel/events/core.c                                               |    2 
 kernel/sysctl.c                                                    |   30 +-
 kernel/trace/trace_dynevent.c                                      |    2 
 kernel/trace/trace_events.c                                        |   11 
 kernel/trace/trace_events_hist.c                                   |    3 
 kernel/trace/trace_osnoise.c                                       |    6 
 lib/Kconfig.debug                                                  |    9 
 mm/compaction.c                                                    |   22 -
 mm/damon/core.c                                                    |   31 +-
 mm/damon/dbgfs.c                                                   |   27 +-
 mm/damon/lru_sort.c                                                |   46 ++-
 mm/damon/reclaim.c                                                 |   23 +
 mm/damon/sysfs.c                                                   |   63 ++++-
 net/9p/trans_fd.c                                                  |    4 
 net/hsr/hsr_forward.c                                              |    5 
 net/ipv4/fib_semantics.c                                           |   10 
 net/mac80211/airtime.c                                             |    3 
 net/mptcp/protocol.c                                               |   13 -
 net/mptcp/subflow.c                                                |    6 
 net/packet/af_packet.c                                             |    6 
 net/sctp/stream.c                                                  |   25 +-
 net/sctp/stream_sched.c                                            |    5 
 net/sctp/stream_sched_prio.c                                       |   19 +
 net/sctp/stream_sched_rr.c                                         |    5 
 net/tipc/crypto.c                                                  |    3 
 net/wireless/scan.c                                                |   10 
 scripts/faddr2line                                                 |    7 
 sound/firewire/dice/dice-stream.c                                  |   12 -
 sound/soc/codecs/tlv320adc3xxx.c                                   |    3 
 sound/soc/soc-ops.c                                                |    2 
 tools/lib/bpf/libbpf.c                                             |    2 
 tools/lib/bpf/ringbuf.c                                            |   12 -
 tools/testing/selftests/net/fib_nexthops.sh                        |   16 +
 tools/vm/slabinfo-gnuplot.sh                                       |    4 
 151 files changed, 1152 insertions(+), 628 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix voltage switch delay

Alexandre Ghiti (1):
      riscv: Sync efi page table's kernel mappings before switching

Amir Goldstein (1):
      vfs: fix copy_file_range() averts filesystem freeze protection

Andrew Lunn (1):
      i2c: imx: Only DMA messages with I2C_M_DMA_SAFE flag set

Andy Shevchenko (1):
      pinctrl: intel: Save and restore pins in "direct IRQ" mode

Björn Töpel (1):
      riscv: mm: Proper page permissions after initmem free

Caleb Sander (1):
      nvme: fix SRCU protection of nvme_ns_head list

ChenXiaoSong (1):
      btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Chris Mi (3):
      net/mlx5: E-switch, Destroy legacy fdb table when needed
      net/mlx5: E-switch, Fix duplicate lag creation
      net/mlx5: Lag, Fix for loop when checking lag

Christian König (3):
      drm/amdgpu: move setting the job resources
      drm/amdgpu: cleanup error handling in amdgpu_cs_parser_bos
      drm/amdgpu: fix userptr HMM range handling v2

Christian Löhle (1):
      mmc: core: Fix ambiguous TRIM and DISCARD arg

Christophe Leroy (1):
      powerpc/bpf/32: Fix Oops on tail call tests

Conor Dooley (1):
      Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"

Daniel Bristot de Oliveira (1):
      tracing/osnoise: Fix duration type

David Ahern (1):
      ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

David Howells (1):
      afs: Fix fileserver probe RTT handling

David Virag (1):
      clk: samsung: exynos7885: Correct "div4" clock parents

Derek Nguyen (1):
      hwmon: (ltc2947) fix temperature scaling

Duoming Zhou (1):
      qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Gaosheng Cui (2):
      hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails
      mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()

Gavin Shan (1):
      mm: migrate: fix THP's mapcount on isolation

Goh, Wei Sheng (1):
      net: stmmac: Set MAC's flow control register to reflect current settings

Greg Kroah-Hartman (1):
      Linux 6.0.12

Guo Ren (1):
      riscv: kexec: Fixup irq controller broken in kexec crash path

Hou Tao (2):
      bpf, perf: Use subprog name when reporting subprog ksymbol
      libbpf: Handle size overflow for ringbuf mmap

Hui Tang (1):
      ASoC: tlv320adc3xxx: Fix build error for implicit function declaration

Ido Schimmel (1):
      ipv4: Fix route deletion when nexthop info is not specified

Izabela Bakollari (1):
      aquantia: Do not purge addresses when setting the number of rings

Jan Dabros (1):
      char: tpm: Protect tpm_pm_suspend with locks

Jann Horn (1):
      ipc/sem: Fix dangling sem_array access in semtimedop race

Janusz Krzysztofik (2):
      drm/i915: Fix negative value passed as remaining time
      drm/i915: Never return 0 if not all requests retired

Jerry Ray (1):
      dsa: lan9303: Correct stat name

Jiasheng Jiang (1):
      can: m_can: Add check for devm_clk_get

Jiri Olsa (1):
      libbpf: Use correct return pointer in attach_raw_tp

Jisheng Zhang (2):
      riscv: vdso: fix section overlapping under some conditions
      riscv: fix race when vmap stack overflow

Joe Korty (1):
      clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error

Johan Hovold (1):
      clk: qcom: gdsc: add missing error handling

Johannes Berg (2):
      wifi: cfg80211: fix buffer overflow in elem comparison
      wifi: cfg80211: don't allow multi-BSSID in S1G

Kenneth Feng (1):
      drm/amd/pm: update driver-if header for smu_v13_0_10

Lee Jones (2):
      Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
      drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame

Leo Liu (1):
      drm/amdgpu: enable Vangogh VCN indirect sram mode

Linus Torvalds (3):
      v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails
      proc: avoid integer type confusion in get_proc_long
      proc: proc_skip_spaces() shouldn't think it is working on C strings

Lorenzo Bianconi (1):
      wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

M Chetan Kumar (4):
      net: wwan: iosm: fix kernel test robot reported error
      net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
      net: wwan: iosm: fix crash in peek throughput test
      net: wwan: iosm: fix incorrect skb length

Marc Dionne (1):
      afs: Fix server->active leak in afs_put_server

Mark Brown (1):
      ASoC: ops: Fix bounds check for _sx controls

Maxim Korotkov (1):
      pinctrl: single: Fix potential division by zero

Menglong Dong (1):
      mptcp: don't orphan ssk in mptcp_close()

Michael Grzeschik (1):
      ARM: at91: rm9200: fix usb device clock id

Ninad Malwade (1):
      hwmon: (ina3221) Fix shunt sum critical calculation

Paolo Abeni (1):
      mptcp: fix sleep in atomic at close time

Paul Gazzillo (1):
      iio: light: rpr0521: add missing Kconfig dependencies

Pawan Gupta (1):
      x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

Phil Auld (1):
      hwmon: (coretemp) Check for null before removing sysfs attrs

Ricardo Ribalda (1):
      i2c: Restore initial power state if probe fails

Roi Dayan (1):
      net/mlx5e: Fix use-after-free when reverting termination table

Sebastian Falbesoner (1):
      mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check

SeongJae Park (1):
      mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()

Shang XiaoJing (2):
      ixgbevf: Fix resource leak in ixgbevf_init_module()
      i40e: Fix error handling in i40e_init_module()

Shazad Hussain (1):
      clk: qcom: gcc-sc8280xp: add cxo as parent for three ufs ref clks

Shigeru Yoshida (1):
      net: tun: Fix use-after-free in tun_detach()

Srikar Dronamraju (1):
      scripts/faddr2line: Fix regression in name resolution on ppc64le

Stephen Boyd (1):
      clk: qcom: gdsc: Remove direct runtime PM calls

Steven Rostedt (Google) (3):
      error-injection: Add prompt for function error injection
      tracing: Fix race where histograms can be called before the event
      tracing: Free buffers when a used dynamic event is removed

Takashi Sakamoto (1):
      ALSA: dice: fix regression for Lexicon I-ONIX FW810S

Tiezhu Yang (1):
      tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Vishal Verma (2):
      ACPI: HMAT: remove unnecessary variable initialization
      ACPI: HMAT: Fix initiator registration for single-initiator systems

Wang Hai (2):
      e100: Fix possible use after free in e100_xmit_prepare
      net/9p: Fix a potential socket leak in p9_socket_open

Wang Yufen (1):
      i2c: qcom-geni: fix error return code in geni_i2c_gpi_xfer

Wei Yongjun (3):
      iio: health: afe4403: Fix oob read in afe4403_read_raw
      iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw
      nvmem: rmem: Fix return value check in rmem_read()

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix no reset data and command after voltage switch

Willem de Bruijn (1):
      packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Xin Long (1):
      tipc: re-fetch skb cb after tipc_msg_validate

Xiongfeng Wang (2):
      iommu/vt-d: Fix PCI device refcount leak in has_external_pci()
      iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Xu Kuohai (1):
      bpf: Do not copy spin lock field from user in bpf_selem_alloc

Yajun Deng (1):
      mm/damon: introduce struct damos_access_pattern

Yang Wang (1):
      drm/amd/pm: add smu_v13_0_10 driver if version

Yang Yingliang (5):
      hwmon: (i5500_temp) fix missing pci_disable_device()
      of: property: decrement node refcount in of_fwnode_get_reference_args()
      net: phy: fix null-ptr-deref while probe() failed
      net: mdiobus: fix unbalanced node reference count
      hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Ye Bin (1):
      mmc: mmc_test: Fix removal of debugfs file

Yoshihiro Shimoda (1):
      net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Yuan Can (5):
      fm10k: Fix error handling in fm10k_init_module()
      iavf: Fix error handling in iavf_init_module()
      net: net_netdev: Fix error handling in ntb_netdev_init_module()
      hwmon: (asus-ec-sensors) Add checks for devm_kcalloc
      i2c: npcm7xx: Fix error handling in npcm_i2c_init()

YueHaibing (3):
      net/mlx5: DR, Fix uninitialized var warning
      net/mlx5: Fix uninitialized variable bug in outlen_write()
      net: hsr: Fix potential use-after-free

Yuri Karpov (1):
      net: ethernet: nixge: fix NULL dereference

Zhang Changzhong (5):
      can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
      can: cc770: cc770_isa_probe(): add missing free_cc770dev()
      can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
      can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
      net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()

Zhang Xiaoxu (1):
      Input: raydium_ts_i2c - fix memory leak in raydium_i2c_send()

ZhangPeng (1):
      nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Zhengchao Shao (1):
      sctp: fix memory leak in sctp_stream_outq_migrate()

Ziyang Xuan (1):
      can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down

lyndonli (1):
      drm/amd/pm: update driver if header for smu_13_0_7

