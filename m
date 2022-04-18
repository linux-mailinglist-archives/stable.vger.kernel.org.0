Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7979E50506E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbiDRMZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiDRMYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FF81D0CD;
        Mon, 18 Apr 2022 05:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0995A60F98;
        Mon, 18 Apr 2022 12:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09615C385A7;
        Mon, 18 Apr 2022 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284360;
        bh=UTYPZmiPW7Wo7y/YCIi0GILNnBvKxeoaaGM3OUh3PLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWOXk4m1OhdFv6/96vQpbLRr/8VMqKcUYFKbeigyjpOWjapIbj99tCFmxs+pE3JPP
         ahif/IhqvmhOh/rSLKgov20M8OCSBDer0EyWZsKuQI/7hY3tiyKRVQCjUq+rzVHEqn
         oq4UMA3C28Ah8QRdmiauIxQHAB1vredPI4tzZ8RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 048/219] ALSA: riptide: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:17 +0200
Message-Id: <20220418121206.282343483@linuxfoundation.org>
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

commit 348f08de55b149e41a05111d1a713c4484e5a426 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 546c201a891e ("ALSA: riptide: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-22-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/riptide/riptide.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2023,7 +2023,7 @@ static void snd_riptide_joystick_remove(
 #endif
 
 static int
-snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2124,6 +2124,12 @@ snd_card_riptide_probe(struct pci_dev *p
 	return 0;
 }
 
+static int
+snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_riptide_probe(pci, pci_id));
+}
+
 static struct pci_driver driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_riptide_ids,


