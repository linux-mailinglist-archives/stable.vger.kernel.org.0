Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADBB56A76F
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiGGQIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiGGQIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D13326D2;
        Thu,  7 Jul 2022 09:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02073623CA;
        Thu,  7 Jul 2022 16:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD3AC3411E;
        Thu,  7 Jul 2022 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210093;
        bh=JGOccH4cg3SDqzIZP+3bB2LYjydm7FtNbG9bgf2x360=;
        h=From:To:Cc:Subject:Date:From;
        b=DmfwJibdjgs6/NXhFpDPGAH3WYabreGanldnerkR/AjXenuM3g6/fE9x0NMTSTaCj
         pYDxQbqk08WOCn8LFNE6MBspbrgxXmVWz0M3ckIiPf21ZaAZJ5/f8inOsiehgYbjhd
         ZvktRmHxb51JsVk3fqjRya4PNEX4Jvb4+s5Ohnq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.322
Date:   Thu,  7 Jul 2022 18:08:09 +0200
Message-Id: <165721008935130@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 4.9.322 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/xen/p2m.c                       |    6 -
 arch/powerpc/include/asm/ppc-opcode.h    |    4 
 arch/powerpc/platforms/powernv/powernv.h |    2 
 arch/powerpc/platforms/powernv/rng.c     |   91 ++++++++++++++++---
 arch/powerpc/platforms/powernv/setup.c   |    2 
 drivers/block/xen-blkfront.c             |   52 +++++++----
 drivers/hwmon/ibmaem.c                   |   12 +-
 drivers/md/raid5.c                       |    1 
 drivers/net/bonding/bond_3ad.c           |    3 
 drivers/net/bonding/bond_alb.c           |    2 
 drivers/net/caif/caif_virtio.c           |   10 +-
 drivers/net/usb/ax88179_178a.c           |  101 ++++++++++++++++-----
 drivers/net/usb/qmi_wwan.c               |    6 +
 drivers/net/usb/usbnet.c                 |   23 +++-
 drivers/net/xen-netfront.c               |   55 +++++++++++
 drivers/nfc/nfcmrvl/i2c.c                |    6 -
 drivers/nfc/nfcmrvl/spi.c                |    6 -
 drivers/nfc/nxp-nci/i2c.c                |    3 
 drivers/xen/gntdev.c                     |  144 +++++++++++++++++++++----------
 include/linux/skbuff.h                   |    1 
 net/core/skbuff.c                        |    9 +
 net/ipv6/sit.c                           |   10 --
 net/netfilter/nft_set_hash.c             |    2 
 net/rose/rose_timer.c                    |   34 ++++---
 net/sunrpc/xdr.c                         |    2 
 26 files changed, 439 insertions(+), 150 deletions(-)

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Daniele Palmas (3):
      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
      net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
      net: usb: qmi_wwan: add Telit 0x1070 composition

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Eric Dumazet (1):
      net: bonding: fix possible NULL deref in rlb code

Greg Kroah-Hartman (1):
      Linux 4.9.322

Ilya Lesokhin (1):
      net: Rename and export copy_skb_header

Jason A. Donenfeld (1):
      powerpc/powernv: wire up rng during setup_arch

Jason Wang (1):
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Jörgen Storvist (1):
      qmi_wwan: Added support for Telit LN940 series

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Michael Walle (1):
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Mikulas Patocka (1):
      dm raid: fix KASAN warning in raid5_add_disks

Oleksandr Tyshchenko (1):
      xen/arm: Fix race in RB-tree based P2M accounting

Oliver Neukum (2):
      usbnet: make sure no NULL pointer is passed through
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

katrinzhou (1):
      ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot (1):
      sit: use min

