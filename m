Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7536D647
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhD1LRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhD1LRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BBB461168;
        Wed, 28 Apr 2021 11:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619608586;
        bh=G/+EZNpDd/ktaYInbhr1iqn8g31dvhdi9yI9V7jCbs4=;
        h=From:To:Cc:Subject:Date:From;
        b=vJ0NiFursab/N/eLmUMkrg08Aq7zSUnt4gfb8u5rW8yq6RPveyfsCZqskku95DW3Z
         lnP9sAZ8xq9snOd/L1XgQkdSqVysm+kE3VYtnv4Kz0sNkiB73h+M1wf9+AkVTGFv1F
         HfHnPmVXL0OimOe1ymWpjNeHYXqNGtRkPN0yY9nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.268
Date:   Wed, 28 Apr 2021 13:16:22 +0200
Message-Id: <161960858311193@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.268 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arc/kernel/signal.c                           |    4 
 arch/arm/boot/dts/omap3.dtsi                       |    3 
 arch/arm/boot/dts/omap4.dtsi                       |    5 
 arch/arm/boot/dts/omap5.dtsi                       |    5 
 arch/arm/mach-keystone/keystone.c                  |    4 
 arch/arm/probes/uprobes/core.c                     |    4 
 arch/ia64/mm/discontig.c                           |    6 
 arch/s390/kernel/entry.S                           |    1 
 arch/x86/kernel/crash.c                            |    3 
 drivers/dma/dw/Kconfig                             |    2 
 drivers/input/keyboard/nspire-keypad.c             |   56 ++--
 drivers/input/serio/i8042-x86ia64io.h              |    1 
 drivers/md/dm-table.c                              |   10 
 drivers/net/ethernet/amd/pcnet32.c                 |    5 
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |    2 
 drivers/net/ethernet/davicom/dm9000.c              |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    6 
 drivers/net/usb/hso.c                              |   35 --
 drivers/net/xen-netback/xenbus.c                   |   12 
 drivers/scsi/libsas/sas_ata.c                      |    9 
 fs/ext4/namei.c                                    |    2 
 include/linux/compiler-clang.h                     |   14 +
 include/linux/compiler-gcc.h                       |    4 
 include/linux/compiler-intel.h                     |    4 
 include/linux/overflow.h                           |  278 +++++++++++++++++++++
 net/core/neighbour.c                               |    2 
 net/ieee802154/nl802154.c                          |   29 ++
 net/sctp/socket.c                                  |   13 
 sound/soc/fsl/fsl_esai.c                           |    8 
 tools/arch/ia64/include/asm/barrier.h              |    3 
 31 files changed, 445 insertions(+), 93 deletions(-)

Alexander Aring (7):
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel

Alexander Shiyan (1):
      ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Andy Shevchenko (1):
      dmaengine: dw: Make it dependent to HAS_IOMEM

Anirudh Rayabharam (1):
      net: hso: fix null-ptr-deref during tty device unregistration

Arnd Bergmann (2):
      ARM: keystone: fix integer overflow warning
      Input: i8042 - fix Pegatron C15B ID entry

Christophe JAILLET (1):
      net: davicom: Fix regulator not turned off on failed probe

Fabian Vogt (1):
      Input: nspire-keypad - enable interrupts only when opened

Fredrik Strupe (1):
      ARM: 9071/1: uprobes: Don't hook on thumb instructions

Greg Kroah-Hartman (1):
      Linux 4.4.268

Guenter Roeck (1):
      pcnet32: Use pci_resource_len to validate PCI resource

Jason Xing (1):
      i40e: fix the panic when running bpf in xdpdrv mode

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

John Paul Adrian Glaubitz (1):
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Jolly Shah (1):
      scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Kees Cook (1):
      overflow.h: Add allocation size calculation helpers

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Mike Galbraith (1):
      x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Or Cohen (1):
      net/sctp: fix race condition in sctp_destroy_sock

Randy Dunlap (1):
      ia64: fix discontig.c section mismatches

Rasmus Villemoes (1):
      compiler.h: enable builtin overflow checkers and add fallback code

Tong Zhu (1):
      neighbour: Disregard DEAD dst in neigh_update

Tony Lindgren (2):
      ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
      ARM: dts: Fix swapped mmc order for omap3

Vasily Gorbik (1):
      s390/entry: save the caller of psw_idle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Wang Qing (1):
      arc: kernel: Return -EFAULT if copy_to_user() fails

Zhang Yi (1):
      ext4: correct error label in ext4_rename()

