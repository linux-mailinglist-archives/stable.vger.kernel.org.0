Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C47504FDF
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbiDRMSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbiDRMSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDEF1ADB8;
        Mon, 18 Apr 2022 05:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA299CE106E;
        Mon, 18 Apr 2022 12:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9DAC385A7;
        Mon, 18 Apr 2022 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284136;
        bh=zaHbHiM+ZIOFpggKBe2JpVmpB4u0kp8X235TNiWnL7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oigNyxgcVHpOW2lzIboHZcy3U/LFeDVIK/a0GoLgzvHtxa5Jk63b+/MQyXlYxnwE
         qDpt3Mvyhg+6HT6M+OsSUmQqVIeyynoLYedufBDV/gPqXt359Dfqewrzomhn6k5Y+0
         QGi9wH45V4Q3N9A4+RSa6zdReH5kIdH70LtAiQ2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 018/219] ALSA: sis7019: Fix the missing error handling
Date:   Mon, 18 Apr 2022 14:09:47 +0200
Message-Id: <20220418121204.325660394@linuxfoundation.org>
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

commit 2236a3243ff8291e97c70097dd11a0fdb8904380 upstream.

The previous cleanup with devres forgot to replace the snd_card_free()
call with the devm version.  Moreover, it still needs the manual call
of snd_card_free() at the probe error path, otherwise the reverse
order of the releases may happen.  This patch addresses those issues.

Fixes: 499ddc16394c ("ALSA: sis7019: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-28-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/sis7019.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1331,8 +1331,8 @@ static int sis_chip_create(struct snd_ca
 	return 0;
 }
 
-static int snd_sis7019_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_sis7019_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct sis7019 *sis;
@@ -1352,8 +1352,8 @@ static int snd_sis7019_probe(struct pci_
 	if (!codecs)
 		codecs = SIS_PRIMARY_CODEC_PRESENT;
 
-	rc = snd_card_new(&pci->dev, index, id, THIS_MODULE,
-			  sizeof(*sis), &card);
+	rc = snd_devm_card_new(&pci->dev, index, id, THIS_MODULE,
+			       sizeof(*sis), &card);
 	if (rc < 0)
 		return rc;
 
@@ -1386,6 +1386,12 @@ static int snd_sis7019_probe(struct pci_
 	return 0;
 }
 
+static int snd_sis7019_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_sis7019_probe(pci, pci_id));
+}
+
 static struct pci_driver sis7019_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_sis7019_ids,


