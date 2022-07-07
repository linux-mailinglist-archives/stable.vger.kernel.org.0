Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75056A779
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiGGQJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiGGQIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EB833A3D;
        Thu,  7 Jul 2022 09:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D25C3B82124;
        Thu,  7 Jul 2022 16:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AED0C3411E;
        Thu,  7 Jul 2022 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210116;
        bh=617NzsJEpUeTfY5kWzOGskWtnjp16XWFayR7kaZ8SFM=;
        h=From:To:Cc:Subject:Date:From;
        b=jQEL0eB/loxJJgixpUTQAOrzfvN5dFos2FGv42L+YiL//cJdPrXpRr4w05QuyrSbi
         X1hyQxVROl+1f0QpkRO0h6o9772Cy0wulGd2RkgditD2NQDMkuU4I8+FPM7wGOGaSc
         aMXWslf0wbb9EPNguNAhrGmGoysjanxWjdG9zX8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.251
Date:   Thu,  7 Jul 2022 18:08:18 +0200
Message-Id: <165721009823437@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.251 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/xen/p2m.c                          |    6 -
 arch/s390/crypto/arch_random.c              |  111 ---------------------
 arch/s390/include/asm/archrandom.h          |   21 ++--
 arch/s390/kernel/setup.c                    |    5 
 drivers/block/xen-blkfront.c                |   56 +++++++---
 drivers/hwmon/ibmaem.c                      |   12 +-
 drivers/infiniband/hw/qedr/qedr.h           |    1 
 drivers/infiniband/hw/qedr/verbs.c          |    4 
 drivers/md/dm-raid.c                        |   34 +++---
 drivers/md/raid5.c                          |    1 
 drivers/net/bonding/bond_3ad.c              |    3 
 drivers/net/bonding/bond_alb.c              |    2 
 drivers/net/caif/caif_virtio.c              |   10 +
 drivers/net/dsa/bcm_sf2.c                   |    5 
 drivers/net/tun.c                           |   15 ++
 drivers/net/usb/ax88179_178a.c              |  101 ++++++++++++++-----
 drivers/net/usb/qmi_wwan.c                  |    2 
 drivers/net/usb/usbnet.c                    |    4 
 drivers/net/virtio_net.c                    |    8 +
 drivers/net/xen-netfront.c                  |   52 +++++++++
 drivers/nfc/nfcmrvl/i2c.c                   |    6 -
 drivers/nfc/nfcmrvl/spi.c                   |    6 -
 drivers/nfc/nxp-nci/i2c.c                   |    3 
 drivers/nvdimm/bus.c                        |    4 
 drivers/xen/gntdev-common.h                 |    8 +
 drivers/xen/gntdev.c                        |  146 +++++++++++++++++++---------
 net/ipv6/seg6_hmac.c                        |    1 
 net/ipv6/sit.c                              |   10 -
 net/netfilter/nft_set_hash.c                |    2 
 net/rose/rose_timer.c                       |   34 +++---
 net/sunrpc/xdr.c                            |    2 
 tools/testing/selftests/net/udpgso_bench.sh |    2 
 33 files changed, 405 insertions(+), 274 deletions(-)

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Chris Ye (1):
      nvdimm: Fix badblocks clear off-by-one error

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1070 composition

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Dimitris Michailidis (1):
      selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Eric Dumazet (1):
      net: bonding: fix possible NULL deref in rlb code

Greg Kroah-Hartman (1):
      Linux 4.19.251

Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Jakub Kicinski (3):
      net: tun: unlink NAPI from device on destruction
      net: tun: stop NAPI when detaching queues
      net: tun: avoid disabling NAPI twice

Jason A. Donenfeld (1):
      s390/archrandom: simplify back to earlier design and initialize earlier

Jason Wang (2):
      virtio-net: fix race between ndo_open() and virtio_device_ready()
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Kamal Heib (1):
      RDMA/qedr: Fix reporting QP timeout attribute

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Michael Walle (1):
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Mikulas Patocka (1):
      dm raid: fix KASAN warning in raid5_add_disks

Oleksandr Tyshchenko (1):
      xen/arm: Fix race in RB-tree based P2M accounting

Oliver Neukum (1):
      usbnet: fix memory allocation in helpers

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Roger Pau Monne (4):
      xen/blkfront: fix leaking data in shared pages
      xen/netfront: fix leaking data in shared pages
      xen/netfront: force data bouncing when backend is untrusted
      xen/blkfront: force data bouncing when backend is untrusted

Yang Yingliang (1):
      hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Yevhen Orlov (1):
      net: bonding: fix use-after-free after 802.3ad slave unbind

YueHaibing (1):
      net: ipv6: unexport __init-annotated seg6_hmac_net_init()

katrinzhou (1):
      ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot (1):
      sit: use min

