Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA85FF8BB
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJOGVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 02:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiJOGVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 02:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6E56336C;
        Fri, 14 Oct 2022 23:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D27A8B818B2;
        Sat, 15 Oct 2022 06:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C754C433D6;
        Sat, 15 Oct 2022 06:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665814884;
        bh=HzhAvdNzJ+Pi6j4WFj2gNLuxd0xmCmkj+tnS07Gt/90=;
        h=From:To:Cc:Subject:Date:From;
        b=F04p+lBT5SYRDMadPAMeEw8b8rnA0g9x6dEws9wfsS94Kuq5vut3gsq9gE0jJpK6U
         YoBkzpCcBeMS4Xr+WdyHltg9JZ/OtB90EP0Sstdfxo7OITzgiooPaajPw5QNy6VhW4
         /5R5l+z0exOpEXaJjfxbwQ7egbKi2D8DmD0jjPCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.74
Date:   Sat, 15 Oct 2022 08:22:01 +0200
Message-Id: <166581492119138@kroah.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.74 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/powerpc/include/asm/paca.h               |    1 
 arch/powerpc/include/asm/rtas.h               |    1 
 arch/powerpc/kernel/paca.c                    |   32 ---
 arch/powerpc/kernel/rtas.c                    |   54 ------
 arch/powerpc/sysdev/xics/ics-rtas.c           |   22 +-
 drivers/char/mem.c                            |    4 
 drivers/char/random.c                         |   25 ++
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   12 -
 drivers/input/joystick/xpad.c                 |   20 ++
 drivers/misc/pci_endpoint_test.c              |   34 +++-
 drivers/net/wireless/mac80211_hwsim.c         |    2 
 drivers/scsi/stex.c                           |   17 +-
 drivers/usb/serial/qcserial.c                 |    1 
 fs/ceph/file.c                                |   10 -
 fs/nilfs2/inode.c                             |   19 ++
 fs/nilfs2/segment.c                           |   21 +-
 include/scsi/scsi_cmnd.h                      |    2 
 net/mac80211/agg-rx.c                         |   14 -
 net/mac80211/ibss.c                           |   33 ++-
 net/mac80211/ieee80211_i.h                    |   40 ++--
 net/mac80211/mesh.c                           |   87 +++++-----
 net/mac80211/mesh_hwmp.c                      |   44 ++---
 net/mac80211/mesh_plink.c                     |   11 -
 net/mac80211/mesh_sync.c                      |   26 +--
 net/mac80211/mlme.c                           |  218 ++++++++++++++------------
 net/mac80211/rx.c                             |   12 -
 net/mac80211/scan.c                           |   16 +
 net/mac80211/tdls.c                           |   63 ++++---
 net/mac80211/util.c                           |   53 +++---
 net/wireless/scan.c                           |   77 +++++----
 security/integrity/platform_certs/load_uefi.c |    2 
 sound/pci/hda/hda_intel.c                     |    3 
 33 files changed, 535 insertions(+), 443 deletions(-)

Cameron Gutman (1):
      Input: xpad - fix wireless 360 controller breaking after suspend

Frank Wunderlich (1):
      USB: serial: qcserial: add new usb-id for Dell branded EM7455

Giovanni Cabiddu (1):
      Revert "crypto: qat - reduce size of mapped region"

Greg Kroah-Hartman (1):
      Linux 5.15.74

Hu Weiwen (1):
      ceph: don't truncate file in atomic_open

Jason A. Donenfeld (4):
      random: restore O_NONBLOCK support
      random: clamp credited irq bits to maximum mixed
      random: avoid reading two cache lines on irq randomness
      random: use expired timer rather than wq for mixing fast pool

Johannes Berg (14):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: mac80211: fix crash in beacon protection for P2P-device
      wifi: cfg80211: update hidden BSSes to avoid WARN_ON
      mac80211: mesh: clean up rx_bcn_presp API
      mac80211: move CRC into struct ieee802_11_elems
      mac80211: mlme: find auth challenge directly
      mac80211: always allocate struct ieee802_11_elems
      mac80211: fix memory leaks with element parsing
      wifi: mac80211: fix MBSSID parsing use-after-free

Linus Torvalds (1):
      scsi: stex: Properly zero out the passthrough command structure

Nathan Lynch (1):
      Revert "powerpc/rtas: Implement reentrant rtas call"

Orlando Chamberlain (1):
      efi: Correct Macmini DMI match in uefi cert quirk

Pavel Rojtberg (1):
      Input: xpad - add supported devices as contributed on github

Ryusuke Konishi (4):
      nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
      nilfs2: fix use-after-free bug of struct nilfs_root
      nilfs2: fix leak of nilfs_root in case of writer thread creation failure
      nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Shunsuke Mie (2):
      misc: pci_endpoint_test: Aggregate params checking for xfer
      misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Takashi Iwai (1):
      ALSA: hda: Fix position reporting on Poulsbo

