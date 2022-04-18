Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C02505199
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238935AbiDRMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239259AbiDRMfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8624E20BCD;
        Mon, 18 Apr 2022 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3CAB80ED7;
        Mon, 18 Apr 2022 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC0C385A8;
        Mon, 18 Apr 2022 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284839;
        bh=/uZNh/M4gUDMNnNFTD4XbALCipDR1PYR9QCqnjx+Epc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NP2ZbCKCHV626T5WlomplBf+VNbJsrP6bAvwX4zY2KILnIp3c+x0RujiPu5PLn/K5
         oEk4ozyl/Cw+kW6VwZ2TL1sboG7Enjrt8twq5NfxqvFScoUXcR01Pp/e+Cdon54Nx8
         WQ2pHLElpPO3Nop4o68L+LcKoc43q4Q3zm1465YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 025/189] ALSA: bt87x: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:45 +0200
Message-Id: <20220418121201.230495831@linuxfoundation.org>
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
 sound/pci/bt87x.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index d23f93163841..621985bfee5d 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -805,8 +805,8 @@ static int snd_bt87x_detect_card(struct pci_dev *pci)
 	return SND_BT87X_BOARD_UNKNOWN;
 }
 
-static int snd_bt87x_probe(struct pci_dev *pci,
-			   const struct pci_device_id *pci_id)
+static int __snd_bt87x_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -889,6 +889,12 @@ static int snd_bt87x_probe(struct pci_dev *pci,
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
-- 
2.35.2



