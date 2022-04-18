Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6719D50520D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiDRMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiDRMhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E360020BEC;
        Mon, 18 Apr 2022 05:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80B0C60FB6;
        Mon, 18 Apr 2022 12:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A264C385A7;
        Mon, 18 Apr 2022 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284871;
        bh=QWRS/AUjwxtcWUDyIfuSvFkHkDKNENW6IFq4axNs3YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhdyEUoTba4LNtEXrLdtAmDMQQs286zAYBo5WqFOBdzHNAGm/IwJtxbgHv1ON/3tv
         5hSmQU/0UiYGHBl52ENJxGkOz86OEnQGm9G5Sufk/AJdtoCIgQICJA6nNzxkDUIMsn
         B+NJ5vmF/c3Yal2B7d3m46gp7nWGKn1oHyJxqCIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 034/189] ALSA: es1968: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:54 +0200
Message-Id: <20220418121201.483203308@linuxfoundation.org>
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

commit de9a01bc95a9e5e36d0659521bb04579053d8566 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: a7b4cbfdc701 ("ALSA: es1968: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-16-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/es1968.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 6a8a02a9ecf4..4a7e20bb11bc 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2741,8 +2741,8 @@ static int snd_es1968_create(struct snd_card *card,
 
 /*
  */
-static int snd_es1968_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_es1968_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2848,6 +2848,12 @@ static int snd_es1968_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_es1968_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_es1968_probe(pci, pci_id));
+}
+
 static struct pci_driver es1968_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_es1968_ids,
-- 
2.35.2



