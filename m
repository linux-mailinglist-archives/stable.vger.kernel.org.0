Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298EF61217C
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJ2ImK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 04:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiJ2ImJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 04:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04DC18D836;
        Sat, 29 Oct 2022 01:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6875AB80B16;
        Sat, 29 Oct 2022 08:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86C0C433C1;
        Sat, 29 Oct 2022 08:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667032925;
        bh=AnUiwucCAog3utz056x2IwzLMgiSEteBCLpbdSARkJA=;
        h=From:To:Cc:Subject:Date:From;
        b=EfwH2n2UEf/Mkkjj7mWoketjt3xxkFSRONuBcNNX4ROy5qs6LBuR3Oh/pbv+Wkx3z
         qA9gMN5xJrQfQ/GZ7QtIuhUaVOmQ2G2bZaqMXpJbL/70ps8lrfUliMQYKW5J/ZeVY9
         dzFbZGKnekEdzcIsudhtbggXqXlHvACWwi5EB648=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.76
Date:   Sat, 29 Oct 2022 10:42:59 +0200
Message-Id: <1667032979148189@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.76 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst          |    4 +
 Makefile                                        |    6 +-
 arch/arm64/Kconfig                              |   16 +++++
 arch/arm64/include/asm/mte.h                    |    5 +
 arch/arm64/include/asm/pgtable-hwdef.h          |    2 
 arch/arm64/include/asm/sysreg.h                 |    4 -
 arch/arm64/kernel/cpu_errata.c                  |   16 +++++
 arch/arm64/kernel/cpufeature.c                  |   17 +++++-
 arch/arm64/kernel/mte.c                         |   51 ++++++++++++++++++
 arch/arm64/kernel/suspend.c                     |    2 
 arch/arm64/kvm/vgic/vgic-its.c                  |    5 +
 arch/arm64/mm/proc.S                            |   48 ++---------------
 arch/arm64/tools/cpucaps                        |    1 
 arch/x86/Kconfig                                |    1 
 arch/x86/events/intel/pt.c                      |   63 +++++++++++++++++-----
 arch/x86/include/asm/iommu.h                    |    4 +
 arch/x86/kernel/cpu/microcode/amd.c             |   16 ++++-
 arch/x86/kernel/cpu/resctrl/core.c              |    8 --
 arch/x86/kernel/cpu/topology.c                  |   16 +++--
 drivers/acpi/acpi_extlog.c                      |   33 +++++++----
 drivers/acpi/video_detect.c                     |   64 ++++++++++++++++++++++
 drivers/ata/ahci.h                              |    2 
 drivers/ata/ahci_imx.c                          |    2 
 drivers/cpufreq/qcom-cpufreq-nvmem.c            |   10 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c          |    5 -
 drivers/gpu/drm/amd/amdgpu/soc15.c              |   21 +++++++
 drivers/gpu/drm/vc4/vc4_drv.c                   |    1 
 drivers/hid/hid-magicmouse.c                    |    2 
 drivers/hwmon/coretemp.c                        |   56 ++++++++++++++------
 drivers/i2c/busses/i2c-qcom-cci.c               |   13 ++--
 drivers/iommu/intel/iommu.c                     |    5 +
 drivers/md/dm.c                                 |    1 
 drivers/media/platform/qcom/venus/vdec.c        |    2 
 drivers/media/rc/mceusb.c                       |    2 
 drivers/mmc/core/block.c                        |    7 ++
 drivers/mmc/core/card.h                         |    6 ++
 drivers/mmc/core/quirks.h                       |    6 ++
 drivers/mmc/host/sdhci-tegra.c                  |    2 
 drivers/net/ethernet/hisilicon/hns/hnae.c       |    4 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c  |    3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c     |   16 +++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c     |   13 +---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h     |    1 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c      |   67 +++++++++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h      |    2 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |   12 ++--
 drivers/net/ethernet/sfc/ef10.c                 |   58 ++++++++------------
 drivers/net/ethernet/sfc/filter.h               |    3 -
 drivers/net/ethernet/sfc/rx_common.c            |   10 +--
 drivers/net/phy/dp83822.c                       |    3 -
 drivers/net/phy/dp83867.c                       |    8 ++
 drivers/net/phy/phylink.c                       |    3 +
 drivers/net/usb/cdc_ether.c                     |    7 ++
 drivers/net/usb/r8152.c                         |    3 +
 drivers/net/wwan/wwan_hwsim.c                   |    2 
 drivers/nvme/host/core.c                        |    6 +-
 drivers/nvme/host/hwmon.c                       |   32 +++++++----
 drivers/nvme/target/core.c                      |    2 
 drivers/scsi/lpfc/lpfc_init.c                   |    7 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c          |   31 +++++------
 drivers/usb/gadget/function/uvc.h               |    5 +
 drivers/usb/gadget/function/uvc_queue.c         |   15 -----
 drivers/usb/gadget/function/uvc_queue.h         |    2 
 drivers/usb/gadget/function/uvc_video.c         |   35 +++++++-----
 drivers/usb/gadget/function/uvc_video.h         |    2 
 fs/btrfs/backref.c                              |   46 +++++++++++-----
 fs/btrfs/block-group.c                          |   11 +++
 fs/btrfs/super.c                                |    9 +++
 fs/cifs/cifsfs.c                                |    7 +-
 fs/cifs/dir.c                                   |    6 +-
 fs/cifs/file.c                                  |   11 ++-
 fs/cifs/sess.c                                  |    1 
 fs/dlm/lock.c                                   |    2 
 fs/ksmbd/smb2pdu.c                              |   24 ++++----
 fs/ocfs2/namei.c                                |   23 +++-----
 fs/proc/task_mmu.c                              |    2 
 include/linux/kvm_host.h                        |    2 
 include/linux/mmc/card.h                        |    1 
 include/linux/phylink.h                         |    2 
 include/net/sch_generic.h                       |    1 
 include/net/sock_reuseport.h                    |   11 +--
 kernel/trace/trace.c                            |   12 ++--
 mm/hugetlb.c                                    |    2 
 net/atm/mpoa_proc.c                             |    3 -
 net/core/sock_reuseport.c                       |   16 +++++
 net/hsr/hsr_forward.c                           |   12 ++--
 net/ipv4/datagram.c                             |    2 
 net/ipv4/udp.c                                  |    2 
 net/ipv6/datagram.c                             |    2 
 net/ipv6/udp.c                                  |    2 
 net/netfilter/nf_tables_api.c                   |    5 +
 net/sched/sch_api.c                             |    5 +
 net/sched/sch_atm.c                             |    1 
 net/sched/sch_cake.c                            |    4 +
 net/sched/sch_cbq.c                             |    1 
 net/sched/sch_choke.c                           |    2 
 net/sched/sch_drr.c                             |    2 
 net/sched/sch_dsmark.c                          |    2 
 net/sched/sch_etf.c                             |    3 -
 net/sched/sch_ets.c                             |    2 
 net/sched/sch_fq_codel.c                        |    2 
 net/sched/sch_fq_pie.c                          |    3 -
 net/sched/sch_hfsc.c                            |    2 
 net/sched/sch_htb.c                             |    2 
 net/sched/sch_multiq.c                          |    1 
 net/sched/sch_prio.c                            |    2 
 net/sched/sch_qfq.c                             |    2 
 net/sched/sch_red.c                             |    2 
 net/sched/sch_sfb.c                             |    5 -
 net/sched/sch_skbprio.c                         |    3 -
 net/sched/sch_taprio.c                          |    2 
 net/sched/sch_tbf.c                             |    2 
 net/sched/sch_teql.c                            |    1 
 net/tipc/discover.c                             |    2 
 net/tipc/topsrv.c                               |    2 
 security/selinux/ss/services.c                  |    5 +
 security/selinux/ss/sidtab.c                    |    4 -
 security/selinux/ss/sidtab.h                    |    2 
 tools/perf/util/parse-events.c                  |    3 +
 tools/perf/util/pmu.c                           |   17 ++++++
 tools/perf/util/pmu.h                           |    2 
 tools/perf/util/pmu.l                           |    2 
 tools/perf/util/pmu.y                           |   15 +----
 virt/kvm/kvm_main.c                             |   11 +++
 124 files changed, 806 insertions(+), 404 deletions(-)

