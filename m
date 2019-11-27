Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD810B282
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 16:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfK0Pgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 10:36:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:42580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbfK0Pgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 10:36:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21A57AD1A;
        Wed, 27 Nov 2019 15:36:50 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.4.y v2] ALSA: hda - Disable audio component for legacy Nvidia HDMI codecs
Date:   Wed, 27 Nov 2019 16:36:47 +0100
Message-Id: <20191127153647.24752-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5a858e79c911330678b5a9be91a24830e94a0dc9 upstream.

The old Nvidia chips have multiple HD-audio codecs on the same
HD-audio controller, and this doesn't work as expected with the current
audio component binding that is implemented under the one-codec-per-
controller assumption; at the probe time, the driver leads to several
kernel WARNING messages.

For the proper support, we may change the pin2port and port2pin to
traverse the codec list per the given pin number, but this needs more
development and testing.

As a quick workaround, instead, this patch drops the binding in the
audio side for these legacy chips since the audio component support in
nouveau graphics driver is still not merged (hence it's basically
unused).

[ Unlike the original commit, this patch actually disables the audio
  component binding for all Nvidia chips, not only for legacy chips.
  It doesn't matter much, though: nouveau gfx driver still doesn't
  provide the audio component binding on 5.4.y, so it's only a
  placeholder for now.  Also, another difference from the original
  commit is that this removes the nvhdmi_audio_ops and other
  definitions completely in order to avoid a compile warning due to
  unused stuff.  -- tiwai ]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205625
Fixes: ade49db337a9 ("ALSA: hda/hdmi - Allow audio component for AMD/ATI and Nvidia HDMI")
Link: https://lore.kernel.org/r/20191122132000.4460-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/patch_hdmi.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 78bd2e3722c7..d14f6684737d 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3454,26 +3454,6 @@ static int nvhdmi_chmap_validate(struct hdac_chmap *chmap,
 	return 0;
 }
 
-/* map from pin NID to port; port is 0-based */
-/* for Nvidia: assume widget NID starting from 4, with step 1 (4, 5, 6, ...) */
-static int nvhdmi_pin2port(void *audio_ptr, int pin_nid)
-{
-	return pin_nid - 4;
-}
-
-/* reverse-map from port to pin NID: see above */
-static int nvhdmi_port2pin(struct hda_codec *codec, int port)
-{
-	return port + 4;
-}
-
-static const struct drm_audio_component_audio_ops nvhdmi_audio_ops = {
-	.pin2port = nvhdmi_pin2port,
-	.pin_eld_notify = generic_acomp_pin_eld_notify,
-	.master_bind = generic_acomp_master_bind,
-	.master_unbind = generic_acomp_master_unbind,
-};
-
 static int patch_nvhdmi(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec;
@@ -3492,8 +3472,6 @@ static int patch_nvhdmi(struct hda_codec *codec)
 
 	codec->link_down_at_suspend = 1;
 
-	generic_acomp_init(codec, &nvhdmi_audio_ops, nvhdmi_port2pin);
-
 	return 0;
 }
 
-- 
2.16.4

