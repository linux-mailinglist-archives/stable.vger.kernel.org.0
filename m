Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95AB612177
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 10:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJ2Ijc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 04:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ2Ijb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 04:39:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2A1265C;
        Sat, 29 Oct 2022 01:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0C81B80B13;
        Sat, 29 Oct 2022 08:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A363C433C1;
        Sat, 29 Oct 2022 08:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667032765;
        bh=ai6HpyGnOKMVPoS8z42fsqZTKSTbcEm0Tzv/JbbI+ls=;
        h=From:To:Cc:Subject:Date:From;
        b=IGiLPFHOAssy8JxWC+scdKE4iYeexaKIMj+dwRppCq5yRfi2JivPZrVm3GTFa81Xs
         M2Y+u2L6H7S6MH1tKbdTF2FkNwsDXvbpDhUrz0hOs3azcR0hdUUnmEzlCoNzt7XORb
         G1cAaN02tRr2200gzlNiiuEFYdPdzEviuqo+8eig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.6
Date:   Sat, 29 Oct 2022 10:40:19 +0200
Message-Id: <1667032820213146@kroah.com>
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

I'm announcing the release of the 6.0.6 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm64/kvm/vgic/vgic-its.c                      |    5 
 arch/x86/Kconfig                                    |    1 
 arch/x86/include/asm/iommu.h                        |    4 
 arch/x86/kernel/cpu/microcode/amd.c                 |   16 ++
 arch/x86/kernel/cpu/resctrl/core.c                  |    8 -
 arch/x86/kernel/cpu/topology.c                      |   16 +-
 arch/x86/kvm/x86.c                                  |   87 +++++++++++---
 block/blk-mq.c                                      |    7 -
 drivers/acpi/acpi_extlog.c                          |   33 +++--
 drivers/acpi/video_detect.c                         |   64 ++++++++++
 drivers/ata/ahci.h                                  |    2 
 drivers/ata/ahci_imx.c                              |    2 
 drivers/block/drbd/drbd_req.c                       |   14 --
 drivers/cpufreq/qcom-cpufreq-nvmem.c                |   10 +
 drivers/cpufreq/tegra194-cpufreq.c                  |    1 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c              |    5 
 drivers/gpu/drm/amd/amdgpu/soc15.c                  |   21 +++
 drivers/gpu/drm/amd/display/dc/dml/Makefile         |    2 
 drivers/gpu/drm/vc4/vc4_drv.c                       |    1 
 drivers/gpu/drm/vc4/vc4_hdmi.c                      |    9 +
 drivers/hid/hid-magicmouse.c                        |    2 
 drivers/hwmon/coretemp.c                            |   56 ++++++---
 drivers/i2c/busses/i2c-qcom-cci.c                   |   13 +-
 drivers/iommu/intel/iommu.c                         |    5 
 drivers/md/dm-bufio.c                               |   13 +-
 drivers/md/dm.c                                     |    1 
 drivers/media/platform/qcom/venus/helpers.c         |   13 +-
 drivers/media/platform/qcom/venus/vdec.c            |    2 
 drivers/media/rc/mceusb.c                           |    2 
 drivers/net/dsa/qca/qca8k-8xxx.c                    |   83 +++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c   |   11 -
 drivers/net/ethernet/hisilicon/hns/hnae.c           |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c      |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c         |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c         |   13 --
 drivers/net/ethernet/intel/i40e/i40e_txrx.h         |    1 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c          |   67 +++++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h          |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c         |   17 +-
 drivers/net/ethernet/mediatek/mtk_wed.c             |   15 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |   12 +
 drivers/net/ethernet/sfc/ef10.c                     |   58 +++------
 drivers/net/ethernet/sfc/filter.h                   |    4 
 drivers/net/ethernet/sfc/rx_common.c                |   10 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |    1 
 drivers/net/phy/dp83822.c                           |    3 
 drivers/net/phy/dp83867.c                           |    8 +
 drivers/net/phy/phylink.c                           |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c     |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h    |    2 
 drivers/net/wwan/wwan_hwsim.c                       |    2 
 drivers/nvme/host/core.c                            |    6 
 drivers/nvme/host/hwmon.c                           |   32 +++--
 drivers/nvme/target/core.c                          |    2 
 drivers/platform/x86/amd/pmc.c                      |    7 +
 drivers/scsi/lpfc/lpfc_init.c                       |    7 -
 drivers/staging/media/ipu3/ipu3-v4l2.c              |   31 ++---
 drivers/video/aperture.c                            |   11 +
 fs/btrfs/backref.c                                  |   46 +++++--
 fs/cifs/cifsfs.c                                    |    7 -
 fs/cifs/dir.c                                       |    6 
 fs/cifs/file.c                                      |   11 +
 fs/cifs/sess.c                                      |    1 
 fs/cifs/smb2ops.c                                   |    3 
 fs/cifs/smb2pdu.c                                   |    2 
 fs/erofs/zdata.c                                    |    8 -
 fs/erofs/zdata.h                                    |    6 
 fs/ext4/fast_commit.c                               |  122 +++++++++++++-------
 fs/ext4/fast_commit.h                               |    3 
 fs/ocfs2/namei.c                                    |   23 +--
 fs/proc/task_mmu.c                                  |    2 
 include/linux/dsa/tag_qca.h                         |    8 -
 include/linux/kvm_host.h                            |    2 
 include/linux/phylink.h                             |    2 
 include/net/sch_generic.h                           |    1 
 include/net/sock_reuseport.h                        |   11 -
 io_uring/io_uring.h                                 |   10 -
 io_uring/msg_ring.c                                 |    3 
 io_uring/rw.c                                       |    2 
 mm/hugetlb.c                                        |    2 
 net/atm/mpoa_proc.c                                 |    3 
 net/core/dev.c                                      |    4 
 net/core/skmsg.c                                    |    8 -
 net/core/sock_reuseport.c                           |   16 ++
 net/hsr/hsr_forward.c                               |   12 -
 net/ipv4/datagram.c                                 |    2 
 net/ipv4/netfilter/ipt_rpfilter.c                   |    3 
 net/ipv4/netfilter/nft_fib_ipv4.c                   |    3 
 net/ipv4/udp.c                                      |    2 
 net/ipv6/addrconf.c                                 |    2 
 net/ipv6/datagram.c                                 |    2 
 net/ipv6/netfilter/ip6t_rpfilter.c                  |   10 -
 net/ipv6/netfilter/nft_fib_ipv6.c                   |    7 -
 net/ipv6/udp.c                                      |    2 
 net/netfilter/nf_tables_api.c                       |    5 
 net/sched/sch_api.c                                 |    5 
 net/sched/sch_atm.c                                 |    1 
 net/sched/sch_cake.c                                |    4 
 net/sched/sch_cbq.c                                 |    1 
 net/sched/sch_choke.c                               |    2 
 net/sched/sch_drr.c                                 |    2 
 net/sched/sch_dsmark.c                              |    2 
 net/sched/sch_etf.c                                 |    3 
 net/sched/sch_ets.c                                 |    2 
 net/sched/sch_fq_codel.c                            |    2 
 net/sched/sch_fq_pie.c                              |    3 
 net/sched/sch_hfsc.c                                |    2 
 net/sched/sch_htb.c                                 |    2 
 net/sched/sch_multiq.c                              |    1 
 net/sched/sch_prio.c                                |    2 
 net/sched/sch_qfq.c                                 |    2 
 net/sched/sch_red.c                                 |    2 
 net/sched/sch_sfb.c                                 |    5 
 net/sched/sch_skbprio.c                             |    3 
 net/sched/sch_taprio.c                              |    2 
 net/sched/sch_tbf.c                                 |    2 
 net/sched/sch_teql.c                                |    1 
 net/smc/smc_core.c                                  |    3 
 net/tipc/discover.c                                 |    2 
 net/tipc/topsrv.c                                   |    2 
 net/tls/tls_strp.c                                  |   32 ++++-
 security/selinux/ss/services.c                      |    5 
 security/selinux/ss/sidtab.c                        |    4 
 security/selinux/ss/sidtab.h                        |    2 
 tools/verification/dot2/dot2c.py                    |    2 
 virt/kvm/kvm_main.c                                 |   11 +
 128 files changed, 887 insertions(+), 440 deletions(-)

