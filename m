Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC05504FF3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiDRMTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbiDRMSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D8C1AF0F;
        Mon, 18 Apr 2022 05:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E547C60F17;
        Mon, 18 Apr 2022 12:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C17C385A1;
        Mon, 18 Apr 2022 12:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284171;
        bh=hE81g85NztebfTlsEOIi0/Bw4c/ZQ+SJseDegNnojnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNayd6tQiPwGNODfApX7xItYwjC+SMu+2CmdzfxBhuuikIeNqt4EtsawmcnMomyL9
         FAwfhnT937tdrzwSxW1plm04FBJM3sa6Na4U/FQk3x1F8cvT1MXZEJgxeLM5UF7PG2
         1zIVLWvW/WlwX1HC9ZHVDiEyH/6hRz9YvSHfejxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 027/219] ALSA: ca0106: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:56 +0200
Message-Id: <20220418121204.885355211@linuxfoundation.org>
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

commit c79442cc5a38e46597bc647128c8f1de62d80020 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 1656fa6ea258 ("ALSA: ca0106: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ca0106/ca0106_main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1725,8 +1725,8 @@ static int snd_ca0106_midi(struct snd_ca
 }
 
 
-static int snd_ca0106_probe(struct pci_dev *pci,
-					const struct pci_device_id *pci_id)
+static int __snd_ca0106_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1786,6 +1786,12 @@ static int snd_ca0106_probe(struct pci_d
 	return 0;
 }
 
+static int snd_ca0106_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ca0106_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_ca0106_suspend(struct device *dev)
 {


