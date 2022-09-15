Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9CA5B97F8
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 11:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiIOJsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 05:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiIOJrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 05:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD775F21E;
        Thu, 15 Sep 2022 02:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2566B81F1F;
        Thu, 15 Sep 2022 09:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA8C433C1;
        Thu, 15 Sep 2022 09:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663235204;
        bh=9kdKlx6IGUNgCA8yvT37j0WgIx5MpeWmTLiK3cAZnwA=;
        h=From:To:Cc:Subject:Date:From;
        b=L4i1JVGTBUKH+vJ9hJSKLND903Bm99E2IZMW8NBmIYPXCyPhzfpYUI2oS9i3UnR1g
         cY/fS39MYQAXuMoYNdfH9NzjW+7y3CtzGGFz+uspOsV3lXvj1td8W80WPfd6YMON9F
         jX+uetd3JFHTA/RweOCwUkUL+NM9I2A+sO7C+9eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.68
Date:   Thu, 15 Sep 2022 11:47:09 +0200
Message-Id: <1663235229191201@kroah.com>
X-Mailer: git-send-email 2.37.3
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

I'm announcing the release of the 5.15.68 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                    |    2 
 Makefile                                                  |    5 
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi               |   21 -
 arch/arm/boot/dts/at91-sama5d2_icp.dts                    |   21 -
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi             |   10 
 arch/arm/mach-at91/pm.c                                   |   36 +
 arch/arm/mach-at91/pm_suspend.S                           |   24 -
 arch/arm64/Kconfig                                        |   19 
 arch/arm64/kernel/cacheinfo.c                             |    6 
 arch/arm64/kernel/cpu_errata.c                            |    9 
 arch/arm64/kernel/cpufeature.c                            |    5 
 arch/arm64/kernel/hibernate.c                             |    5 
 arch/arm64/kernel/mte.c                                   |    9 
 arch/arm64/kernel/topology.c                              |   32 +
 arch/arm64/mm/copypage.c                                  |    9 
 arch/arm64/mm/mteswap.c                                   |    9 
 arch/arm64/tools/cpucaps                                  |    1 
 arch/mips/loongson32/ls1c/board.c                         |    1 
 arch/parisc/include/asm/bitops.h                          |    8 
 arch/parisc/kernel/head.S                                 |   43 ++
 arch/s390/kernel/nmi.c                                    |    2 
 arch/s390/kernel/setup.c                                  |    1 
 drivers/cpufreq/cpufreq.c                                 |    2 
 drivers/firmware/efi/capsule-loader.c                     |   31 -
 drivers/firmware/efi/libstub/Makefile                     |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                   |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                  |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                     |    3 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c                   |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 
 drivers/gpu/drm/bridge/display-connector.c                |   86 ++++
 drivers/gpu/drm/drm_gem.c                                 |   17 
 drivers/gpu/drm/drm_internal.h                            |    4 
 drivers/gpu/drm/drm_prime.c                               |   20 
 drivers/gpu/drm/i915/display/intel_dp_link_training.c     |   22 +
 drivers/gpu/drm/radeon/radeon_device.c                    |    3 
 drivers/hwmon/mr75203.c                                   |   72 ++-
 drivers/hwmon/tps23861.c                                  |   10 
 drivers/infiniband/core/cma.c                             |    4 
 drivers/infiniband/core/umem_odp.c                        |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                |    2 
 drivers/infiniband/hw/hns/hns_roce_qp.c                   |    7 
 drivers/infiniband/hw/irdma/uk.c                          |    4 
 drivers/infiniband/hw/irdma/verbs.c                       |    7 
 drivers/infiniband/hw/mlx5/mad.c                          |    6 
 drivers/infiniband/sw/siw/siw_qp_tx.c                     |   18 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                    |    9 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                    |   14 
 drivers/infiniband/ulp/srp/ib_srp.c                       |    3 
 drivers/iommu/amd/iommu.c                                 |    3 
 drivers/iommu/intel/iommu.c                               |   28 +
 drivers/md/md.c                                           |    1 
 drivers/net/ethernet/intel/i40e/i40e.h                    |   14 
 drivers/net/ethernet/intel/i40e/i40e_client.c             |    5 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c            |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c               |   23 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c               |    3 
 drivers/net/ethernet/intel/iavf/iavf_main.c               |   14 
 drivers/net/ethernet/intel/ice/ice_main.c                 |    2 
 drivers/net/phy/meson-gxl.c                               |    8 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c             |    5 
 drivers/net/wireless/microchip/wilc1000/netdev.h          |    1 
 drivers/net/wireless/microchip/wilc1000/sdio.c            |   39 +
 drivers/net/wireless/microchip/wilc1000/wlan.c            |   15 
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c             |   10 
 drivers/net/xen-netback/xenbus.c                          |    2 
 drivers/nvme/host/tcp.c                                   |    7 
 drivers/nvme/target/core.c                                |    6 
 drivers/nvme/target/zns.c                                 |   17 
 drivers/parisc/ccio-dma.c                                 |   11 
 drivers/regulator/core.c                                  |    9 
 drivers/scsi/lpfc/lpfc_init.c                             |    5 
 drivers/scsi/megaraid/megaraid_sas_fusion.c               |    1 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                      |    2 
 drivers/scsi/qla2xxx/qla_target.c                         |   10 
 drivers/scsi/ufs/ufshcd.c                                 |    9 
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                       |   50 +-
 drivers/soc/imx/gpcv2.c                                   |    5 
 drivers/tee/tee_shm.c                                     |    1 
 drivers/vfio/vfio_iommu_type1.c                           |   12 
 drivers/video/fbdev/chipsfb.c                             |    1 
 drivers/video/fbdev/core/fbsysfs.c                        |    4 
 fs/afs/flock.c                                            |    2 
 fs/afs/fsclient.c                                         |    2 
 fs/afs/internal.h                                         |    3 
 fs/afs/rxrpc.c                                            |    7 
 fs/afs/yfsclient.c                                        |    3 
 fs/btrfs/zoned.c                                          |   15 
 fs/debugfs/inode.c                                        |   22 +
 fs/erofs/internal.h                                       |   29 -
 fs/nfs/dir.c                                              |   16 
 fs/nfs/file.c                                             |   15 
 fs/nfs/inode.c                                            |   27 -
 fs/nfs/write.c                                            |    6 
 include/linux/buffer_head.h                               |   11 
 include/linux/debugfs.h                                   |    6 
 include/linux/nfs_fs.h                                    |   48 +-
 include/linux/skbuff.h                                    |   49 +-
 include/linux/udp.h                                       |    1 
 include/net/udp_tunnel.h                                  |    4 
 include/soc/at91/sama7-ddr.h                              |   12 
 kernel/cgroup/cgroup.c                                    |   85 +++-
 kernel/cgroup/cpuset.c                                    |    3 
 kernel/dma/swiotlb.c                                      |    5 
 kernel/fork.c                                             |    1 
 kernel/kprobes.c                                          |    1 
 kernel/sched/debug.c                                      |    2 
 kernel/trace/trace_events_trigger.c                       |    3 
 mm/kmemleak.c                                             |    8 
 net/bridge/br_netfilter_hooks.c                           |    2 
 net/bridge/br_netfilter_ipv6.c                            |    1 
 net/core/datagram.c                                       |    2 
 net/core/skbuff.c                                         |    5 
 net/ipv4/tcp.c                                            |    2 
 net/ipv4/tcp_input.c                                      |   25 -
 net/ipv4/udp.c                                            |    2 
 net/ipv4/udp_tunnel_core.c                                |    1 
 net/ipv6/seg6.c                                           |    5 
 net/ipv6/udp.c                                            |    5 
 net/netfilter/nf_conntrack_irc.c                          |    5 
 net/netfilter/nf_conntrack_proto_tcp.c                    |   31 +
 net/netfilter/nf_tables_api.c                             |    4 
 net/rxrpc/ar-internal.h                                   |    1 
 net/rxrpc/local_object.c                                  |    1 
 net/rxrpc/peer_event.c                                    |  293 ++++++++++++--
 net/rxrpc/rxkad.c                                         |    2 
 net/sched/sch_sfb.c                                       |   13 
 net/tipc/monitor.c                                        |    2 
 sound/core/oss/pcm_oss.c                                  |    6 
 sound/drivers/aloop.c                                     |    7 
 sound/pci/emu10k1/emupcm.c                                |    2 
 sound/soc/atmel/mchp-spdiftx.c                            |   10 
 sound/soc/qcom/sm8250.c                                   |    1 
 sound/usb/card.c                                          |    2 
 sound/usb/endpoint.c                                      |   23 -
 sound/usb/endpoint.h                                      |    6 
 sound/usb/pcm.c                                           |   14 
 sound/usb/quirks.c                                        |    2 
 sound/usb/stream.c                                        |    9 
 tools/perf/builtin-script.c                               |    3 
 tools/perf/util/machine.c                                 |    3 
 141 files changed, 1344 insertions(+), 496 deletions(-)

