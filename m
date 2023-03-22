Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBBB6C542B
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCVSxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjCVSxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:53:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5458E2D4C;
        Wed, 22 Mar 2023 11:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6414B81DBF;
        Wed, 22 Mar 2023 18:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F077AC433EF;
        Wed, 22 Mar 2023 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511180;
        bh=31PW6xDP9hW2wnR79pa3xYTzuFilup7tkUKtFNNX3uA=;
        h=From:To:Cc:Subject:Date:From;
        b=f4mxE6FJLtZiryq6DuJpUFcqUDA+Kpzs7DE0tItqMKI5msiyUMpvznB57PGuGt5OG
         3gJPqXoIbQ65ptmTMQRZTfCqsNvY3ZozWhEHBwV7jwbm0PMoWzZyiMLmVZ4/VN1iTC
         Pd4Xpn0Zn7JilrmlFHv/2cL9Iuv98zOs9mvJC0bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.21
Date:   Wed, 22 Mar 2023 19:52:52 +0100
Message-Id: <16795111732969@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.21 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/vfs.rst                                  |    2 
 Makefile                                                           |    2 
 arch/loongarch/kernel/time.c                                       |   11 
 arch/powerpc/Makefile                                              |   26 -
 arch/powerpc/boot/Makefile                                         |   14 
 arch/powerpc/mm/fault.c                                            |   11 
 arch/powerpc/platforms/Kconfig.cputype                             |   20 
 arch/riscv/include/asm/mmu.h                                       |    2 
 arch/riscv/include/asm/tlbflush.h                                  |   18 
 arch/riscv/mm/context.c                                            |   40 -
 arch/riscv/mm/tlbflush.c                                           |   28 -
 arch/s390/boot/ipl_report.c                                        |    8 
 arch/s390/pci/pci.c                                                |   16 
 arch/s390/pci/pci_bus.c                                            |   12 
 arch/s390/pci/pci_bus.h                                            |    3 
 arch/x86/Makefile.um                                               |    6 
 arch/x86/include/asm/sev-common.h                                  |    3 
 arch/x86/include/asm/svm.h                                         |   12 
 arch/x86/kernel/cpu/mce/core.c                                     |    1 
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c                          |    7 
 arch/x86/kernel/cpu/resctrl/internal.h                             |    1 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                             |   25 +
 arch/x86/kernel/ftrace_64.S                                        |    2 
 arch/x86/kernel/sev.c                                              |   26 -
 arch/x86/kvm/svm/avic.c                                            |   26 -
 arch/x86/kvm/vmx/nested.c                                          |   10 
 arch/x86/mm/mem_encrypt_identity.c                                 |    3 
 block/blk-mq.c                                                     |    5 
 drivers/acpi/pptt.c                                                |    5 
 drivers/block/loop.c                                               |   25 -
 drivers/block/null_blk/main.c                                      |    6 
 drivers/block/sunvdc.c                                             |    2 
 drivers/clk/Kconfig                                                |    2 
 drivers/cpuidle/cpuidle-psci-domain.c                              |    3 
 drivers/firmware/xilinx/zynqmp.c                                   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                            |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                            |   11 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                            |    9 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c                 |    3 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c              |    6 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c     |    5 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |    4 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c            |   43 +-
 drivers/gpu/drm/drm_gem.c                                          |    9 
 drivers/gpu/drm/drm_gem_shmem_helper.c                             |    9 
 drivers/gpu/drm/i915/display/intel_display_types.h                 |    2 
 drivers/gpu/drm/i915/display/intel_psr.c                           |   78 +++
 drivers/gpu/drm/i915/display/intel_snps_phy.c                      |   62 +++
 drivers/gpu/drm/i915/gt/intel_sseu.h                               |    2 
 drivers/gpu/drm/i915/i915_active.c                                 |   25 -
 drivers/gpu/drm/meson/meson_vpp.c                                  |    2 
 drivers/gpu/drm/msm/msm_gem_shrinker.c                             |   11 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                            |    2 
 drivers/gpu/drm/sun4i/sun4i_drv.c                                  |    6 
 drivers/gpu/drm/ttm/ttm_device.c                                   |    2 
 drivers/gpu/drm/virtio/virtgpu_vq.c                                |    4 
 drivers/hwmon/adt7475.c                                            |    8 
 drivers/hwmon/ina3221.c                                            |    2 
 drivers/hwmon/ltc2992.c                                            |    1 
 drivers/hwmon/pmbus/adm1266.c                                      |    1 
 drivers/hwmon/pmbus/ucd9000.c                                      |   75 +++
 drivers/hwmon/tmp513.c                                             |    2 
 drivers/hwmon/xgene-hwmon.c                                        |    1 
 drivers/interconnect/core.c                                        |   68 ++-
 drivers/interconnect/imx/imx.c                                     |   20 
 drivers/interconnect/qcom/icc-rpm.c                                |   29 -
 drivers/interconnect/qcom/icc-rpmh.c                               |   30 -
 drivers/interconnect/qcom/msm8974.c                                |   20 
 drivers/interconnect/qcom/osm-l3.c                                 |   14 
 drivers/interconnect/samsung/exynos.c                              |   26 -
 drivers/md/Kconfig                                                 |    4 
 drivers/media/i2c/m5mols/m5mols_core.c                             |    2 
 drivers/memory/tegra/mc.c                                          |   16 
 drivers/memory/tegra/tegra124-emc.c                                |   12 
 drivers/memory/tegra/tegra20-emc.c                                 |   12 
 drivers/memory/tegra/tegra30-emc.c                                 |   12 
 drivers/mmc/host/atmel-mci.c                                       |    3 
 drivers/mmc/host/sdhci_am654.c                                     |    2 
 drivers/net/bonding/bond_main.c                                    |   23 -
 drivers/net/dsa/microchip/ksz_common.c                             |    2 
 drivers/net/dsa/mt7530.c                                           |   64 +--
 drivers/net/dsa/mv88e6xxx/chip.c                                   |   16 
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c                   |   28 +
 drivers/net/ethernet/i825xx/sni_82596.c                            |   14 
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |    1 
 drivers/net/ethernet/intel/ice/ice.h                               |   14 
 drivers/net/ethernet/intel/ice/ice_main.c                          |   19 
 drivers/net/ethernet/intel/ice/ice_xsk.c                           |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                       |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                   |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    |   20 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h                    |    2 
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c          |  203 +---------
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |   31 -
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                     |    4 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                |   22 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                     |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c              |   14 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                          |    5 
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c                      |    2 
 drivers/net/ethernet/renesas/ravb_main.c                           |   12 
 drivers/net/ethernet/renesas/sh_eth.c                              |   12 
 drivers/net/ethernet/sun/ldmvsw.c                                  |    3 
 drivers/net/ethernet/sun/sunvnet.c                                 |    3 
 drivers/net/ipvlan/ipvlan_l3s.c                                    |    1 
 drivers/net/phy/nxp-c45-tja11xx.c                                  |    2 
 drivers/net/phy/smsc.c                                             |    5 
 drivers/net/usb/smsc75xx.c                                         |    7 
 drivers/net/veth.c                                                 |    6 
 drivers/nfc/pn533/usb.c                                            |    1 
 drivers/nfc/st-nci/ndlc.c                                          |    6 
 drivers/nvme/host/core.c                                           |   28 -
 drivers/nvme/host/pci.c                                            |    2 
 drivers/nvme/target/core.c                                         |    4 
 drivers/pci/bus.c                                                  |   21 +
 drivers/scsi/hosts.c                                               |    3 
 drivers/scsi/mpi3mr/mpi3mr.h                                       |    5 
 drivers/scsi/mpi3mr/mpi3mr_fw.c                                    |   71 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c                                    |   25 +
 drivers/scsi/mpi3mr/mpi3mr_transport.c                             |    5 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                           |   14 
 drivers/scsi/scsi.c                                                |    3 
 drivers/scsi/scsi_devinfo.c                                        |    3 
 drivers/scsi/scsi_scan.c                                           |    3 
 drivers/soc/mediatek/mtk-svs.c                                     |    6 
 drivers/tty/serial/8250/8250_em.c                                  |    4 
 drivers/tty/serial/8250/8250_fsl.c                                 |    4 
 drivers/tty/serial/8250/Kconfig                                    |    3 
 drivers/tty/serial/Kconfig                                         |    2 
 drivers/tty/serial/fsl_lpuart.c                                    |   12 
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                                 |    1 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                  |    6 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                   |   13 
 drivers/vdpa/virtio_pci/vp_vdpa.c                                  |    2 
 drivers/vhost/vdpa.c                                               |    3 
 drivers/video/fbdev/chipsfb.c                                      |   14 
 drivers/video/fbdev/core/fb_defio.c                                |   17 
 drivers/video/fbdev/stifb.c                                        |   27 +
 drivers/virt/coco/sev-guest/sev-guest.c                            |  128 +++---
 fs/cifs/smb2inode.c                                                |   31 +
 fs/cifs/smb2transport.c                                            |    2 
 fs/cifs/transport.c                                                |   21 -
 fs/ext4/inode.c                                                    |   18 
 fs/ext4/namei.c                                                    |    4 
 fs/ext4/super.c                                                    |    7 
 fs/ext4/xattr.c                                                    |   11 
 fs/jffs2/file.c                                                    |   15 
 fs/ocfs2/aops.c                                                    |   19 
 include/drm/drm_bridge.h                                           |    4 
 include/drm/drm_gem.h                                              |    4 
 include/linux/blk-mq.h                                             |    6 
 include/linux/fb.h                                                 |    1 
 include/linux/interconnect-provider.h                              |   12 
 include/linux/netdevice.h                                          |    6 
 include/linux/pci.h                                                |    1 
 include/linux/sh_intc.h                                            |    5 
 include/linux/tracepoint.h                                         |   15 
 include/scsi/scsi_device.h                                         |    2 
 include/scsi/scsi_devinfo.h                                        |    6 
 io_uring/msg_ring.c                                                |    4 
 kernel/events/core.c                                               |    2 
 kernel/trace/ftrace.c                                              |    3 
 kernel/trace/trace.c                                               |    2 
 kernel/trace/trace_events_hist.c                                   |    3 
 kernel/trace/trace_hwlat.c                                         |    7 
 mm/huge_memory.c                                                   |    6 
 mm/mincore.c                                                       |    2 
 net/9p/client.c                                                    |    2 
 net/dsa/slave.c                                                    |    9 
 net/ipv4/fib_frontend.c                                            |    3 
 net/ipv4/inet_hashtables.c                                         |    8 
 net/ipv4/ip_tunnel.c                                               |   12 
 net/ipv4/tcp_output.c                                              |    2 
 net/ipv6/ip6_tunnel.c                                              |    4 
 net/iucv/iucv.c                                                    |    2 
 net/mptcp/pm_netlink.c                                             |   16 
 net/mptcp/subflow.c                                                |   12 
 net/netfilter/nft_masq.c                                           |    2 
 net/netfilter/nft_nat.c                                            |    2 
 net/netfilter/nft_redir.c                                          |    4 
 net/smc/smc_cdc.c                                                  |    3 
 net/smc/smc_core.c                                                 |    2 
 net/wireless/nl80211.c                                             |   18 
 net/xfrm/xfrm_state.c                                              |    5 
 scripts/kconfig/confdata.c                                         |    6 
 sound/hda/intel-dsp-config.c                                       |    9 
 sound/pci/hda/hda_intel.c                                          |    5 
 sound/pci/hda/patch_realtek.c                                      |    2 
 sound/soc/intel/common/soc-acpi-intel-adl-match.c                  |    2 
 sound/soc/qcom/qdsp6/q6prm.c                                       |    4 
 sound/soc/sof/intel/pci-apl.c                                      |    1 
 sound/soc/sof/intel/pci-cnl.c                                      |    2 
 sound/soc/sof/intel/pci-icl.c                                      |    1 
 sound/soc/sof/intel/pci-mtl.c                                      |    1 
 sound/soc/sof/intel/pci-skl.c                                      |    2 
 sound/soc/sof/intel/pci-tgl.c                                      |    7 
 sound/soc/sof/ipc4-topology.h                                      |    2 
 tools/testing/selftests/lib.mk                                     |    2 
 tools/testing/selftests/net/devlink_port_split.py                  |   36 +
 205 files changed, 1548 insertions(+), 900 deletions(-)

