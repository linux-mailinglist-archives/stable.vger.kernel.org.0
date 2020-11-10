Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F32AD95B
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgKJOz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgKJOz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 09:55:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B9F1206B2;
        Tue, 10 Nov 2020 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020154;
        bh=b9ZkdaislWVP3urFe/Aq6O61f5Jv5ertm9EYpjL1Eik=;
        h=From:To:Cc:Subject:Date:From;
        b=k14bEQv+nqgqIL9M2AvdQGwE6DZx+3IXrIpH2k2LunXdMNMTQLhMbXKbtEPUgABW1
         MgDVt+1vB/xMrfK4abJbMQBC2VkvIPXDfN+YjoqdKtnl3OuT2NDRGXHTYebH8A3Sr7
         8AlKza6xZo+8Yl/gIY8sVyLBVbLU1u44l1iy+PAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.242
Date:   Tue, 10 Nov 2020 15:56:50 +0100
Message-Id: <1605020210211238@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.242 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/arc/kernel/entry.S                    |   16 +++-
 arch/arc/kernel/stacktrace.c               |    7 +-
 arch/arm/Kconfig                           |    2 
 arch/arm/boot/dts/s5pv210.dtsi             |   78 ++++++++++-------------
 arch/arm/boot/dts/sun4i-a10.dtsi           |    2 
 arch/arm/plat-samsung/Kconfig              |    1 
 arch/arm64/Kconfig.platforms               |    1 
 arch/ia64/kernel/Makefile                  |    2 
 arch/powerpc/platforms/powernv/opal-dump.c |    9 --
 arch/powerpc/platforms/powernv/opal-elog.c |   33 +++++++--
 arch/powerpc/platforms/powernv/smp.c       |    2 
 arch/sparc/kernel/smp_64.c                 |   65 ++++---------------
 arch/um/kernel/sigio.c                     |    6 -
 arch/x86/kernel/kexec-bzimage64.c          |    3 
 drivers/acpi/acpi_extlog.c                 |    6 -
 drivers/acpi/video_detect.c                |    9 ++
 drivers/ata/sata_rcar.c                    |    2 
 drivers/base/core.c                        |    4 -
 drivers/clk/ti/clockdomain.c               |    2 
 drivers/cpufreq/acpi-cpufreq.c             |    3 
 drivers/dma/dma-jz4780.c                   |    7 +-
 drivers/iio/gyro/itg3200_buffer.c          |   15 +++-
 drivers/input/serio/hil_mlc.c              |   21 +++++-
 drivers/input/serio/hp_sdc_mlc.c           |    8 +-
 drivers/leds/leds-bcm6328.c                |    2 
 drivers/leds/leds-bcm6358.c                |    2 
 drivers/md/bitmap.c                        |    2 
 drivers/md/raid5.c                         |    4 -
 drivers/memory/emif.c                      |   33 +--------
 drivers/message/fusion/mptscsih.c          |   13 ++-
 drivers/mmc/host/via-sdmmc.c               |    3 
 drivers/mtd/ubi/wl.c                       |   13 +++
 drivers/net/ethernet/freescale/gianfar.c   |   14 ----
 drivers/net/ethernet/renesas/ravb_main.c   |   10 ++
 drivers/net/wan/hdlc_fr.c                  |   98 +++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/htt_rx.c   |    8 ++
 drivers/of/of_reserved_mem.c               |   13 +++
 drivers/power/test_power.c                 |    6 +
 drivers/scsi/scsi_scan.c                   |    7 +-
 drivers/staging/comedi/drivers/cb_pcidas.c |    1 
 drivers/tty/serial/8250/8250_mtk.c         |    2 
 drivers/tty/serial/serial_txx9.c           |    3 
 drivers/tty/vt/keyboard.c                  |   39 +++++------
 drivers/tty/vt/vt.c                        |   24 -------
 drivers/tty/vt/vt_ioctl.c                  |   32 +++++----
 drivers/usb/core/quirks.c                  |    3 
 drivers/usb/misc/adutux.c                  |    1 
 drivers/usb/serial/cyberjack.c             |    7 +-
 drivers/usb/serial/option.c                |    8 ++
 drivers/vhost/vringh.c                     |    9 +-
 drivers/video/fbdev/pvr2fb.c               |    2 
 drivers/w1/masters/mxc_w1.c                |   14 ++--
 drivers/watchdog/rdc321x_wdt.c             |    5 -
 drivers/xen/events/events_base.c           |   29 ++++++--
 fs/9p/vfs_file.c                           |    4 -
 fs/btrfs/tree-log.c                        |    8 ++
 fs/cachefiles/rdwr.c                       |    3 
 fs/ceph/addr.c                             |    2 
 fs/efivarfs/super.c                        |    3 
 fs/ext4/namei.c                            |    6 -
 fs/ext4/super.c                            |    5 +
 fs/f2fs/checkpoint.c                       |    2 
 fs/f2fs/dir.c                              |    7 --
 fs/f2fs/namei.c                            |    6 -
 fs/gfs2/ops_fstype.c                       |   18 +++--
 fs/nfs/namespace.c                         |   12 ++-
 fs/ubifs/debug.c                           |    1 
 fs/xfs/xfs_rtalloc.c                       |   10 ++
 include/linux/hil_mlc.h                    |    2 
 include/linux/mtd/pfow.h                   |    2 
 init/Kconfig                               |    3 
 kernel/debug/debug_core.c                  |   22 ++++--
 kernel/fork.c                              |   10 +-
 kernel/trace/ring_buffer.c                 |    8 +-
 kernel/trace/trace.h                       |   26 ++++++-
 kernel/trace/trace_selftest.c              |    9 ++
 lib/fonts/font_10x18.c                     |    2 
 lib/fonts/font_6x10.c                      |    2 
 lib/fonts/font_6x11.c                      |    2 
 lib/fonts/font_7x14.c                      |    2 
 lib/fonts/font_8x16.c                      |    2 
 lib/fonts/font_8x8.c                       |    2 
 lib/fonts/font_acorn_8x8.c                 |    2 
 lib/fonts/font_mini_4x6.c                  |    2 
 lib/fonts/font_pearl_8x8.c                 |    2 
 lib/fonts/font_sun12x22.c                  |    2 
 lib/fonts/font_sun8x16.c                   |    2 
 net/9p/trans_fd.c                          |    2 
 net/ceph/messenger.c                       |    5 +
 net/sunrpc/clnt.c                          |    8 ++
 net/tipc/core.c                            |    5 +
 net/tipc/msg.c                             |    5 -
 net/vmw_vsock/af_vsock.c                   |    2 
 scripts/setlocalversion                    |   21 ++++--
 sound/usb/pcm.c                            |    1 
 96 files changed, 548 insertions(+), 405 deletions(-)