Ajay.Kathat@microchip.com (1):
      wifi: wilc1000: fix DMA on stack objects

Alex Williamson (1):
      vfio/type1: Unpin zero pages

Alexander Gordeev (1):
      s390/boot: fix absolute zero lowcore corruption on boot

Alexandru Gagniuc (1):
      hwmon: (tps23861) fix byte order in resistance register

Andrew Halaney (1):
      regulator: core: Clean up on enable failure

Ard Biesheuvel (1):
      efi: libstub: Disable struct randomization

Arnaldo Carvalho de Melo (1):
      perf machine: Use path__join() to compose a path instead of snprintf(dir, '/', filename)

Bart Van Assche (2):
      scsi: ufs: core: Reduce the power mode change timeout
      nvmet: fix a use-after-free

Candice Li (1):
      drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Chao Gao (1):
      swiotlb: avoid potential left shift overflow

Chengchang Tang (1):
      RDMA/hns: Fix supported page size

Chris Mi (1):
      RDMA/mlx5: Set local port to one when accessing counters

Christian A. Ehrhardt (1):
      kprobes: Prohibit probes in gate area

Claudiu Beznea (8):
      ARM: at91: pm: fix self-refresh for sama7g5
      ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh
      ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges
      ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges
      ARM: dts: at91: sama5d27_wlsom1: don't keep ldo2 enabled all the time
      ARM: dts: at91: sama5d2_icp: don't keep vdd_other enabled all the time
      ASoC: mchp-spdiftx: remove references to mchp_i2s_caps
      ARM: at91: ddr: remove CONFIG_SOC_SAMA7 dependency

