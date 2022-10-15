Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28785FF8CD
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJOG0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 02:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJOG0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 02:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0A58B4F;
        Fri, 14 Oct 2022 23:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21A8A60AB4;
        Sat, 15 Oct 2022 06:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144B1C433B5;
        Sat, 15 Oct 2022 06:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665815153;
        bh=/gcv49zMEojO6ESR/TG9zdy27Xe+mwhQ69wLr/r4wJA=;
        h=From:To:Cc:Subject:Date:From;
        b=z1MNXXup1+7supJv49z51h5Y6Nir7/spkXOrt+XXMWfOsr/hrnY4khcB0adoMGzL5
         2iHoXdBZOz6f2HMGUhwsVUa6rTm0dC2Y4GdgbiTiVN/8pRx8H0PQmCKc0LcuySQ97D
         CdM4IqYANF1G5BXMkmkpLE7p/+ecA3wGPlGspGQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.2
Date:   Sat, 15 Oct 2022 08:26:33 +0200
Message-Id: <166581519416722@kroah.com>
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

I'm announcing the release of the 6.0.2 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/powerpc/include/asm/paca.h               |    1 
 arch/powerpc/include/asm/rtas.h               |    1 
 arch/powerpc/kernel/paca.c                    |   32 ----------
 arch/powerpc/kernel/rtas.c                    |   54 ------------------
 arch/powerpc/sysdev/xics/ics-rtas.c           |   22 +++----
 drivers/char/mem.c                            |    4 -
 drivers/char/random.c                         |   25 +++++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   12 ++--
 drivers/input/joystick/xpad.c                 |   20 ++++++
 drivers/misc/pci_endpoint_test.c              |   34 +++++++++--
 drivers/net/wireless/mac80211_hwsim.c         |    2 
 drivers/nvme/host/pci.c                       |    3 -
 drivers/scsi/qla2xxx/qla_gbl.h                |    2 
 drivers/scsi/qla2xxx/qla_isr.c                |   22 ++-----
 drivers/scsi/qla2xxx/qla_os.c                 |   10 ---
 drivers/scsi/stex.c                           |   17 +++--
 drivers/usb/dwc3/core.c                       |   50 ----------------
 drivers/usb/dwc3/drd.c                        |   50 ++++++++++++++++
 drivers/usb/serial/qcserial.c                 |    1 
 fs/nilfs2/inode.c                             |   19 ++++++
 fs/nilfs2/segment.c                           |   21 ++++---
 include/scsi/scsi_cmnd.h                      |    2 
 net/mac80211/ieee80211_i.h                    |    8 ++
 net/mac80211/rx.c                             |   12 ++--
 net/mac80211/util.c                           |   32 +++++-----
 net/mctp/af_mctp.c                            |   23 +++++--
 net/mctp/route.c                              |   10 +--
 net/wireless/scan.c                           |   77 ++++++++++++++++----------
 security/integrity/platform_certs/load_uefi.c |    2 
 sound/pci/hda/hda_intel.c                     |    3 -
 sound/pci/hda/patch_realtek.c                 |   18 ++++++
 32 files changed, 312 insertions(+), 279 deletions(-)

Andy Shevchenko (2):
      Revert "USB: fixup for merge issue with "usb: dwc3: Don't switch OTG -> peripheral if extcon is present""
      Revert "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"

Arun Easi (2):
      scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue handler reading stale packets"
      scsi: qla2xxx: Fix response queue handler reading stale packets

Cameron Gutman (1):
      Input: xpad - fix wireless 360 controller breaking after suspend

Frank Wunderlich (1):
      USB: serial: qcserial: add new usb-id for Dell branded EM7455

Giovanni Cabiddu (1):
      Revert "crypto: qat - reduce size of mapped region"

Greg Kroah-Hartman (1):
      Linux 6.0.2

Jason A. Donenfeld (4):
      random: restore O_NONBLOCK support
      random: clamp credited irq bits to maximum mixed
      random: avoid reading two cache lines on irq randomness
      random: use expired timer rather than wq for mixing fast pool

Jeremy Kerr (1):
      mctp: prevent double key removal and unref

Johannes Berg (9):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: mac80211: fix MBSSID parsing use-after-free
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: mac80211: fix crash in beacon protection for P2P-device
      wifi: cfg80211: update hidden BSSes to avoid WARN_ON

Linus Torvalds (1):
      scsi: stex: Properly zero out the passthrough command structure

Nathan Lynch (1):
      Revert "powerpc/rtas: Implement reentrant rtas call"

Orlando Chamberlain (1):
      efi: Correct Macmini DMI match in uefi cert quirk

Pavel Rojtberg (1):
      Input: xpad - add supported devices as contributed on github

Rishabh Bhatnagar (1):
      nvme-pci: set min_align_mask before calculating max_hw_sectors

Ryusuke Konishi (4):
      nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
      nilfs2: fix use-after-free bug of struct nilfs_root
      nilfs2: fix leak of nilfs_root in case of writer thread creation failure
      nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Shunsuke Mie (2):
      misc: pci_endpoint_test: Aggregate params checking for xfer
      misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Takashi Iwai (2):
      ALSA: hda: Fix position reporting on Poulsbo
      ALSA: hda/realtek: Add quirk for HP Zbook Firefly 14 G9 model

