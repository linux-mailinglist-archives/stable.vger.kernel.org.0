Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20F542DD6F
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhJNPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhJNPFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684D06124A;
        Thu, 14 Oct 2021 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223682;
        bh=/M1ye1wTka+9xP3XL7Zt1MKIPDn2n66Dlgv269VpWZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JV54/OSzAzUmj8xxnuACXwwI1/pl5afX2JIocxRgn92JkzWVzdWzufhoLrYxQKq49
         PBTf0m1BSusHstLTFtA/QsIiPmc8KDWpGm7WUT+MBUSrQu38GaT6iTw2B19xwCvNU/
         58rTAenwuSfpvW3p/QvX1zm3WyP6mcstqjwg0cf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, En-Shuo Hsu <enshuo@chromium.org>,
        Yu-Hsuan Hsu <yuhsuan@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 06/30] ALSA: usb-audio: Unify mixer resume and reset_resume procedure
Date:   Thu, 14 Oct 2021 16:54:11 +0200
Message-Id: <20211014145209.731464673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b9cf9036609428e845dc300aec13822ba2c4ab3 ]

USB-audio driver assumes that the normal resume would preserve the
device configuration while reset_resume wouldn't, and tries to restore
the mixer elements only at reset_resume callback.  However, this seems
too naive, and some devices do behave differently, resetting the
volume at the normal resume; this resulted in the inconsistent volume
that surprised users.

This patch changes the mixer resume code to handle both the normal and
reset resume in the same way, always restoring the original mixer
element values.  This allows us to unify the both callbacks as well as
dropping the no longer used reset_resume field, which ends up with a
good code reduction.

A slight behavior change by this patch is that now we assign
restore_mixer_value() as the default resume callback, and the function
is no longer called at reset-resume when the resume callback is
overridden by the quirk function.  That is, if needed, the quirk
resume function would have to handle similarly as
restore_mixer_value() by itself.

Reported-by: En-Shuo Hsu <enshuo@chromium.org>
Cc: Yu-Hsuan Hsu <yuhsuan@chromium.org>
Link: https://lore.kernel.org/r/CADDZ45UPsbpAAqP6=ZkTT8BE-yLii4Y7xSDnjK550G2DhQsMew@mail.gmail.com
Link: https://lore.kernel.org/r/20210910105155.12862-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c         | 18 ++++--------------
 sound/usb/mixer.c        | 26 ++++----------------------
 sound/usb/mixer.h        |  3 +--
 sound/usb/mixer_quirks.c |  2 +-
 4 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 6abfc9d079e7..fa75b7e72ad1 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -1020,7 +1020,7 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
 	return 0;
 }
 
-static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
+static int usb_audio_resume(struct usb_interface *intf)
 {
 	struct snd_usb_audio *chip = usb_get_intfdata(intf);
 	struct snd_usb_stream *as;
@@ -1046,7 +1046,7 @@ static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
 	 * we just notify and restart the mixers
 	 */
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
-		err = snd_usb_mixer_resume(mixer, reset_resume);
+		err = snd_usb_mixer_resume(mixer);
 		if (err < 0)
 			goto err_out;
 	}
@@ -1066,20 +1066,10 @@ err_out:
 	atomic_dec(&chip->active); /* allow autopm after this point */
 	return err;
 }
-
-static int usb_audio_resume(struct usb_interface *intf)
-{
-	return __usb_audio_resume(intf, false);
-}
-
-static int usb_audio_reset_resume(struct usb_interface *intf)
-{
-	return __usb_audio_resume(intf, true);
-}
 #else
 #define usb_audio_suspend	NULL
 #define usb_audio_resume	NULL
-#define usb_audio_reset_resume	NULL
+#define usb_audio_resume	NULL
 #endif		/* CONFIG_PM */
 
 static const struct usb_device_id usb_audio_ids [] = {
@@ -1101,7 +1091,7 @@ static struct usb_driver usb_audio_driver = {
 	.disconnect =	usb_audio_disconnect,
 	.suspend =	usb_audio_suspend,
 	.resume =	usb_audio_resume,
-	.reset_resume =	usb_audio_reset_resume,
+	.reset_resume =	usb_audio_resume,
 	.id_table =	usb_audio_ids,
 	.supports_autosuspend = 1,
 };
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9b713b4a5ec4..fa7cf982d39e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3655,33 +3655,16 @@ static int restore_mixer_value(struct usb_mixer_elem_list *list)
 	return 0;
 }
 
-static int default_mixer_reset_resume(struct usb_mixer_elem_list *list)
-{
-	int err;
-
-	if (list->resume) {
-		err = list->resume(list);
-		if (err < 0)
-			return err;
-	}
-	return restore_mixer_value(list);
-}
-
-int snd_usb_mixer_resume(struct usb_mixer_interface *mixer, bool reset_resume)
+int snd_usb_mixer_resume(struct usb_mixer_interface *mixer)
 {
 	struct usb_mixer_elem_list *list;
-	usb_mixer_elem_resume_func_t f;
 	int id, err;
 
 	/* restore cached mixer values */
 	for (id = 0; id < MAX_ID_ELEMS; id++) {
 		for_each_mixer_elem(list, mixer, id) {
-			if (reset_resume)
-				f = list->reset_resume;
-			else
-				f = list->resume;
-			if (f) {
-				err = f(list);
+			if (list->resume) {
+				err = list->resume(list);
 				if (err < 0)
 					return err;
 			}
@@ -3702,7 +3685,6 @@ void snd_usb_mixer_elem_init_std(struct usb_mixer_elem_list *list,
 	list->id = unitid;
 	list->dump = snd_usb_mixer_dump_cval;
 #ifdef CONFIG_PM
-	list->resume = NULL;
-	list->reset_resume = default_mixer_reset_resume;
+	list->resume = restore_mixer_value;
 #endif
 }
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index ea41e7a1f7bf..16567912b998 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -70,7 +70,6 @@ struct usb_mixer_elem_list {
 	bool is_std_info;
 	usb_mixer_elem_dump_func_t dump;
 	usb_mixer_elem_resume_func_t resume;
-	usb_mixer_elem_resume_func_t reset_resume;
 };
 
 /* iterate over mixer element list of the given unit id */
@@ -122,7 +121,7 @@ int snd_usb_mixer_vol_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 
 #ifdef CONFIG_PM
 int snd_usb_mixer_suspend(struct usb_mixer_interface *mixer);
-int snd_usb_mixer_resume(struct usb_mixer_interface *mixer, bool reset_resume);
+int snd_usb_mixer_resume(struct usb_mixer_interface *mixer);
 #endif
 
 int snd_usb_set_cur_mix_value(struct usb_mixer_elem_info *cval, int channel,
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 0a3cb8fd7d00..4a4d3361ac04 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -151,7 +151,7 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 		*listp = list;
 	list->mixer = mixer;
 	list->id = id;
-	list->reset_resume = resume;
+	list->resume = resume;
 	kctl = snd_ctl_new1(knew, list);
 	if (!kctl) {
 		kfree(list);
-- 
2.33.0



