Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998CB499B05
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452496AbiAXVtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457477AbiAXVlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F1FC07E326;
        Mon, 24 Jan 2022 12:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECDEB80FA1;
        Mon, 24 Jan 2022 20:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC80C340E5;
        Mon, 24 Jan 2022 20:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056117;
        bh=cDHcC41BeRDzRH5xuHhn9uCJHlJzt0RBPzFkknz6tko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yaxnwqll4dMnYfL3xo8mUdz2AWkbAoyx2X26O+O4/8Xhu0kyPEpPerA/AUs1s0j+u
         c9xVGkloF+aD8LyUaBf//KIF9sC6AaT9ZNIS9fRHwUJxtQGITbtlkgKlJWFK5USE31
         TJK3EJ7mVkY5AWNV+ScuEqwLYE48VzYmzfBS9/W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/846] ALSA: hda: Fix potential deadlock at codec unbinding
Date:   Mon, 24 Jan 2022 19:38:14 +0100
Message-Id: <20220124184113.930522959@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7206998f578d5553989bc01ea2e544b622e79539 ]

When a codec is unbound dynamically via sysfs while its stream is in
use, we may face a potential deadlock at the proc remove or a UAF.
This happens since the hda_pcm is managed by a linked list, as it
handles the hda_pcm object release via kref.

When a PCM is opened at the unbinding time, the release of hda_pcm
gets delayed and it ends up with the close of the PCM stream releasing
the associated hda_pcm object of its own.  The hda_pcm destructor
contains the PCM device release that includes the removal of procfs
entries.  And, this removal has the sync of the close of all in-use
files -- which would never finish because it's called from the PCM
file descriptor itself, i.e. it's trying to shoot its foot.

For addressing the deadlock above, this patch changes the way to
manage and release the hda_pcm object.  The kref of hda_pcm is
dropped, and instead a simple refcount is introduced in hda_codec for
keeping the track of the active PCM streams, and at each PCM open and
close, this refcount is adjusted accordingly.  At unbinding, the
driver calls snd_device_disconnect() for each PCM stream, then
synchronizes with the refcount finish, and finally releases the object
resources.

Fixes: bbbc7e8502c9 ("ALSA: hda - Allocate hda_pcm objects dynamically")
Link: https://lore.kernel.org/r/20211116072459.18930-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h |  8 +++++---
 sound/pci/hda/hda_bind.c  |  5 +++++
 sound/pci/hda/hda_codec.c | 42 ++++++++++++++++++++++++---------------
 sound/pci/hda/hda_local.h |  1 +
 4 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 0e45963bb767f..82d9daa178517 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -8,7 +8,7 @@
 #ifndef __SOUND_HDA_CODEC_H
 #define __SOUND_HDA_CODEC_H
 
-#include <linux/kref.h>
+#include <linux/refcount.h>
 #include <linux/mod_devicetable.h>
 #include <sound/info.h>
 #include <sound/control.h>
@@ -166,8 +166,8 @@ struct hda_pcm {
 	bool own_chmap;		/* codec driver provides own channel maps */
 	/* private: */
 	struct hda_codec *codec;
-	struct kref kref;
 	struct list_head list;
+	unsigned int disconnected:1;
 };
 
 /* codec information */
@@ -187,6 +187,8 @@ struct hda_codec {
 
 	/* PCM to create, set by patch_ops.build_pcms callback */
 	struct list_head pcm_list_head;
+	refcount_t pcm_ref;
+	wait_queue_head_t remove_sleep;
 
 	/* codec specific info */
 	void *spec;
@@ -420,7 +422,7 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec);
 
 static inline void snd_hda_codec_pcm_get(struct hda_pcm *pcm)
 {
-	kref_get(&pcm->kref);
+	refcount_inc(&pcm->codec->pcm_ref);
 }
 void snd_hda_codec_pcm_put(struct hda_pcm *pcm);
 
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 1c8bffc3eec6e..7153bd53e1893 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -156,6 +156,11 @@ static int hda_codec_driver_remove(struct device *dev)
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
+	refcount_dec(&codec->pcm_ref);
+	snd_hda_codec_disconnect_pcms(codec);
+	wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
+	snd_power_sync_ref(codec->bus->card);
+
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
 	snd_hda_codec_cleanup_for_unbind(codec);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index eda70814369bd..7016b48227bf2 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -703,20 +703,10 @@ get_hda_cvt_setup(struct hda_codec *codec, hda_nid_t nid)
 /*
  * PCM device
  */
