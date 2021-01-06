Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BEA2EC1A5
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 18:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbhAFRBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 12:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbhAFRBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 12:01:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE182312F;
        Wed,  6 Jan 2021 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609952452;
        bh=wGwAtevGmPoYBtTCZE6S0TbOyZ91kKsEjVpcGNgxZp0=;
        h=From:To:Cc:Subject:Date:From;
        b=lOoaFPUwsFdeB1LET83yCwJvqrT87y/I/VPwPjk65GV5guKZMZ5cfoGXZPmw2bgxA
         nr6o9yPKYxUjcZ7Q4SrUHMPoEFuIyozh9po8Bj2mGMAX5yRgIxdrr+qb1EwuZ/CEpg
         0LJ/MYvkh0D/lPFUJKGsPs6J9c20QzJGeM78dVkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.5
Date:   Wed,  6 Jan 2021 18:02:10 +0100
Message-Id: <160995253074219@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.5 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/gpu/todo.rst                                |   18 +
 Makefile                                                  |    2 
 arch/ia64/mm/init.c                                       |    4 
 arch/powerpc/kernel/irq.c                                 |   53 ---
 arch/powerpc/kernel/time.c                                |    9 
 arch/powerpc/platforms/powernv/opal.c                     |    2 
 arch/powerpc/sysdev/mpic_msgr.c                           |    2 
 arch/s390/kernel/entry.S                                  |   12 
 arch/um/drivers/random.c                                  |  101 +------
 arch/um/drivers/ubd_kern.c                                |  191 ++++++++------
 block/blk-pm.c                                            |   15 -
 drivers/bluetooth/hci_h5.c                                |    8 
 drivers/char/hw_random/Kconfig                            |   16 -
 drivers/dax/bus.c                                         |   44 +--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c |   12 
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c     |   44 +++
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h     |    2 
 drivers/i3c/master.c                                      |    5 
 drivers/md/dm-verity-target.c                             |   12 
 drivers/md/raid10.c                                       |    3 
 drivers/media/usb/dvb-usb/gp8psk.c                        |    2 
 drivers/misc/vmw_vmci/vmci_context.c                      |    2 
 drivers/opp/core.c                                        |    9 
 drivers/rtc/rtc-pl031.c                                   |    6 
 drivers/rtc/rtc-sun6i.c                                   |    8 
 drivers/scsi/cxgbi/cxgb4i/Kconfig                         |    1 
 drivers/spi/Kconfig                                       |    3 
 drivers/video/fbdev/core/fbcon.c                          |   45 ---
 drivers/watchdog/rti_wdt.c                                |    4 
 fs/bfs/inode.c                                            |    2 
 fs/ceph/inode.c                                           |    2 
 fs/ext4/mballoc.c                                         |    9 
 fs/ext4/super.c                                           |   40 +-
 fs/f2fs/checkpoint.c                                      |    2 
 fs/f2fs/compress.c                                        |    2 
 fs/f2fs/data.c                                            |   58 +++-
 fs/f2fs/debug.c                                           |   11 
 fs/f2fs/f2fs.h                                            |   11 
 fs/f2fs/node.c                                            |   29 +-
 fs/f2fs/node.h                                            |    4 
 fs/f2fs/shrinker.c                                        |    4 
 fs/f2fs/super.c                                           |    9 
 fs/fcntl.c                                                |   10 
 fs/io_uring.c                                             |   91 ++++--
 fs/jffs2/jffs2_fs_sb.h                                    |    1 
 fs/jffs2/super.c                                          |   17 -
 fs/namespace.c                                            |    9 
 fs/nfs/nfs42xdr.c                                         |   36 +-
 fs/nfs/nfs4super.c                                        |    2 
 fs/nfs/pnfs.c                                             |   33 ++
 fs/nfs/pnfs.h                                             |    5 
 fs/pnode.h                                                |    2 
 fs/quota/quota_tree.c                                     |    8 
 fs/reiserfs/stree.c                                       |    6 
 include/linux/mm.h                                        |    5 
 include/uapi/linux/const.h                                |    5 
 include/uapi/linux/ethtool.h                              |    2 
 include/uapi/linux/kernel.h                               |    9 
 include/uapi/linux/lightnvm.h                             |    2 
 include/uapi/linux/mroute6.h                              |    2 
 include/uapi/linux/netfilter/x_tables.h                   |    2 
 include/uapi/linux/netlink.h                              |    2 
 include/uapi/linux/sysctl.h                               |    2 
 kernel/cgroup/cgroup-v1.c                                 |    2 
 kernel/module.c                                           |    6 
 kernel/time/tick-sched.c                                  |    7 
 lib/zlib_dfltcc/Makefile                                  |    2 
 lib/zlib_dfltcc/dfltcc.c                                  |    6 
 lib/zlib_dfltcc/dfltcc_deflate.c                          |    3 
 lib/zlib_dfltcc/dfltcc_inflate.c                          |    4 
 lib/zlib_dfltcc/dfltcc_syms.c                             |   17 -
 mm/hugetlb.c                                              |   22 +
 mm/memory_hotplug.c                                       |    2 
 mm/page_alloc.c                                           |    8 
 net/ethtool/channels.c                                    |    6 
 net/ethtool/strset.c                                      |    2 
 net/mptcp/protocol.c                                      |    2 
 net/sched/sch_taprio.c                                    |   17 +
 sound/core/pcm_native.c                                   |    9 
 sound/core/rawmidi.c                                      |   49 ++-
 sound/core/seq/seq_queue.h                                |    8 
 tools/include/uapi/linux/const.h                          |    5 
 82 files changed, 710 insertions(+), 536 deletions(-)

