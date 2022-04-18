Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6635B505007
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiDRMT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbiDRMTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F2C1BEBC;
        Mon, 18 Apr 2022 05:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A12C460EDF;
        Mon, 18 Apr 2022 12:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF671C385A1;
        Mon, 18 Apr 2022 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284195;
        bh=thAcNDv0bjzczGE8n6ZxEVdrYFGb13fwE6fsDCxC2pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7B0Eyxo40ZlS9Md9iGKzBezzpte5j2cr22cmBLCWxHEuWtJ9eZbu/kuQ2ohJf/sg
         Z4+KCMIxV2uS2UtEawJ9ewLyDRaxR0nxZtqwJ1n6dW5keeJntZOw3kOfAm5/m4rA5g
         Ml2Uu15FVz7VgRS77GGw0+MWIpffWofIDaWPl26s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 033/219] ALSA: ens137x: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:02 +0200
Message-Id: <20220418121205.269669990@linuxfoundation.org>
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

commit c2dc46932d117a1505f589ad1db3095aa6789058 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 10ed6eaf9d72 ("ALSA: ens137x: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-14-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ens1370.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -2304,8 +2304,8 @@ static irqreturn_t snd_audiopci_interrup
 	return IRQ_HANDLED;
 }
 
-static int snd_audiopci_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_audiopci_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2369,6 +2369,12 @@ static int snd_audiopci_probe(struct pci
 	return 0;
 }
 
+static int snd_audiopci_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_audiopci_probe(pci, pci_id));
+}
+
 static struct pci_driver ens137x_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_audiopci_ids,


