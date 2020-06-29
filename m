Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F2D20DDBA
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbgF2USc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgF2TZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB774252FE;
        Mon, 29 Jun 2020 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445128;
        bh=5sygOEUEHK7dK3X8fR8FlA4NhqPgFJ3+yDxttz1/BtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTgSKb0/Bb3NsW+HSodVYoFKhQMrNTFMkmQMUEu68TxXjDyKoULifhsmCcm6Kty47
         mNEcK/AqhB/XFlMb9Z4dI6PvAyZbX5rThhDjRp/btPIPP3d31JU46PT33tvQ3V5+aF
         tkToTICTnmPxHsMEmdPv3RtwPk5h70C6xqLBQUmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/78] ALSA: usb-audio: Clean up mixer element list traverse
Date:   Mon, 29 Jun 2020 11:37:23 -0400
Message-Id: <20200629153806.2494953-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8c558076c740e8009a96c6fdc3d4245dde62be77 ]

Introduce a new macro for iterating over mixer element list for
avoiding the open codes in many places.  Also the open-coded
container_of() and the forced cast to struct usb_mixer_elem_info are
replaced with another simple macro, too.

No functional changes but just readability improvement.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c          | 20 +++++++++-----------
 sound/usb/mixer.h          |  6 ++++++
 sound/usb/mixer_quirks.c   |  2 +-
 sound/usb/mixer_scarlett.c |  6 ++----
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 33deb5ec8b7a1..1a8d706491e65 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2403,9 +2403,9 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 {
 	struct usb_mixer_elem_list *list;
 
-	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem) {
+	for_each_mixer_elem(list, mixer, unitid) {
 		struct usb_mixer_elem_info *info =
-			(struct usb_mixer_elem_info *)list;
+			mixer_elem_list_to_info(list);
 		/* invalidate cache, so the value is read from the device */
 		info->cached = 0;
 		snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
@@ -2416,7 +2416,7 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 static void snd_usb_mixer_dump_cval(struct snd_info_buffer *buffer,
 				    struct usb_mixer_elem_list *list)
 {
-	struct usb_mixer_elem_info *cval = (struct usb_mixer_elem_info *)list;
+	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
 	static char *val_types[] = {"BOOLEAN", "INV_BOOLEAN",
 				    "S8", "U8", "S16", "U16"};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
@@ -2442,8 +2442,7 @@ static void snd_usb_mixer_proc_read(struct snd_info_entry *entry,
 				mixer->ignore_ctl_error);
 		snd_iprintf(buffer, "Card: %s\n", chip->card->longname);
 		for (unitid = 0; unitid < MAX_ID_ELEMS; unitid++) {
-			for (list = mixer->id_elems[unitid]; list;
-			     list = list->next_id_elem) {
+			for_each_mixer_elem(list, mixer, unitid) {
 				snd_iprintf(buffer, "  Unit: %i\n", list->id);
 				if (list->kctl)
 					snd_iprintf(buffer,
@@ -2473,19 +2472,19 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 		return;
 	}
 
-	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem)
+	for_each_mixer_elem(list, mixer, unitid)
 		count++;
 
 	if (count == 0)
 		return;
 
-	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem) {
+	for_each_mixer_elem(list, mixer, unitid) {
 		struct usb_mixer_elem_info *info;
 
 		if (!list->kctl)
 			continue;
 
-		info = (struct usb_mixer_elem_info *)list;
+		info = mixer_elem_list_to_info(list);
 		if (count > 1 && info->control != control)
 			continue;
 
@@ -2705,7 +2704,7 @@ int snd_usb_mixer_suspend(struct usb_mixer_interface *mixer)
 
 static int restore_mixer_value(struct usb_mixer_elem_list *list)
 {
-	struct usb_mixer_elem_info *cval = (struct usb_mixer_elem_info *)list;
+	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
 	int c, err, idx;
 
 	if (cval->cmask) {
@@ -2741,8 +2740,7 @@ int snd_usb_mixer_resume(struct usb_mixer_interface *mixer, bool reset_resume)
 	if (reset_resume) {
 		/* restore cached mixer values */
 		for (id = 0; id < MAX_ID_ELEMS; id++) {
-			for (list = mixer->id_elems[id]; list;
-			     list = list->next_id_elem) {
+			for_each_mixer_elem(list, mixer, id) {
 				if (list->resume) {
 					err = list->resume(list);
 					if (err < 0)
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index ba27f7ade670e..e02653465e292 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -53,6 +53,12 @@ struct usb_mixer_elem_list {
 	usb_mixer_elem_resume_func_t resume;
 };
 
+/* iterate over mixer element list of the given unit id */
+#define for_each_mixer_elem(list, mixer, id)	\
+	for ((list) = (mixer)->id_elems[id]; (list); (list) = (list)->next_id_elem)
+#define mixer_elem_list_to_info(list) \
+	container_of(list, struct usb_mixer_elem_info, head)
+
 struct usb_mixer_elem_info {
 	struct usb_mixer_elem_list head;
 	unsigned int control;	/* CS or ICN (high byte) */
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index b9ea4a42aee4e..ead0456a747c2 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1171,7 +1171,7 @@ void snd_emuusb_set_samplerate(struct snd_usb_audio *chip,
 	int unitid = 12; /* SamleRate ExtensionUnit ID */
 
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
-		cval = (struct usb_mixer_elem_info *)mixer->id_elems[unitid];
+		cval = mixer_elem_list_to_info(mixer->id_elems[unitid]);
 		if (cval) {
 			snd_usb_mixer_set_ctl_value(cval, UAC_SET_CUR,
 						    cval->control << 8,
diff --git a/sound/usb/mixer_scarlett.c b/sound/usb/mixer_scarlett.c
index c33e2378089d5..4aeb9488a0c99 100644
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -287,8 +287,7 @@ static int scarlett_ctl_switch_put(struct snd_kcontrol *kctl,
 
 static int scarlett_ctl_resume(struct usb_mixer_elem_list *list)
 {
-	struct usb_mixer_elem_info *elem =
-		container_of(list, struct usb_mixer_elem_info, head);
+	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 	int i;
 
 	for (i = 0; i < elem->channels; i++)
@@ -447,8 +446,7 @@ static int scarlett_ctl_enum_put(struct snd_kcontrol *kctl,
 
 static int scarlett_ctl_enum_resume(struct usb_mixer_elem_list *list)
 {
-	struct usb_mixer_elem_info *elem =
-		container_of(list, struct usb_mixer_elem_info, head);
+	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 
 	if (elem->cached)
 		snd_usb_set_cur_mix_value(elem, 0, 0, *elem->cache_val);
-- 
2.25.1

