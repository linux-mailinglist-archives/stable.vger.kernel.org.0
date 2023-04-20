Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CDF6E905B
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbjDTKgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbjDTKfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E54093CE;
        Thu, 20 Apr 2023 03:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B9F60F27;
        Thu, 20 Apr 2023 10:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C891C4339B;
        Thu, 20 Apr 2023 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986776;
        bh=WVMxcAE7ogqj25DjLZMwYvR/d/h/xFa/gyO7/+p2/HY=;
        h=From:To:Cc:Subject:Date:From;
        b=PCZD+vM/xGXyLSKXcBpRpQQHXFeOPBY0KaaDCccJ/d21LdGpz4d4SSJug1bZxIw9g
         WTqX9U2bbv7A3Lx3Hvx/kxF4ocdrIFLPYkfz/4iAvOtgf+3sPNBPY1iZ3sBa13M85H
         JPugER8CDRg+mQHJtO0CLZiUxtBhBUcaIB7BWIfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.108
Date:   Thu, 20 Apr 2023 12:32:52 +0200
Message-Id: <2023042053-cataract-encounter-ff50@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.108 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/driver-api/generic-counter.rst      |    2 
 Documentation/networking/ip-sysctl.rst            |    2 
 Documentation/sound/hd-audio/models.rst           |    2 
 MAINTAINERS                                       |    1 
 Makefile                                          |    2 
 arch/arm/lib/uaccess_with_memcpy.c                |    4 
 arch/arm64/kvm/pmu-emul.c                         |    1 
 arch/arm64/kvm/sys_regs.c                         |    1 
 arch/powerpc/mm/numa.c                            |    1 
 arch/powerpc/platforms/pseries/papr_scm.c         |    7 
 arch/riscv/kernel/signal.c                        |    9 
 arch/x86/kernel/x86_init.c                        |    4 
 arch/x86/pci/fixup.c                              |   21 
 crypto/asymmetric_keys/pkcs7_verify.c             |   10 
 crypto/asymmetric_keys/verify_pefile.c            |   32 
 drivers/acpi/resource.c                           |    7 
 drivers/clk/sprd/common.c                         |    9 
 drivers/counter/104-quad-8.c                      |  451 ++----
 drivers/counter/Makefile                          |    1 
 drivers/counter/counter-core.c                    |  142 ++
 drivers/counter/counter-sysfs.c                   |  849 ++++++++++++
 drivers/counter/counter-sysfs.h                   |   13 
 drivers/counter/counter.c                         | 1496 ----------------------
 drivers/counter/ftm-quaddec.c                     |   60 
 drivers/counter/intel-qep.c                       |  146 --
 drivers/counter/interrupt-cnt.c                   |   62 
 drivers/counter/microchip-tcb-capture.c           |   91 -
 drivers/counter/stm32-lptimer-cnt.c               |  212 +--
 drivers/counter/stm32-timer-cnt.c                 |  195 +-
 drivers/counter/ti-eqep.c                         |  180 +-
 drivers/firmware/efi/sysfb_efi.c                  |    8 
 drivers/gpu/drm/armada/armada_drv.c               |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c    |   13 
 drivers/gpu/drm/i915/display/icl_dsi.c            |   20 
 drivers/gpu/drm/i915/i915_perf.c                  |  155 +-
 drivers/i2c/busses/i2c-hisi.c                     |    7 
 drivers/i2c/busses/i2c-imx-lpi2c.c                |    2 
 drivers/i2c/busses/i2c-ocores.c                   |   35 
 drivers/infiniband/core/cma.c                     |   60 
 drivers/infiniband/core/verbs.c                   |    2 
 drivers/infiniband/hw/irdma/cm.c                  |   16 
 drivers/infiniband/hw/irdma/cm.h                  |    2 
 drivers/infiniband/hw/irdma/hw.c                  |    3 
 drivers/infiniband/hw/mlx5/main.c                 |    4 
 drivers/mtd/mtdblock.c                            |   12 
 drivers/mtd/nand/raw/meson_nand.c                 |    6 
 drivers/mtd/nand/raw/stm32_fmc2_nand.c            |    3 
 drivers/mtd/ubi/build.c                           |   21 
 drivers/mtd/ubi/wl.c                              |    4 
 drivers/net/ethernet/cadence/macb_main.c          |    4 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c   |    8 
 drivers/net/ethernet/sun/niu.c                    |    2 
 drivers/net/phy/nxp-c45-tja11xx.c                 |   14 
 drivers/net/phy/sfp.c                             |   13 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |    4 
 drivers/net/wireless/marvell/mwifiex/pcie.c       |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c       |    2 
 drivers/nvme/host/pci.c                           |   15 
 drivers/pinctrl/pinctrl-amd.c                     |   36 
 drivers/power/supply/cros_usbpd-charger.c         |    2 
 drivers/scsi/ses.c                                |   20 
 drivers/video/fbdev/core/fbmem.c                  |    2 
 fs/btrfs/disk-io.c                                |   17 
 fs/btrfs/super.c                                  |    2 
 include/linux/counter.h                           |  658 ++++-----
 include/linux/counter_enum.h                      |   45 
 include/linux/kexec.h                             |    2 
 include/linux/mfd/stm32-lptimer.h                 |    5 
 include/linux/mfd/stm32-timers.h                  |    4 
 include/linux/trace.h                             |   12 
 kernel/cgroup/cpuset.c                            |    6 
 kernel/kexec.c                                    |   11 
 kernel/kexec_core.c                               |   28 
 kernel/kexec_file.c                               |    4 
 kernel/kexec_internal.h                           |   15 
 kernel/ksysfs.c                                   |    7 
 kernel/sched/fair.c                               |   15 
 kernel/trace/trace.c                              |   41 
 net/9p/trans_xen.c                                |    4 
 net/bluetooth/hidp/core.c                         |    2 
 net/bluetooth/l2cap_core.c                        |   24 
 net/core/skbuff.c                                 |   16 
 net/ipv4/sysctl_net_ipv4.c                        |    3 
 net/ipv4/tcp_ipv4.c                               |    4 
 net/ipv6/udp.c                                    |    8 
 net/mptcp/options.c                               |    5 
 net/mptcp/protocol.c                              |    2 
 net/mptcp/subflow.c                               |   18 
 net/qrtr/af_qrtr.c                                |    8 
 net/sctp/stream_interleave.c                      |    3 
 sound/firewire/tascam/tascam-stream.c             |    2 
 sound/i2c/cs8427.c                                |    7 
 sound/pci/emu10k1/emupcm.c                        |   14 
 sound/pci/hda/patch_sigmatel.c                    |   10 
 tools/lib/bpf/btf_dump.c                          |    7 
 98 files changed, 2579 insertions(+), 2955 deletions(-)

