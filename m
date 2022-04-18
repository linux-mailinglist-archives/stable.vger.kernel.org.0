Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECFD505189
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiDRMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbiDRMdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8202B201A6;
        Mon, 18 Apr 2022 05:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E84E61012;
        Mon, 18 Apr 2022 12:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A54C385A1;
        Mon, 18 Apr 2022 12:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284823;
        bh=IerkZ3grBNTOfrFLSCzoo3e0r4RUyaZwXYa50HoRnMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrkEhb0szUH9lhly89WfFwtOaSRsZSSzYqagQF/T8VLmdWWrW3gnhYTj0L/QWZoQJ
         4aTxTvmQgcClMMmH4OxiDlOG8qTQlUdJpTogkYNW3JfB8ref832KA9Ke4uQfTdbxyU
         X44xpjPMNDkvsOv7FD7WULGuzfhYV4NgrW/vs+b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 020/189] ALSA: als4000: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:40 +0200
Message-Id: <20220418121201.089491317@linuxfoundation.org>
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

commit d616a0246da88d811f9f4c3aa83003c05efd3af0 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 0e175f665960 ("ALSA: als4000: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/als4000.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -806,8 +806,8 @@ static void snd_card_als4000_free( struc
 	snd_als4000_free_gameport(acard);
 }
 
-static int snd_card_als4000_probe(struct pci_dev *pci,
-				  const struct pci_device_id *pci_id)
+static int __snd_card_als4000_probe(struct pci_dev *pci,
+				    const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -930,6 +930,12 @@ static int snd_card_als4000_probe(struct
 	return 0;
 }
 
+static int snd_card_als4000_probe(struct pci_dev *pci,
+				  const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_als4000_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_als4000_suspend(struct device *dev)
 {