-static void release_pcm(struct kref *kref)
-{
-	struct hda_pcm *pcm = container_of(kref, struct hda_pcm, kref);
-
-	if (pcm->pcm)
-		snd_device_free(pcm->codec->card, pcm->pcm);
-	clear_bit(pcm->device, pcm->codec->bus->pcm_dev_bits);
-	kfree(pcm->name);
-	kfree(pcm);
-}
-
 void snd_hda_codec_pcm_put(struct hda_pcm *pcm)
 {
-	kref_put(&pcm->kref, release_pcm);
+	if (refcount_dec_and_test(&pcm->codec->pcm_ref))
+		wake_up(&pcm->codec->remove_sleep);
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_pcm_put);
 
@@ -731,7 +721,6 @@ struct hda_pcm *snd_hda_codec_pcm_new(struct hda_codec *codec,
 		return NULL;
 
 	pcm->codec = codec;
-	kref_init(&pcm->kref);
 	va_start(args, fmt);
 	pcm->name = kvasprintf(GFP_KERNEL, fmt, args);
 	va_end(args);
@@ -741,6 +730,7 @@ struct hda_pcm *snd_hda_codec_pcm_new(struct hda_codec *codec,
 	}
 
 	list_add_tail(&pcm->list, &codec->pcm_list_head);
+	refcount_inc(&codec->pcm_ref);
 	return pcm;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_pcm_new);
@@ -748,15 +738,31 @@ EXPORT_SYMBOL_GPL(snd_hda_codec_pcm_new);
 /*
  * codec destructor
  */
+void snd_hda_codec_disconnect_pcms(struct hda_codec *codec)
+{
+	struct hda_pcm *pcm;
+
+	list_for_each_entry(pcm, &codec->pcm_list_head, list) {
+		if (pcm->disconnected)
+			continue;
+		if (pcm->pcm)
+			snd_device_disconnect(codec->card, pcm->pcm);
+		snd_hda_codec_pcm_put(pcm);
+		pcm->disconnected = 1;
+	}
+}
+
 static void codec_release_pcms(struct hda_codec *codec)
 {
 	struct hda_pcm *pcm, *n;
 
 	list_for_each_entry_safe(pcm, n, &codec->pcm_list_head, list) {
-		list_del_init(&pcm->list);
+		list_del(&pcm->list);
 		if (pcm->pcm)
-			snd_device_disconnect(codec->card, pcm->pcm);
-		snd_hda_codec_pcm_put(pcm);
+			snd_device_free(pcm->codec->card, pcm->pcm);
+		clear_bit(pcm->device, pcm->codec->bus->pcm_dev_bits);
+		kfree(pcm->name);
+		kfree(pcm);
 	}
 }
 
@@ -769,6 +775,7 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 		codec->registered = 0;
 	}
 
+	snd_hda_codec_disconnect_pcms(codec);
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	if (!codec->in_freeing)
 		snd_hda_ctls_clear(codec);
@@ -792,6 +799,7 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	remove_conn_list(codec);
 	snd_hdac_regmap_exit(&codec->core);
 	codec->configured = 0;
+	refcount_set(&codec->pcm_ref, 1); /* reset refcount */
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_cleanup_for_unbind);
 
@@ -958,6 +966,8 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
 	INIT_LIST_HEAD(&codec->conn_list);
 	INIT_LIST_HEAD(&codec->pcm_list_head);
+	refcount_set(&codec->pcm_ref, 1);
+	init_waitqueue_head(&codec->remove_sleep);
 
 	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
 	codec->depop_delay = -1;
diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index d22c96eb2f8fb..8621f576446b8 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -137,6 +137,7 @@ int __snd_hda_add_vmaster(struct hda_codec *codec, char *name,
 int snd_hda_codec_reset(struct hda_codec *codec);
 void snd_hda_codec_register(struct hda_codec *codec);
 void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec);
+void snd_hda_codec_disconnect_pcms(struct hda_codec *codec);
 
 #define snd_hda_regmap_sync(codec)	snd_hdac_regmap_sync(&(codec)->core)
 
-- 
2.34.1



