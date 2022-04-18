Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B6E50501E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiDRMVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbiDRMVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2CE1B791;
        Mon, 18 Apr 2022 05:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E2560F39;
        Mon, 18 Apr 2022 12:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D058DC385A1;
        Mon, 18 Apr 2022 12:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284238;
        bh=VE0w32us6RxHOKpYaFbYWnYgYVNbP3MaTohL/xDfP0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GitfBgroJn2dYy9Ybr2EkfAuSXmDo+cYohjOV1TjjpA70USFd+fYPukWmm7KITzAc
         fgDTKX+puuWDMRBGZftIt9mXm/FuM34MIqtoNAaZlgOC2X9Fmn6DnuOQx1axkCDwXZ
         +ECgbsCxqoAF5vyyW7zaL4nxbOotgp2Ax4BjcKtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 041/219] ALSA: intel8x0: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:10 +0200
Message-Id: <20220418121205.804110130@linuxfoundation.org>
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
 sound/pci/intel8x0.c  |   10 ++++++++--
 sound/pci/intel8x0m.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -3109,8 +3109,8 @@ static int check_default_spdif_aclink(st
 	return 0;
 }
 
-static int snd_intel8x0_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_intel8x0_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct intel8x0 *chip;
@@ -3189,6 +3189,12 @@ static int snd_intel8x0_probe(struct pci
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
@@ -1225,6 +1225,12 @@ static int snd_intel8x0m_probe(struct pc
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


