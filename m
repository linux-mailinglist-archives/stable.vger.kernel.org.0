Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C501241E19
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgHKQVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729144AbgHKQVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:21:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7264C20774;
        Tue, 11 Aug 2020 16:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162862;
        bh=hTtWBWsIvukC/dh8ASEAUpJcJkxywaKMw28Z25WE2FM=;
        h=From:To:Cc:Subject:Date:From;
        b=EaRF8nQa0x551/5dVrvz4sor0Ez123jl48vJlkk38g6hX0+ptTr73nVVjkgErpLc3
         ZRk6m2iChgRqn/RcM6jYA+qlvIu5j9wTDaPYc6vkl2/TTrQ9tMoeF/Q3tLtOBkDvX2
         Btj+toEOQOnIBgu9nLMZxdDXmSGLR+4a759lhToo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.1
Date:   Tue, 11 Aug 2020 18:21:08 +0200
Message-Id: <159716286872188@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.1 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm64/include/asm/archrandom.h         |    1 
 arch/arm64/kernel/kaslr.c                   |   14 +--
 arch/powerpc/include/asm/kasan.h            |    2 
 arch/powerpc/mm/init_32.c                   |    2 
 arch/powerpc/mm/kasan/kasan_init_32.c       |   29 +++----
 drivers/android/binder.c                    |   15 +++
 drivers/gpio/gpio-max77620.c                |    5 -
 drivers/leds/leds-88pm860x.c                |   14 +++
 drivers/leds/leds-da903x.c                  |   14 +++
 drivers/leds/leds-lm3533.c                  |   12 ++
 drivers/leds/leds-lm36274.c                 |   15 ++-
 drivers/leds/leds-wm831x-status.c           |   14 +++
 drivers/misc/lkdtm/heap.c                   |    9 +-
 drivers/mtd/mtdchar.c                       |   56 +++++++++++--
 drivers/pci/controller/pci-tegra.c          |   32 -------
 drivers/scsi/ufs/ufshcd.c                   |    9 +-
 drivers/staging/android/ashmem.c            |   12 ++
 drivers/staging/rtl8188eu/core/rtw_mlme.c   |    4 
 drivers/staging/rtl8712/hal_init.c          |    3 
 drivers/staging/rtl8712/usb_intf.c          |   11 +-
 drivers/usb/host/xhci-pci.c                 |   10 +-
 drivers/usb/misc/iowarrior.c                |   35 ++++++--
 drivers/usb/serial/qcserial.c               |    1 
 drivers/video/console/vgacon.c              |    4 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c  |    2 
 fs/xattr.c                                  |   84 ++++++++++++++++++--
 include/linux/prandom.h                     |   78 +++++++++++++++++++
 include/linux/random.h                      |   66 ----------------
 include/linux/xattr.h                       |    2 
 net/bluetooth/hci_event.c                   |   11 ++
 scripts/coccinelle/misc/add_namespace.cocci |    8 +
 scripts/nsdeps                              |    2 
 security/integrity/ima/Kconfig              |    2 
 security/integrity/ima/ima_appraise.c       |    6 +
 security/smack/smackfs.c                    |   13 ++-
 sound/core/seq/oss/seq_oss.c                |    8 +
 sound/pci/hda/hda_intel.c                   |    1 
 sound/pci/hda/patch_ca0132.c                |   12 ++
 sound/pci/hda/patch_realtek.c               |  114 ++++++++++++++++++++++++++++
 40 files changed, 548 insertions(+), 186 deletions(-)

Adam Ford (1):
      omapfb: dss: Fix max fclk divider for omap36xx

Bruno Meneguele (1):
      ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime

Christophe Leroy (2):
      Revert "powerpc/kasan: Fix shadow pages allocation failure"
      powerpc/kasan: Fix shadow pages allocation failure

Connor McAdams (3):
      ALSA: hda/ca0132 - Add new quirk ID for Recon3D.
      ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.
      ALSA: hda/ca0132 - Fix AE-5 microphone selection commands.

Dinghao Liu (1):
      Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

Dmitry Osipenko (1):
      gpio: max77620: Fix missing release of interrupt

Eric Biggers (1):
      Smack: fix use-after-free in smk_write_relabel_self()

Erik Ekman (1):
      USB: serial: qcserial: add EM7305 QDL product ID

Forest Crossman (2):
      usb: xhci: define IDs for various ASMedia host controllers
      usb: xhci: Fix ASMedia ASM1142 DMA addressing

Frank van der Linden (1):
      xattr: break delegations in {set,remove}xattr

Greg Kroah-Hartman (3):
      USB: iowarrior: fix up report size handling for some devices
      mtd: properly check all write ioctls for permissions
      Linux 5.8.1

Guenter Roeck (1):
      arm64: kaslr: Use standard early random function

Huacai Chen (1):
      ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops

Hui Wang (1):
      Revert "ALSA: hda: call runtime_allow() for all hda controllers"

Jann Horn (1):
      binder: Prevent context manager from incrementing ref 0

Johan Hovold (5):
      leds: wm831x-status: fix use-after-free on unbind
      leds: lm36274: fix use-after-free on unbind
      leds: da903x: fix use-after-free on unbind
      leds: lm3533: fix use-after-free on unbind
      leds: 88pm860x: fix use-after-free on unbind

Kees Cook (1):
      lkdtm/heap: Avoid edge and middle of slabs

Linus Torvalds (2):
      random32: move the pseudo-random 32-bit definitions to prandom.h
      random: random.h should include archrandom.h, not the other way around

Matthias Maennich (1):
      scripts: add dummy report mode to add_namespace.cocci

Nicolas Chauvet (1):
      PCI: tegra: Revert tegra124 raw_violation_fixup

Peilin Ye (3):
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Rustam Kovhaev (1):
      staging: rtl8712: handle firmware load failure

Stanley Chu (1):
      scsi: ufs: Fix and simplify setup_xfer_req variant operation

Suren Baghdasaryan (1):
      staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai (1):
      ALSA: seq: oss: Serialize ioctls

Yunhai Zhang (1):
      vgacon: Fix for missing check in scrollback handling

