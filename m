Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE831E47A5
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgE0PgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 11:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgE0PgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 11:36:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5FC20776;
        Wed, 27 May 2020 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590593781;
        bh=0chIcTzL9zF8Xj2Xy7CX8f0cZi2EEy6h0mItKk0tc1Q=;
        h=Subject:To:Cc:From:Date:From;
        b=XZ++TF0AcZmzV3pcbbZB6T1YsVF27r9tKJyCzHD7SivTisTwgjujxha9R8QQawuqD
         8uGA8b6P3HnfRvs/OGoAv7FiyrMj7+bb5rlPfZNm53olMHZtO68KCRKhche6bp27wb
         rhPM5Fgylt7qtxDzWyQand9yizJZDZpwJECk9B/o=
Subject: Linux 4.4.225
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 27 May 2020 17:36:16 +0200
Message-ID: <159059377614465@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.225 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/l2tp.txt         |    8 
 Makefile                                  |    2 
 arch/arm/include/asm/futex.h              |    9 
 drivers/hid/hid-ids.h                     |    1 
 drivers/hid/hid-multitouch.c              |    3 
 drivers/i2c/i2c-dev.c                     |   60 +++--
 drivers/media/media-device.c              |   43 +++-
 drivers/media/media-devnode.c             |  168 +++++++++-------
 drivers/media/usb/uvc/uvc_driver.c        |    2 
 drivers/misc/mei/client.c                 |    2 
 drivers/net/ethernet/intel/igb/igb_main.c |    4 
 drivers/nvdimm/btt.c                      |    8 
 drivers/platform/x86/alienware-wmi.c      |   17 -
 drivers/platform/x86/asus-nb-wmi.c        |   24 ++
 drivers/staging/iio/accel/sca3000_ring.c  |    2 
 drivers/staging/iio/resolver/ad2s1210.c   |   17 +
 drivers/usb/core/message.c                |    4 
 fs/ceph/caps.c                            |    1 
 fs/ext4/xattr.c                           |   66 +++---
 fs/file.c                                 |    2 
 fs/gfs2/glock.c                           |    3 
 include/linux/cpumask.h                   |   19 +
 include/linux/net.h                       |    3 
 include/linux/padata.h                    |   13 -
 include/media/media-device.h              |    5 
 include/media/media-devnode.h             |   32 ++-
 include/net/ipv6.h                        |    2 
 include/uapi/linux/if_pppol2tp.h          |   13 -
 include/uapi/linux/l2tp.h                 |   17 +
 kernel/padata.c                           |   88 +++-----
 lib/cpumask.c                             |   32 +++
 net/ipv6/datagram.c                       |    4 
 net/l2tp/l2tp_core.c                      |  181 +++++------------
 net/l2tp/l2tp_core.h                      |   47 ++--
 net/l2tp/l2tp_eth.c                       |  216 ++++++++++++--------
 net/l2tp/l2tp_ip.c                        |   68 +++---
 net/l2tp/l2tp_ip6.c                       |   82 +++----
 net/l2tp/l2tp_netlink.c                   |  124 +++++++-----
 net/l2tp/l2tp_ppp.c                       |  309 +++++++++++++++++-------------
 net/socket.c                              |   46 ++++
 security/integrity/evm/evm_crypto.c       |    2 
 sound/core/pcm_lib.c                      |    1 
 42 files changed, 1015 insertions(+), 735 deletions(-)

Al Viro (1):
      fix multiplication overflow in copy_fdtable()

Alan Stern (1):
      USB: core: Fix misleading driver bug report

Alexander Usyskin (1):
      mei: release me_cl object reference

Asbjørn Sloth Tønnesen (3):
      net: l2tp: export debug flags to UAPI
      net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
      net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*

Bob Peterson (1):
      Revert "gfs2: Don't demote a glock until its revokes are written"

Brent Lu (1):
      ALSA: pcm: fix incorrect hw_base increase

