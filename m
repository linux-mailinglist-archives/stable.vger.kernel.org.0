Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97656FB3D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiGKJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiGKJ0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DBC6053D;
        Mon, 11 Jul 2022 02:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C31B80E74;
        Mon, 11 Jul 2022 09:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636BDC341CB;
        Mon, 11 Jul 2022 09:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530924;
        bh=4WZcDCsFE9fpCFpZDFTLUsccbZ30dyi6tyVEhn+pBDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krFgbsDpY/UniGQpiEkABPmpalTYOkb0xXMkmVHlcV8CP9MZv0P43h08zoQ9dLYXR
         JeNgzvAJkCMXlarzjtjl8cxmIPeVaVw/yRiQZ8B2ATGVxBZFn9GVd9GHLIVphUc4jG
         wJdtgv3QYNH9hNJEEHeIWvbzYRJ7qpLmeb2ZEsr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5.18 004/112] ALSA: cs46xx: Fix missing snd_card_free() call at probe error
Date:   Mon, 11 Jul 2022 11:06:04 +0200
Message-Id: <20220711090549.674639067@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit c5e58c4545a69677d078b4c813b5d10d3481be9c upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() manually on the error
from the probe callback.

Fixes: 5bff69b3645d ("ALSA: cs46xx: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Reported-and-tested-by: Jan Engelhardt <jengelh@inai.de>
Link: https://lore.kernel.org/r/p2p1s96o-746-74p4-s95-61qo1p7782pn@vanv.qr
Link: https://lore.kernel.org/r/20220705152336.350-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cs46xx/cs46xx.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -74,36 +74,36 @@ static int snd_card_cs46xx_probe(struct
 	err = snd_cs46xx_create(card, pci,
 				external_amp[dev], thinkpad[dev]);
 	if (err < 0)
-		return err;
+		goto error;
 	card->private_data = chip;
 	chip->accept_valid = mmap_valid[dev];
 	err = snd_cs46xx_pcm(chip, 0);
 	if (err < 0)
-		return err;
+		goto error;
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	err = snd_cs46xx_pcm_rear(chip, 1);
 	if (err < 0)
-		return err;
+		goto error;
 	err = snd_cs46xx_pcm_iec958(chip, 2);
 	if (err < 0)
-		return err;
+		goto error;
 #endif
 	err = snd_cs46xx_mixer(chip, 2);
 	if (err < 0)
-		return err;
+		goto error;
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	if (chip->nr_ac97_codecs ==2) {
 		err = snd_cs46xx_pcm_center_lfe(chip, 3);
 		if (err < 0)
-			return err;
+			goto error;
 	}
 #endif
 	err = snd_cs46xx_midi(chip, 0);
 	if (err < 0)
-		return err;
+		goto error;
 	err = snd_cs46xx_start_dsp(chip);
 	if (err < 0)
-		return err;
+		goto error;
 
 	snd_cs46xx_gameport(chip);
 
@@ -117,11 +117,15 @@ static int snd_card_cs46xx_probe(struct
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver cs46xx_driver = {


