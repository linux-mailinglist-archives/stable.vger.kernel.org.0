Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4F504FE3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbiDRMS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiDRMSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8CE1B790;
        Mon, 18 Apr 2022 05:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5187EB80EC1;
        Mon, 18 Apr 2022 12:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDBEC385A1;
        Mon, 18 Apr 2022 12:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284150;
        bh=IerkZ3grBNTOfrFLSCzoo3e0r4RUyaZwXYa50HoRnMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tokkL+wubTRk5nEOjT26E5X+rQPiFSMi7TNESWTMFjDPP2K5Di31Qnpqf+vzomiCk
         LhJgQZNd7Q5rWU/mqtqeDwfcf34mpET7zuuNNpIipB6MI+GgUCK6YzESezA7jS8L8W
         TxqQgKCdeyH78+Lh+KRMhZSxjVmGd0l+xvYh5xdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 021/219] ALSA: als4000: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:50 +0200
Message-Id: <20220418121204.515366861@linuxfoundation.org>
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

commit d616a0246da88d811f9f4c3aa83003c05efd3af0 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 0e175f665960 ("ALSA: als4000: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/als4000.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -806,8 +806,8 @@ static void snd_card_als4000_free( struc
 	snd_als4000_free_gameport(acard);
 }
 
-static int snd_card_als4000_probe(struct pci_dev *pci,
-				  const struct pci_device_id *pci_id)
+static int __snd_card_als4000_probe(struct pci_dev *pci,
+				    const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -930,6 +930,12 @@ static int snd_card_als4000_probe(struct
 	return 0;
 }
 
+static int snd_card_als4000_probe(struct pci_dev *pci,
+				  const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_als4000_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_als4000_suspend(struct device *dev)
 {


