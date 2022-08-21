Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36C659B406
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiHUNmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiHUNmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409D322BFA
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EABE6B80D57
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C84C433C1;
        Sun, 21 Aug 2022 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089369;
        bh=MWEE3Cz0Wfvt0bgUHWtK4JgtT5LQPZ2Z0k8gFqzFSbg=;
        h=Subject:To:Cc:From:Date:From;
        b=rN9q5z3vz3gA8gWwhWg0et/oHT2No3HraLLFGtc8jgf8itklJ1zvPBg0/MVheGRxE
         WmTs/my+PdhS/8pMAeMaarvR/wheVPDX2/ek/Ldno8phNiLTc58/TOxHx6IhpVIgdh
         v3IGvUMuKtqCNXiGvaIB2BfFVgmbpasFCF7rBgL4=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Add quirk for Lenovo Yoga7 14IAL7" failed to apply to 5.15-stable tree
To:     tiwai@suse.de, baipush@tutanota.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:42:35 +0200
Message-ID: <166108935522674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 70cfdd0365acf550350d8949096c0b34a96b6b48 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 16 Aug 2022 15:21:32 +0200
Subject: [PATCH] ALSA: hda/realtek: Add quirk for Lenovo Yoga7 14IAL7

Lenovo Yoga7 14IAL7 requires the same quirk as Lenovo Yoga9 14IAP7 for
fixing the bass speaker problems.

Reported-by: Pascal Gross <baipush@tutanota.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/N9_CjBz--3-2@tutanota.com
Link: https://lore.kernel.org/r/20220816132132.15520-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f544761eb11b..b42496c01c43 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9492,6 +9492,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),

