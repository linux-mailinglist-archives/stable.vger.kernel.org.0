Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373334BE133
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350590AbiBUJej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:34:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350611AbiBUJea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6B129CB5;
        Mon, 21 Feb 2022 01:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD12E60DDD;
        Mon, 21 Feb 2022 09:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8FCC340E9;
        Mon, 21 Feb 2022 09:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434860;
        bh=JYWDbU6bgdel2TqJfbkLMIvMsCB9bZCENyJtEUYeeMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC/XhVf1ez7HBzNhvOkGkkHyGPo3761xUZ9imdbsmFqeinn3/vOnl+84Th2c9Wr4G
         IaWVL21/9Sr1V/8/NdW2hk9CtRcRp7uz253CDjUpnTI14FMGclDz1d41+6PgvV7/74
         dwHMdpKKIF15k4YXZlYOtEBJXHtB9dbKNUsTnG3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dmummenschanz@web.de,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 114/196] ALSA: hda: Fix regression on forced probe mask option
Date:   Mon, 21 Feb 2022 09:49:06 +0100
Message-Id: <20220221084934.751793494@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 6317f7449348a897483a2b4841f7a9190745c81b upstream.

The forced probe mask via probe_mask 0x100 bit doesn't work any longer
as expected since the bus init code was moved and it's clearing the
codec_mask value that was set beforehand.  This patch fixes the
long-time regression by moving the check_probe_mask() call.

Fixes: a41d122449be ("ALSA: hda - Embed bus into controller object")
Reported-by: dmummenschanz@web.de
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/trinity-f018660b-95c9-442b-a2a8-c92a56eb07ed-1644345967148@3c-app-webde-bap22
Link: https://lore.kernel.org/r/20220214100020.8870-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1794,8 +1794,6 @@ static int azx_create(struct snd_card *c
 
 	assign_position_fix(chip, check_position_fix(chip, position_fix[dev]));
 
-	check_probe_mask(chip, dev);
-
 	if (single_cmd < 0) /* allow fallback to single_cmd at errors */
 		chip->fallback_to_single_cmd = 1;
 	else /* explicitly set to single_cmd or not */
@@ -1821,6 +1819,8 @@ static int azx_create(struct snd_card *c
 		chip->bus.core.needs_damn_long_delay = 1;
 	}
 
+	check_probe_mask(chip, dev);
+
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {
 		dev_err(card->dev, "Error creating device [card]!\n");


