Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EE92B9262
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgKSMOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:14:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgKSMOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:14:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AB7246F5;
        Thu, 19 Nov 2020 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605788055;
        bh=+GM7sRvHXyXM2JTvE+sQEYGk3nKE2qIGL7wqos30i0Y=;
        h=From:To:Cc:Subject:Date:From;
        b=FlBAdakbINB1G1bbKio2wUOGwLQl6nLONuR11eUIxUpm2aMtKBOBMq2M7w8Q4iBb5
         NpIXj8p158ZfV6slpSY0lcBZqSyaHdcg6MCUV14CAaXlPbcJiCJvH1s06ArwQ1W1QT
         bDWgeZJnyaIj1+FL4Um6BXGJfflZwzfKOkomPVqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.207
Date:   Thu, 19 Nov 2020 13:14:46 +0100
Message-Id: <160578808684233@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.207 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |    8 
 Makefile                                        |    2 
 arch/Kconfig                                    |    7 
 arch/arm/include/asm/kprobes.h                  |   22 -
 arch/arm/probes/kprobes/opt-arm.c               |   18 
 arch/x86/events/intel/pt.c                      |    4 
 arch/x86/kernel/cpu/bugs.c                      |   52 +-
 drivers/block/nbd.c                             |   10 
 drivers/block/xen-blkback/blkback.c             |   22 -
 drivers/block/xen-blkback/xenbus.c              |    5 
 drivers/char/random.c                           |    1 
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c           |   27 -
 drivers/gpu/drm/gma500/psb_irq.c                |   34 -
 drivers/hv/hv_balloon.c                         |    2 
 drivers/iommu/amd_iommu_types.h                 |    6 
 drivers/misc/mei/client.h                       |    4 
 drivers/net/can/dev.c                           |   14 
 drivers/net/can/peak_canfd/peak_canfd.c         |   11 
 drivers/net/can/rx-offload.c                    |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c    |   51 ++
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c      |   48 +-
 drivers/net/ethernet/realtek/r8169.c            |    3 
 drivers/net/vrf.c                               |   92 +++-
 drivers/net/wan/cosa.c                          |    1 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 
 drivers/net/xen-netback/common.h                |   15 
 drivers/net/xen-netback/interface.c             |   61 ++-
 drivers/net/xen-netback/netback.c               |   11 
 drivers/net/xen-netback/rx.c                    |   13 
 drivers/of/address.c                            |    4 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c         |    7 
 drivers/pinctrl/intel/pinctrl-intel.c           |    8 
 drivers/pinctrl/pinctrl-amd.c                   |    6 
 drivers/regulator/core.c                        |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c      |    9 
 drivers/scsi/hpsa.c                             |    4 
 drivers/thunderbolt/nhi.c                       |   19 
 drivers/uio/uio.c                               |   10 
 drivers/usb/class/cdc-acm.c                     |    9 
 drivers/usb/gadget/udc/goku_udc.c               |    2 
 drivers/xen/events/events_2l.c                  |    9 
 drivers/xen/events/events_base.c                |  422 ++++++++++++++++++++-
 drivers/xen/events/events_fifo.c                |   83 ++--
 drivers/xen/events/events_internal.h            |   20 -
 drivers/xen/evtchn.c                            |    7 
 drivers/xen/pvcalls-back.c                      |   76 ++-
 drivers/xen/xen-pciback/pci_stub.c              |   14 
 drivers/xen/xen-pciback/pciback.h               |   12 
 drivers/xen/xen-pciback/pciback_ops.c           |   48 +-
 drivers/xen/xen-pciback/xenbus.c                |    2 
 drivers/xen/xen-scsiback.c                      |   23 -
 fs/btrfs/extent_io.c                            |    4 
 fs/btrfs/ioctl.c                                |    2 
 fs/btrfs/volumes.c                              |    7 
 fs/cifs/cifs_unicode.c                          |    8 
 fs/exec.c                                       |   15 
 fs/ext4/inline.c                                |    1 
 fs/ext4/super.c                                 |    4 
 fs/gfs2/rgrp.c                                  |    5 
 fs/gfs2/super.c                                 |    1 
 fs/ocfs2/super.c                                |    1 
 fs/xfs/libxfs/xfs_rmap.c                        |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c                  |   16 
 fs/xfs/xfs_iops.c                               |   10 
 fs/xfs/xfs_pnfs.c                               |    2 
 include/linux/can/skb.h                         |   20 -
 include/linux/perf_event.h                      |    2 
 include/linux/prandom.h                         |   36 +
 include/linux/time64.h                          |    4 
 include/xen/events.h                            |   29 +
 kernel/events/core.c                            |   44 +-
 kernel/events/internal.h                        |    2 
 kernel/exit.c                                   |    5 
 kernel/futex.c                                  |    5 
 kernel/irq/Kconfig                              |    1 
 kernel/reboot.c                                 |   28 -
 kernel/time/itimer.c                            |    4 
 kernel/time/timer.c                             |    7 
 kernel/trace/ring_buffer.c                      |   54 ++
 lib/random32.c                                  |  462 ++++++++++++++----------
 lib/swiotlb.c                                   |    6 
 mm/mempolicy.c                                  |    6 
 net/ipv4/syncookies.c                           |    9 
 net/ipv6/sit.c                                  |    2 
 net/ipv6/syncookies.c                           |   10 
 net/iucv/af_iucv.c                              |    3 
 net/mac80211/tx.c                               |   35 +
 net/wireless/reg.c                              |    2 
 net/x25/af_x25.c                                |    2 
 net/xfrm/xfrm_state.c                           |    8 
 security/selinux/ibpkey.c                       |    4 
 sound/hda/ext/hdac_ext_controller.c             |    2 
 tools/perf/util/session.c                       |    1 
 93 files changed, 1587 insertions(+), 630 deletions(-)

