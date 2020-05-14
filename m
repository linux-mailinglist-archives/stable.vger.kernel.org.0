Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77AE1D2ABB
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 10:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgENI4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 04:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgENI4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 04:56:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB7D206BE;
        Thu, 14 May 2020 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589446597;
        bh=f91etRWBxixNRcq3F21gjakI2syTPypReaTMPCIunQY=;
        h=Subject:To:Cc:From:Date:From;
        b=dkLZsoeYsovRkFQsWWh/lJfqP8jxi3HQ9z+HjLi0PIBVPoyBWLTbI8TlKGzg3O/pK
         xy23BnAYKYA4F9IpF07G/Yb4OsPUWtMT1QWG/+NMFW/mUSQv1ncmPIQa0VauILl3wt
         6acazH56ySeHoxCiAi2iMXsBf7q8OCuKX+ZNphgA=
Subject: Linux 5.4.41
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 14 May 2020 10:49:27 +0200
Message-ID: <158944616723079@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.41 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/crypto/nhpoly1305-neon-glue.c                     |    2 
 arch/arm64/crypto/nhpoly1305-neon-glue.c                   |    2 
 arch/arm64/kvm/guest.c                                     |    7 
 arch/arm64/mm/hugetlbpage.c                                |    2 
 arch/riscv/mm/init.c                                       |    3 
 arch/s390/kvm/priv.c                                       |    4 
 arch/x86/crypto/nhpoly1305-avx2-glue.c                     |    2 
 arch/x86/crypto/nhpoly1305-sse2-glue.c                     |    2 
 arch/x86/entry/calling.h                                   |   40 ++--
 arch/x86/entry/entry_64.S                                  |    9 -
 arch/x86/include/asm/kvm_host.h                            |    4 
 arch/x86/include/asm/unwind.h                              |    2 
 arch/x86/kernel/unwind_orc.c                               |   61 +++++-
 arch/x86/kvm/svm.c                                         |    2 
 arch/x86/kvm/vmx/vmenter.S                                 |    3 
 block/blk-iocost.c                                         |  117 +++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                 |    7 
 drivers/gpu/drm/ingenic/ingenic-drm.c                      |    1 
 drivers/hid/usbhid/hid-core.c                              |   37 +++-
 drivers/hid/usbhid/usbhid.h                                |    1 
 drivers/hid/wacom_sys.c                                    |    4 
 drivers/hid/wacom_wac.c                                    |   88 ++-------
 drivers/iommu/virtio-iommu.c                               |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                  |   20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                  |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c            |   10 -
 drivers/net/ethernet/cadence/macb_main.c                   |   24 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c             |    3 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c            |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |   14 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |   12 +
 drivers/net/ethernet/netronome/nfp/abm/main.c              |    1 
 drivers/net/ethernet/toshiba/tc35815.c                     |    2 
 drivers/net/macsec.c                                       |    3 
 drivers/net/phy/dp83640.c                                  |    2 
 drivers/net/usb/qmi_wwan.c                                 |    1 
 drivers/nvme/host/core.c                                   |   28 +--
 drivers/staging/gasket/gasket_core.c                       |    4 
 drivers/tty/serial/xilinx_uartps.c                         |    1 
 drivers/tty/vt/vt.c                                        |    9 -
 drivers/usb/chipidea/ci_hdrc_msm.c                         |    2 
 drivers/usb/serial/garmin_gps.c                            |    4 
 drivers/usb/serial/qcserial.c                              |    1 
 drivers/usb/storage/unusual_uas.h                          |    7 
 fs/ceph/mds_client.c                                       |    8 
 fs/ceph/quota.c                                            |    4 
 fs/coredump.c                                              |    8 
 fs/eventpoll.c                                             |   61 +++---
 fs/notify/fanotify/fanotify.c                              |    9 -
 fs/notify/inotify/inotify_fsnotify.c                       |    4 
 fs/notify/inotify/inotify_user.c                           |    2 
 include/linux/backing-dev-defs.h                           |    1 
 include/linux/backing-dev.h                                |    9 -
 include/linux/fsnotify_backend.h                           |    7 
 include/linux/virtio_net.h                                 |   26 ++
 include/net/inet_ecn.h                                     |   57 ++++++
 include/net/ip6_fib.h                                      |    4 
 include/net/net_namespace.h                                |    7 
 ipc/mqueue.c                                               |   34 ++-
 kernel/trace/trace.c                                       |   13 +
 kernel/trace/trace_kprobe.c                                |    2 
 kernel/umh.c                                               |    5 
 mm/backing-dev.c                                           |   13 +
 mm/memcontrol.c                                            |   15 +
 mm/page_alloc.c                                            |    9 +
 net/batman-adv/bat_v_ogm.c                                 |    2 
 net/batman-adv/network-coding.c                            |    9 -
 net/batman-adv/sysfs.c                                     |    3 
 net/core/devlink.c                                         |    5 
 net/core/neighbour.c                                       |    6 
 net/dsa/master.c                                           |    3 
 net/ipv6/route.c                                           |   25 ++
 net/netfilter/nf_nat_proto.c                               |    4 
 net/netfilter/nfnetlink_osf.c                              |   12 -
 net/sched/sch_choke.c                                      |    3 
 net/sched/sch_fq_codel.c                                   |    2 
 net/sched/sch_sfq.c                                        |    9 +
 net/sched/sch_skbprio.c                                    |    3 
 net/sctp/sm_statefuns.c                                    |    6 
 net/tipc/topsrv.c                                          |    5 
 net/tls/tls_sw.c                                           |    7 
 scripts/decodecode                                         |    2 
 tools/cgroup/iocost_monitor.py                             |    7 
 tools/objtool/check.c                                      |    2 
 virt/kvm/arm/hyp/aarch32.c                                 |    8 
 virt/kvm/arm/vgic/vgic-mmio.c                              |    4 
 90 files changed, 647 insertions(+), 345 deletions(-)

