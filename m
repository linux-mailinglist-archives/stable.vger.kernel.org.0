Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D927505223
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbiDRMlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbiDRMiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C7524082;
        Mon, 18 Apr 2022 05:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 342D8B80EC1;
        Mon, 18 Apr 2022 12:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2D4C385A7;
        Mon, 18 Apr 2022 12:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284916;
        bh=/fqMjCNT4AqAcdcP6P4uwFTsohJL/7wk5xXvhWqKiWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VycgXOu2Z1UjEptJC37B36EfZQskvH8B6W/RJcn1ct6OPy0Lf1C1ubeuUjc4MAOKH
         HP+CkbXzoFy+mIDttQSpmKMydCnRCJ/K8/b10AwlYFJNFe83D6b1JavUYJUvhBLhtM
         UC3vG6OgNUPjPrwzfzbnU55lf6ZdIFhQGbdhKgiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 046/189] ALSA: oxygen: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:06 +0200
Message-Id: <20220418121201.820639923@linuxfoundation.org>
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

commit 6ebc16e206aa82ddb0450c907865c55bcb7c0f43 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 596ae97ab0ce ("ALSA: oxygen: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-35-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/oxygen/oxygen_lib.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/oxygen_lib.c b/sound/pci/oxygen/oxygen_lib.c
index 4fb3f2484fdb..92ffe9dc20c5 100644
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -576,7 +576,7 @@ static void oxygen_card_free(struct snd_card *card)
 	mutex_destroy(&chip->mutex);
 }
 
-int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
+static int __oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 		     struct module *owner,
 		     const struct pci_device_id *ids,
 		     int (*get_model)(struct oxygen *chip,
@@ -701,6 +701,16 @@ int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 	pci_set_drvdata(pci, card);
 	return 0;
 }
+
+int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
+		     struct module *owner,
+		     const struct pci_device_id *ids,
+		     int (*get_model)(struct oxygen *chip,
+				      const struct pci_device_id *id))
+{
+	return snd_card_free_on_error(&pci->dev,
+				      __oxygen_pci_probe(pci, index, id, owner, ids, get_model));
+}
 EXPORT_SYMBOL(oxygen_pci_probe);
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.35.2



