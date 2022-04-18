Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AE35051A2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbiDRMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbiDRMem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE862125E;
        Mon, 18 Apr 2022 05:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC5EF6100F;
        Mon, 18 Apr 2022 12:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9F2C385A1;
        Mon, 18 Apr 2022 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284836;
        bh=z5OIoCU6ZMb0mcg6D4QRRKJ1bUiR8RvMqQREY4apkmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZf6HRLUFu0HBS1SFI0ERyfdK9eiP2/bAZKNFitD64ePaNNq3lXCANABNW7153YOT
         peF/bjuQXS+NoHbfhM8fBxz8P1sduJmIkxYfjoD73amawxFPNRbhRd+GBS9wnmcvyI
         oBd3pT17vs4fzHfqAgE8A4Awn6ohjZ716MxOG1Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 024/189] ALSA: azt3328: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:44 +0200
Message-Id: <20220418121201.202626008@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

commit 49fe36e1c02cb06f66689c888e4e767c31cd259d upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 8c5823ef31e1 ("ALSA: azt3328: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-9-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/azt3328.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 089050470ff2..7f329dfc5404 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2427,7 +2427,7 @@ snd_azf3328_create(struct snd_card *card,
 }
 
 static int
-snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2520,6 +2520,12 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_azf3328_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static inline void
 snd_azf3328_suspend_regs(const struct snd_azf3328 *chip,
-- 
2.35.2



