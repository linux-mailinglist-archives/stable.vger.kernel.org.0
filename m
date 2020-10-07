Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADE0285B65
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 10:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgJGI6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 04:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgJGI6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 04:58:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5002A20797;
        Wed,  7 Oct 2020 08:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061100;
        bh=tF6Nsv6L+phYSzrgiw9bWHVq01uCBI4x0BA3/UP7VhI=;
        h=From:To:Cc:Subject:Date:From;
        b=ETHcWygaStBe5uTZkq85ja8FbMQOSnbIJRJimScQ96Lb9zMdzz5Qmcsod+hKmfvkA
         HcIUm9pPZ39wPLwG9/PA51vDieodb4tXLPrjCrF7ahZN36HROsGNgHE8pkIRTMiJvP
         clqfGCqaGJX4SVgzUsj1EBq4UBbttEjOayLXOHsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.150
Date:   Wed,  7 Oct 2020 10:59:03 +0200
Message-Id: <160206114389220@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.150 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/ia64/mm/init.c                         |    6 
 drivers/base/node.c                         |   84 +++++---
 drivers/clk/samsung/clk-exynos4.c           |    4 
 drivers/clk/socfpga/clk-s10.c               |    2 
 drivers/gpio/gpio-mockup.c                  |    2 
 drivers/gpio/gpio-sprd.c                    |    3 
 drivers/gpio/gpio-tc3589x.c                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |    2 
 drivers/gpu/drm/sun4i/sun8i_mixer.c         |    2 
 drivers/i2c/busses/i2c-cpm.c                |    3 
 drivers/input/mouse/trackpoint.c            |    2 
 drivers/input/serio/i8042-x86ia64io.h       |    7 
 drivers/iommu/exynos-iommu.c                |    8 
 drivers/mmc/host/sdhci-pci-core.c           |    3 
 drivers/net/ethernet/dec/tulip/de2104x.c    |    2 
 drivers/net/usb/rndis_host.c                |    2 
 drivers/net/wan/hdlc_cisco.c                |    1 
 drivers/net/wan/hdlc_fr.c                   |    6 
 drivers/net/wan/hdlc_ppp.c                  |    1 
 drivers/net/wan/lapbether.c                 |    4 
 drivers/nvme/host/core.c                    |   15 +
 drivers/nvme/host/fc.c                      |    6 
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c   |    2 
 drivers/spi/spi-fsl-espi.c                  |    5 
 drivers/usb/gadget/function/f_ncm.c         |   30 ---
 drivers/vhost/vsock.c                       |   94 ++++-----
 fs/eventpoll.c                              |   71 +++----
 fs/nfs/dir.c                                |    3 
 include/linux/mm.h                          |    2 
 include/linux/mmzone.h                      |   11 -
 include/linux/node.h                        |   11 -
 include/linux/virtio_vsock.h                |    3 
 kernel/trace/ftrace.c                       |    6 
 lib/random32.c                              |    2 
 mm/memory_hotplug.c                         |    5 
 mm/page_alloc.c                             |   11 -
 net/mac80211/vht.c                          |    8 
 net/netfilter/nf_conntrack_netlink.c        |    2 
 net/packet/af_packet.c                      |    9 
 net/vmw_vsock/virtio_transport.c            |  265 +++++++++++++++++-----------
 net/vmw_vsock/virtio_transport_common.c     |   13 -
 42 files changed, 424 insertions(+), 298 deletions(-)

Al Viro (4):
      epoll: do not insert into poll queues until all sanity checks are done
      epoll: replace ->visited/visited_list with generation count
      epoll: EPOLL_CTL_ADD: close the race in decision to take fast path
      ep_create_wakeup_source(): dentry name can change under you...

Bartosz Golaszewski (1):
      gpio: mockup: fix resource leak in error path

Bryan O'Donoghue (1):
      USB: gadget: f_ncm: Fix NDP16 datagram validation

Chaitanya Kulkarni (1):
      nvme-core: get/put ctrl and transport module in nvme_dev_open/release()

Chris Packham (2):
      spi: fsl-espi: Only process interrupts for expected events
      pinctrl: mvebu: Fix i2c sda definition for 98DX3236

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk

Felix Fietkau (1):
      mac80211: do not allow bigger VHT MPDUs than the hardware supports

Greg Kroah-Hartman (1):
      Linux 4.19.150

Hans de Goede (1):
      mmc: sdhci: Workaround broken command queuing on Intel GLK based IRBIS models

James Smart (1):
      nvme-fc: fail new connections to a deleted host or remote port

Jean Delvare (1):
      drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Jeffrey Mitchell (1):
      nfs: Fix security label length not being reset

Jiri Kosina (1):
      Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

Laurent Dufour (2):
      mm: replace memmap_context by meminit_context
      mm: don't rely on system state to detect hot-plug operations

Lucy Yan (1):
      net: dec: de2104x: Increase receive ring size for Tulip

Marek Szyprowski (1):
      clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Martin Cerveny (1):
      drm/sun4i: mixer: Extend regmap max_register

Nicolas VINCENT (1):
      i2c: cpm: Fix i2c_ram structure

Olympia Giannou (1):
      rndis_host: increase sleep time in the query-response loop

Or Cohen (1):
      net/packet: fix overflow in tpacket_rcv

Sebastien Boeuf (1):
      net: virtio_vsock: Enhance connection semantics

Stefano Garzarella (3):
      vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock
      vsock/virtio: stop workers during the .remove()
      vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()

Steven Rostedt (VMware) (1):
      ftrace: Move RCU is watching check after recursion check

Taiping Lai (1):
      gpio: sprd: Clear interrupt when setting the type as edge

Thibaut Sautereau (1):
      random32: Restore __latent_entropy attribute on net_rand_state

Vincent Huang (1):
      Input: trackpoint - enable Synaptics trackpoints

Will McVicker (1):
      netfilter: ctnetlink: add a range check for l3/l4 protonum

Xie He (3):
      drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
      drivers/net/wan/lapbether: Make skb->protocol consistent with the header
      drivers/net/wan/hdlc: Set skb->protocol before transmitting

Yu Kuai (1):
      iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

dillon min (1):
      gpio: tc35894: fix up tc35894 interrupt configuration