Abhijit (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM760

Alexander Stein (1):
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Andrew Jeffery (1):
      ARM: 9290/1: uaccess: Fix KASAN false-positives

Andrii Nakryiko (1):
      libbpf: Fix single-line struct definition output in btf_dump

Aneesh Kumar K.V (1):
      powerpc/papr_scm: Update the NUMA distance table for the target node

Arseniy Krasnov (1):
      mtd: rawnand: meson: fix bitmask for length in command word

Aymeric Wibo (1):
      ACPI: resource: Add Medion S17413 to IRQ override quirk

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Basavaraj Natikar (1):
      x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Christoph Hellwig (1):
      btrfs: fix fast csum implementation detection

Christophe JAILLET (1):
      drm/armada: Fix a potential double free in an error handling path

Christophe Kerello (2):
      mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
      mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min

Chunyan Zhang (1):
      clk: sprd: set max_register according to mapping range

Daniel Vetter (1):
      fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace

David Sterba (1):
      btrfs: print checksum type and implementation at mount time

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Duy Truong (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD

Eric Dumazet (1):
      udp6: fix potential access to stale information

Grant Grundler (1):
      power: supply: cros_usbpd: reclassify "default case!" as debug

Greg Kroah-Hartman (1):
      Linux 5.15.108

Gregor Herburger (1):
      i2c: ocores: generate stop condition after timeout in polling mode

Hans de Goede (2):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
      drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Harshit Mogalapalli (1):
      niu: Fix missing unwind goto in niu_alloc_channels()

Ivan Bornyakov (1):
      net: sfp: initialize sfp->i2c_block_size at sfp allocation

Jani Nikula (1):
      drm/i915/dsi: fix DSS CTL register offsets for TGL+

Jiri Kosina (1):
      scsi: ses: Handle enclosure with just a primary component gracefully

Johannes Berg (1):
      wifi: iwlwifi: mvm: fix mvmtxq->stopped handling

Juraj Pecigos (1):
      nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN

Kornel Dulęba (1):
      Revert "pinctrl: amd: Disable and mask interrupts on resume"

Krzysztof Kozlowski (1):
      wifi: mwifiex: mark OF related data as maybe unused

Liang Chen (1):
      skbuff: Fix a race between coalescing and releasing SKBs

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Maher Sanalla (1):
      IB/mlx5: Add support for 400G_8X lane speed

Mark Zhang (1):
      RDMA/cma: Allow UD qp_type to join multicast only

Martin KaFai Lau (1):
      bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Mathis Salmen (1):
      riscv: add icache flush for nommu sigreturn trampoline

Matija Glavinic Pecotic (1):
      x86/rtc: Remove __init for runtime functions

Min Li (2):
      Bluetooth: Fix race condition in hidp_session_thread
      drm/i915: fix race condition UAF in i915_perf_add_config_ioctl

Mustafa Ismail (2):
      RDMA/irdma: Fix memory leak of PBLE objects
      RDMA/irdma: Increase iWARP CM default rexmit count

Ning Wang (1):
      nvme-pci: avoid the deepest sleep state on ZHITAI TiPro7000 SSDs

Oswald Buddenhagen (5):
      ALSA: emu10k1: fix capture interrupt handler unlinking
      ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
      ALSA: i2c/cs8427: fix iec958 mixer control deactivation
      ALSA: emu10k1: don't create old pass-through playback device on Audigy
      ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Paolo Abeni (2):
      mptcp: use mptcp_schedule_work instead of open-coding it
      mptcp: stricter state check in mptcp_worker

Radu Pirea (OSS) (2):
      net: phy: nxp-c45-tja11xx: add remove callback
      net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow

Randy Dunlap (1):
      counter: fix docum. build problems after filename change

Reiji Watanabe (1):
      KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

Robbie Harwood (2):
      verify_pefile: relax wrapper length check
      asymmetric_keys: log on fatal failures in PE/pkcs7

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Saravanan Vajravel (1):
      RDMA/core: Fix GID entry ref leak when create_ah fails

Shyamin Ayesh (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610

Stefan Reiter (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG GAMMIX S50

Steven Rostedt (Google) (2):
      tracing: Add trace_array_puts() to write into instance
      tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance

Tatyana Nikolova (1):
      RDMA/irdma: Add ipv4 check to irdma_find_listener()

Tobias Gruetzmacher (1):
      nvme-pci: Crucial P2 has bogus namespace ids

Umesh Nerlige Ramappa (1):
      i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call

Valentin Schneider (2):
      kexec: turn all kexec_mutex acquisitions into trylocks
      panic, kexec: make __crash_kexec() NMI safe

Vincent Guittot (1):
      sched/fair: Fix imbalance overflow

Waiman Long (1):
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

William Breathitt Gray (4):
      counter: stm32-lptimer-cnt: Provide defines for clock polarities
      counter: stm32-timer-cnt: Provide defines for slave mode selection
      counter: Internalize sysfs interface code
      counter: 104-quad-8: Fix Synapse action reported for Index signals

Xi Ruoyao (1):
      nvme-pci: avoid the deepest sleep state on ZHITAI TiPro5000 SSDs

Xin Long (1):
      sctp: fix a potential overflow in sctp_ifwdtsn_skip

Xu Biang (1):
      ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Yanteng Si (1):
      counter: Add the necessary colons and indents to the comments of counter_compi

Yicong Yang (1):
      i2c: hisi: Avoid redundant interrupts

YueHaibing (1):
      tcp: restrict net.ipv4.tcp_app_win

ZhaoLong Wang (1):
      ubi: Fix deadlock caused by recursively holding work_sem

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Ziyang Xuan (1):
      net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

zgpeng (1):
      sched/fair: Move calculate of avg_load to a better location

