Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1F4ABB9E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384609AbiBGL30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383108AbiBGLVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C4AC0401D9;
        Mon,  7 Feb 2022 03:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06BE26126D;
        Mon,  7 Feb 2022 11:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6906C004E1;
        Mon,  7 Feb 2022 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232880;
        bh=DNdWn2flkb8w9nBNpBs9iVhmk+7EkEXEnkSrwUo7IMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMxqTPub1JI6bAmCGCGuwd7CCq4neR5sfYnJRLiDKatTy7+Mj3bNLizLa+mnwnk4Z
         VCvFeKDZfXAfk27NZdrFpHHDOU9AepHgaC77hxHp8llS0CvXu+k8WFuxoRDs5FEQCO
         ig5k7f4K8cGV0GyPqGOcDVxb/gxL6DgAYkLtbfK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Sergeyev <sergeev917@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 08/74] ALSA: hda: realtek: Fix race at concurrent COEF updates
Date:   Mon,  7 Feb 2022 12:06:06 +0100
Message-Id: <20220207103757.509087979@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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

commit b837a9f5ab3bdfab9233c9f98a6bef717673a3e5 upstream.

The COEF access is done with two steps: setting the index then read or
write the data.  When multiple COEF accesses are performed
concurrently, the index and data might be paired unexpectedly.
In most cases, this isn't a big problem as the COEF setup is done at
the initialization, but some dynamic changes like the mute LED may hit
such a race.

For avoiding the racy COEF accesses, this patch introduces a new
mutex coef_mutex to alc_spec, and wrap the COEF accessing functions
with it.

Reported-by: Alexander Sergeyev <sergeev917@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220111195229.a77wrpjclqwrx4bx@localhost.localdomain
Link: https://lore.kernel.org/r/20220131075738.24323-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   61 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 11 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -97,6 +97,7 @@ struct alc_spec {
 	unsigned int gpio_mic_led_mask;
 	struct alc_coef_led mute_led_coef;
 	struct alc_coef_led mic_led_coef;
+	struct mutex coef_mutex;
 
 	hda_nid_t headset_mic_pin;
 	hda_nid_t headphone_mic_pin;
@@ -133,8 +134,8 @@ struct alc_spec {
  * COEF access helper functions
  */
 
-static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
-			       unsigned int coef_idx)
+static int __alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				 unsigned int coef_idx)
 {
 	unsigned int val;
 
@@ -143,28 +144,61 @@ static int alc_read_coefex_idx(struct hd
 	return val;
 }
 
+static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+			       unsigned int coef_idx)
+{
+	struct alc_spec *spec = codec->spec;
+	unsigned int val;
+
+	mutex_lock(&spec->coef_mutex);
+	val = __alc_read_coefex_idx(codec, nid, coef_idx);
+	mutex_unlock(&spec->coef_mutex);
+	return val;
+}
+
 #define alc_read_coef_idx(codec, coef_idx) \
 	alc_read_coefex_idx(codec, 0x20, coef_idx)
 
-static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
-				 unsigned int coef_idx, unsigned int coef_val)
+static void __alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				   unsigned int coef_idx, unsigned int coef_val)
 {
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_COEF_INDEX, coef_idx);
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PROC_COEF, coef_val);
 }
 
+static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				 unsigned int coef_idx, unsigned int coef_val)
+{
+	struct alc_spec *spec = codec->spec;
+
+	mutex_lock(&spec->coef_mutex);
+	__alc_write_coefex_idx(codec, nid, coef_idx, coef_val);
+	mutex_unlock(&spec->coef_mutex);
+}
+
 #define alc_write_coef_idx(codec, coef_idx, coef_val) \
 	alc_write_coefex_idx(codec, 0x20, coef_idx, coef_val)
 
+static void __alc_update_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				    unsigned int coef_idx, unsigned int mask,
+				    unsigned int bits_set)
+{
+	unsigned int val = __alc_read_coefex_idx(codec, nid, coef_idx);
+
+	if (val != -1)
+		__alc_write_coefex_idx(codec, nid, coef_idx,
+				       (val & ~mask) | bits_set);
+}
+
 static void alc_update_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				  unsigned int coef_idx, unsigned int mask,
 				  unsigned int bits_set)
 {
-	unsigned int val = alc_read_coefex_idx(codec, nid, coef_idx);
+	struct alc_spec *spec = codec->spec;
 
-	if (val != -1)
-		alc_write_coefex_idx(codec, nid, coef_idx,
-				     (val & ~mask) | bits_set);
+	mutex_lock(&spec->coef_mutex);
+	__alc_update_coefex_idx(codec, nid, coef_idx, mask, bits_set);
+	mutex_unlock(&spec->coef_mutex);
 }
 
 #define alc_update_coef_idx(codec, coef_idx, mask, bits_set)	\
@@ -197,13 +231,17 @@ struct coef_fw {
 static void alc_process_coef_fw(struct hda_codec *codec,
 				const struct coef_fw *fw)
 {
+	struct alc_spec *spec = codec->spec;
+
+	mutex_lock(&spec->coef_mutex);
 	for (; fw->nid; fw++) {
 		if (fw->mask == (unsigned short)-1)
-			alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
+			__alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
 		else
-			alc_update_coefex_idx(codec, fw->nid, fw->idx,
-					      fw->mask, fw->val);
+			__alc_update_coefex_idx(codec, fw->nid, fw->idx,
+						fw->mask, fw->val);
 	}
+	mutex_unlock(&spec->coef_mutex);
 }
 
 /*
@@ -1160,6 +1198,7 @@ static int alc_alloc_spec(struct hda_cod
 	codec->spdif_status_reset = 1;
 	codec->forced_resume = 1;
 	codec->patch_ops = alc_patch_ops;
+	mutex_init(&spec->coef_mutex);
 
 	err = alc_codec_rename_from_preset(codec);
 	if (err < 0) {


