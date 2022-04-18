Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12278504FF1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbiDRMTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiDRMSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0241ADAC;
        Mon, 18 Apr 2022 05:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B929B80EC1;
        Mon, 18 Apr 2022 12:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BC9C385A1;
        Mon, 18 Apr 2022 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284165;
        bh=41TNFZZlkzsBABIoZsv+QWqEre4HxqtCGuF/NioWhFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sq3YzhO6z6bu+yyuoDMT9IT88DCuZ0k7ik5WxUccjl0LmBwyUVVrw84hOtDt9YrNi
         m9dnnnxwHbMf/iwhMfLqOEqTUY2RtZaU6/Mzeag6O/H/sZnkvkEJfHc3VFQV1UkG4F
         plH66CDN8VJpvz4L02+4Bi41GwrtLiBTPTp5GlcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 026/219] ALSA: bt87x: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:55 +0200
Message-Id: <20220418121204.826001521@linuxfoundation.org>
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

commit f0438155273f057fec9818bc9d1b782ba35cf6a1 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 9e80ed64a006 ("ALSA: bt87x: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-29-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/bt87x.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -805,8 +805,8 @@ static int snd_bt87x_detect_card(struct
 	return SND_BT87X_BOARD_UNKNOWN;
 }
 
-static int snd_bt87x_probe(struct pci_dev *pci,
-			   const struct pci_device_id *pci_id)
+static int __snd_bt87x_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -889,6 +889,12 @@ static int snd_bt87x_probe(struct pci_de
 	return 0;
 }
 
+static int snd_bt87x_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_bt87x_probe(pci, pci_id));
+}
+
 /* default entries for all Bt87x cards - it's not exported */
 /* driver_data is set to 0 to call detection */
 static const struct pci_device_id snd_bt87x_default_ids[] = {


