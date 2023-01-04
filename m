Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197F665D0F9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjADKyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbjADKxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:53:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E6A5FEF;
        Wed,  4 Jan 2023 02:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93777616CA;
        Wed,  4 Jan 2023 10:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D86FC433F0;
        Wed,  4 Jan 2023 10:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672829627;
        bh=VBML3cTBe7758fH1v1U00MqtVY94pjTIhJ5Y61BwEjA=;
        h=From:To:Cc:Subject:Date:From;
        b=nfO0JVYQ3DEFm/06Yc9ivyOQOxOQh57xJqVb4WJ7RXQrlelkleQQQNwv5NAl1HuEf
         k9dx/8purWkY4WErRIRnFrHU+1WYEUB+w36wVkUpVIwvkwVIU5gTBYqXH3LC1vx2qg
         VOhPNVSOz27GsCH0G/jocknhVKMLDmhKuhNjJkpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.17
Date:   Wed,  4 Jan 2023 11:53:38 +0100
Message-Id: <167282961870246@kroah.com>
X-Mailer: git-send-email 2.39.0
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

I'm announcing the release of the 6.0.17 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/trace/kprobes.rst   |    3 -
 Makefile                          |    2 
 arch/powerpc/kernel/rtas.c        |   20 ++++++-
 block/bfq-iosched.c               |    2 
 block/blk-cgroup.c                |  100 ++++++++++++++------------------------
 block/blk-cgroup.h                |   68 +++++++------------------
 block/blk-throttle.c              |    7 +-
 block/blk-throttle.h              |    8 +--
 block/blk.h                       |    2 
 block/genhd.c                     |   12 +++-
 block/ioctl.c                     |   12 ++--
 drivers/acpi/resource.c           |   78 ++++++++++++++++++++++++-----
 drivers/ata/ahci.c                |   32 ++++++++----
 drivers/char/tpm/eventlog/acpi.c  |   12 +++-
 drivers/char/tpm/tpm_crb.c        |   29 +++++++----
 drivers/char/tpm/tpm_tis.c        |    9 +--
 drivers/hid/hid-ids.h             |    3 +
 drivers/hid/hid-multitouch.c      |    4 +
 drivers/hid/hid-plantronics.c     |    9 +++
 drivers/iommu/mtk_iommu.c         |    2 
 drivers/md/md.c                   |    9 ++-
 drivers/mfd/mt6360-core.c         |   14 ++++-
 drivers/mmc/host/vub300.c         |    2 
 drivers/nvme/host/pci.c           |   37 +++++++-------
 drivers/nvme/target/passthru.c    |   11 +---
 drivers/rtc/rtc-msc313.c          |   12 ----
 drivers/soundwire/dmi-quirks.c    |    8 +++
 drivers/usb/dwc3/dwc3-qcom.c      |   13 +++-
 fs/binfmt_elf_fdpic.c             |    5 +
 fs/cifs/smb2file.c                |    4 -
 fs/eventfd.c                      |   37 +++++++-------
 fs/eventpoll.c                    |   18 +++---
 fs/f2fs/gc.c                      |    1 
 fs/f2fs/node.c                    |    3 -
 fs/hfsplus/hfsplus_fs.h           |    2 
 fs/hfsplus/inode.c                |    4 -
 fs/hfsplus/options.c              |    4 +
 fs/ntfs3/attrib.c                 |   18 ++++++
 fs/ntfs3/attrlist.c               |    5 +
 fs/ntfs3/bitmap.c                 |    2 
 fs/ntfs3/frecord.c                |   14 +++++
 fs/ntfs3/fslog.c                  |   35 ++++---------
 fs/ntfs3/fsntfs.c                 |   10 ++-
 fs/ntfs3/index.c                  |    6 ++
 fs/ntfs3/inode.c                  |    9 +++
 fs/ntfs3/record.c                 |   10 +++
 fs/ntfs3/super.c                  |    9 +--
 fs/overlayfs/dir.c                |   46 +++++++++++------
 fs/overlayfs/file.c               |    1 
 fs/pnode.c                        |    2 
 fs/pstore/ram.c                   |    2 
 fs/pstore/zone.c                  |    2 
 include/linux/eventfd.h           |    7 ++
 include/linux/nvme.h              |    3 -
 include/uapi/linux/eventpoll.h    |    6 ++
 io_uring/io_uring.c               |    2 
 io_uring/msg_ring.c               |    4 -
 io_uring/opdef.c                  |    7 ++
 io_uring/opdef.h                  |    2 
 kernel/futex/syscalls.c           |   11 ++--
 kernel/kcsan/core.c               |   50 +++++++++++++++++++
 kernel/kprobes.c                  |    8 ---
 kernel/locking/rtmutex.c          |   55 +++++++++++++++++---
 kernel/locking/rtmutex_api.c      |    6 +-
 mm/compaction.c                   |   18 +-----
 mm/mempolicy.c                    |    1 
 net/sunrpc/auth_gss/svcauth_gss.c |    9 ++-
 sound/pci/hda/patch_hdmi.c        |   27 +++++++---
 sound/usb/line6/driver.c          |    3 -
 sound/usb/line6/midi.c            |    6 +-
 sound/usb/line6/midibuf.c         |   25 ++++++---
 sound/usb/line6/midibuf.h         |    5 +
 sound/usb/line6/pod.c             |    3 -
 tools/objtool/check.c             |    2 
 74 files changed, 663 insertions(+), 366 deletions(-)

