Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D463475C5
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhCXKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhCXKTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:19:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67734619BB;
        Wed, 24 Mar 2021 10:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616581163;
        bh=VsUZkGvKQjsd2fyPplNNxkkTYGaEhjLFN/VUEK+OGew=;
        h=From:To:Cc:Subject:Date:From;
        b=TkGRYVCQSLIjTLuXCO1XR5cre1RPGx0tcVvd01nma/v5ldTfclU8zp3nnucQpax7d
         LWyaZfaoQhBqIyvJhOTr56y+SzXCLaDkBx93/tJiDUTDBulzopSlpqD2qkuigoLYTJ
         KGsXHYu1wGmApD7AobcsL09bffMp9ji4mtneZl44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.263
Date:   Wed, 24 Mar 2021 11:19:18 +0100
Message-Id: <161658115876200@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.263 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/x86/events/intel/ds.c                    |    2 
 arch/x86/include/asm/processor.h              |    9 ---
 arch/x86/include/asm/thread_info.h            |   23 ++++++++
 arch/x86/kernel/apic/io_apic.c                |   10 +++
 arch/x86/kernel/signal.c                      |   24 --------
 drivers/iio/imu/adis16400_core.c              |    3 -
 drivers/net/dsa/b53/b53_common.c              |   20 +++++++
 drivers/net/dsa/b53/b53_regs.h                |    1 
 drivers/net/dsa/bcm_sf2.c                     |    5 +
 drivers/net/dsa/bcm_sf2_regs.h                |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |   27 +++++++++
 drivers/nvme/target/core.c                    |   17 +++++-
 drivers/pci/hotplug/rpadlpar_sysfs.c          |   14 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c              |    4 -
 drivers/usb/gadget/composite.c                |    4 -
 drivers/usb/gadget/configfs.c                 |   16 ++++-
 drivers/usb/gadget/usbstring.c                |    4 -
 fs/btrfs/ctree.c                              |    2 
 fs/ext4/block_validity.c                      |   71 ++++++++++++--------------
 fs/ext4/ext4.h                                |    6 +-
 fs/ext4/extents.c                             |   16 ++---
 fs/ext4/indirect.c                            |    6 --
 fs/ext4/inode.c                               |   13 ++--
 fs/ext4/mballoc.c                             |    4 -
 fs/ext4/namei.c                               |   29 +++++++++-
 fs/ext4/super.c                               |    5 +
 fs/select.c                                   |   10 +--
 include/linux/thread_info.h                   |   13 ++++
 include/uapi/linux/usb/ch9.h                  |    3 +
 kernel/futex.c                                |    3 -
 kernel/irq/manage.c                           |    4 +
 kernel/time/alarmtimer.c                      |    2 
 kernel/time/hrtimer.c                         |    2 
 kernel/time/posix-cpu-timers.c                |    2 
 net/qrtr/qrtr.c                               |    2 
 net/sunrpc/svc.c                              |    6 +-
 net/sunrpc/svc_xprt.c                         |    4 -
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c    |    6 +-
 41 files changed, 255 insertions(+), 146 deletions(-)

Dan Carpenter (2):
      scsi: lpfc: Fix some error codes in debugfs
      iio: adis16400: Fix an error code in adis16400_initial_setup()

Daniel Kobras (1):
      sunrpc: fix refcount leak for rpc auth modules

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Greg Kroah-Hartman (1):
      Linux 4.9.263

Jacob Keller (2):
      ixgbe: check for Tx timestamp timeouts during watchdog
      ixgbe: prevent ptp_rx_hang from running when in FILTER_ALL mode

Jan Kara (3):
      ext4: handle error of ext4_setup_system_zone() on remount
      ext4: don't allow overlapping system zones
      ext4: check journal inode extents more carefully

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

Joe Korty (1):
      NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Kan Liang (1):
      perf/x86/intel: Fix a crash caused by zero PEBS status

Macpaul Lin (1):
      USB: replace hardcode maximum usb string length by definition

Oleg Nesterov (3):
      kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
      x86: Move TS_COMPAT back to asm/thread_info.h
      x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Pavel Skripkin (1):
      net/qrtr: fix __netdev_alloc_skb call

Sagi Grimberg (1):
      nvmet: don't check iosqes,iocqes for discovery controllers

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Timo Rothenpieler (1):
      svcrdma: disable timeouts on rdma backchannel

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

zhangyi (F) (1):
      ext4: find old entry again if failed to rename whiteout

