Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92472279AD5
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgIZQ2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZQ2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:28:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF7BD2177B;
        Sat, 26 Sep 2020 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601137731;
        bh=SVyxDfO6fy3CNrHIbhiOhDlkhe53PtCS7tZfxXuHbVc=;
        h=From:To:Cc:Subject:Date:From;
        b=pL83tEbNjzon1eOx4eip9pWLHumg+mfjqkgo2wTvUWqrSNpBcPISFU2gx/839n+KO
         d9y/pVoOy+k8Rz9tKKYrEEkpkotB382+qbW5EVtJoS/IyaRYdzb9n4VHLUTiIb/x6E
         kw7nrntHy0PdKXEAnSKacFvTYiZKboy91UPbi4oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.148
Date:   Sat, 26 Sep 2020 18:29:02 +0200
Message-Id: <16011377421485@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.148 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kbuild/llvm.rst                        |   87 +++++++++
 MAINTAINERS                                          |    9 
 Makefile                                             |   38 +++-
 arch/x86/boot/compressed/Makefile                    |    2 
 drivers/net/dsa/rtl8366.c                            |   20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |   19 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c    |   31 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c    |    9 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    4 
 drivers/net/geneve.c                                 |   37 ++-
 drivers/net/phy/phy_device.c                         |    3 
 drivers/net/wan/Kconfig                              |    2 
 drivers/net/wan/Makefile                             |   12 -
 drivers/net/wan/hdlc_ppp.c                           |   16 +
 drivers/tty/serial/8250/8250_core.c                  |   11 -
 include/linux/skbuff.h                               |    7 
 include/net/inet_connection_sock.h                   |    4 
 kernel/kprobes.c                                     |    9 
 mm/huge_memory.c                                     |   40 ++--
 mm/vmscan.c                                          |    8 
 net/dcb/dcbnl.c                                      |    8 
 net/ipv4/ip_output.c                                 |    3 
 net/ipv4/route.c                                     |   13 -
 net/ipv4/tcp_bbr.c                                   |  180 ++++++++++++++++---
 net/ipv6/Kconfig                                     |    1 
 net/ipv6/ip6_fib.c                                   |   13 -
 net/key/af_key.c                                     |    7 
 net/qrtr/qrtr.c                                      |   20 +-
 net/sched/sch_generic.c                              |   49 +++--
 net/tipc/group.c                                     |   14 +
 net/tipc/msg.c                                       |    3 
 net/tipc/socket.c                                    |    5 
 tools/objtool/Makefile                               |    6 
 virt/kvm/kvm_main.c                                  |   21 +-
 34 files changed, 550 insertions(+), 161 deletions(-)

Dan Carpenter (1):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()

David Ahern (1):
      ipv4: Update exception handling for multipath routes via same device

Dmitry Golovin (1):
      x86/boot: kbuild: allow readelf executable to be specified

Edwin Peer (1):
      bnxt_en: return proper error codes in bnxt_show_temp

Eric Dumazet (3):
      ipv6: avoid lockdep issue in fib6_del()
      net: qrtr: check skb_put_padto() return value
      net: add __must_check to skb_put_padto()

Fangrui Song (1):
      Documentation/llvm: fix the name of llvm-size

Florian Fainelli (1):
      net: phy: Avoid NPD upon phy_detach() when driver is unbound

Ganji Aravind (1):
      cxgb4: Fix offset when clearing filter byte counters

Greg Kroah-Hartman (1):
      Linux 4.19.148

Jakub Kicinski (1):
      nfp: use correct define to return NONE fec

Linus Walleij (1):
      net: dsa: rtl8366: Properly clear member config

Lukas Wunner (1):
      serial: 8250: Avoid error message on reprobe

Mark Gray (1):
      geneve: add transport ports in route lookup for geneve

Mark Salyzyn (1):
      af_key: pfkey_dump needs parameter validation

Masahiro Yamada (5):
      net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware
      net: wan: wanxl: use $(M68KCC) instead of $(M68KAS) for rebuilding firmware
      kbuild: remove AS variable
      kbuild: replace AS=clang with LLVM_IAS=1
      kbuild: support LLVM=1 to switch the default tools to Clang/LLVM

Michael Chan (1):
      bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Muchun Song (1):
      kprobes: fix kill kprobe which has been marked as gone

Necip Fazil Yildiran (1):
      net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Nick Desaulniers (2):
      MAINTAINERS: add CLANG/LLVM BUILD SUPPORT info
      Documentation/llvm: add documentation on building w/ Clang/LLVM

Peilin Ye (1):
      tipc: Fix memory leak in tipc_group_create_member()

Petr Machata (1):
      net: DCB: Validate DCB_ATTR_DCB_BUFFER argument

Priyaranjan Jha (2):
      tcp_bbr: refactor bbr_target_cwnd() for general inflight provisioning
      tcp_bbr: adapt cwnd based on ack aggregation estimation

Ralph Campbell (1):
      mm/thp: fix __split_huge_pmd_locked() for migration PMD

Rustam Kovhaev (1):
      KVM: fix memory leak in kvm_io_bus_unregister_dev()

Tetsuo Handa (1):
      tipc: fix shutdown() of connection oriented socket

Vasily Gorbik (1):
      kbuild: add OBJSIZE variable for the size tool

Wei Wang (1):
      ip: fix tos reflection in ack and reset packets

Xin Long (1):
      tipc: use skb_unshare() instead in tipc_buf_append()

Xunlei Pang (1):
      mm: memcg: fix memcg reclaim soft lockup

Yunsheng Lin (1):
      net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc

