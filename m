Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7449073E99
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389268AbfGXTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389563AbfGXTiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E1320665;
        Wed, 24 Jul 2019 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997084;
        bh=xN7Geh9N/0DPx/OZt3xRqiZ3AUSoyI7pwGHwsyU10/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwWYCvrlPoNmfh+9MnjOkmwtDrbQGJMxjX+BY4VxVIEClWrPusIfa8UOgHBvpA0CK
         LuwXxHTga8O+YcucgpV9A976sNMIuu4GmO/JwZDSTJzwGeCm77QPs1mnMUUh06CHd9
         hWcMEQ6V8VCBTXdsKcOmbR1ViXx86mQo+qVu+0+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 315/413] ALSA: hda - Dont resume forcibly i915 HDMI/DP codec
Date:   Wed, 24 Jul 2019 21:20:06 +0200
Message-Id: <20190724191758.376309299@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4914da2fb0c89205790503f20dfdde854f3afdd8 upstream.

We apply the codec resume forcibly at system resume callback for
updating and syncing the jack detection state that may have changed
during sleeping.  This is, however, superfluous for the codec like
Intel HDMI/DP, where the jack detection is managed via the audio
component notification; i.e. the jack state change shall be reported
sooner or later from the graphics side at mode change.

This patch changes the codec resume callback to avoid the forcible
resume conditionally with a new flag, codec->relaxed_resume, for
reducing the resume time.  The flag is set in the codec probe.

Although this doesn't fix the entire bug mentioned in the bugzilla
entry below, it's still a good optimization and some improvements are
seen.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201901
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/hda_codec.h  |    2 ++
 sound/pci/hda/hda_codec.c  |    8 ++++++--
 sound/pci/hda/patch_hdmi.c |    6 +++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -249,6 +249,8 @@ struct hda_codec {
 	unsigned int auto_runtime_pm:1; /* enable automatic codec runtime pm */
 	unsigned int force_pin_prefix:1; /* Add location prefix */
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
+	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
+
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
 	unsigned long power_off_acct;
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2941,15 +2941,19 @@ static int hda_codec_runtime_resume(stru
 #ifdef CONFIG_PM_SLEEP
 static int hda_codec_force_resume(struct device *dev)
 {
+	struct hda_codec *codec = dev_to_hda_codec(dev);
+	bool forced_resume = !codec->relaxed_resume;
 	int ret;
 
 	/* The get/put pair below enforces the runtime resume even if the
 	 * device hasn't been used at suspend time.  This trick is needed to
 	 * update the jack state change during the sleep.
 	 */
-	pm_runtime_get_noresume(dev);
+	if (forced_resume)
+		pm_runtime_get_noresume(dev);
 	ret = pm_runtime_force_resume(dev);
-	pm_runtime_put(dev);
+	if (forced_resume)
+		pm_runtime_put(dev);
 	return ret;
 }
 
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2291,8 +2291,10 @@ static void generic_hdmi_free(struct hda
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx, pcm_idx;
 
-	if (codec_has_acomp(codec))
+	if (codec_has_acomp(codec)) {
 		snd_hdac_acomp_register_notifier(&codec->bus->core, NULL);
+		codec->relaxed_resume = 0;
+	}
 
 	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
 		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
@@ -2565,6 +2567,8 @@ static void register_i915_notifier(struc
 	spec->drm_audio_ops.pin_eld_notify = intel_pin_eld_notify;
 	snd_hdac_acomp_register_notifier(&codec->bus->core,
 					&spec->drm_audio_ops);
+	/* no need for forcible resume for jack check thanks to notifier */
+	codec->relaxed_resume = 1;
 }
 
 /* setup_stream ops override for HSW+ */


