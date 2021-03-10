Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925C1333E00
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhCJNZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhCJNYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64FB664FE0;
        Wed, 10 Mar 2021 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382684;
        bh=wiR4hiq4vtsiddQOGhmpDJqkYXtor3dcc/mcVWvEhmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+eiN8XvgWA0li8SOalURrVA32yZIRndFMYw7NBTrAQ0pGm5+vbcbwoH3LpnwYiIe
         Mefg6g1QsNWwr8OEjbb7Qj1AX68dPvz4WbRNPQRmYj0Priw8BbdF/PUZHhJa+iWANC
         yLolSI4TTi8mbkFxnbqMefPdbPMTGiQ5zHCyZnD8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Lesniak <fabian@lesniak-it.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 28/36] ALSA: usb-audio: add mixer quirks for Pioneer DJM-900NXS2
Date:   Wed, 10 Mar 2021 14:23:41 +0100
Message-Id: <20210310132321.390661575@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Fabian Lesniak <fabian@lesniak-it.de>

[ Upstream commit fee03efc69345344c8851596d74d93199b175bfe ]

This commit adds mixer quirks for the Pioneer DJM-900NXS2 mixer. This
device has 6 capture channels, 5 of them allow setting the signal
source. This adds controls for these, similar to the DJM-250Mk2.
However, playpack channels are not controllable via software like on the
250Mk2, as they can only be set manually on the mixing console.
Read-only controls showing the currently selected playback channels are
omitted.

Signed-off-by: Fabian Lesniak <fabian@lesniak-it.de>
Link: https://lore.kernel.org/r/20210205215116.258724-2-fabian@lesniak-it.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 788b75cb9447..448de77f43fd 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2618,6 +2618,7 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 // Capture types
 #define SND_DJM_CAP_LINE	0x00
 #define SND_DJM_CAP_CDLINE	0x01
+#define SND_DJM_CAP_DIGITAL	0x02
 #define SND_DJM_CAP_PHONO	0x03
 #define SND_DJM_CAP_PFADER	0x06
 #define SND_DJM_CAP_XFADERA	0x07
@@ -2628,6 +2629,8 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 #define SND_DJM_CAP_NONE	0x0f
 #define SND_DJM_CAP_CH1PFADER	0x11
 #define SND_DJM_CAP_CH2PFADER	0x12
+#define SND_DJM_CAP_CH3PFADER	0x13
+#define SND_DJM_CAP_CH4PFADER	0x14
 
 // Playback types
 #define SND_DJM_PB_CH1		0x00
@@ -2648,6 +2651,7 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 // device table index
 #define SND_DJM_250MK2_IDX	0x0
 #define SND_DJM_750_IDX		0x1
+#define SND_DJM_900NXS2_IDX	0x2
 
 
 #define SND_DJM_CTL(_name, suffix, _default_value, _windex) { \
@@ -2692,6 +2696,7 @@ static const char *snd_djm_get_label_cap(u16 wvalue)
 	switch (wvalue & 0x00ff) {
 	case SND_DJM_CAP_LINE:		return "Control Tone LINE";
 	case SND_DJM_CAP_CDLINE:	return "Control Tone CD/LINE";
+	case SND_DJM_CAP_DIGITAL:	return "Control Tone DIGITAL";
 	case SND_DJM_CAP_PHONO:		return "Control Tone PHONO";
 	case SND_DJM_CAP_PFADER:	return "Post Fader";
 	case SND_DJM_CAP_XFADERA:	return "Cross Fader A";
@@ -2702,6 +2707,8 @@ static const char *snd_djm_get_label_cap(u16 wvalue)
 	case SND_DJM_CAP_NONE:		return "None";
 	case SND_DJM_CAP_CH1PFADER:	return "Post Fader Ch1";
 	case SND_DJM_CAP_CH2PFADER:	return "Post Fader Ch2";
+	case SND_DJM_CAP_CH3PFADER:	return "Post Fader Ch3";
+	case SND_DJM_CAP_CH4PFADER:	return "Post Fader Ch4";
 	default:			return NULL;
 	}
 };
@@ -2774,9 +2781,32 @@ static const struct snd_djm_ctl snd_djm_ctls_750[] = {
 };
 
 
+// DJM-900NXS2
+static const u16 snd_djm_opts_900nxs2_cap1[] = {
+	0x0100, 0x0102, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a };
+static const u16 snd_djm_opts_900nxs2_cap2[] = {
+	0x0200, 0x0202, 0x0203, 0x0206, 0x0207, 0x0208, 0x0209, 0x020a };
+static const u16 snd_djm_opts_900nxs2_cap3[] = {
+	0x0300, 0x0302, 0x0303, 0x0306, 0x0307, 0x0308, 0x0309, 0x030a };
+static const u16 snd_djm_opts_900nxs2_cap4[] = {
+	0x0400, 0x0402, 0x0403, 0x0406, 0x0407, 0x0408, 0x0409, 0x040a };
+static const u16 snd_djm_opts_900nxs2_cap5[] = {
+	0x0507, 0x0508, 0x0509, 0x050a, 0x0511, 0x0512, 0x0513, 0x0514 };
+
+static const struct snd_djm_ctl snd_djm_ctls_900nxs2[] = {
+	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Ch1 Input",   900nxs2_cap1, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch2 Input",   900nxs2_cap2, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch3 Input",   900nxs2_cap3, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch4 Input",   900nxs2_cap4, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch5 Input",   900nxs2_cap5, 3, SND_DJM_WINDEX_CAP)
+};
+
+
 static const struct snd_djm_device snd_djm_devices[] = {
 	SND_DJM_DEVICE(250mk2),
-	SND_DJM_DEVICE(750)
+	SND_DJM_DEVICE(750),
+	SND_DJM_DEVICE(900nxs2)
 };
 
 
@@ -3015,6 +3045,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x08e4, 0x017f): /* Pioneer DJ DJM-750 */
 		err = snd_djm_controls_create(mixer, SND_DJM_750_IDX);
 		break;
+	case USB_ID(0x2b73, 0x000a): /* Pioneer DJ DJM-900NXS2 */
+		err = snd_djm_controls_create(mixer, SND_DJM_900NXS2_IDX);
+		break;
 	}
 
 	return err;
-- 
2.30.1



