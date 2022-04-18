Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC35505187
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiDRMfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbiDRMde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C2B1EC6A;
        Mon, 18 Apr 2022 05:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFD460B40;
        Mon, 18 Apr 2022 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6757C385A8;
        Mon, 18 Apr 2022 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284817;
        bh=ySO7GTBaEjzR2TeAio7eXrxjSfOfiGxEe0t48xlU2Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRxKajxUXIWKCbnIwvldumXp49ZKCc3Qlby30hScVVO4FWUIXPs5H75lm2WQ4RMZ0
         iSShdC3BsKQfzGyqXKzDIaTw0VIoq6oiKZx88WYqrbrslq00BZwA9hvBlBTd0vghrk
         RW0gBR8maBC7yshS7Q/ombBXvqFNRpIQfE/rB7vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 018/189] ALSA: ali5451: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:38 +0200
Message-Id: <20220418121201.033545609@linuxfoundation.org>
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

commit 19401a9441236cfbbbeb1bef4ef4c8668db45dfc upstream.

The recent cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 1f0819979248 ("ALSA: ali5451: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ali5451/ali5451.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 92eb59db106d..2378a39abaeb 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2124,8 +2124,8 @@ static int snd_ali_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_ali_probe(struct pci_dev *pci,
-			 const struct pci_device_id *pci_id)
+static int __snd_ali_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct snd_ali *codec;
@@ -2170,6 +2170,12 @@ static int snd_ali_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_ali_probe(struct pci_dev *pci,
+			 const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ali_probe(pci, pci_id));
+}
+
 static struct pci_driver ali5451_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_ali_ids,
-- 
2.35.2



