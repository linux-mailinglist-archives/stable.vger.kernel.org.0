Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7966C555
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjAPQFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjAPQEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6624926843
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D3A6101F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2002AC433EF;
        Mon, 16 Jan 2023 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884979;
        bh=q3I9oyNPuyaG204omZYQ7JfhSGA8eH56E/F4qYmFTME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adC3rgkDse2c+XlMnuPKYDhg+sMSAZj3P9uknI4/6MxslBsv1GqnvBkwlv33jZG0w
         p2e2Y1fmLy/Xpsn092jl4Aki1gWtagwmWBM8aNa5wdaR+2HBWYew81aRRB6v5hldEl
         1gPDojNX+3zZdaMDNIutCeiwgK8URMtk9qp+Fjgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuchi Yang <yangyuchi66@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 03/86] ALSA: hda/realtek - Turn on power early
Date:   Mon, 16 Jan 2023 16:50:37 +0100
Message-Id: <20230116154747.201472242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchi Yang <yangyuchi66@gmail.com>

commit 1f680609bf1beac20e2a31ddcb1b88874123c39f upstream.

Turn on power early to avoid wrong state for power relation register.
This can earlier update JD state when resume back.

Signed-off-by: Yuchi Yang <yangyuchi66@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e35d8f4fa18f4448a2315cc7d4a3715f@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3558,6 +3558,15 @@ static void alc256_init(struct hda_codec
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
+		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
+		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
+		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		msleep(30);
+	}
+
 	if (!hp_pin)
 		hp_pin = 0x21;
 
@@ -3569,14 +3578,6 @@ static void alc256_init(struct hda_codec
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
-		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
-		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
-		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		msleep(30);
-	}
 
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
@@ -3707,6 +3708,13 @@ static void alc225_init(struct hda_codec
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp1_pin_sense, hp2_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
+		msleep(30);
+	}
+
 	if (spec->codec_variant != ALC269_TYPE_ALC287 &&
 		spec->codec_variant != ALC269_TYPE_ALC245)
 		/* required only at boot or S3 and S4 resume time */
@@ -3728,12 +3736,6 @@ static void alc225_init(struct hda_codec
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
-		msleep(30);
-	}
 
 	if (hp1_pin_sense || spec->ultra_low_power)
 		snd_hda_codec_write(codec, hp_pin, 0,


