Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B37603BD0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJSIjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJSIjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98257FE48;
        Wed, 19 Oct 2022 01:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091F5617E7;
        Wed, 19 Oct 2022 08:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F3AC433C1;
        Wed, 19 Oct 2022 08:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168716;
        bh=c3J8aS+0mHc2rC1YOQ+gpl9CPH8bxkvxWZbbf19llkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fbqjh4ZJtRwZkcB0/d2AfaqSkBCD3jLkBWkp2d5BcN3mbIjSLgfXlsbxUN/5zMx64
         WQ/Xv1vhlVAOrt/jolO+PPtf01X/4qPARyU29Zt+RnZQGZ4U1wr2cEaw9CH3+WwZlE
         1LzbQW3rU/0WjtLeWFBxBBSk71E76MZspQOilq1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Callum Osmotherly <callum.osmotherly@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 005/862] ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530
Date:   Wed, 19 Oct 2022 10:21:32 +0200
Message-Id: <20221019083250.237245212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Callum Osmotherly <callum.osmotherly@gmail.com>

commit 417b9c51f59734d852e47252476fadc293ad994a upstream.

After some feedback from users with Dell Precision 5530 machines, this
patch reverts the previous change to add ALC289_FIXUP_DUAL_SPK.
While it improved the speaker output quality, it caused the headphone
jack to have an audible "pop" sound when power saving was toggled.

Fixes: 1885ff13d4c4 ("ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop")
Signed-off-by: Callum Osmotherly <callum.osmotherly@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Yz0uyN1zwZhnyRD6@piranha
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9186,7 +9186,6 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
-	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),