Dan Carpenter (1):
      tipc: fix shift wrapping bug in map_get()

David Howells (3):
      rxrpc: Fix ICMP/ICMP6 error handling
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      afs: Use the operation issue time instead of the reply time for callbacks

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

David Sloan (1):
      md: Flush workqueue md_rdev_misc_wq in md_alloc()

Dennis Maisenbacher (1):
      nvmet: fix mar and mor off-by-one errors

Dongxiang Ke (1):
      ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Eliav Farber (5):
      hwmon: (mr75203) fix VM sensor allocation when "intel,vm-map" not defined
      hwmon: (mr75203) update pvt->v_num and vm_num to the actual number of used sensors
      hwmon: (mr75203) fix voltage equation for negative source input
      hwmon: (mr75203) fix multi-channel voltage reading
      hwmon: (mr75203) enable polling for all VM channels

Eric Dumazet (1):
      tcp: TX zerocopy should not sense pfmemalloc status

Florian Westphal (1):
      netfilter: conntrack: work around exceeded receive window

Gao Xiang (1):
      erofs: fix pcluster use-after-free on UP platforms

Greg Kroah-Hartman (4):
      debugfs: add debugfs_lookup_and_remove()
      sched/debug: fix dentry leak in update_sched_domain_debugfs
      drm/amd/display: fix memory leak when using debugfs_lookup()
      Linux 5.15.68

Guixin Liu (1):
      scsi: megaraid_sas: Fix double kfree()

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Heiner Kallweit (1):
      Revert "net: phy: meson-gxl: improve link-up behavior"

Helge Deller (2):
      Revert "parisc: Show error if wrong 32/64-bit compiler is being used"
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Hyunwoo Kim (1):
      efi: capsule-loader: Fix use-after-free in efi_capsule_write

