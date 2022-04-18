Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD450525B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiDRMkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239368AbiDRMhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A3C222A8;
        Mon, 18 Apr 2022 05:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F2A0B80ED6;
        Mon, 18 Apr 2022 12:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8EEC385AE;
        Mon, 18 Apr 2022 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284874;
        bh=QFTRQt+UgYTy/jS01Q0+XiCAEMbdg9veDOH4iPIK744=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSIS0qWvyMcD6yq282kIu9n1CWtTGjmcfAXfripDkaXpp090TcwbEOBXf9Yl3OSAj
         XD1biTP8kE/b+JZANx0Nj82Rq47buOh44wG5LgUfMy+/NotLN1gfyQtBLn7mA2//KT
         ticziM+2gubN9oUHPg9+PfGBopkxMlE6X0UltXfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 035/189] ALSA: fm801: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:55 +0200
Message-Id: <20220418121201.511484968@linuxfoundation.org>
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

commit 7f611274a3d1657a67b3fa8cd0cec1dee00e02b4 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 47c413395376 ("ALSA: fm801: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-17-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/fm801.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 9c22ff19e56d..62b3cb126c6d 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1268,8 +1268,8 @@ static int snd_fm801_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_card_fm801_probe(struct pci_dev *pci,
-				const struct pci_device_id *pci_id)
+static int __snd_card_fm801_probe(struct pci_dev *pci,
+				  const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1333,6 +1333,12 @@ static int snd_card_fm801_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_card_fm801_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_fm801_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static const unsigned char saved_regs[] = {
 	FM801_PCM_VOL, FM801_I2S_VOL, FM801_FM_VOL, FM801_REC_SRC,
-- 
2.35.2



