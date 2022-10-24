Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D7560A96B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiJXNUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiJXNTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:19:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1855AA6C05;
        Mon, 24 Oct 2022 05:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B55BEB810F5;
        Mon, 24 Oct 2022 12:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D46C433C1;
        Mon, 24 Oct 2022 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613145;
        bh=dZdoUx1cfGig2aKa5ufWKxeODt8wBSQvHb3m16sWYFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5uz2h2fZzRfw4GyLmFXgOy6EC6g1j4r9VwF79NGKFPUWSv3/ExdBL2cCs+aiwZSO
         iHP8TopRLBa9Q3qvd2IP4Yi9rUhL4BFYZ1bwLm8e8LbTGsLCRhyImVE6DjyLVQIVB6
         gbm/O9NidLTmCkvCVQdEKxeoNi1zv79XDWLsDkr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Callum Osmotherly <callum.osmotherly@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 005/255] ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530
Date:   Mon, 24 Oct 2022 13:28:35 +0200
Message-Id: <20221024113002.638783406@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -8138,7 +8138,6 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
-	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),


