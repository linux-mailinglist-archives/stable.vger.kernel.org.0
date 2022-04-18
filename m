Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65A6505003
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiDRMUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238320AbiDRMTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A394D1C125;
        Mon, 18 Apr 2022 05:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34A2BB80EDC;
        Mon, 18 Apr 2022 12:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B227C385A1;
        Mon, 18 Apr 2022 12:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284198;
        bh=G9ItEzenN+2uKLak/gGAlo13Cdy/IJBDH5i38StQZy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOHt73xtJK8RF8+++7HpQ++i12kGinZWomDgPaknYpbiGymj1RIfIIYHLOmKHrMPy
         barTukM9PF06gbbBvTUkV7Q/6ajs6j5uuYGh/JGSK/UAIU1ejC41YvU9kI/kB+teOF
         E1XuNBM0OtnH9w7V+g6RJddC+lp3PrcfWR6Bb0QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 034/219] ALSA: es1938: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:03 +0200
Message-Id: <20220418121205.338427123@linuxfoundation.org>
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

commit bc22628591e5913e67edb3c2a89b97849e30a8f8 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 08e9d3ab4cc1 ("ALSA: es1938: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-15-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/es1938.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1716,8 +1716,8 @@ static int snd_es1938_mixer(struct es193
 }
        
 
-static int snd_es1938_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_es1938_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1796,6 +1796,12 @@ static int snd_es1938_probe(struct pci_d
 	return 0;
 }
 
+static int snd_es1938_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_es1938_probe(pci, pci_id));
+}
+
 static struct pci_driver es1938_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_es1938_ids,