Cao jin (1):
      igb: use igb_adapter->io_addr instead of e1000_hw->hw_addr

Christophe JAILLET (1):
      iio: sca3000: Remove an erroneous 'get_device()'

Colin Ian King (1):
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Dan Carpenter (1):
      i2c: dev: use after free in detach

Daniel Jordan (2):
      padata: initialize pd->cpu with effective cpumask
      padata: purge get_cpu and reorder_via_wq from padata_do_serial

Dragos Bogdan (1):
      staging: iio: ad2s1210: Fix SPI reading

Erico Nunes (1):
      i2c: dev: switch from register_chrdev to cdev API

Greg Kroah-Hartman (1):
      Linux 4.4.225

Guillaume Nault (22):
      l2tp: lock socket before checking flags in connect()
      l2tp: fix racy socket lookup in l2tp_ip and l2tp_ip6 bind()
      l2tp: hold session while sending creation notifications
      l2tp: take a reference on sessions used in genetlink handlers
      l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
      l2tp: remove useless duplicate session detection in l2tp_netlink
      l2tp: remove l2tp_session_find()
      l2tp: define parameters of l2tp_session_get*() as "const"
      l2tp: define parameters of l2tp_tunnel_find*() as "const"
      l2tp: initialise session's refcount before making it reachable
      l2tp: hold tunnel while looking up sessions in l2tp_netlink
      l2tp: hold tunnel while processing genl delete command
      l2tp: hold tunnel while handling genl tunnel updates
      l2tp: hold tunnel while handling genl TUNNEL_GET commands
      l2tp: hold tunnel used while creating sessions with netlink
      l2tp: prevent creation of sessions on terminated tunnels
      l2tp: pass tunnel pointer to ->session_create()
      l2tp: fix l2tp_eth module loading
      l2tp: don't register sessions in l2tp_session_create()
      l2tp: initialise l2tp_eth sessions before registering them
      l2tp: protect sock pointer of struct pppol2tp_session with RCU
      l2tp: initialise PPP sessions before registering them

Hans de Goede (1):
      platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Herbert Xu (1):
      padata: Replace delayed timer with immediate workqueue in padata_reorder

Jason A. Donenfeld (1):
      padata: get_next is never NULL

Kevin Hao (1):
      i2c: dev: Fix the race between the release of i2c_dev and cdev

Mathias Krause (3):
      padata: ensure the reorder timer callback runs on the correct CPU
      padata: ensure padata_do_serial() runs on the correct CPU
      padata: set cpu_index of unused CPUs to -1

Mauro Carvalho Chehab (2):
      media-devnode: fix namespace mess
      media-device: dynamically allocate struct media_devnode

Max Kellermann (2):
      drivers/media/media-devnode: clear private_data before put_device()
      media-devnode: add missing mutex lock in error handler

Michael Kelley (1):
      cpumask: Make for_each_cpu_wrap() available on UP as well

Peter Zijlstra (1):
      sched/fair, cpumask: Export for_each_cpu_wrap()

R. Parameswaran (3):
      New kernel function to get IP overhead on a socket.
      L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
      l2tp: device MTU setup, tunnel socket needs a lock

Roberto Sassu (1):
      evm: Check also if *tfm is an error pointer in init_desc()

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Shuah Khan (3):
      media: Fix media_open() to clear filp->private_data in error leg
      media: fix use-after-free in cdev_put() when app exits after driver unbind
      media: fix media devnode ioctl/syscall and unregister race

Theodore Ts'o (1):
      ext4: lock the xattr block before checksuming it

Thomas Gleixner (1):
      ARM: futex: Address build warning

Tobias Klauser (1):
      padata: Remove unused but set variables

Vishal Verma (1):
      libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Wolfram Sang (1):
      i2c: dev: don't start function name with 'return'

Wu Bo (1):
      ceph: fix double unlock in handle_cap_export()

viresh kumar (1):
      i2c-dev: don't get i2c adapter via i2c_dev