Anant Thazhemadam (2):
      Bluetooth: hci_h5: close serdev device and free hu in h5_close
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Arnaldo Carvalho de Melo (1):
      tools headers UAPI: Sync linux/const.h with the kernel headers

Baoquan He (1):
      mm: memmap defer init doesn't work as expected

Bart Van Assche (1):
      scsi: block: Fix a race in the runtime power management code

Boqun Feng (1):
      fcntl: Fix potential deadlock in send_sig{io, urg}()

Chao Yu (1):
      f2fs: fix shift-out-of-bounds in sanity_check_raw_super()

Christopher Obbard (1):
      um: random: Register random as hwrng-core device

Chunguang Xu (1):
      ext4: avoid s_mb_prefetch to be zero in individual scenarios

Daeho Jeong (1):
      f2fs: fix race of pending_pages in decompression

Dan Williams (1):
      device-dax: Fix range release

Daniel Vetter (1):
      fbcon: Disable accelerated scrolling

Davide Caratti (1):
      net/sched: sch_taprio: reset child qdiscs before freeing them

Dinghao Liu (1):
      rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Eric Biggers (1):
      fs/namespace.c: WARN if mnt_count has become negative

Gabriel Krisman Bertazi (1):
      um: ubd: Submit all data segments atomically

Greg Kroah-Hartman (1):
      Linux 5.10.5

Heiko Carstens (1):
      s390: always clear kernel stack backchain before calling functions

Hyeongseok Kim (1):
      dm verity: skip verity work if I/O error when system is shutting down

Ilya Leoshkevich (1):
      lib/zlib: fix inflating zlib streams on s390

Ivan Vecera (1):
      ethtool: fix error paths in ethnl_set_channels()

Jaegeuk Kim (1):
      f2fs: avoid race condition for shrinker count

Jake Wang (1):
      drm/amd/display: updated wm table for Renoir

Jamie Iles (1):
      jffs2: Fix NULL pointer dereference in rp_size fs option parsing

Jan Kara (1):
      quota: Don't overflow quota file offsets

Jeff Layton (1):
      ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails

Jens Axboe (2):
      io_uring: don't assume mm is constant across submits
      io_uring: use bottom half safe lock for fixed file data

Jessica Yu (1):
      module: delay kobject uevent until after module init call

Kevin Vigor (1):
      md/raid10: initialize r10_bio->read_slot before use.

Mauro Carvalho Chehab (1):
      media: gp8psk: initialize stats at power control logic

Michal Kubecek (1):
      ethtool: fix string set id check

Mike Kravetz (1):
      mm/hugetlb: fix deadlock in hugetlb_cow error path

Miroslav Benes (1):
      module: set MODULE_STATE_GOING state when a module fails to load

Nicholas Piggin (1):
      powerpc/64: irq replay remove decrementer overflow check

Paolo Abeni (1):
      mptcp: fix security context on server socket

Pavel Begunkov (4):
      io_uring: close a small race gap for files cancel
      io_uring: add a helper for setting a ref node
      io_uring: fix io_sqe_files_unregister() hangs
      io_uring: remove racy overflow list fast checks

Petr Vorel (1):
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Qinglang Miao (3):
      cgroup: Fix memory leak when parsing multiple source parameters
      powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
      i3c master: fix missing destroy_workqueue() on error in i3c_master_register

Quanyang Wang (1):
      opp: fix memory leak in _allocate_opp_table

Randy Dunlap (3):
      zlib: move EXPORT_SYMBOL() and MODULE_LICENSE() out of dfltcc_syms.c
      scsi: cxgb4i: Fix TLS dependency
      bfs: don't use WARNING: string when it's just info.

Rodrigo Siqueira (1):
      drm/amd/display: Add get_dig_frontend implementation for DCEx

Rustam Kovhaev (1):
      reiserfs: add check for an invalid ih_entry_count

Serge Semin (1):
      spi: dw-bt1: Fix undefined devm_mux_control_get symbol

Takashi Iwai (3):
      ALSA: seq: Use bool for snd_seq_queue internal flags
      ALSA: rawmidi: Access runtime->avail always in spinlock
      ALSA: pcm: Clear the full allocated memory at hw_params

Theodore Ts'o (1):
      ext4: check for invalid block size early when mounting a file system

Thomas Gleixner (1):
      tick/sched: Remove bogus boot "safety" check

Trond Myklebust (2):
      NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode
      NFSv4.2: Don't error when exiting early on a READ_PLUS buffer overflow

Viresh Kumar (1):
      opp: Call the missing clk_put() on error

Xiaoguang Wang (1):
      io_uring: check kthread stopped flag when sq thread is unparked

Zhang Qilong (1):
      watchdog: rti-wdt: fix reference leak in rti_wdt_probe

Zheng Liang (1):
      rtc: pl031: fix resource leak in pl031_probe

lizhe (1):
      jffs2: Allow setting rp_size to zero during remounting

