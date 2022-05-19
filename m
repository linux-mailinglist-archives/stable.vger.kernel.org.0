Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10E52D60C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiESO3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 10:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239594AbiESO3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 10:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC43CC17A
        for <stable@vger.kernel.org>; Thu, 19 May 2022 07:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8151B61962
        for <stable@vger.kernel.org>; Thu, 19 May 2022 14:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9C8C385AA;
        Thu, 19 May 2022 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652970580;
        bh=DUU6+A2oUBjfXcLPYr1UWPr4HGSNyjS9ahk2QJdIdA4=;
        h=Subject:To:Cc:From:Date:From;
        b=A3vNaecfoGOlgxvj9JrM5e+6ASYMF+XJiHnkHEGUOGI/B6yMNO5F4wai/pW/ZkLXw
         oCU3gM7N1fjTQ6XsTuLrsPfFJTDqzCTmoiTi/uxfN3wfskZaAfvt2jkL322d2upeyX
         BsTEghJcSs1zMZb4sxt8lLVLUIN5vDN86OGCV45Q=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for" failed to apply to 5.15-stable tree
To:     andy.chi@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 May 2022 16:29:30 +0200
Message-ID: <16529705705957@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 024a7ad9eb4df626ca8c77fef4f67fd0ebd559d2 Mon Sep 17 00:00:00 2001
From: Andy Chi <andy.chi@canonical.com>
Date: Fri, 13 May 2022 20:16:45 +0800
Subject: [PATCH] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for
 HP machine

The HP EliteBook 630 is using ALC236 codec which used 0x02 to control mute LED
and 0x01 to control micmute LED. Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220513121648.28584-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ce2cb1986677..ad292df7d805 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9091,6 +9091,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8995, "HP EliteBook 855 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x89a4, "HP ProBook 440 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89a6, "HP ProBook 450 G9", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ac, "HP EliteBook 640 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ae, "HP EliteBook 650 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "Zbook Studio G9", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),