Alex Deucher (1):
      drm/amdgpu: fix sdma doorbell init ordering on APUs

Alexander Graf (3):
      kvm: Add support for arch compat vm ioctls
      KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()
      KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

Alexander Potapenko (1):
      tipc: fix an information leak in tipc_topsrv_kern_subscr

Alexander Stein (1):
      ata: ahci-imx: Fix MODULE_ALIAS

Babu Moger (1):
      x86/resctrl: Fix min_cbm_bits for AMD

Borislav Petkov (1):
      x86/microcode/AMD: Apply the patch early on every logical thread

Brett Creeley (1):
      ionic: catch NULL pointer issue on reconfig

Bryan O'Donoghue (3):
      i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter
      media: venus: dec: Handle the case where find_format fails
      media: venus: Fix NV12 decoder buffer discovery on HFI_VERSION_1XX

Charlotte Tan (1):
      iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()

Christian Marangi (2):
      net: dsa: qca8k: fix inband mgmt for big-endian systems
      net: dsa: qca8k: fix ethtool autocast mib for big-endian systems

Christoph Böhmwalder (1):
      drbd: only clone bio if we have a backing device

Christoph Hellwig (1):
      nvme-hwmon: consistently ignore errors from nvme_hwmon_init

Dan Carpenter (1):
      net/smc: Fix an error code in smc_lgr_create()

