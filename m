Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3034B56FD21
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiGKJvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiGKJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99BC27FF6;
        Mon, 11 Jul 2022 02:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 491A16112E;
        Mon, 11 Jul 2022 09:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B57C341C0;
        Mon, 11 Jul 2022 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531485;
        bh=utpFc4eprk1ZOCb4ywBMrgGC5I9nTAOGmMQyCLDsbcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PweaJCB26qzp9Dy5I1pLT3o49QkIMxRzSaPaZg7G2cpWhg3mw6GW6vwJBaVAwIfbR
         5lN2kO4Y5qgTn7tY/XYJvkr8sQyJ2b6OYAgLLw530xSLJ6VA9cY2g3Kcgz8W0krqGI
         fq1wpHzpS4Zxxo6misfZCTEkFCgMx81nkQ2nk6wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Schickel <lordhoto@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/230] ALSA: usb-audio: add mapping for MSI MPG X570S Carbon Max Wifi.
Date:   Mon, 11 Jul 2022 11:06:17 +0200
Message-Id: <20220711090607.497626700@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Johannes Schickel <lordhoto@gmail.com>

[ Upstream commit 5762f980ca10dcfe5eead7c40d1c34cae61f409b ]

The USB audio device 0db0:419c based on the Realtek ALC4080 chip exposes
all playback volume controls as "PCM". This is makes distinguishing the
individual functions hard.

The added mapping distinguishes all playback volume controls as their
respective function:
 - Speaker              - for back panel output
 - Frontpanel Headphone - for front panel output
 - IEC958               - for digital output on the back panel

This clarifies the individual volume control functions for users.

Signed-off-by: Johannes Schickel <lordhoto@gmail.com>
Link: https://lore.kernel.org/r/20220115140257.8751-1-lordhoto@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 6ffd23f2ee65..64fdca76b40e 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -423,6 +423,14 @@ static const struct usbmix_name_map aorus_master_alc1220vb_map[] = {
 	{}
 };
 
+/* MSI MPG X570S Carbon Max Wifi with ALC4080  */
+static const struct usbmix_name_map msi_mpg_x570s_carbon_max_wifi_alc4080_map[] = {
+	{ 29, "Speaker Playback" },
+	{ 30, "Front Headphone Playback" },
+	{ 32, "IEC958 Playback" },
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -574,6 +582,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = trx40_mobo_map,
 		.connector_map = trx40_mobo_connector_map,
 	},
+	{	/* MSI MPG X570S Carbon Max Wifi */
+		.id = USB_ID(0x0db0, 0x419c),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
-- 
2.35.1



