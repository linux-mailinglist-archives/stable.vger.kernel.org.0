Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780D54BE81F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbiBUJ2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349144AbiBUJ1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A7622BDA;
        Mon, 21 Feb 2022 01:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8154CE0E79;
        Mon, 21 Feb 2022 09:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4751C340E9;
        Mon, 21 Feb 2022 09:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434741;
        bh=CvA19KV9FG1Gjf9m0b3HLPFaZC9yM084E9lwfwyuGhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOKaUZeg6cGNixM59e2vtufF8rGppBUcFoEIH5XOpe4Ztpgvz7lheWl0A1qpn+BJ7
         YcvwzCu8CV3RyquKZySNQkGn/HODbC0KaqVBbrgTftC+aHaB04ocCOyR8wD8PF6fbz
         3qvPq0c83v6ZUHYQZfZxeYwlA4J+5F5Dw9oF57jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Julian Wollrath <jwollrath@web.de>
Subject: [PATCH 5.15 113/196] ALSA: hda/realtek: Fix deadlock by COEF mutex
Date:   Mon, 21 Feb 2022 09:49:05 +0100
Message-Id: <20220221084934.719340638@linuxfoundation.org>
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

commit 2a845837e3d0ddaed493b4c5c4643d7f0542804d upstream.

The recently introduced coef_mutex for Realtek codec seems causing a
deadlock when the relevant code is invoked from the power-off state;
then the HD-audio core tries to power-up internally, and this kicks
off the codec runtime PM code that tries to take the same coef_mutex.

In order to avoid the deadlock, do the temporary power up/down around
the coef_mutex acquisition and release.  This assures that the
power-up sequence runs before the mutex, hence no re-entrance will
happen.

Fixes: b837a9f5ab3b ("ALSA: hda: realtek: Fix race at concurrent COEF updates")
Reported-and-tested-by: Julian Wollrath <jwollrath@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220214132838.4db10fca@schienar
Link: https://lore.kernel.org/r/20220214130410.21230-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -133,6 +133,22 @@ struct alc_spec {
  * COEF access helper functions
  */
 
+static void coef_mutex_lock(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	snd_hda_power_up_pm(codec);
+	mutex_lock(&spec->coef_mutex);
+}
+
+static void coef_mutex_unlock(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	mutex_unlock(&spec->coef_mutex);
+	snd_hda_power_down_pm(codec);
+}
+
 static int __alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				 unsigned int coef_idx)
 {
@@ -146,12 +162,11 @@ static int __alc_read_coefex_idx(struct
 static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 			       unsigned int coef_idx)
 {
-	struct alc_spec *spec = codec->spec;
 	unsigned int val;
 
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	val = __alc_read_coefex_idx(codec, nid, coef_idx);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 	return val;
 }
 
@@ -168,11 +183,9 @@ static void __alc_write_coefex_idx(struc
 static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				 unsigned int coef_idx, unsigned int coef_val)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	__alc_write_coefex_idx(codec, nid, coef_idx, coef_val);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 #define alc_write_coef_idx(codec, coef_idx, coef_val) \
@@ -193,11 +206,9 @@ static void alc_update_coefex_idx(struct
 				  unsigned int coef_idx, unsigned int mask,
 				  unsigned int bits_set)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	__alc_update_coefex_idx(codec, nid, coef_idx, mask, bits_set);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 #define alc_update_coef_idx(codec, coef_idx, mask, bits_set)	\
@@ -230,9 +241,7 @@ struct coef_fw {
 static void alc_process_coef_fw(struct hda_codec *codec,
 				const struct coef_fw *fw)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	for (; fw->nid; fw++) {
 		if (fw->mask == (unsigned short)-1)
 			__alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
@@ -240,7 +249,7 @@ static void alc_process_coef_fw(struct h
 			__alc_update_coefex_idx(codec, fw->nid, fw->idx,
 						fw->mask, fw->val);
 	}
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 /*


