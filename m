Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9366C462
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjAPPyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjAPPyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B31CF78
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34757B80F4B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C079C433F0;
        Mon, 16 Jan 2023 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884455;
        bh=4evxPRLh2NZTiziwo27HS6TqK/gdeQb54BDvFHW3bcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6AqIOWa0cq1O+jY0NqPqF3hRJvYRMJn9rIb5nFBp23yCA6T0LpreN2Zf60Rd+A8o
         2aHcXDyq9v0VaErpGKhft9aSDpQTsvKJvU0BYQEfU5fUR77iW5bl7YBQkHDQ54fQyp
         2lzDZkwPkIjGgYi8gpSnjI6Ph0jKCNxUJdRpF/gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuchi Yang <yangyuchi66@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 005/183] ALSA: hda/realtek - Turn on power early
Date:   Mon, 16 Jan 2023 16:48:48 +0100
Message-Id: <20230116154803.585967408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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
@@ -3564,6 +3564,15 @@ static void alc256_init(struct hda_codec
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
 
@@ -3575,14 +3584,6 @@ static void alc256_init(struct hda_codec
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
@@ -3713,6 +3714,13 @@ static void alc225_init(struct hda_codec
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
@@ -3734,12 +3742,6 @@ static void alc225_init(struct hda_codec
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


