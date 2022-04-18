Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD0505169
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbiDRMem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbiDRMdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88F71FCEE;
        Mon, 18 Apr 2022 05:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 554A960B40;
        Mon, 18 Apr 2022 12:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6580BC385A1;
        Mon, 18 Apr 2022 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284826;
        bh=glnq+QS0iQg+Z4Catr5hrs0n4Z7GiFQTcj0rj5oEa64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VUq0qpce6CK1e99rFrtiQgGaDwKGknab4BM9urh6d03oDyB/nLGgT1OZ2bxQ21rd
         aCWqq95WD1U3LeRwRB0aYyK8ub8RHT0rALZvN5mYQDZZ1//taNRPteTC5bT3loWOro
         lOFkAD7zAcZJKoXEfYR/vlGidtNRIOhBYyyeXIko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 021/189] ALSA: atiixp: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:41 +0200
Message-Id: <20220418121201.117340080@linuxfoundation.org>
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

commit 48e8adde8d1c586c799dab123fc1ebc8b8db620f upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 86bde74dbf09 ("ALSA: atiixp: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/atiixp.c       | 10 ++++++++--
 sound/pci/atiixp_modem.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index b8e035d5930d..43d01f1847ed 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1572,8 +1572,8 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 }
 
 
-static int snd_atiixp_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_atiixp_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct atiixp *chip;
@@ -1623,6 +1623,12 @@ static int snd_atiixp_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_atiixp_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_atiixp_probe(pci, pci_id));
+}
+
 static struct pci_driver atiixp_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_atiixp_ids,
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 178dce8ef1e9..8864c4c3c7e1 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1201,8 +1201,8 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 }
 
 
-static int snd_atiixp_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_atiixp_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct atiixp_modem *chip;
@@ -1247,6 +1247,12 @@ static int snd_atiixp_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_atiixp_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_atiixp_probe(pci, pci_id));
+}
+
 static struct pci_driver atiixp_modem_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_atiixp_ids,
-- 
2.35.2



