Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6B350502C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbiDRMWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbiDRMVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CB51D0DA;
        Mon, 18 Apr 2022 05:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ADC2B80EDB;
        Mon, 18 Apr 2022 12:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C9C385BA;
        Mon, 18 Apr 2022 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284250;
        bh=1GZdEwx0jW2sHnXThBh772tRCExCXNl/wQviBjG0fQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ne2I07mrGY5nbX7+ui43X+F44Lhe3keNxHLRrgWpLXGV9+l6vuupEnXzsl3gW0XNB
         QHsaCQkpRQx6UHwUc4bGWFioa7c+u502djqBDB9hF2R5QhL/Ij9He1Qm9JEmc4Jgvz
         pJmqqcNftJcaE7pHiVZTAUWf+SqbaFBpladh3V5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 053/219] ALSA: sonicvibes: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:22 +0200
Message-Id: <20220418121206.625061023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

commit b087a381d7386ec95803222d0d9b1ac499550713 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 2ca6cbde6ad7 ("ALSA: sonicvibes: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-25-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/sonicvibes.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1387,8 +1387,8 @@ static int snd_sonicvibes_midi(struct so
 	return 0;
 }
 
-static int snd_sonic_probe(struct pci_dev *pci,
-			   const struct pci_device_id *pci_id)
+static int __snd_sonic_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1459,6 +1459,12 @@ static int snd_sonic_probe(struct pci_de
 	return 0;
 }
 
+static int snd_sonic_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_sonic_probe(pci, pci_id));
+}
+
 static struct pci_driver sonicvibes_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_sonic_ids,