Alan Stern (1):
      HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Amir Goldstein (2):
      fsnotify: replace inode pointer with an object id
      fanotify: merge duplicate events on parent and child

Andy Shevchenko (1):
      net: macb: Fix runtime PM refcounting

Anthony Felice (1):
      net: tc35815: Fix phydev supported/advertising mask

Arnd Bergmann (1):
      netfilter: nf_osf: avoid passing pointer to local var

Bryan O'Donoghue (1):
      usb: chipidea: msm: Ensure proper controller reset using role switch API

Christian Borntraeger (1):
      KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction

Christoph Hellwig (3):
      nvme: refactor nvme_identify_ns_descs error handling
      bdi: move bdi_dev_name out of line
      bdi: add a ->dev_name field to struct backing_dev_info

Dan Carpenter (2):
      net: mvpp2: prevent buffer overflow in mvpp22_rss_ctx()
      net: mvpp2: cls: Prevent buffer overflow in mvpp2_ethtool_cls_rule_del()

David Ahern (1):
      ipv6: Use global sernum for dst validation with nexthop objects

David Hildenbrand (1):
      mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Dejin Zheng (1):
      net: macb: fix an issue about leak related system resources

Erez Shitrit (1):
      net/mlx5: DR, On creation set CQ's arm_db member to right value

Eric Dumazet (4):
      fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
      net_sched: sch_skbprio: add message validation to skbprio_change()
      sch_choke: avoid potential panic in choke_reset()
      sch_sfq: validate silly quantum values

Evan Quan (2):
      drm/amdgpu: move kfd suspend after ip_suspend_phase1
      drm/amdgpu: drop redundant cg/pg ungate on runpm enter

Florian Fainelli (1):
      net: dsa: Do not leave DSA master with NULL netdev_ops

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Greg Kroah-Hartman (1):
      Linux 5.4.41

Guillaume Nault (1):
      netfilter: nat: never update the UDP checksum when it's 0

H. Nikolaus Schaller (1):
      drm: ingenic-drm: add MODULE_DEVICE_TABLE

Henry Willard (1):
      mm: limit boost_watermark on small zones

Ivan Delalande (1):
      scripts/decodecode: fix trapping instruction formatting

Jakub Kicinski (1):
      devlink: fix return value after hitting end in region read

Janakarajan Natarajan (1):
      arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()