Alex Hung (1):
      drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Andrea Righi (1):
      drm/i915/sseu: fix max_subslices array-index-out-of-bounds access

Ankit Nautiyal (1):
      drm/i915/dg2: Add HDMI pixel clock frequencies 267.30 and 319.89 MHz

Arnd Bergmann (1):
      ftrace,kcfi: Define ftrace_stub_graph conditionally

Arınç ÜNAL (2):
      net: dsa: mt7530: remove now incorrect comment regarding port 5
      net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used

Ayush Gupta (1):
      drm/amd/display: disconnect MPCC only on OTG change

Baokun Li (3):
      ext4: fail ext4_iget if special inode unallocated
      ext4: update s_journal_inum if it changes after journal replay
      ext4: fix task hung in ext4_xattr_delete_inode

Bard Liao (1):
      ALSA: hda: intel-dsp-config: add MTL PCI id

Bart Van Assche (2):
      scsi: core: Fix a procfs host directory removal regression
      loop: Fix use-after-free issues

Biju Das (1):
      serial: 8250_em: Fix UART port type

Bjorn Helgaas (1):
      ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Borislav Petkov (AMD) (6):
      virt/coco/sev-guest: Check SEV_SNP attribute at probe time
      virt/coco/sev-guest: Simplify extended guest request handling
      virt/coco/sev-guest: Remove the disable_vmpck label in handle_guest_request()
      virt/coco/sev-guest: Carve out the request issuing logic into a helper
      virt/coco/sev-guest: Do some code style cleanups
      virt/coco/sev-guest: Convert the sw_exit_info_2 checking to a switch-case