Ionela Voinescu (1):
      arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

Ivan Vecera (2):
      i40e: Fix kernel crash during module removal
      iavf: Detach device during reset task

Jack Wang (2):
      RDMA/rtrs-clt: Use the right sg_cnt after ib_dma_map_sg
      RDMA/rtrs-srv: Pass the correct number of entries for dma mapped SGL

Jakub Kicinski (1):
      net: wwan: iosm: remove pointless null check

Jeffy Chen (1):
      drm/gem: Fix GEM handle release errors

Jens Wiklander (1):
      tee: fix compiler warning in tee_shm_register()

John Sperbeck (1):
      iommu/amd: use full 64-bit value in build_completion_wait()

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Liang He (1):
      soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Linus Walleij (1):
      RDMA/siw: Pass a pointer to virt_to_page()

Lu Baolu (1):
      iommu/vt-d: Correctly calculate sagaw value of IOMMU

Lukasz Luba (1):
      cpufreq: check only freq_table in __resolve_freq()

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node

Marek Vasut (1):
      soc: imx: gpcv2: Assert reset before ungating clock

Mark Brown (1):
      arm64/bti: Disable in kernel BTI when cross section thunks are broken

Masahiro Yamada (1):
      kbuild: disable header exports for UML in a straightforward way

Masami Hiramatsu (Google) (1):
      tracing: Fix to check event_mutex is held while accessing trigger list

Michael Guralnik (1):
      RDMA/cma: Fix arguments order in net device validation

Michal Swiatkowski (1):
      ice: use bitmap_free instead of devm_kfree

Nathan Chancellor (1):
      ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Neil Armstrong (1):
      drm/bridge: display-connector: implement bus fmts callbacks

Pablo Neira Ayuso (1):
      netfilter: nf_tables: clean up hook list when offload flags check fails

Pattara Teerapong (1):
      ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Paul Durrant (1):
      xen-netback: only remove 'hotplug-status' when the vif is actually destroyed

Pavel Begunkov (1):
      net: introduce __skb_fill_page_desc_noacc

Przemyslaw Patynowski (2):
      i40e: Refactor tc mqprio checks
      i40e: Fix ADQ rate limiting for PF

Qu Huang (1):
      drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Sagi Grimberg (2):
      nvme-tcp: fix UAF when detecting digest errors
      nvme-tcp: fix regression that causes sporadic requests to time out

Sasha Levin (1):
      Revert "arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags""

Shigeru Yoshida (1):
      fbdev: fbcon: Destroy mutex on freeing struct fb_info

Shin'ichiro Kawasaki (1):
      btrfs: zoned: set pseudo max append zone limit in zone emulation mode

Sindhu-Devale (3):
      RDMA/irdma: Report the correct max cqes from query device
      RDMA/irdma: Return correct WC error for bind operation failure
      RDMA/irdma: Report RNR NAK generation in device caps

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Srinivas Kandagatla (1):
      ASoC: qcom: sm8250: add missing module owner

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Sudeep Holla (1):
      arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level

Takashi Iwai (4):
      ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
      ALSA: usb-audio: Split endpoint setups for hw_params and prepare
      ALSA: usb-audio: Inform the delayed registration more properly
      ALSA: usb-audio: Register card again for iface over delayed_register option

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Tejun Heo (2):
      cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Tony Battersby (1):
      scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

Trond Myklebust (3):
      NFS: Further optimisations for 'ls -l'
      NFS: Save some space in the inode
      NFS: Fix another fsync() issue after a server reboot

Ville Syrjälä (1):
      drm/i915: Implement WaEdpLinkRateDataReload

Wenpeng Liang (1):
      RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (2):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
      scsi: lpfc: Add missing destroy_workqueue() in error path

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

YiPeng Chai (1):
      drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini

Yishai Hadas (1):
      IB/core: Fix a nested dead lock as part of ODP flow

Zhengjun Xing (1):
      perf script: Fix Cannot print 'iregs' field for hybrid systems

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

lily (1):
      net/core/skbuff: Check the return value of skb_copy_bits()

yangx.jy@fujitsu.com (1):
      RDMA/srp: Set scmnd->result only when scmnd is not NULL

