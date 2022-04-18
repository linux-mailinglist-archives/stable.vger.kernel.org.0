Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7057A505242
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbiDRMkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbiDRMhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3289422B32;
        Mon, 18 Apr 2022 05:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BA74CE106E;
        Mon, 18 Apr 2022 12:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9A7C385A1;
        Mon, 18 Apr 2022 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284880;
        bh=1+mHDbx/2APMySnQ2Nnve3ZYUelcYmW+MeHsO0mit48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7pYnf7skrn5LaA3PaZ1r3gVFmVM+PXWaaN1wyWiEkGZyr4cgBzsA2XVodmQcFLUV
         GTkqm/Jfuaz5NxXWp9htWi9CZ161PmHd9EQ6vdXgXuw6XRSI2RHpsp7LW/t79tk1R1
         PipNnsX/cKoTclaDQRYSsRzsg7h5ve0dvM11Rw9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 036/189] ALSA: galaxy: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:10:56 +0200
Message-Id: <20220418121201.539623125@linuxfoundation.org>
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

commit 10b1881a97be240126891cb384bd3bc1869f52d8 upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 35a245ec0619 ("ALSA: galaxy: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/galaxy/galaxy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
index ea001c80149d..3164eb8510fa 100644
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -478,7 +478,7 @@ static void snd_galaxy_free(struct snd_card *card)
 		galaxy_set_config(galaxy, galaxy->config);
 }
 
-static int snd_galaxy_probe(struct device *dev, unsigned int n)
+static int __snd_galaxy_probe(struct device *dev, unsigned int n)
 {
 	struct snd_galaxy *galaxy;
 	struct snd_wss *chip;
@@ -598,6 +598,11 @@ static int snd_galaxy_probe(struct device *dev, unsigned int n)
 	return 0;
 }
 
+static int snd_galaxy_probe(struct device *dev, unsigned int n)
+{
+	return snd_card_free_on_error(dev, __snd_galaxy_probe(dev, n));
+}
+
 static struct isa_driver snd_galaxy_driver = {
 	.match		= snd_galaxy_match,
 	.probe		= snd_galaxy_probe,
-- 
2.35.2



