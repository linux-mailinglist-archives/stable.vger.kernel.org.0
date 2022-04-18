Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED550502D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiDRMWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbiDRMVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C591C12C;
        Mon, 18 Apr 2022 05:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8387660F09;
        Mon, 18 Apr 2022 12:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F1C385A1;
        Mon, 18 Apr 2022 12:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284252;
        bh=B8FQAJw9+VDk757S4dMVCrNEdd5tU9fGX7Vr2Zbfdos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySmaY4tWB6JJBskJ//bgoEXKCsCXqyzPfO1oMf5MmeXsLZ96qVK0ZmybIE3+f6noJ
         Gh8Qp7MsT+GM6xO1m9cHS7m5T249zmYa+vf1oBQ2Cb87uENPbUYQFIEEhP9L6erS4e
         7m5FoTOYWI9LGHxmOOBoDBEKw33dA0SGlkrc5Bq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 054/219] ALSA: via82xx: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:23 +0200
Message-Id: <20220418121206.702514665@linuxfoundation.org>
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
 sound/pci/via82xx.c       |   10 ++++++++--
 sound/pci/via82xx_modem.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2458,8 +2458,8 @@ static int check_dxs_list(struct pci_dev
 	return VIA_DXS_48K;
 };
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx *chip;
@@ -2569,6 +2569,12 @@ static int snd_via82xx_probe(struct pci_
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
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1103,8 +1103,8 @@ static int snd_via82xx_create(struct snd
 }
 
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx_modem *chip;
@@ -1157,6 +1157,12 @@ static int snd_via82xx_probe(struct pci_
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