Breno Leitao (1):
      tcp: tcp_make_synack() can be called from process context

Budimir Markovic (1):
      perf: Fix check before add_event_to_groups() in perf_group_detach()

Błażej Szczygieł (1):
      drm/amd/pm: Fix sienna cichlid incorrect OD volage after resume

Chen Zhongjin (1):
      ftrace: Fix invalid address access in lookup_rec() when index is 0

Christian Hewitt (1):
      drm/meson: fix 1px pink line on GXM when scaling video overlay

Christophe Leroy (4):
      powerpc/64: Set default CPU in Kconfig
      powerpc: Pass correct CPU reference to assembler
      powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG
      powerpc/64: Replace -mcpu=e500mc64 by -mcpu=e5500

Cindy Lu (1):
      vp_vdpa: fix the crash in hot unplug with vp_vdpa

D. Wythe (1):
      net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Damien Le Moal (2):
      block: null_blk: Fix handling of fake timeout request
      nvmet: avoid potential UAF in nvmet_req_complete()

Dan Carpenter (1):
      fbdev: chipsfb: Fix error codes in chipsfb_pci_init()

Daniel Jurgens (1):
      net/mlx5: Disable eswitch before waiting for VF pages

Daniil Tatianin (2):
      qed/qed_dev: guard against a possible division by zero
      qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Dave Ertman (1):
      ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

