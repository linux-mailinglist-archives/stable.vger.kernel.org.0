Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0375494EA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357591AbiFMNOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376499AbiFMNLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B166FA0;
        Mon, 13 Jun 2022 04:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CCC560F91;
        Mon, 13 Jun 2022 11:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7CDC34114;
        Mon, 13 Jun 2022 11:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119314;
        bh=yzEr4owxzOhbiK85r++xW5wWQCnarR6rihYSQru+o2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtMGccPki/Y9Ruh+h3G6lLAHm9MSYml/AyVjWd8q7txk1LJ5oLxn28STWb5F6u6X8
         GywIWOsG4ete4qFMj5TEy90qTpbBJoOfRIYlJp18EffO/0hHlTHEpgLGR4HcaC8IMK
         llN7Diua33RVrDaDAEbU4ynMPrSI11nfyD260uoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Takashi Iwai <tiwai@suse.de>,
        Songine <donglingluoying@gmail.com>
Subject: [PATCH 5.15 217/247] ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo Yoga DuetITL 2021
Date:   Mon, 13 Jun 2022 12:11:59 +0200
Message-Id: <20220613094929.524544774@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Berkenpas <cam@neo-zeon.de>

commit 85743a847caeab696dafc4ce1a7e1e2b7e29a0f6 upstream.

Enables the ALC287_FIXUP_YOGA7_14ITL_SPEAKERS quirk for the Lenovo
Yoga DuetITL 2021 laptop to fix speaker output.

[ re-sorted in the SSID order by tiwai ]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208555
Signed-off-by: Cameron Berkenpas <cam@neo-zeon.de>
Co-authored-by: Songine <donglingluoying@gmail.com>
Cc: stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220606002329.215330-1-cam@neo-zeon.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9043,6 +9043,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
+	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),


