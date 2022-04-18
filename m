Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5EA50505F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbiDRMYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiDRMXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:23:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37921D0CA;
        Mon, 18 Apr 2022 05:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B24760F01;
        Mon, 18 Apr 2022 12:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351FAC385A7;
        Mon, 18 Apr 2022 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284339;
        bh=KJhOiG78T1nRHR2+NaULZbtj53RBADErqzhl+13IYrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNLVou171h3MWm879Sm4vZDAHm8zvn0OXTY0uQwP6uvlrzo6nLqVFZ/eTDDOBUwkx
         q4+leukziwYBciwvmPN2Uw6oAG24iZoKkonQc5jwQM14m4hSCgaRqjOa00t0s+w73p
         4rEl9EXQo33UEwHYKTwrNkUWzWcYZIJnaoyr0Au8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 044/219] ALSA: lola: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:13 +0200
Message-Id: <20220418121206.010623072@linuxfoundation.org>
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

commit d04e84b9817c652002f0ee9b42059d41493e9118 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 098fe3d6e775 ("ALSA: lola: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-30-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/lola/lola.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -637,8 +637,8 @@ static int lola_create(struct snd_card *
 	return 0;
 }
 
-static int lola_probe(struct pci_dev *pci,
-		      const struct pci_device_id *pci_id)
+static int __lola_probe(struct pci_dev *pci,
+			const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -687,6 +687,12 @@ static int lola_probe(struct pci_dev *pc
 	return 0;
 }
 
+static int lola_probe(struct pci_dev *pci,
+		      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __lola_probe(pci, pci_id));
+}
+
 /* PCI IDs */
 static const struct pci_device_id lola_ids[] = {
 	{ PCI_VDEVICE(DIGIGRAM, 0x0001) },


