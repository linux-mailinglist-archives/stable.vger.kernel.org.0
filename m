Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43821B0AAE
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgDTMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729480AbgDTMtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A32C20736;
        Mon, 20 Apr 2020 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386986;
        bh=/5P2lY970bwoIolqfPFDUT2oL89XWpEFfu7S0tXYhuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkRAdCmlJctsIGw3vExkcQH2ipVSP757aZQPM15laqByEUU1U2Bx46BBucGrQe8+H
         XiUqqeiRM7Gy1c7L+m/po/0SFXJEr6z/0D8c6Iv2Oi2n/YgN9tQWeAGNY9g1T6AikV
         otP9rdstPb2hCcIpaxqgkGEu6Lb8bAjjjm7Ff0j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 20/40] ALSA: usb-audio: Check mapping at creating connector controls, too
Date:   Mon, 20 Apr 2020 14:39:30 +0200
Message-Id: <20200420121459.997660932@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 934b96594ed66b07dbc7e576d28814466df3a494 upstream.

Add the mapping check to build_connector_control() so that the device
specific quirk can provide the node to skip for the badly behaving
connector controls.  As an example, ALC1220-VB-based codec implements
the skip entry for the broken SPDIF connector detection.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206873
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200412081331.4742-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c      |   18 +++++++++++-------
 sound/usb/mixer_maps.c |    4 +++-
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1765,11 +1765,15 @@ static void get_connector_control_name(s
 
 /* Build a mixer control for a UAC connector control (jack-detect) */
 static void build_connector_control(struct usb_mixer_interface *mixer,
+				    const struct usbmix_name_map *imap,
 				    struct usb_audio_term *term, bool is_input)
 {
 	struct snd_kcontrol *kctl;
 	struct usb_mixer_elem_info *cval;
 
+	if (check_ignored_ctl(find_map(imap, term->id, 0)))
+		return;
+
 	cval = kzalloc(sizeof(*cval), GFP_KERNEL);
 	if (!cval)
 		return;
@@ -2109,7 +2113,7 @@ static int parse_audio_input_terminal(st
 	/* Check for jack detection. */
 	if ((iterm.type & 0xff00) != 0x0100 &&
 	    uac_v2v3_control_is_readable(bmctls, control))
-		build_connector_control(state->mixer, &iterm, true);
+		build_connector_control(state->mixer, state->map, &iterm, true);
 
 	return 0;
 }
@@ -3070,13 +3074,13 @@ static int snd_usb_mixer_controls_badd(s
 		memset(&iterm, 0, sizeof(iterm));
 		iterm.id = UAC3_BADD_IT_ID4;
 		iterm.type = UAC_BIDIR_TERMINAL_HEADSET;
-		build_connector_control(mixer, &iterm, true);
+		build_connector_control(mixer, map->map, &iterm, true);
 
 		/* Output Term - Insertion control */
 		memset(&oterm, 0, sizeof(oterm));
 		oterm.id = UAC3_BADD_OT_ID3;
 		oterm.type = UAC_BIDIR_TERMINAL_HEADSET;
-		build_connector_control(mixer, &oterm, false);
+		build_connector_control(mixer, map->map, &oterm, false);
 	}
 
 	return 0;
@@ -3151,8 +3155,8 @@ static int snd_usb_mixer_controls(struct
 			if ((state.oterm.type & 0xff00) != 0x0100 &&
 			    uac_v2v3_control_is_readable(le16_to_cpu(desc->bmControls),
 							 UAC2_TE_CONNECTOR)) {
-				build_connector_control(state.mixer, &state.oterm,
-							false);
+				build_connector_control(state.mixer, state.map,
+							&state.oterm, false);
 			}
 		} else {  /* UAC_VERSION_3 */
 			struct uac3_output_terminal_descriptor *desc = p;
@@ -3177,8 +3181,8 @@ static int snd_usb_mixer_controls(struct
 			if ((state.oterm.type & 0xff00) != 0x0100 &&
 			    uac_v2v3_control_is_readable(le32_to_cpu(desc->bmControls),
 							 UAC3_TE_INSERTION)) {
-				build_connector_control(state.mixer, &state.oterm,
-							false);
+				build_connector_control(state.mixer, state.map,
+							&state.oterm, false);
 			}
 		}
 	}
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -364,9 +364,11 @@ static const struct usbmix_name_map dell
 };
 
 /* Some mobos shipped with a dummy HD-audio show the invalid GET_MIN/GET_MAX
- * response for Input Gain Pad (id=19, control=12).  Skip it.
+ * response for Input Gain Pad (id=19, control=12) and the connector status
+ * for SPDIF terminal (id=18).  Skip them.
  */
 static const struct usbmix_name_map asus_rog_map[] = {
+	{ 18, NULL }, /* OT, connector control */
 	{ 19, NULL, 12 }, /* FU, Input Gain Pad */
 	{}
 };


