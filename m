Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72335410B4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353449AbiFGT3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356600AbiFGT2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657451A0766;
        Tue,  7 Jun 2022 11:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2261B61927;
        Tue,  7 Jun 2022 18:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E16C385A5;
        Tue,  7 Jun 2022 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625413;
        bh=g1hLS+ya2aqBBFKEuQr7s2NPVCANtnGbX7JMaSlptaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3hvmUr5bgolbWc47DkNuRszhWkwV+5N1JsMKt1zl+G2Z7czuxVIbacrjR//H6qSu
         7V7tWPFr8BJuxe8880M2cP1ASMD7ESqFvJRmhWasE6aW7WW6frZRYfVlnYihSDwreB
         9cQf2/Jkkvt7bjo88PWtARWYANTqJkBRbBOv4aQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van der Kemp <rik@upto11.nl>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 011/772] ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop
Date:   Tue,  7 Jun 2022 18:53:23 +0200
Message-Id: <20220607164949.331836000@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Rik van der Kemp <rik@upto11.nl>

commit 15dad62f4bdb5dc0f0efde8181d680db9963544c upstream.

The 2022-model XPS 15 appears to use the same 4-speakers-on-ALC289
audio setup as the Dell XPS 15 9510, so requires the same quirk to
enable woofer output. Tested on my own 9520.

[ Move the entry to the right position in the SSID order -- tiwai ]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216035
Cc: <stable@vger.kernel.org>
Signed-off-by: Rik van der Kemp <rik@upto11.nl>
Link: https://lore.kernel.org/r/181056a137b.d14baf90133058.8425453735588429828@upto11.nl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8921,6 +8921,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a9d, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


