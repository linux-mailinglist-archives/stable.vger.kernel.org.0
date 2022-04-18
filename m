Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2165051BC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiDRMkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbiDRMg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89032229C;
        Mon, 18 Apr 2022 05:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACAC560F09;
        Mon, 18 Apr 2022 12:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E711C385A7;
        Mon, 18 Apr 2022 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284862;
        bh=pJIq3ZxK6Arfm3K0LxRQSwADTbZlCO3y4SpsBHByZyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvtLgziijeWKnnDbmRiH2agczg2/48LuhVu8cBaHct8yuEHEaoidPapy2yuh686Q/
         Sli8bFWdPHXXLPiAj/gnyNYKyoJ85XgPKMXDfBix947At4PqT8hpCZtaiyOI9xTQ1J
         SumTu2wY2NvbdOqBtk6BZ++cALE1J+REMsS7/x6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 031/189] ALSA: emu10k1x: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:51 +0200
Message-Id: <20220418121201.398105343@linuxfoundation.org>
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

commit f37019b6bfe2e13cc536af0e6a42ed62005392ae upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 2b377c6b6012 ("ALSA: emu10k1x: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-13-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emu10k1x.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index c49c44dc1082..89043392f3ec 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1491,8 +1491,8 @@ static int snd_emu10k1x_midi(struct emu10k1x *emu)
 	return 0;
 }
 
-static int snd_emu10k1x_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_emu10k1x_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1554,6 +1554,12 @@ static int snd_emu10k1x_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_emu10k1x_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_emu10k1x_probe(pci, pci_id));
+}
+
 // PCI IDs
 static const struct pci_device_id snd_emu10k1x_ids[] = {
 	{ PCI_VDEVICE(CREATIVE, 0x0006), 0 },	/* Dell OEM version (EMU10K1) */
-- 
2.35.2