David Gow (1):
      rust: arch/um: Disable FP/SIMD instruction to match x86

David Hildenbrand (1):
      mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Dionna Glaze (1):
      virt/coco/sev-guest: Add throttling awareness

Dmitry Osipenko (3):
      drm/msm/gem: Prevent blocking within shrinker loop
      drm/panfrost: Don't sync rpm suspension after mmu flushing
      drm/shmem-helper: Remove another errant put in error path

Elmer Miroslav Mosher Golovin (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000

Emeel Hakim (1):
      net/mlx5e: Fix macsec ASO context alignment

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Eric Van Hensbergen (1):
      net/9p: fix bug in client create for .L

Eugenio Pérez (2):
      vdpa_sim: not reset state in vdpasim_queue_ready
      vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Fedor Pchelkin (1):
      nfc: pn533: initialize struct pn533_out_arg properly

Felix Kuehling (1):
      drm/amdgpu: Don't resume IOMMU after incomplete init

Francesco Dolcini (1):
      mmc: sdhci_am654: lower power-on failed message severity

Gautam Dawar (1):
      vhost-vdpa: free iommu domain after last use during cleanup

Geliang Tang (1):
      mptcp: add ro_after_init for tcp{,v6}_prot_override

Glenn Washburn (1):
      docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Greg Kroah-Hartman (1):
      Linux 6.1.21

Guillaume Tucker (1):
      selftests: fix LLVM build for i386 and x86_64

Guo Ren (1):
      riscv: asid: Fixup stale TLB entry cause application crash

Hamidreza H. Fard (1):
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro

Heiner Kallweit (1):
      net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Helge Deller (1):
      fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Herbert Xu (1):
      xfrm: Allow transport-mode states with AF_UNSPEC selector

Horatio Zhang (1):
      drm/amdgpu: fix ttm_bo calltrace warning in psp_hw_fini

Ido Schimmel (2):
      mlxsw: spectrum: Fix incorrect parsing depth after reload
      ipv4: Fix incorrect table ID in IOCTL path

Ivan Vecera (1):
      i40e: Fix kernel crash during reboot when adapter is in recovery mode

James Houghton (1):
      mm: teach mincore_hugetlb about pte markers

Jan Kara (1):
      block: do not reverse request order when flushing plug list

Jan Kara via Ocfs2-devel (1):
      ocfs2: fix data corruption after failed write

Janusz Krzysztofik (1):
      drm/i915/active: Fix misuse of non-idle barriers as fence trackers

Jaska Uimonen (1):
      ASoC: SOF: ipc4-topology: set dmic dai index from copier

Jeremy Sowden (4):
      netfilter: nft_nat: correct length for loading protocol registers
      netfilter: nft_masq: correct length for loading protocol registers
      netfilter: nft_redir: correct length for loading protocol registers
      netfilter: nft_redir: correct value of inet type `.maxattrs`

Jeremy Szu (1):
      ALSA: hda/realtek: fix speaker, mute/micmute LEDs not work on a HP platform

Jianguo Wu (1):
      ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Johan Hovold (18):
      serial: 8250_fsl: fix handle_irq locking
      memory: tegra: fix interconnect registration race
      memory: tegra20-emc: fix interconnect registration race
      memory: tegra124-emc: fix interconnect registration race
      memory: tegra30-emc: fix interconnect registration race
      interconnect: fix icc_provider_del() error handling
      interconnect: fix provider registration API
      interconnect: imx: fix registration race
      interconnect: fix mem leak when freeing nodes
      interconnect: qcom: osm-l3: fix registration race
      interconnect: qcom: rpm: fix probe child-node error handling
      interconnect: qcom: rpm: fix registration race
      interconnect: qcom: rpmh: fix probe child-node error handling
      interconnect: qcom: rpmh: fix registration race
      interconnect: qcom: msm8974: fix registration race
      interconnect: exynos: fix node leak in probe PM QoS error path
      interconnect: exynos: fix registration race
      drm/sun4i: fix missing component unbind on bind errors

Johannes Berg (2):
      wifi: nl80211: fix NULL-ptr deref in offchan check
      wifi: cfg80211: fix MLO connection ownership

Jouni Högander (1):
      drm/i915/psr: Use calculated io and fast wake lines

Jurica Vukadin (1):
      kconfig: Update config changed flag before calling callback

Krzysztof Kozlowski (2):
      hwmon: tmp512: drop of_match_ptr for ID table
      ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP

Kuniyuki Iwashima (1):
      tcp: Fix bind() conflict check for dual-stack wildcard address.

Lars-Peter Clausen (3):
      hwmon: (ucd90320) Add minimum delay between bus accesses
      hwmon: (adm1266) Set `can_sleep` flag for GPIO chip
      hwmon: (ltc2992) Set `can_sleep` flag for GPIO chip

Lee Duncan (1):
      scsi: core: Add BLIST_NO_VPD_SIZE for some VDASD

Liang He (2):
      block: sunvdc: add check for mdesc_grab() returning NULL
      ethernet: sun: add check for the mdesc_grab()

Linus Torvalds (1):
      media: m5mols: fix off-by-one loop termination error

Liu Ying (1):
      drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc

Maciej Fijalkowski (1):
      ice: xsk: disable txq irq before flushing hw

Maor Dickman (3):
      net/mlx5e: Support Geneve and GRE with VF tunnel offload
      net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
      net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port

Marcus Folkesson (1):
      hwmon: (ina3221) return prober error code

Marek Vasut (1):
      net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795

Matthieu Baerts (1):
      mptcp: avoid setting TCP_CLOSE state twice

Michael Karcher (1):
      sh: intc: Avoid spurious sizeof-pointer-div warning

Ming Lei (1):
      nvme: fix handling single range discard request

NeilBrown (1):
      md: select BLOCK_LEGACY_AUTOLOAD

Nikita Zhandarovich (1):
      x86/mm: Fix use of uninitialized buffer in sme_enable()

Niklas Schnelle (1):
      PCI: s390: Fix use-after-free of PCI resources with per-function hotplug

Nikolay Aleksandrov (2):
      bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
      bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails

Oleksandr Tyshchenko (1):
      drm/virtio: Pass correct device to dma_sync_sgtable_for_device()

Pali Rohár (1):
      powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage

Paolo Abeni (2):
      mptcp: fix possible deadlock in subflow_error_report
      mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

Paolo Bonzini (1):
      KVM: nVMX: add missing consistency checks for CR0 and CR4

Parav Pandit (2):
      net/mlx5e: Don't cache tunnel offloads capability
      net/mlx5: Fix setting ec_function bit in MANAGE_PAGES

Paul Blakey (1):
      net/mlx5e: Fix cleanup null-ptr deref on encap lock

Pavel Begunkov (1):
      io_uring/msg_ring: let target know allocated index

Pierre-Louis Bossart (1):
      ASoC: Intel: soc-acpi: fix copy-paste issue in topology names

Po-Hsu Lin (1):
      selftests: net: devlink_port_split.py: skip test if no suitable device available

Qu Huang (1):
      drm/amdkfd: Fix an illegal memory access

Radu Pirea (OSS) (1):
      net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit

Randy Dunlap (2):
      clk: HI655X: select REGMAP instead of depending on it
      serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Ranjan Kumar (2):
      scsi: mpi3mr: Return proper values for failures in firmware init path
      scsi: mpi3mr: ioctl timeout when disabling/enabling interrupt

Ranjani Sridharan (4):
      ASoC: SOF: Intel: MTL: Fix the device description
      ASoC: SOF: Intel: HDA: Fix device description
      ASoC: SOF: Intel: SKL: Fix device description
      ASOC: SOF: Intel: pci-tgl: Fix device description

Roger Lu (1):
      soc: mediatek: mtk-svs: keep svs alive if CONFIG_DEBUG_FS not supported

Roman Gushchin (1):
      firmware: xilinx: don't make a sleepable memory allocation from an atomic context

Russell Currey (1):
      powerpc/mm: Fix false detection of read faults

Sean Christopherson (1):
      KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask

Sergey Matyukevich (1):
      Revert "riscv: mm: notify remote harts about mmu cache updates"

Shawn Bohrer (1):
      veth: Fix use after free in XDP_REDIRECT

Shawn Guo (1):
      cpuidle: psci: Iterate backwards over list in psci_pd_remove()

Shawn Wang (1):
      x86/resctrl: Clear staged_config[] before and after it is used

Shay Drory (1):
      net/mlx5: Set BREAK_FW_WAIT flag first when removing driver

Sherry Sun (1):
      tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Shyam Prasad N (1):
      cifs: generate signkey for the channel that's reconnecting

Si-Wei Liu (1):
      vdpa/mlx5: should not activate virtq object when suspended

Steven Rostedt (Google) (2):
      tracing: Check field value in hist_field_name()
      tracing: Make tracepoint lockdep check actually test something

Sudeep Holla (1):
      ACPI: PPTT: Fix to avoid sleep in the atomic context when PPTT is absent

Sung-hun Kim (1):
      tracing: Make splice_read available again

Suravee Suthikulpanit (1):
      KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs

Sven Schnelle (1):
      s390/ipl: add missing intersection check to ipl_report handling

Szymon Heidrich (2):
      net: usb: smsc75xx: Limit packet length to skb->len
      net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Takashi Iwai (1):
      fbdev: Fix incorrect page mapping clearance at fb_deferred_io_release()

Tero Kristo (2):
      trace/hwlat: Do not wipe the contents of per-cpu thread data
      trace/hwlat: Do not start per-cpu thread if it is already running

Theodore Ts'o (1):
      ext4: fix possible double unlock when moving a directory

Thomas Bogendoerfer (1):
      i825xx: sni_82596: use eth_hw_addr_set()

Thomas Hellström (1):
      drm/ttm: Fix a NULL pointer dereference

Tiezhu Yang (1):
      LoongArch: Only call get_timer_irq() once in constant_clockevent_init()

Tim Huang (1):
      drm/amd/pm: bump SMU 13.0.4 driver_if header version

Tobias Schramm (1):
      mmc: atmel-mci: fix race between stop command and start of next command

Toke Høiland-Jørgensen (1):
      net: atlantic: Fix crash when XDP is enabled but no program is loaded

Tom Rix (1):
      Revert "tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency"

Tomas Henzl (6):
      scsi: mpi3mr: Fix throttle_groups memory leak
      scsi: mpi3mr: Fix config page DMA memory leak
      scsi: mpi3mr: Fix mpi3mr_hba_port memory leak in mpi3mr_remove()
      scsi: mpi3mr: Fix sas_hba.phy memory leak in mpi3mr_remove()
      scsi: mpi3mr: Fix memory leaks in mpi3mr_init_ioc()
      scsi: mpi3mr: Fix expander node leak in mpi3mr_remove()

Tony O'Brien (2):
      hwmon: (adt7475) Display smoothing attributes in correct order
      hwmon: (adt7475) Fix masking of hysteresis registers

Vladimir Oltean (2):
      net: dsa: don't error out when drivers return ETH_DATA_LEN in .port_max_mtu()
      net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Volker Lendecke (1):
      cifs: Fix smb2_set_path_size()

Wenchao Hao (1):
      scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Wenjia Zhang (1):
      net/smc: fix deadlock triggered by cancel_delayed_work_syn()

Wesley Chalmers (1):
      drm/amd/display: Do not set DRR on pipe Commit

Wolfram Sang (2):
      ravb: avoid PHY being resumed when interface is not up
      sh_eth: avoid PHY being resumed when interface is not up

Yazen Ghannam (1):
      x86/mce: Make sure logged MCEs are processed after sysfs update

Yifei Liu (1):
      jffs2: correct logic when creating a hole in jffs2_write_begin

Zhang Xiaoxu (1):
      cifs: Move the in_send statistic to __smb_send_rqst()

Zheng Wang (2):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
      hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

