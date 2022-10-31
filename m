Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3B661301F
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJaGFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJaGFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D145A6472
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 939D5B80EF9
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CBBC433C1;
        Mon, 31 Oct 2022 06:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667196308;
        bh=gx/GpIb+JMlLmxU9BGWGXXM/3CF3IyeYZISUvsOuKz4=;
        h=Subject:To:Cc:From:Date:From;
        b=FgPAtKlAgR1szNNWx0twpgomI3pi7Ciq1Oi95TrG3nh3bxFz0k1F2DDC7uQSU1+MR
         Gnnzi9ECSn6bcknWpgNZUG2JaQFwLsSswX9m4VyKokIbt8Jq0NHU0GspU7dHCvlf5X
         lpkUklTm0Toni1xYAWcTGXErZhh/PjJEhkBeYZ+E=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41" failed to apply to 5.15-stable tree
To:     sbinding@opensource.cirrus.com, stable@vger.kernel.org,
        tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:05:54 +0100
Message-ID: <1667196354169251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

491a4ccd8a02 ("ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 491a4ccd8a0258392900c80c6b2b622c7115fc23 Mon Sep 17 00:00:00 2001
From: Stefan Binding <sbinding@opensource.cirrus.com>
Date: Tue, 18 Oct 2022 13:15:06 +0100
Subject: [PATCH] ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41

This Asus Zenbook laptop use Realtek HDA codec combined with
2xCS35L41 Amplifiers using SPI with External Boost.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221018121506.2561397-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7c177426bf30..79acd2a2caf2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9395,6 +9395,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),

