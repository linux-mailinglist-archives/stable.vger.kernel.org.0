Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FC24EC04A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344071AbiC3LuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343882AbiC3Ltr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B947A26B5B5;
        Wed, 30 Mar 2022 04:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B981B81C28;
        Wed, 30 Mar 2022 11:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59E7C36AE3;
        Wed, 30 Mar 2022 11:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640844;
        bh=WK14gTrMY4mrdBoN5dGYoL3uKdyenRH+qI/k85oo9S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOtA+vFoiE1LILRxkJSRJiA3sbAq+0xyvl1mM67t4LSFwICinl9etE34O4aBFWqgL
         Nr6KURCgF97HYpZ+IvlcgIQOkCEfbYfjXc37dj04eQAyyBPi/8+zI+RVVX002nozeT
         uvD4dGqaimyv0/eXeboeXke2EoHOLoHqSID7F3vFz5jFMUWegcWZp1cAwFNvi5iRu0
         xWDJNWGbPD7ctMCDldv4Efsm3TVyS3GNrmy/JV/DsVkUziHir3Ajqgx0aPMeKClOBO
         MLV3zJ2iHaEDmLeToPLf3QVPKKZRnHB6bPIIs5KKSyQMrTkfTgTZQlo4ZjS91lMV2X
         EU1uX2SXWm9OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Alexander Sergeyev <sergeev917@gmail.com>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, gregkh@linuxfoundation.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 24/66] ALSA: hda: Fix driver index handling at re-binding
Date:   Wed, 30 Mar 2022 07:46:03 -0400
Message-Id: <20220330114646.1669334-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 69458e2c27800da7697c87ed908b65323ef3f3bd ]

HD-audio driver handles the multiple instances and keeps the static
index that is incremented at each probe.  This becomes a problem when
user tries to re-bind the device via sysfs multiple times; as the
device index isn't cleared unlike rmmod case, it points to the next
element at re-binding, and eventually later you can't probe any more
when it reaches to SNDRV_CARDS_MAX (usually 32).

This patch is an attempt to improve the handling at rebinding.
Instead of a static device index, now we keep a bitmap and assigns to
the first zero bit position.  At the driver remove, in return, the
bitmap slot is cleared again, so that it'll be available for the next
probe.

Reported-by: Alexander Sergeyev <sergeev917@gmail.com>
Link: https://lore.kernel.org/r/20220209081912.20687-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 572ff0d1fafe..8eff25d2d9e6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2066,14 +2066,16 @@ static const struct hda_controller_ops pci_hda_ops = {
 	.position_check = azx_position_check,
 };
 
+static DECLARE_BITMAP(probed_devs, SNDRV_CARDS);
+
 static int azx_probe(struct pci_dev *pci,
 		     const struct pci_device_id *pci_id)
 {
-	static int dev;
 	struct snd_card *card;
 	struct hda_intel *hda;
 	struct azx *chip;
 	bool schedule_probe;
+	int dev;
 	int err;
 
 	if (pci_match_id(driver_denylist, pci)) {
@@ -2081,10 +2083,11 @@ static int azx_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
+	dev = find_first_zero_bit(probed_devs, SNDRV_CARDS);
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) {
-		dev++;
+		set_bit(dev, probed_devs);
 		return -ENOENT;
 	}
 
@@ -2151,7 +2154,7 @@ static int azx_probe(struct pci_dev *pci,
 	if (schedule_probe)
 		schedule_delayed_work(&hda->probe_work, 0);
 
-	dev++;
+	set_bit(dev, probed_devs);
 	if (chip->disabled)
 		complete_all(&hda->probe_wait);
 	return 0;
@@ -2374,6 +2377,7 @@ static void azx_remove(struct pci_dev *pci)
 		cancel_delayed_work_sync(&hda->probe_work);
 		device_lock(&pci->dev);
 
+		clear_bit(chip->dev_index, probed_devs);
 		pci_set_drvdata(pci, NULL);
 		snd_card_free(card);
 	}
-- 
2.34.1