Adam Vodopjan (1):
      ata: ahci: Fix PCS quirk application for suspend

Aditya Garg (1):
      hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Adrian Freund (1):
      ACPI: resource: do IRQ override on Lenovo 14ALC7

Al Viro (1):
      ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags

Artem Egorkine (2):
      ALSA: line6: correct midi status byte when receiving data from podxt
      ALSA: line6: fix stack overflow in line6_midi_transmit

ChiYuan Huang (1):
      mfd: mt6360: Add bounds checking in Regmap read/write call-backs

Christian Brauner (1):
      pnode: terminate at peers of source

Christoph Hellwig (9):
      blk-cgroup: fix error unwinding in blkcg_init_queue
      blk-cgroup: remove blk_queue_root_blkg
      blk-cgroup: remove open coded blkg_lookup instances
      blk-cgroup: cleanup the blkg_lookup family of functions
      blk-cgroup: pass a gendisk to blkcg_init_queue and blkcg_exit_queue
      blk-throttle: pass a gendisk to blk_throtl_init and blk_throtl_exit
      blk-cgroup: pass a gendisk to blkg_destroy_all
      nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition
      nvmet: don't defer passthrough commands with trivial effects to the workqueue

Christophe Leroy (1):
      objtool: Fix SEGFAULT

Chuck Lever (1):
      SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Dan Carpenter (1):
      fs/ntfs3: Delete duplicate condition in ntfs_read_mft()

Deren Wu (1):
      mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Edward Lo (7):
      fs/ntfs3: Validate data run offset
      fs/ntfs3: Add null pointer check to attr_load_runs_vcn
      fs/ntfs3: Add null pointer check for inode operations
      fs/ntfs3: Validate attribute name offset
      fs/ntfs3: Validate buffer length while parsing index
      fs/ntfs3: Validate resident attribute name
      fs/ntfs3: Validate index root when initialize NTFS security

Erik Schumacher (1):
      ACPI: resource: do IRQ override on XMG Core 15

Greg Kroah-Hartman (1):
      Linux 6.0.17

Hanjun Guo (3):
      tpm: acpi: Call acpi_put_table() to fix memory leak
      tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
      tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hawkins Jiawei (1):
      fs/ntfs3: Fix slab-out-of-bounds read in run_unpack

Jaegeuk Kim (1):
      f2fs: allow to read node block after shutdown

Jan Kara (1):
      block: Do not reread partition table on exclusively open device

Jens Axboe (2):
      eventpoll: add EPOLL_URING_WAKE poll wakeup flag
      eventfd: provide a eventfd_signal_mask() helper

Jiri Slaby (SUSE) (1):
      ACPI: resource: do IRQ override on LENOVO IdeaPad

José Expósito (1):
      HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

Kees Cook (1):
      rtc: msc313: Fix function prototype mismatch in msc313_rtc_probe()

Keith Busch (2):
      nvme-pci: fix mempool alloc size
      nvme-pci: fix page size checks

Klaus Jensen (1):
      nvme-pci: fix doorbell buffer value endianness

Luca Stefani (1):
      pstore: Properly assign mem_type property

Marco Elver (1):
      kcsan: Instrument memcpy/memset/memmove with newer Clang

Mathieu Desnoyers (2):
      futex: Fix futex_waitv() hrtimer debug object leak on kcalloc error
      mm/mempolicy: fix memory leak in set_mempolicy_home_node system call

Mel Gorman (1):
      rtmutex: Add acquire semantics for rtmutex lock acquisition slow path

Miaoqian Lin (1):
      usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init

Mikulas Patocka (1):
      md: fix a crash in mempool_free

NARIBAYASHI Akira (1):
      mm, compaction: fix fast_isolate_around() to stay within boundaries

Nathan Lynch (2):
      powerpc/rtas: avoid device tree lookups in rtas_os_term()
      powerpc/rtas: avoid scheduling in rtas_os_term()

Paulo Alcantara (2):
      cifs: fix static checker warning
      cifs: don't leak -ENOMEM in smb2_open_file()

Pavel Begunkov (1):
      io_uring: dont remove file from msg_ring reqs

Pavel Machek (1):
      f2fs: should put a page when checking the summary info

Pierre-Louis Bossart (1):
      soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15

Qiujun Huang (1):
      pstore/zone: Use GFP_ATOMIC to allocate zone buffer

Ricardo Ribalda (1):
      iommu/mediatek: Fix crash on isr after kexec()

Shigeru Yoshida (1):
      fs/ntfs3: Fix memory leak on ntfs_fill_super() error path

Takashi Iwai (1):
      ALSA: hda/hdmi: Static PCM mapping again with AMD HDMI codecs

Tamim Khan (1):
      ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA

Tejun Heo (1):
      blk-iolatency: Fix memory leak on add_disk() failures

Terry Junge (1):
      HID: plantronics: Additional PIDs for double volume key presses quirk

Tetsuo Handa (2):
      fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()
      fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()

Wang Yufen (1):
      binfmt: Fix error return code in load_elf_fdpic_binary()

Yin Xiujiang (1):
      fs/ntfs3: Fix slab-out-of-bounds in r_page

Yu Kuai (1):
      block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq

Zhang Tianci (1):
      ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

edward lo (2):
      fs/ntfs3: Validate BOOT record_size
      fs/ntfs3: Add overflow check for attribute size

wuqiang (1):
      kprobes: kretprobe events missing on 2-core KVM guest

