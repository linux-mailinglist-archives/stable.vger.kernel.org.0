Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907CF551BE5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345131AbiFTN0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344460AbiFTNY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7071ADBD;
        Mon, 20 Jun 2022 06:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADBF560ABE;
        Mon, 20 Jun 2022 13:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365CC3411B;
        Mon, 20 Jun 2022 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730596;
        bh=3R++zcar7zR6TsDlEHyNXHwewnX2b38K5TREgitHZyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uii0L9uXRPpPO5bv78VQD6WyKTUrsuFXLerHxPCrW0c1Bddc2p0kPasM8wviNl+qd
         Z74kVcfKKSJ1oQDCjPGPeIFKRRtl5wnKuxS4ccSN6ktflIUUXtfDDKmEOECGlH2cQB
         +PdAEOrKXYJ4kwJ+tD+ydI8g30SonSAa5zOMSfu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Chi <andy.chi@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 103/106] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine
Date:   Mon, 20 Jun 2022 14:52:02 +0200
Message-Id: <20220620124727.432412555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Chi <andy.chi@canonical.com>

commit 024a7ad9eb4df626ca8c77fef4f67fd0ebd559d2 upstream.

The HP EliteBook 630 is using ALC236 codec which used 0x02 to control mute LED
and 0x01 to control micmute LED. Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220513121648.28584-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8857,6 +8857,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),


