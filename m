Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82266505265
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiDRMlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiDRMhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1C523156;
        Mon, 18 Apr 2022 05:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8019DCE1099;
        Mon, 18 Apr 2022 12:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74738C385A7;
        Mon, 18 Apr 2022 12:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284892;
        bh=HMXl8nmOaGhbYfOY1r6F39OUCyiTyYIrVwNItqG0bX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB7kzmLGF7ZMopvY3U9MlRy/xaGgI4Rcxb7WzCwrE7bL+RNPZg4gD57tn3ej56xgZ
         XtGlkHSFLHRP6Jh1qBNO/QfMe5zD/1zFfNqdkJe21LuOLjS+ix6OO68wNwbAgQJD6G
         v7ovowsk1bWyB1FHtKqVVWyMZrviDZ9k+Mq82JKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 040/189] ALSA: intel8x0: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:00 +0200
Message-Id: <20220418121201.651810648@linuxfoundation.org>
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

commit 71b21f5f8970a87f034138454ebeff0608d24875 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 7835e0901e24 ("ALSA: intel8x0: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-19-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/intel8x0.c  | 10 ++++++++--
 sound/pci/intel8x0m.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index a51032b3ac4d..ae285c0a629c 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -3109,8 +3109,8 @@ static int check_default_spdif_aclink(struct pci_dev *pci)
 	return 0;
 }
 
-static int snd_intel8x0_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_intel8x0_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct intel8x0 *chip;
@@ -3189,6 +3189,12 @@ static int snd_intel8x0_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_intel8x0_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_intel8x0_probe(pci, pci_id));
+}
+
 static struct pci_driver intel8x0_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_intel8x0_ids,
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 7de3cb2f17b5..2845cc006d0c 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1178,8 +1178,8 @@ static struct shortname_table {
 	{ 0 },
 };
 
-static int snd_intel8x0m_probe(struct pci_dev *pci,
-			       const struct pci_device_id *pci_id)
+static int __snd_intel8x0m_probe(struct pci_dev *pci,
+				 const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct intel8x0m *chip;
@@ -1225,6 +1225,12 @@ static int snd_intel8x0m_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_intel8x0m_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_intel8x0m_probe(pci, pci_id));
+}
+
 static struct pci_driver intel8x0m_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_intel8x0m_ids,
-- 
2.35.2