Al Viro (1):
      don't dump the threads that had been already exiting when zapped.

Alexander Usyskin (1):
      mei: protect mei_cl_mtu from null dereference

Anand K Mistry (1):
      x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Andrew Jeffery (1):
      ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andy Shevchenko (1):
      pinctrl: intel: Set default bias in case no particular value given

Billy Tsai (1):
      pinctrl: aspeed: Fix GPI only function problem.

Bob Peterson (3):
      gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
      gfs2: Add missing truncate_inode_pages_final for sd_aspace
      gfs2: check for live vs. read-only file system in gfs2_fitrim

Boris Protopopov (1):
      Convert trailing spaces and periods in path components

Brian Foster (1):
      xfs: flush new eof page on truncate to avoid post-eof corruption

Chen Zhou (1):
      selinux: Fix error return code in sel_ib_pkey_sid_slow()

Chris Brandt (1):
      usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Christoph Hellwig (2):
      nbd: fix a block_device refcount leak in nbd_release
      xfs: fix a missing unlock on error in xfs_fs_map_blocks

Coiby Xu (2):
      pinctrl: amd: use higher precision for 512 RtcClk
      pinctrl: amd: fix incorrect way to disable debounce filter

Dan Carpenter (3):
      ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()
      can: peak_usb: add range checking in decode operations
      futex: Don't enable IRQs unconditionally in put_pi_state()

Darrick J. Wong (2):
      xfs: fix flags argument to rmap lookup when converting shared file rmaps
      xfs: fix rmap key and record comparison functions

Evan Nimmo (1):
      of/address: Fix of_node memory leak in of_dma_is_coherent

Evan Quan (1):
      drm/amdgpu: perform srbm soft reset always on SDMA resume

Evgeny Novikov (1):
      usb: gadget: goku_udc: fix potential crashes in probe

Filipe Manana (1):
      Btrfs: fix missing error return if writeback for extent buffer never started

George Spelvin (1):
      random32: make prandom_u32() output unpredictable

Greg Kroah-Hartman (1):
      Linux 4.14.207

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Heiner Kallweit (1):
      r8169: fix potential skb double free in an error path

Jing Xiangfeng (1):
      thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Jiri Olsa (2):
      perf tools: Add missing swap for ino_generation
      perf/core: Fix race in the perf_mmap_close() function

Johannes Berg (1):
      mac80211: fix use of skb payload instead of header

Johannes Thumshirn (1):
      btrfs: reschedule when cloning lots of extents

Josef Bacik (1):
      btrfs: sysfs: init devices outside of the chunk_mutex

Joseph Qi (1):
      ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Juergen Gross (13):
      xen/events: avoid removing an event channel while handling it
      xen/events: add a proper barrier to 2-level uevent unmasking
      xen/events: fix race in evtchn_fifo_unmask()
      xen/events: add a new "late EOI" evtchn framework
      xen/blkback: use lateeoi irq binding
      xen/netback: use lateeoi irq binding
      xen/scsiback: use lateeoi irq binding
      xen/pvcallsback: use lateeoi irq binding
      xen/pciback: use lateeoi irq binding
      xen/events: switch user event channels to lateeoi model
      xen/events: use a common cpu hotplug hook for event channels
      xen/events: defer eoi in case of excessive number of events
      xen/events: block rogue events for some time

Kaixu Xia (1):
      ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Keita Suzuki (1):
      scsi: hpsa: Fix memory leak in hpsa_init_one()

Mao Wenan (1):
      net: Update window_clamp if SOCK_RCVBUF is set

Marc Kleine-Budde (1):
      can: rx-offload: don't call kfree_skb() from IRQ context

Marc Zyngier (1):
      genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Martin Schiller (1):
      net/x25: Fix null-ptr-deref in x25_connect

Martin Willi (1):
      vrf: Fix fast path output packet handling with async Netfilter rules

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Mathieu Poirier (1):
      perf/core: Fix crash when using HW tracing kernel filters

Matteo Croce (2):
      Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
      reboot: fix overflow parsing reboot cpu number

Michał Mirosław (1):
      regulator: defer probe when trying to get voltage from unresolved supply

Ming Lei (1):
      nbd: don't update block size after device is started

Nicholas Piggin (1):
      mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race

Olaf Hering (1):
      hv_balloon: disable warning when floor reached

Oleksij Rempel (1):
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (1):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Oliver Herms (1):
      IPv6: Set SIT tunnel hard_header_len to zero

Peter Zijlstra (1):
      perf: Fix get_recursion_context()

Shijie Luo (1):
      mm: mempolicy: fix potential pte_unmap_unlock pte error

Shin'ichiro Kawasaki (1):
      uio: Fix use-after-free in uio_unregister_device()

Song Liu (1):
      perf/core: Fix bad use of igrab()

Stefano Stabellini (1):
      swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Steven Rostedt (VMware) (1):
      ring-buffer: Fix recursion protection transitions between interrupt context

Suravee Suthikulpanit (1):
      iommu/amd: Increase interrupt remapping table limit to 512 entries

Thomas Zimmermann (1):
      drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

Ursula Braun (1):
      net/af_iucv: fix null pointer dereference on shutdown

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Wang Hai (1):
      cosa: Add missing kfree in error path of cosa_write

Wengang Wang (1):
      ocfs2: initialize ip_next_orphan

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

Zeng Tao (1):
      time: Prevent undefined behaviour in timespec64_to_ns()

kiyin(尹亮) (1):
      perf/core: Fix a memory leak in perf_event_parse_addr_filter()

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

