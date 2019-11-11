Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A018DF7EB0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfKKSnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfKKSnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C932173B;
        Mon, 11 Nov 2019 18:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497794;
        bh=JqzwQxQ104kzt6M5XDcqI9GBDE09Hn1vNKNQHNuT/v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tB6IhSEQzsamFrdvyJPLeC/0LhSGe2CfL6gn4jamaNk/eYblx8dqgtQ41KSxWTTi
         15H61iabphhINH8YtvIGP+CP1XGGpz3qozKEJl7C8dMSMhOF2JnlFB5m+ZAUED8icb
         +Vzg3hrceL9OVcwi1T2HqN8hrsvc8WnVHa6OyvHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 059/125] ALSA: usb-audio: Unify the release of usb_mixer_elem_info objects
Date:   Mon, 11 Nov 2019 19:28:18 +0100
Message-Id: <20191111181448.190584181@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 52c3e317a857091fd746e15179a637f32be4d337 upstream.

Instead of the direct kfree() calls, introduce a new local helper to
release the usb_mixer_elem_info object.  This will be extended to do
more than a single kfree() in the later patches.

Also, use the standard goto instead of multiple calls in
parse_audio_selector_unit() error paths.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1041,10 +1041,15 @@ static struct usb_feature_control_info a
 	{ UAC2_FU_PHASE_INVERTER,	 "Phase Inverter Control", USB_MIXER_BOOLEAN, -1 },
 };
 
+static void usb_mixer_elem_info_free(struct usb_mixer_elem_info *cval)
+{
+	kfree(cval);
+}
+
 /* private_free callback */
 void snd_usb_mixer_elem_free(struct snd_kcontrol *kctl)
 {
-	kfree(kctl->private_data);
+	usb_mixer_elem_info_free(kctl->private_data);
 	kctl->private_data = NULL;
 }
 
@@ -1567,7 +1572,7 @@ static void __build_feature_ctl(struct u
 
 	ctl_info = get_feature_control_info(control);
 	if (!ctl_info) {
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		return;
 	}
 	if (mixer->protocol == UAC_VERSION_1)
@@ -1600,7 +1605,7 @@ static void __build_feature_ctl(struct u
 
 	if (!kctl) {
 		usb_audio_err(mixer->chip, "cannot malloc kcontrol\n");
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		return;
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
@@ -1770,7 +1775,7 @@ static void build_connector_control(stru
 	kctl = snd_ctl_new1(&usb_connector_ctl_ro, cval);
 	if (!kctl) {
 		usb_audio_err(mixer->chip, "cannot malloc kcontrol\n");
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		return;
 	}
 	get_connector_control_name(mixer, term, is_input, kctl->id.name,
@@ -1823,7 +1828,7 @@ static int parse_clock_source_unit(struc
 	kctl = snd_ctl_new1(&usb_bool_master_control_ctl_ro, cval);
 
 	if (!kctl) {
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		return -ENOMEM;
 	}
 
@@ -2089,7 +2094,7 @@ static void build_mixer_unit_ctl(struct
 	kctl = snd_ctl_new1(&usb_feature_unit_ctl, cval);
 	if (!kctl) {
 		usb_audio_err(state->chip, "cannot malloc kcontrol\n");
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		return;
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
@@ -2487,7 +2492,7 @@ static int build_audio_procunit(struct m
 
 		kctl = snd_ctl_new1(&mixer_procunit_ctl, cval);
 		if (!kctl) {
-			kfree(cval);
+			usb_mixer_elem_info_free(cval);
 			return -ENOMEM;
 		}
 		kctl->private_free = snd_usb_mixer_elem_free;
@@ -2625,7 +2630,7 @@ static void usb_mixer_selector_elem_free
 	if (kctl->private_data) {
 		struct usb_mixer_elem_info *cval = kctl->private_data;
 		num_ins = cval->max;
-		kfree(cval);
+		usb_mixer_elem_info_free(cval);
 		kctl->private_data = NULL;
 	}
 	if (kctl->private_value) {
@@ -2697,10 +2702,10 @@ static int parse_audio_selector_unit(str
 		break;
 	}
 
-	namelist = kmalloc_array(desc->bNrInPins, sizeof(char *), GFP_KERNEL);
+	namelist = kcalloc(desc->bNrInPins, sizeof(char *), GFP_KERNEL);
 	if (!namelist) {
-		kfree(cval);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto error_cval;
 	}
 #define MAX_ITEM_NAME_LEN	64
 	for (i = 0; i < desc->bNrInPins; i++) {
@@ -2708,11 +2713,8 @@ static int parse_audio_selector_unit(str
 		len = 0;
 		namelist[i] = kmalloc(MAX_ITEM_NAME_LEN, GFP_KERNEL);
 		if (!namelist[i]) {
-			while (i--)
-				kfree(namelist[i]);
-			kfree(namelist);
-			kfree(cval);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto error_name;
 		}
 		len = check_mapped_selector_name(state, unitid, i, namelist[i],
 						 MAX_ITEM_NAME_LEN);
@@ -2726,10 +2728,8 @@ static int parse_audio_selector_unit(str
 	kctl = snd_ctl_new1(&mixer_selectunit_ctl, cval);
 	if (! kctl) {
 		usb_audio_err(state->chip, "cannot malloc kcontrol\n");
-		for (i = 0; i < desc->bNrInPins; i++)
-			kfree(namelist[i]);
-		kfree(namelist);
-		kfree(cval);
+		err = -ENOMEM;
+		goto error_name;
 		return -ENOMEM;
 	}
 	kctl->private_value = (unsigned long)namelist;
@@ -2776,6 +2776,14 @@ static int parse_audio_selector_unit(str
 	usb_audio_dbg(state->chip, "[%d] SU [%s] items = %d\n",
 		    cval->head.id, kctl->id.name, desc->bNrInPins);
 	return snd_usb_mixer_add_control(&cval->head, kctl);
+
+ error_name:
+	for (i = 0; i < desc->bNrInPins; i++)
+		kfree(namelist[i]);
+	kfree(namelist);
+ error_cval:
+	usb_mixer_elem_info_free(cval);
+	return err;
 }
 
 /*


