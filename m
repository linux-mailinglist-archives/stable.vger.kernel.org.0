Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE45EA432
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiIZLlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238313AbiIZLlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AF26F548;
        Mon, 26 Sep 2022 03:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B88960A52;
        Mon, 26 Sep 2022 10:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F5CC433D6;
        Mon, 26 Sep 2022 10:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189085;
        bh=5/kmmVFM79XD0DknOLwHTGFBbLTGilshMyNLZ8aNO5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3e51/27/2q7AFBDnVapcTVOtntUZU/v8wBta2AXrZaham145G/j4ZAdDZtGHHnJb
         vWnnyZN1WFZHmXciu2OfY6wENBu1SLwaTPnTR2W0L31FHX/gO0XzxtMCQaD05VWlV7
         DilgIVDu7NTQEypkMLulEPyizv2A/g1HTwgu0Tow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Callum Osmotherly <callum.osmotherly@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 037/207] ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop
Date:   Mon, 26 Sep 2022 12:10:26 +0200
Message-Id: <20220926100808.273907483@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Callum Osmotherly <callum.osmotherly@gmail.com>

commit 1885ff13d4c42910b37a0e3f7c2f182520f4eed1 upstream.

Just as with the 5570 (and the other Dell laptops), this enables the two
subwoofer speakers on the Dell Precision 5530 together with the main
ones, significantly increasing the audio quality. I've tested this
myself on a 5530 and can confirm it's working as expected.

Signed-off-by: Callum Osmotherly <callum.osmotherly@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YyMjQO3mhyXlMbCf@piranha
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9134,6 +9134,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
+	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),