Alan Stern (1):
      USB: Add NO_LPM quirk for Kingston flash drive

Alex Hung (1):
      ACPI: video: use ACPI backlight for HP 635 Notebook

Anant Thazhemadam (2):
      net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
      gfs2: add validation checks for size of superblock

Andrew Gabbasov (1):
      ravb: Fix bit fields checking in ravb_hwtstamp_get()

Andy Shevchenko (2):
      device property: Keep secondary firmware node secondary by type
      device property: Don't clear secondary pointer for shared primary firmware node

Ashish Sangwan (1):
      NFS: fix nfs_path in case of a rename retry

Ben Hutchings (1):
      ACPI / extlog: Check for RDMSR failure

Chao Yu (2):
      f2fs crypto: avoid unneeded memory allocation in ->readdir
      f2fs: fix to check segment boundary during SIT page readahead

Claire Chang (1):
      serial: 8250_mtk: Fix uart_get_baud_rate warning

Claudiu Manoil (2):
      gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
      gianfar: Account for Tx PTP timestamp in the skb headroom

Clément Péron (1):
      ARM: dts: sun4i-a10: fix cpu_alert temperature

Dan Carpenter (1):
      memory: emif: Remove bogus debugfs error handling

Daniel Vetter (1):
      vt: Disable KD_FONT_OP_COPY

Daniele Palmas (2):
      USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231
      USB: serial: option: add Telit FN980 composition 0x1055

Darrick J. Wong (1):
      xfs: fix realtime bitmap/summary file truncation when growing rt volume

Douglas Anderson (1):
      kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

Eddy Wu (1):
      fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Eric Biggers (1):
      fscrypt: return -EXDEV for incompatible rename or link into encrypted dir

Filipe Manana (1):
      btrfs: reschedule if necessary when logging directory items

Geert Uytterhoeven (1):
      ata: sata_rcar: Fix DMA boundary mask

Geoffrey D. Bennett (1):
      ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Greg Kroah-Hartman (1):
      Linux 4.4.242

