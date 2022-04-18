Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D49C50518F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbiDRMfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbiDRMdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8772120F5B;
        Mon, 18 Apr 2022 05:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D25561009;
        Mon, 18 Apr 2022 12:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6CFC385A1;
        Mon, 18 Apr 2022 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284832;
        bh=TonmvN+JcIpROxF13maxx2oGiva/r9GnVhHhVGDmt5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bot7jGjU/1uSQ/ABOTtjt4Z9X4TBsRRg2MnLGiTVUyMp1I1Of653AO3rQCLwFvITI
         zEt7R7qNre5ROjMn/g4Jg8pYFFcMn0FDtpSf0fNjp4uFlQ2+I7f9KhMPA2K9p+Mcuf
         1Xc7HTj6UoSJ+uftVGa2CUjpa9yu58LSFG2c6x4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 023/189] ALSA: aw2: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:43 +0200
Message-Id: <20220418121201.173965651@linuxfoundation.org>
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

commit bf4067e8a19eae67c45659a956c361d59251ba57 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() manually on the error
from the probe callback.

Fixes: 33631012cd06 ("ALSA: aw2: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-32-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/aw2/aw2-alsa.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index d56f126d6fdd..29a4bcdec237 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -275,7 +275,7 @@ static int snd_aw2_probe(struct pci_dev *pci,
 	/* (3) Create main component */
 	err = snd_aw2_create(card, pci);
 	if (err < 0)
-		return err;
+		goto error;
 
 	/* initialize mutex */
 	mutex_init(&chip->mtx);
@@ -294,13 +294,17 @@ static int snd_aw2_probe(struct pci_dev *pci,
 	/* (6) Register card instance */
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	/* (7) Set PCI driver data */
 	pci_set_drvdata(pci, card);
 
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 /* open callback */
-- 
2.35.2



