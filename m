Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F741505000
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbiDRMUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiDRMTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFC61AD89;
        Mon, 18 Apr 2022 05:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 481B6CE1077;
        Mon, 18 Apr 2022 12:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07671C385A7;
        Mon, 18 Apr 2022 12:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284183;
        bh=g2rNjQNG0sDfRmDtZRk544KJU8K+uBrjsb5r0xlxa6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpXrXURarOuRc5HJ7Kgft5Q2jDbw1CCU5cCTh+W9Bt8VN38EaZM1HQo5+YGEF9LeY
         caaau25kPVZJsrCYNzJKrjfGUcVwr7yjB5gOZBOg7kOLtbRF/eT4Fkw6iuQ2lJ2gJ4
         R1JdU4jxLAy82RqJLTI055IsvXGmILEiY8egl55s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 029/219] ALSA: cs4281: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:09:58 +0200
Message-Id: <20220418121205.009137322@linuxfoundation.org>
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

commit 9bf5ed9a4e623583f15202d99f4521bc39050f61 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 99041fea70d0 ("ALSA: cs4281: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-11-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cs4281.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1827,8 +1827,8 @@ static void snd_cs4281_opl3_command(stru
 	spin_unlock_irqrestore(&opl3->reg_lock, flags);
 }
 
-static int snd_cs4281_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_cs4281_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1888,6 +1888,12 @@ static int snd_cs4281_probe(struct pci_d
 	return 0;
 }
 
+static int snd_cs4281_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_cs4281_probe(pci, pci_id));
+}
+
 /*
  * Power Management
  */


