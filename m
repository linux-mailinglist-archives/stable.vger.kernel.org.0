Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A699A504FE2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiDRMSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238136AbiDRMSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3641AF21;
        Mon, 18 Apr 2022 05:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E039460F09;
        Mon, 18 Apr 2022 12:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED114C385A1;
        Mon, 18 Apr 2022 12:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284145;
        bh=sCROHJ/hg47ICOANMftKN8vH5mtxayCl4vMQj4oLdOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBnY3PUpTtltktSMRoHZwtwsmaWJqCdAjLmEQ1Ntq3L1mgW+rLII1EPTMxeIIIfCn
         JfIZHeZSSfQcbuFLyKAfd7Wh+MtGH7B84IoBMQGJF6gsBYUYOp/vBA7KlCTdpKcVcU
         bIRzdBd00MPI0RSqeHVpLMcyJgkTdN9oLHhTW/NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 020/219] ALSA: als300: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:49 +0200
Message-Id: <20220418121204.458225498@linuxfoundation.org>
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

commit ab8bce9da6102c575c473c053672547589bc4c59 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() manually on the error
from the probe callback.

Fixes: 21a9314cf93b ("ALSA: als300: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-31-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/als300.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -708,7 +708,7 @@ static int snd_als300_probe(struct pci_d
 
 	err = snd_als300_create(card, pci, chip_type);
 	if (err < 0)
-		return err;
+		goto error;
 
 	strcpy(card->driver, "ALS300");
 	if (chip->chip_type == DEVICE_ALS300_PLUS)
@@ -723,11 +723,15 @@ static int snd_als300_probe(struct pci_d
 
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
 
 static struct pci_driver als300_driver = {


