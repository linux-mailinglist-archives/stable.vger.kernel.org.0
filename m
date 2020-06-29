Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5782320DE7E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgF2U0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732524AbgF2TZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7074925452;
        Mon, 29 Jun 2020 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445406;
        bh=pn4EvdabqAIQFqUK8OAXHmMfrV0skEtEdPDrXlOgglU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFa4nVpVAXIg51sic7V6+bRjWx3wzbzrSUnr0ruIADc2BZ6pX6igR1ZDfcoL2V0Qr
         ul5jCldFCD0+ZwT+GUQ2a3C6jXepaaefUi6uaFeYXwlSjOi07gEt2wk2Yy9JN6vSyw
         poLpDwMCpdNNuO/caudgAD8sL1t2sqH2mp9fTSC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+fb14314433463ad51625@syzkaller.appspotmail.com,
        syzbot+2405ca3401e943c538b5@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 157/191] ALSA: usb-audio: Fix OOB access of mixer element list
Date:   Mon, 29 Jun 2020 11:39:33 -0400
Message-Id: <20200629154007.2495120-158-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 220345e98f1cdc768eeb6e3364a0fa7ab9647fe7 ]

The USB-audio mixer code holds a linked list of usb_mixer_elem_list,
and several operations are performed for each mixer element.  A few of
them (snd_usb_mixer_notify_id() and snd_usb_mixer_interrupt_v2())
assume each mixer element being a usb_mixer_elem_info object that is a
subclass of usb_mixer_elem_list, cast via container_of() and access it
members.  This may result in an out-of-bound access when a
non-standard list element has been added, as spotted by syzkaller
recently.

This patch adds a new field, is_std_info, in usb_mixer_elem_list to
indicate that the element is the usb_mixer_elem_info type or not, and
skip the access to such an element if needed.

Reported-by: syzbot+fb14314433463ad51625@syzkaller.appspotmail.com
Reported-by: syzbot+2405ca3401e943c538b5@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200624122340.9615-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c        | 15 +++++++++++----
 sound/usb/mixer.h        |  9 +++++++--
 sound/usb/mixer_quirks.c |  3 ++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 97ce7b7269847..6913ea27e978e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -585,8 +585,9 @@ static int check_matrix_bitmap(unsigned char *bmap,
  * if failed, give up and free the control instance.
  */
 
-int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
-			      struct snd_kcontrol *kctl)
+int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
+			   struct snd_kcontrol *kctl,
+			   bool is_std_info)
 {
 	struct usb_mixer_interface *mixer = list->mixer;
 	int err;
@@ -599,6 +600,7 @@ int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
 		return err;
 	}
 	list->kctl = kctl;
+	list->is_std_info = is_std_info;
 	list->next_id_elem = mixer->id_elems[list->id];
 	mixer->id_elems[list->id] = list;
 	return 0;
@@ -2398,8 +2400,11 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 	struct usb_mixer_elem_list *list;
 
 	for_each_mixer_elem(list, mixer, unitid) {
-		struct usb_mixer_elem_info *info =
-			mixer_elem_list_to_info(list);
+		struct usb_mixer_elem_info *info;
+
+		if (!list->is_std_info)
+			continue;
+		info = mixer_elem_list_to_info(list);
 		/* invalidate cache, so the value is read from the device */
 		info->cached = 0;
 		snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
@@ -2477,6 +2482,8 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 
 		if (!list->kctl)
 			continue;
+		if (!list->is_std_info)
+			continue;
 
 		info = mixer_elem_list_to_info(list);
 		if (count > 1 && info->control != control)
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 004d99037210f..7d16a92210705 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -48,6 +48,7 @@ struct usb_mixer_elem_list {
 	struct usb_mixer_elem_list *next_id_elem; /* list of controls with same id */
 	struct snd_kcontrol *kctl;
 	unsigned int id;
+	bool is_std_info;
 	usb_mixer_elem_dump_func_t dump;
 	usb_mixer_elem_resume_func_t resume;
 };
@@ -85,8 +86,12 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid);
 int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 				int request, int validx, int value_set);
 
-int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
-			      struct snd_kcontrol *kctl);
+int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
+			   struct snd_kcontrol *kctl,
+			   bool is_std_info);
+
+#define snd_usb_mixer_add_control(list, kctl) \
+	snd_usb_mixer_add_list(list, kctl, true)
 
 void snd_usb_mixer_elem_init_std(struct usb_mixer_elem_list *list,
 				 struct usb_mixer_interface *mixer,
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 5d6af9c861ad9..198515f86fcc2 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -168,7 +168,8 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 		return -ENOMEM;
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
-	return snd_usb_mixer_add_control(list, kctl);
+	/* don't use snd_usb_mixer_add_control() here, this is a special list element */
+	return snd_usb_mixer_add_list(list, kctl, false);
 }
 
 /*
-- 
2.25.1

