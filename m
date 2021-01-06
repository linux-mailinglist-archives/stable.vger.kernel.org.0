Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018512EC19C
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbhAFRBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 12:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbhAFRBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 12:01:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FCB92311E;
        Wed,  6 Jan 2021 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609952436;
        bh=KDNRjzDFKcd9bXIz2r3bHw5P/nghxHA37t2thO5lZOs=;
        h=From:To:Cc:Subject:Date:From;
        b=C2nN5cYYZ67AX3OTt8HpuKByrvIm29tuEZO48CyArP0hFvkBSTKf8vdXfbxbAyG/Z
         65gBFGmZWTSOergeLWw/RlvJFyJS34AEdNUZjm7zbOwHWAxt9/JgkcAPuN0U7WHmEU
         PkpHC/jSqn1f2yucS9hr+VXI7cT+C1vmwBB5wDk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.165
Date:   Wed,  6 Jan 2021 18:01:56 +0100
Message-Id: <160995251611257@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.165 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 -
 arch/powerpc/include/asm/bitops.h       |   23 +++++++++++++--
 arch/powerpc/sysdev/mpic_msgr.c         |    2 -
 arch/x86/kvm/cpuid.h                    |   14 +++++++++
 arch/x86/kvm/svm.c                      |    9 +----
 arch/x86/kvm/vmx.c                      |    6 +--
 drivers/block/null_blk_zoned.c          |   20 ++++++++-----
 drivers/bluetooth/hci_h5.c              |    8 +++--
 drivers/md/dm-verity-target.c           |   12 +++++++
 drivers/md/raid10.c                     |    3 +
 drivers/media/usb/dvb-usb/gp8psk.c      |    2 -
 drivers/misc/vmw_vmci/vmci_context.c    |    2 -
 drivers/rtc/rtc-sun6i.c                 |    8 +++--
 drivers/vfio/pci/vfio_pci.c             |    3 -
 drivers/xen/gntdev.c                    |   17 +++++++----
 fs/crypto/hooks.c                       |   10 +++---
 fs/ext4/namei.c                         |    3 +
 fs/ext4/super.c                         |   14 +++------
 fs/f2fs/f2fs.h                          |    2 +
 fs/fcntl.c                              |   10 +++---
 fs/nfs/nfs4super.c                      |    2 -
 fs/nfs/pnfs.c                           |   33 ++++++++++++++++++++-
 fs/nfs/pnfs.h                           |    5 +++
 fs/quota/quota_tree.c                   |    8 ++---
 fs/reiserfs/stree.c                     |    6 +++
 fs/ubifs/dir.c                          |   17 ++++++++---
 include/linux/fscrypt_notsupp.h         |    5 +++
 include/linux/fscrypt_supp.h            |   29 ++++++++++++++++++
 include/linux/of.h                      |    1 
 include/uapi/linux/const.h              |    5 +++
 include/uapi/linux/ethtool.h            |    2 -
 include/uapi/linux/kernel.h             |    9 -----
 include/uapi/linux/lightnvm.h           |    2 -
 include/uapi/linux/mroute6.h            |    2 -
 include/uapi/linux/netfilter/x_tables.h |    2 -
 include/uapi/linux/netlink.h            |    2 -
 include/uapi/linux/sysctl.h             |    2 -
 kernel/module.c                         |    6 ++-
 sound/core/pcm_native.c                 |    9 ++++-
 sound/core/rawmidi.c                    |   49 ++++++++++++++++++++++----------
 sound/core/seq/seq_queue.h              |    8 ++---
 41 files changed, 274 insertions(+), 100 deletions(-)

Anant Thazhemadam (2):
      Bluetooth: hci_h5: close serdev device and free hu in h5_close
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Boqun Feng (1):
      fcntl: Fix potential deadlock in send_sig{io, urg}()

Christophe Leroy (1):
      powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Damien Le Moal (1):
      null_blk: Fix zone size initialization

Dinghao Liu (1):
      rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Eric Biggers (4):
      fscrypt: add fscrypt_is_nokey_name()
      ext4: prevent creating duplicate encrypted filenames
      f2fs: prevent creating duplicate encrypted filenames
      ubifs: prevent creating duplicate encrypted filenames

Greg Kroah-Hartman (1):
      Linux 4.19.165

Hyeongseok Kim (1):
      dm verity: skip verity work if I/O error when system is shutting down

Jan Kara (2):
      ext4: don't remount read-only with errors=continue on reboot
      quota: Don't overflow quota file offsets

Jessica Yu (1):
      module: delay kobject uevent until after module init call

Johan Hovold (1):
      of: fix linker-section match-table corruption

Kevin Vigor (1):
      md/raid10: initialize r10_bio->read_slot before use.

Mauro Carvalho Chehab (1):
      media: gp8psk: initialize stats at power control logic

Miroslav Benes (1):
      module: set MODULE_STATE_GOING state when a module fails to load

Paolo Bonzini (2):
      KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
      KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits

Petr Vorel (1):
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Qinglang Miao (1):
      powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Rustam Kovhaev (1):
      reiserfs: add check for an invalid ih_entry_count

Souptick Joarder (1):
      xen/gntdev.c: Mark pages as dirty

Takashi Iwai (3):
      ALSA: seq: Use bool for snd_seq_queue internal flags
      ALSA: rawmidi: Access runtime->avail always in spinlock
      ALSA: pcm: Clear the full allocated memory at hw_params

Trond Myklebust (1):
      NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode

