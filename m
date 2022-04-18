Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98545504FFD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiDRMUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbiDRMTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B7F1AD82;
        Mon, 18 Apr 2022 05:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBE0CB80ED7;
        Mon, 18 Apr 2022 12:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4119AC385A7;
        Mon, 18 Apr 2022 12:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284186;
        bh=EZMe7uLrGbWSPYQn3i6lEKA3laK3wH5AEgSfDubv4Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ypx3IEepbadPpHuT36C7Au9XgvPSa5RLiTgEY4X+XgL/sfY8+LK/T2odexNhEd+EX
         FjdSfJqe1cIkzsnfJqGDT0aNNpIMwdG4U74/C8zvUnWfzQNVi/44UrRjIHDaV7qXGD
         CM1T1djVI6BD2kOpqR/YVlyGd2vmqLg7tyvXnFQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 030/219] ALSA: cs5535audio: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:59 +0200
Message-Id: <20220418121205.081892124@linuxfoundation.org>
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
 sound/pci/cs5535audio/cs5535audio.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -281,8 +281,8 @@ static int snd_cs5535audio_create(struct
 	return 0;
 }
 
-static int snd_cs5535audio_probe(struct pci_dev *pci,
-				 const struct pci_device_id *pci_id)
+static int __snd_cs5535audio_probe(struct pci_dev *pci,
+				   const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -331,6 +331,12 @@ static int snd_cs5535audio_probe(struct
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


