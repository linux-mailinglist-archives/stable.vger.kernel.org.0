Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5845051F3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiDRMk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbiDRMjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C754D13D0D;
        Mon, 18 Apr 2022 05:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89753B80EC1;
        Mon, 18 Apr 2022 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED19FC385AB;
        Mon, 18 Apr 2022 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285017;
        bh=fyWxE0RF41ZGhWxkgiw4q/uIMlEk6YN9STlfHJYsxII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohq4ZIrZaxC5J65P2XbL5RLEUI74AcNuQpaFhgr1EWmyy2d5qTfdsnOCJTtpA9Vqm
         o71r7WowEhKUX69c9XxkOFwxkiZZqmRTHhXlBqKBRdaXwlrY1rOr1KSw4TqfOqVNZv
         Qu5Z/ovVOuDbCiAJazz/3wHlAfkegbQrIJ4Y1YQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 053/189] ALSA: via82xx: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:13 +0200
Message-Id: <20220418121202.017171306@linuxfoundation.org>
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

commit 27a0963f9cea5be3c68281f07fe82cdf712ef333 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: afaf99751d0c ("ALSA: via82xx: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-26-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/via82xx.c       | 10 ++++++++--
 sound/pci/via82xx_modem.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 65514f7e42d7..361b83fd721e 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2458,8 +2458,8 @@ static int check_dxs_list(struct pci_dev *pci, int revision)
 	return VIA_DXS_48K;
 };
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx *chip;
@@ -2569,6 +2569,12 @@ static int snd_via82xx_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_via82xx_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_via82xx_probe(pci, pci_id));
+}
+
 static struct pci_driver via82xx_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_via82xx_ids,
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 234f7fbed236..ca7f024bf8ec 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1103,8 +1103,8 @@ static int snd_via82xx_create(struct snd_card *card,
 }
 
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx_modem *chip;
@@ -1157,6 +1157,12 @@ static int snd_via82xx_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_via82xx_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_via82xx_probe(pci, pci_id));
+}
+
 static struct pci_driver via82xx_modem_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_via82xx_modem_ids,
-- 
2.35.2



