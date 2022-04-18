Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965215051AA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiDRMhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbiDRMft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1F721E23;
        Mon, 18 Apr 2022 05:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B36E860FD6;
        Mon, 18 Apr 2022 12:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA84FC385A9;
        Mon, 18 Apr 2022 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284855;
        bh=yhqizx3gca0zFUFeB4WDKfSfCi/Dfv4/i+Tzx8VhRRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/o06OYVJFr+f5jHZJRQ1VegFWBpWGP57i1PH3jC6JODjA41IAuumeF4XNZkKTVZB
         rPeD4sB3v64CBhdQzivvCjHO/cmLda2g4bwbi1T8B98CMx0n39H5fjFhkXq0ZOYt+f
         OdBwrSWqj7s6qb4RZxIkbsYWVfCaRZ6AnomC0rRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 029/189] ALSA: cs5535audio: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:49 +0200
Message-Id: <20220418121201.342062813@linuxfoundation.org>
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

commit 2a56314798e0227cf51e3d1d184a419dc07bc173 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

Fixes: 5eba4c646dfe ("ALSA: cs5535audio: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-12-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cs5535audio/cs5535audio.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 499fa0148f9a..440b8f9b40c9 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -281,8 +281,8 @@ static int snd_cs5535audio_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_cs5535audio_probe(struct pci_dev *pci,
-				 const struct pci_device_id *pci_id)
+static int __snd_cs5535audio_probe(struct pci_dev *pci,
+				   const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -331,6 +331,12 @@ static int snd_cs5535audio_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_cs5535audio_probe(struct pci_dev *pci,
+				 const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_cs5535audio_probe(pci, pci_id));
+}
+
 static struct pci_driver cs5535audio_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_cs5535audio_ids,
-- 
2.35.2



