Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1732D5404E1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345818AbiFGRTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbiFGRTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5AD104CB2;
        Tue,  7 Jun 2022 10:19:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 882DCB82239;
        Tue,  7 Jun 2022 17:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACAC385A5;
        Tue,  7 Jun 2022 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622349;
        bh=zpv29um/dWI23YVZluNHBcHbfAfuGpB5TvtabHfD68o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN8/yTJ1lE/GrUAAVUJ1/FrDo1weKSVl7OWIEVfjHPHlIyur0XOuP1kKic/A+bkxE
         HiuDPa8LZZwkS1kcVnjlM3AI8qfBeI3KOAnV/fEMsgarr3unuqd6UzUjrTvCP03F9q
         ZCGYguG+OoXf9Vdw6bhy9N4/q2tPKH3g3/dO9eWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van der Kemp <rik@upto11.nl>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 006/452] ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop
Date:   Tue,  7 Jun 2022 18:57:43 +0200
Message-Id: <20220607164908.721449000@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
@@ -8651,6 +8651,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a9d, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


