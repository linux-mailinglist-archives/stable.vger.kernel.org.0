Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36823624D6
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhDPQAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 12:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238227AbhDPQAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 12:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962946113D;
        Fri, 16 Apr 2021 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618588784;
        bh=ck7G4WfOa0BOYzo6GqCAuMFNVZZ7iWMU14AxFti9LG4=;
        h=From:To:Cc:Subject:Date:From;
        b=b8JlRJ+vxnx3wIvN/ysps28GhNblpX5uhOFYIWD1r7b3me9SffnIA3PNpg0brSYV2
         FwF774+XF1NVJcugPHU11W2TLSsKvU7KzHfjaC639Y01NqcIqnz9Elf0oJlNrKRW44
         aXzFEkkK9PldWOpe8GeIV0/oyngLbeDIksO1LxYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.267
Date:   Fri, 16 Apr 2021 17:59:37 +0200
Message-Id: <161858877881225@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.267 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/arm/Kconfig                             |    7 --
 arch/arm/Makefile                            |    6 +-
 arch/arm/include/asm/unified.h               |   77 +--------------------------
 arch/ia64/include/asm/ptrace.h               |    8 --
 arch/parisc/include/asm/cmpxchg.h            |    2 
 arch/s390/kernel/cpcmd.c                     |    6 +-
 drivers/char/agp/Kconfig                     |    2 
 drivers/clk/clk.c                            |   30 ++++------
 drivers/clk/socfpga/clk-gate.c               |    2 
 drivers/gpu/drm/imx/imx-ldb.c                |   10 +++
 drivers/iio/light/hid-sensor-prox.c          |   14 ++++
 drivers/infiniband/hw/cxgb4/cm.c             |    3 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    6 +-
 drivers/net/ethernet/freescale/gianfar.c     |    6 +-
 drivers/net/ieee802154/atusb.c               |    1 
 drivers/net/tun.c                            |   48 ++++++++++++++++
 drivers/soc/fsl/qbman/qman.c                 |    2 
 drivers/usb/usbip/vudc_sysfs.c               |   42 +++++++++++---
 drivers/xen/events/events_base.c             |   14 ++--
 drivers/xen/events/events_internal.h         |    2 
 fs/cifs/connect.c                            |    1 
 fs/direct-io.c                               |    5 +
 fs/gfs2/super.c                              |   10 ++-
 fs/ocfs2/aops.c                              |   11 ---
 fs/ocfs2/file.c                              |    8 ++
 fs/proc/task_mmu.c                           |    1 
 include/net/red.h                            |    4 -
 kernel/workqueue.c                           |    2 
 net/batman-adv/translation-table.c           |    2 
 net/ieee802154/nl-mac.c                      |    7 +-
 net/ieee802154/nl802154.c                    |   23 ++++++--
 net/ipv4/netfilter/arp_tables.c              |    2 
 net/ipv4/netfilter/ip_tables.c               |    2 
 net/ipv6/netfilter/ip6_tables.c              |    2 
 net/ipv6/route.c                             |    8 +-
 net/mac802154/llsec.c                        |    2 
 net/netfilter/x_tables.c                     |   10 ---
 net/nfc/llcp_sock.c                          |   10 +++
 net/sched/sch_teql.c                         |    3 +
 net/tipc/socket.c                            |    2 
 net/wireless/sme.c                           |    2 
 sound/drivers/aloop.c                        |   11 ++-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c |    6 +-
 tools/perf/util/map.c                        |    7 +-
 45 files changed, 244 insertions(+), 187 deletions(-)

Alexander Aring (8):
      net: ieee802154: nl-mac: fix check on panid
      net: ieee802154: fix nl802154 del llsec key
      net: ieee802154: fix nl802154 del llsec dev
      net: ieee802154: fix nl802154 add llsec key
      net: ieee802154: fix nl802154 del llsec devkey
      net: ieee802154: forbid monitor for set llsec params
      net: ieee802154: forbid monitor for del llsec seclevel
      net: ieee802154: stop dump llsec params for monitors

Alexander Gordeev (1):
      s390/cpcmd: fix inline assembly register clobbering

Arnaldo Carvalho de Melo (1):
      perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Arnd Bergmann (2):
      soc/fsl: qbman: fix conflicting alignment attributes
      drm/imx: imx-ldb: fix out of bounds array access warning

Bob Peterson (1):
      gfs2: report "already frozen/thawed" errors

Claudiu Manoil (1):
      gianfar: Handle error code at MAC address change

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Eric Dumazet (1):
      sch_red: fix off-by-one checks in red_check_params()

Florian Westphal (1):
      netfilter: x_tables: fix compat match/target pad out-of-bound write

Gao Xiang (1):
      parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Greg Kroah-Hartman (2):
      Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
      Linux 4.9.267

Hans de Goede (1):
      ASoC: intel: atom: Stop advertising non working S24LE support

Helge Deller (1):
      parisc: parisc-agp requires SBA IOMMU driver

Hugh Dickins (1):
      mm: add cond_resched() in gather_pte_stats()

Jack Qiu (1):
      fs: direct-io: fix missing sdio->boundary

Jonas Holmberg (1):
      ALSA: aloop: Fix initialization of controls

Juergen Gross (1):
      xen/events: fix setting irq affinity

Krzysztof Kozlowski (1):
      clk: socfpga: fix iomem pointer cast on 64-bit

Luca Fancellu (1):
      xen/evtchn: Change irq_info lock to raw_spinlock_t

Lukasz Bartosik (1):
      clk: fix invalid usage of list cursor in unregister

Lv Yunlong (1):
      net:tipc: Fix a double free in tipc_sk_mcast_rcv

Muhammad Usama Anjum (1):
      net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Nicolas Pitre (1):
      ARM: 8723/2: always assume the "unified" syntax for assembly code

Pavel Skripkin (3):
      drivers: net: fix memory leak in atusb_probe
      drivers: net: fix memory leak in peak_usb_create_dev
      net: mac802154: Fix general protection fault

Pavel Tikhomirov (1):
      net: sched: sch_teql: fix null-pointer dereference

Phillip Potter (1):
      net: tun: set tun->dev->addr_len during TUNSETLINK processing

Potnuri Bharat Teja (1):
      RDMA/cxgb4: check for ipv6 address properly while destroying listener

Sergei Trofimovich (1):
      ia64: fix user_stack_pointer() for ptrace()

Shuah Khan (1):
      usbip: fix vudc usbip_sockfd_store races leading to gpf

Tetsuo Handa (1):
      batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Wengang Wang (1):
      ocfs2: fix deadlock between setattr and dio_end_io_write

Xiaoming Ni (4):
      nfc: fix refcount leak in llcp_sock_bind()
      nfc: fix refcount leak in llcp_sock_connect()
      nfc: fix memory leak in llcp_sock_connect()
      nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Ye Xiang (1):
      iio: hid-sensor-prox: Fix scale not correct issue

Zqiang (1):
      workqueue: Move the position of debug_work_activate() in __queue_work()