Jann Horn (1):
      x86/entry/64: Fix unwind hints in rewind_stack_do_exit()

Jason A. Donenfeld (1):
      crypto: arch/nhpoly1305 - process in explicit 4k chunks

Jason Gerecke (3):
      HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices
      Revert "HID: wacom: generic: read the number of expected touches on a per collection basis"
      HID: wacom: Report 2nd-gen Intuos Pro S center button status over BT

Jeff Layton (1):
      ceph: fix endianness bug when handling MDS session feature bits

Jere Leppänen (1):
      sctp: Fix bundling of SHUTDOWN with COOKIE-ACK

Jiri Pirko (1):
      mlxsw: spectrum_acl_tcam: Position vchunk in a vregion list properly

Josh Poimboeuf (6):
      x86/entry/64: Fix unwind hints in register clearing code
      x86/entry/64: Fix unwind hints in kernel exit path
      x86/unwind/orc: Prevent unwinding before ORC initialization
      x86/unwind/orc: Fix error path for bad ORC entry type
      x86/unwind/orc: Fix premature unwind stoppage due to IRET frames
      objtool: Fix stack offset tracking for indirect CFAs

Julia Lawall (2):
      dp83640: reverse arguments to list_add_tail
      iommu/virtio: Reverse arguments to list_add

Khazhismel Kumykov (1):
      eventpoll: fix missing wakeup for ovflist in ep_poll_callback

Luis Chamberlain (1):
      coredump: fix crash when umh is disabled

Luis Henriques (1):
      ceph: demote quotarealm lookup warning to a debug message

Marc Zyngier (2):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
      KVM: arm64: Fix 32bit PC wrap-around

Mark Rutland (1):
      arm64: hugetlb: avoid potential NULL dereference

Masami Hiramatsu (1):
      tracing/kprobes: Fix a double initialization typo

Matt Jolly (2):
      USB: serial: qcserial: Add DW5816e support
      net: usb: qmi_wwan: add support for DW5816e

Michael Chan (4):
      bnxt_en: Fix VF anti-spoof filter setup.
      bnxt_en: Improve AER slot reset.
      bnxt_en: Return error when allocating zero size context memory.
      bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Miroslav Benes (1):
      x86/unwind/orc: Don't skip the first frame for inactive tasks

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Nicolas Pitre (1):
      vt: fix unicode console freeing with a common interface

Oleg Nesterov (1):
      ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

Oliver Neukum (2):
      USB: uas: add quirk for LaCie 2Big Quadra
      USB: serial: garmin_gps: add sanity checking for data length

Oscar Carter (1):
      staging: gasket: Check the return value of gasket_get_bar_index()

Qiushi Wu (1):
      nfp: abm: fix a memory leak bug

Roman Mashak (1):
      neigh: send protocol value in neighbor create notification

Roman Penyaev (1):
      epoll: atomically remove wait entry on wake up

Sagi Grimberg (1):
      nvme: fix possible hang when ns scanning fails during error recovery

Scott Dial (1):
      net: macsec: preserve ingress frame ordering

Sean Christopherson (1):
      KVM: VMX: Explicitly clear RFLAGS.CF and RFLAGS.ZF in VM-Exit RSB path

Shubhrajyoti Datta (1):
      tty: xilinx_uartps: Fix missing id assignment to the console

Steven Rostedt (VMware) (1):
      tracing: Add a vmalloc_sync_mappings() for safe measure

Suravee Suthikulpanit (1):
      KVM: x86: Fixes posted interrupt check for IRQs delivery modes

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Tejun Heo (1):
      iocost: protect iocg->abs_vdebt with iocg->waitq.lock

Toke Høiland-Jørgensen (1):
      tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040

Tuong Lien (1):
      tipc: fix partial topology connection closure

Vasundhara Volam (1):
      bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.

Vincent Chen (1):
      riscv: set max_pfn to the PFN of the last page

Willem de Bruijn (1):
      net: stricter validation of untrusted gso packets

Xiyu Yang (5):
      net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
      net/tls: Fix sk_psock refcnt leak when in tls_data_ready()
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process

Yafang Shao (1):
      mm, memcg: fix error return value of mem_cgroup_css_alloc()