Daniel Bristot de Oliveira (1):
      rv/dot2c: Make automaton definition static

Deren Wu (1):
      wifi: mt76: mt7921e: fix random fw download fail

Eric Dumazet (3):
      skmsg: pass gfp argument to alloc_sk_msg()
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

Gao Xiang (1):
      erofs: shouldn't churn the mapping page for duplicated copies

Genjian Zhang (1):
      dm: remove unnecessary assignment statement in alloc_dev()

Greg Kroah-Hartman (1):
      Linux 6.0.6

Guenter Roeck (1):
      drm/amd/display: Increase frame size limit for display_mode_vba_util_32.o

Guillaume Nault (1):
      netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.

Harini Katakam (1):
      net: phy: dp83867: Extend RX strap quirk for SGMII mode

Harshit Mogalapalli (1):
      io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()

Jakub Kicinski (1):
      tls: strp: make sure the TCP skbs do not have overlapping data

Jan Sokolowski (1):
      i40e: Fix DMA mappings leak

Jens Axboe (2):
      io_uring/rw: remove leftover debug statement
      io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL

Jerry Snitselaar (1):
      iommu/vt-d: Clean up si_domain in the init_dmars() error path

Jon Hunter (1):
      cpufreq: tegra194: Fix module loading

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

Mario Limonciello (1):
      platform/x86/amd: pmc: Read SMU version during suspend on Cezanne systems

Mark Tomlinson (1):
      tipc: Fix recognition of trial period

Maxime Ripard (2):
      drm/vc4: Add module dependency on hdmi-codec
      drm/vc4: hdmi: Enforce the minimum rate at runtime_resume

Mikulas Patocka (1):
      dm bufio: use the acquire memory barrier when testing for B_READING

Nathan Chancellor (1):
      x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Pablo Neira Ayuso (1):
      netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements

Paul Blakey (1):
      net: Fix return value of qdisc ingress handling on success

Phil Sutter (1):
      netfilter: rpfilter/fib: Populate flowic_l3mdev field

Pieter Jansen van Vuuren (1):
      sfc: include vport_id in filter spec hash and equal()

Rafael Mendonca (1):
      scsi: lpfc: Fix memory leak in lpfc_create_port()

Rik van Riel (1):
      mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

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

Shenwei Wang (2):
      net: phylink: add mac_managed_pm in phylink_config structure
      net: stmmac: Enable mac_managed_pm phylink config

Steve French (1):
      smb3: interface count displayed incorrectly

Thomas Zimmermann (1):
      video/aperture: Call sysfb_disable() before removing PCI devices

Tony Luck (1):
      ACPI: extlog: Handle multiple records

Vikas Gupta (1):
      bnxt_en: fix memory leak in bnxt_nvm_test()

Werner Sembach (1):
      ACPI: video: Force backlight native for more TongFang devices

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (5):
      net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
      net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()
      net: ethernet: mtk_eth_wed: add missing of_node_put()
      wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
      net: hns: fix possible memory leak in hnae_ae_register()

Ye Bin (3):
      ext4: introduce EXT4_FC_TAG_BASE_LEN helper
      ext4: factor out ext4_fc_get_tl()
      ext4: fix potential out of bound read in ext4_fc_replay_scan()

Yu Kuai (1):
      blk-mq: fix null pointer dereference in blk_mq_clear_rq_mapping()

Zhang Rui (3):
      hwmon/coretemp: Handle large core ID value
      x86/topology: Fix multiple packages shown on a single-package system
      x86/topology: Fix duplicated core ID within a package

Zhang Xiaoxu (5):
      cifs: Fix xid leak in cifs_create()
      cifs: Fix xid leak in cifs_copy_file_range()
      cifs: Fix xid leak in cifs_flock()
      cifs: Fix xid leak in cifs_ses_add_channel()
      cifs: Fix memory leak when build ntlmssp negotiate blob failed

Zhengchao Shao (4):
      ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
      net: sched: cake: fix null pointer access issue when cake_init() fails
      net: sched: delete duplicate cleanup of backlog and qlen
      net: sched: sfb: fix null pointer access issue when sfb_init() fails