Adrian Hunter (1):
      perf/x86/intel/pt: Relax address filter validation

Alex Deucher (1):
      drm/amdgpu: fix sdma doorbell init ordering on APUs

Alexander Aring (1):
      fs: dlm: fix invalid derefence of sb_lvbptr

Alexander Graf (1):
      kvm: Add support for arch compat vm ioctls

Alexander Potapenko (1):
      tipc: fix an information leak in tipc_topsrv_kern_subscr

Alexander Stein (1):
      ata: ahci-imx: Fix MODULE_ALIAS

Anshuman Khandual (1):
      arm64/mm: Consolidate TCR_EL1 fields

Avri Altman (1):
      mmc: core: Add SD card quirk for broken discard

Babu Moger (1):
      x86/resctrl: Fix min_cbm_bits for AMD

Borislav Petkov (1):
      x86/microcode/AMD: Apply the patch early on every logical thread

Brett Creeley (1):
      ionic: catch NULL pointer issue on reconfig

Bryan O'Donoghue (2):
      i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter
      media: venus: dec: Handle the case where find_format fails

Charlotte Tan (1):
      iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()

Christoph Hellwig (1):
      nvme-hwmon: consistently ignore errors from nvme_hwmon_init

Eric Dumazet (2):
      net: hsr: avoid possible NULL deref in skb_clone()
      net: sched: fix race condition in qdisc_graft()

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

