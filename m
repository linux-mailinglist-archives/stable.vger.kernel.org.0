Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B994050518C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiDRMfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbiDRMdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB64F205DF;
        Mon, 18 Apr 2022 05:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C06AB80EDB;
        Mon, 18 Apr 2022 12:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E99C385A7;
        Mon, 18 Apr 2022 12:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284829;
        bh=ankRfE1NJGscVelAIBbvu7K3FN2QodaqU/jv0PZKqhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHzgpIpmKQOlVzw261UB/H3Yo31I8gOQ2B9mBQukMonv2D+rpwjhUqc1JHYKRuDGY
         YwI3qjZla5AQXzClKtRvoeur/82lHAus6yxaz4Ma1sur5xQtpt+dm5BTnqK73F5M/s
         8PSPrOdvWcPrgTyW7FkbVkMDP9Ql8V46dJHaBt+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 022/189] ALSA: au88x0: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:42 +0200
Message-Id: <20220418121201.145654760@linuxfoundation.org>
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

commit b093de145bc8769c6e9207947afad9efe102f4f6 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: e44b5b440609 ("ALSA: au88x0: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-8-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/au88x0/au88x0.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 342ef2a6655e..eb234153691b 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -193,7 +193,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci)
 
 // constructor -- see "Constructor" sub-section
 static int
-snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -310,6 +310,12 @@ snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_vortex_probe(pci, pci_id));
+}
+
 // pci_driver definition
 static struct pci_driver vortex_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.35.2



