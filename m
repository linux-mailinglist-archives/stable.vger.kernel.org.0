Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C050523E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiDRMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbiDRMh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:37:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B8223178;
        Mon, 18 Apr 2022 05:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23027CE1077;
        Mon, 18 Apr 2022 12:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E52AC385A1;
        Mon, 18 Apr 2022 12:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284896;
        bh=1EwQqzESPihcHRK4PSlhGbS9Ks0fxQYEVUPfRq2bFd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9lwJrP+LPihEXiXS5MK4E/6VUHb0mO9iP21BER6KuyEW4U0ylwx85j1k2gvEbzxz
         fTUYvhzKl+PmO8RxvxFJTat7Ga4WKpfAur5CvV3PsYOh3lL4zhuHiqW3MLxagmJCvf
         Zzu4nzvXhXgZhLh4sIhqSAweSMq18Bj9g/Ljau4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 041/189] ALSA: intel_hdmi: Fix the missing snd_card_free() call at probe error
Date:   Mon, 18 Apr 2022 14:11:01 +0200
Message-Id: <20220418121201.680016447@linuxfoundation.org>
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

commit 5e154dfb4f9995096aa6d342df75040ae802c17e upstream.

The previous cleanup with devres may lead to the incorrect release
orders at the probe error handling due to the devres's nature.  Until
we register the card, snd_card_free() has to be called at first for
releasing the stuff properly when the driver tries to manage and
release the stuff via card->private_free().

This patch fixes it by calling snd_card_free() on the error from the
probe callback using a new helper function.

Fixes: 854577ac2aea ("ALSA: x86: Allocate resources with device-managed APIs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412102636.16000-27-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/x86/intel_hdmi_audio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1665,7 +1665,7 @@ static void hdmi_lpe_audio_free(struct s
  * This function is called when the i915 driver creates the
  * hdmi-lpe-audio platform device.
  */
-static int hdmi_lpe_audio_probe(struct platform_device *pdev)
+static int __hdmi_lpe_audio_probe(struct platform_device *pdev)
 {
 	struct snd_card *card;
 	struct snd_intelhad_card *card_ctx;
@@ -1826,6 +1826,11 @@ static int hdmi_lpe_audio_probe(struct p
 	return 0;
 }
 
+static int hdmi_lpe_audio_probe(struct platform_device *pdev)
+{
+	return snd_card_free_on_error(&pdev->dev, __hdmi_lpe_audio_probe(pdev));
+}
+
 static const struct dev_pm_ops hdmi_lpe_audio_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(hdmi_lpe_audio_suspend, hdmi_lpe_audio_resume)
 };