Gustavo A. R. Silva (1):
      mtd: lpddr: Fix bad logic in print_drs_error

Helge Deller (2):
      scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()
      hil/parisc: Disable HIL driver when it gets stuck

Hoang Huu Le (1):
      tipc: fix use-after-free in tipc_bcast_get_mode

Ian Abbott (1):
      staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Ilya Dryomov (1):
      libceph: clear con->out_msg on Policy::stateful_server faults

Jan Kara (1):
      ext4: Detect already used quota file early

Jeff Vander Stoep (1):
      vsock: use ns_capable_noaudit() on socket create

Jiri Slaby (2):
      vt: keyboard, simplify vt_kdgkbsent
      vt: keyboard, extend func_buf_lock to readers

Jisheng Zhang (1):
      arm64: berlin: Select DW_APB_TIMER_OF

Johan Hovold (1):
      USB: serial: cyberjack: fix write-URB completion race

Johannes Berg (1):
      um: change sigio_spinlock to a mutex

John Ogness (1):
      printk: reduce LOG_BUF_SHIFT range for H8300

Jonathan Cameron (1):
      iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Juergen Gross (1):
      xen/events: don't use chip_data for legacy IRQs

Kairui Song (1):
      x86/kexec: Use up-to-dated screen_info copy to fill boot params

Krzysztof Kozlowski (5):
      ARM: dts: s5pv210: move PMU node out of clock controller
      ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node
      ia64: fix build error with !COREDUMP
      ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
      ARM: s3c24xx: fix missing system reset

Lee Jones (1):
      Fonts: Replace discarded const qualifier

Linus Torvalds (1):
      tty: make FONTX ioctl use the tty pointer they were actually passed

Madhuparna Bhowmik (2):
      mmc: via-sdmmc: Fix data race bug
      drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Mahesh Salgaonkar (1):
      powerpc/powernv/elog: Fix race while processing OPAL error log event.

Marek Behún (1):
      leds: bcm6328, bcm6358: use devres LED registering function

Martin Fuzzey (1):
      w1: mxc_w1: Fix timeout resolution problem leading to bus error

Matthew Wilcox (Oracle) (3):
      ceph: promote to unsigned long long before shifting
      9P: Cast to loff_t before multiplying
      cachefiles: Handle readpage error correctly

Michael Schaller (1):
      efivarfs: Replace invalid slashes with exclamation marks in dentries.

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Mukesh Ojha (1):
      powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler

NeilBrown (1):
      SUNRPC: ECONNREFUSED should cause a rebind.

Nicholas Piggin (1):
      sparc64: remove mm_cpumask clearing to fix kthread_use_mm race

Oliver Neukum (1):
      USB: adutux: fix debugging

Oliver O'Halloran (1):
      powerpc/powernv/smp: Fix spurious DBG() warning

Paul Cercueil (1):
      dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Qinglang Miao (1):
      serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Qiujun Huang (1):
      ring-buffer: Return 0 on success from ring_buffer_resize()

Rasmus Villemoes (1):
      scripts/setlocalversion: make git describe output more reliable

Sathishkumar Muruganandam (1):
      ath10k: fix VHT NSS calculation when STBC is enabled

Song Liu (1):
      md/raid5: fix oops during stripe resizing

Stefano Garzarella (1):
      vringh: fix __vringh_iov() when riov and wiov are different

Steven Rostedt (VMware) (2):
      ftrace: Fix recursion check for NMI test
      ftrace: Handle tracing when switching between context

Tero Kristo (1):
      clk: ti: clockdomain: fix static checker warning

Tom Rix (1):
      video: fbdev: pvr2fb: initialize variables

Tung Nguyen (1):
      tipc: fix memory leak caused by tipc_buf_append()

Vincent Whitchurch (1):
      of: Fix reserved-memory overlap detection

Vineet Gupta (2):
      ARC: stack unwinding: avoid indefinite looping
      Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

Wei Huang (1):
      acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

Xie He (1):
      drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Xiongfeng Wang (1):
      power: supply: test_power: add missing newlines when printing parameters by sysfs

Zhao Heming (1):
      md/bitmap: md_bitmap_get_counter returns wrong blocks

Zhihao Cheng (2):
      ubifs: dent: Fix some potential memory leaks while iterating entries
      ubi: check kthread_should_stop() after the setting of task state