Fabien Parent (2):
      cpufreq: qcom: fix writes in read-only memory region
      cpufreq: qcom: fix memory leak in error path

Felix Riemann (1):
      net: phy: dp83822: disable MDI crossover status change interrupt

Filipe Manana (2):
      btrfs: fix processing of delayed data refs during backref walking
      btrfs: fix processing of delayed tree block refs during backref walking

GONG, Ruiqi (1):
      selinux: enable use of both GFP_KERNEL and GFP_ATOMIC in convert_context()

Genjian Zhang (1):
      dm: remove unnecessary assignment statement in alloc_dev()

Greg Kroah-Hartman (1):
      Linux 5.15.76

Harini Katakam (1):
      net: phy: dp83867: Extend RX strap quirk for SGMII mode

James Morse (1):
      arm64: errata: Remove AES hwcap for COMPAT tasks

Jan Sokolowski (1):
      i40e: Fix DMA mappings leak

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jerry Snitselaar (1):
      iommu/vt-d: Clean up si_domain in the init_dmars() error path

Jonathan Cooper (1):
      sfc: Change VF mac via PF as first preference if available.

Joseph Qi (2):
      ocfs2: clear dinode links count in case of error
      ocfs2: fix BUG when iput after ocfs2_mknod fails

José Expósito (1):
      HID: magicmouse: Do not set BTN_MOUSE on double report

Kai-Heng Feng (1):
      ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Kuniyuki Iwashima (1):
      udp: Update reuse->has_conns under reuseport_lock.

Mark Tomlinson (1):
      tipc: Fix recognition of trial period

Maxime Ripard (1):
      drm/vc4: Add module dependency on hdmi-codec

Michael Grzeschik (5):
      usb: gadget: uvc: consistently use define for headerlen
      usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
      usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
      usb: gadget: uvc: giveback vb2 buffer on req complete
      usb: gadget: uvc: improve sg exit condition

Namjae Jeon (2):
      ksmbd: handle smb2 query dir request for OutputBufferLength that is too small
      ksmbd: fix incorrect handling of iterate_dir

Nathan Chancellor (1):
      x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Nick Desaulniers (1):
      Makefile.debug: re-enable debug info for .S files

Pablo Neira Ayuso (1):
      netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements

Peter Collingbourne (1):
      arm64: mte: move register initialization to C

Pieter Jansen van Vuuren (1):
      sfc: include vport_id in filter spec hash and equal()

Prathamesh Shete (1):
      mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

Qu Wenruo (1):
      btrfs: enhance unsupported compat RO flags handling

Rafael Mendonca (1):
      scsi: lpfc: Fix memory leak in lpfc_create_port()

Rik van Riel (1):
      mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Rob Herring (1):
      perf: Skip and warn on unknown format 'configN' attrs

Sagi Grimberg (1):
      nvmet: fix workqueue MEM_RECLAIM flushing dependency

Sakari Ailus (1):
      media: ipu3-imgu: Fix NULL pointer dereference in active selection access

Sean Young (1):
      media: mceusb: set timeout to at least timeout provided

Serge Semin (1):
      nvme-hwmon: kmalloc the NVME SMART log buffer

Seth Jenkins (1):
      mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Shenwei Wang (1):
      net: phylink: add mac_managed_pm in phylink_config structure

Steven Rostedt (Google) (1):
      tracing: Do not free snapshot if tracer is on cmdline

Tony Luck (1):
      ACPI: extlog: Handle multiple records

Werner Sembach (1):
      ACPI: video: Force backlight native for more TongFang devices

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (2):
      wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
      net: hns: fix possible memory leak in hnae_ae_register()

Zhang Rui (3):
      hwmon/coretemp: Handle large core ID value
      x86/topology: Fix multiple packages shown on a single-package system
      x86/topology: Fix duplicated core ID within a package

Zhang Xiaoxu (4):
      cifs: Fix xid leak in cifs_create()
      cifs: Fix xid leak in cifs_copy_file_range()
      cifs: Fix xid leak in cifs_flock()
      cifs: Fix xid leak in cifs_ses_add_channel()

Zhengchao Shao (3):
      net: sched: cake: fix null pointer access issue when cake_init() fails
      net: sched: delete duplicate cleanup of backlog and qlen
      net: sched: sfb: fix null pointer access issue when sfb_init() fails

sunliming (1):
      tracing: Simplify conditional compilation code in tracing_set_tracer()

