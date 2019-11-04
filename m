Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B9EEEC5
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbfKDWDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388642AbfKDWDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:21 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A938E205C9;
        Mon,  4 Nov 2019 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905000;
        bh=SCz0+aVLOMLFT1rkoSyqH/2iP8sVq0FfewMa5fdSFeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPX3M2esQXqXXFZpbOQUPOGiV5O870oBv2vq5bmW83XwDujKZvBl1pXMC8i0taY2R
         EwSSnV3LZ9XbtDfnHnAqhMYIU4WE/wcyhbYGhFUR11EYnIe9LY36RPlF7ZOGa015g9
         YSeo/kjQf8ChsRmm67+z8o0ARDGB7gUiSgCPivko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/149] ALSA: timer: Simplify error path in snd_timer_open()
Date:   Mon,  4 Nov 2019 22:45:38 +0100
Message-Id: <20191104212146.866718521@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 41672c0c24a62699d20aab53b98d843b16483053 ]

Just a minor refactoring to use the standard goto for error paths in
snd_timer_open() instead of open code.  The first mutex_lock() is
moved to the beginning of the function to make the code clearer.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 61a0cec6e1f66..316794eb44017 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -254,19 +254,20 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	struct snd_timer_instance *timeri = NULL;
 	int err;
 
+	mutex_lock(&register_mutex);
 	if (tid->dev_class == SNDRV_TIMER_CLASS_SLAVE) {
 		/* open a slave instance */
 		if (tid->dev_sclass <= SNDRV_TIMER_SCLASS_NONE ||
 		    tid->dev_sclass > SNDRV_TIMER_SCLASS_OSS_SEQUENCER) {
 			pr_debug("ALSA: timer: invalid slave class %i\n",
 				 tid->dev_sclass);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
-		mutex_lock(&register_mutex);
 		timeri = snd_timer_instance_new(owner, NULL);
 		if (!timeri) {
-			mutex_unlock(&register_mutex);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto unlock;
 		}
 		timeri->slave_class = tid->dev_sclass;
 		timeri->slave_id = tid->device;
@@ -277,13 +278,10 @@ int snd_timer_open(struct snd_timer_instance **ti,
 			snd_timer_close_locked(timeri);
 			timeri = NULL;
 		}
-		mutex_unlock(&register_mutex);
-		*ti = timeri;
-		return err;
+		goto unlock;
 	}
 
 	/* open a master instance */
-	mutex_lock(&register_mutex);
 	timer = snd_timer_find(tid);
 #ifdef CONFIG_MODULES
 	if (!timer) {
@@ -294,25 +292,26 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	}
 #endif
 	if (!timer) {
-		mutex_unlock(&register_mutex);
-		return -ENODEV;
+		err = -ENODEV;
+		goto unlock;
 	}
 	if (!list_empty(&timer->open_list_head)) {
 		timeri = list_entry(timer->open_list_head.next,
 				    struct snd_timer_instance, open_list);
 		if (timeri->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
-			mutex_unlock(&register_mutex);
-			return -EBUSY;
+			err = -EBUSY;
+			timeri = NULL;
+			goto unlock;
 		}
 	}
 	if (timer->num_instances >= timer->max_instances) {
-		mutex_unlock(&register_mutex);
-		return -EBUSY;
+		err = -EBUSY;
+		goto unlock;
 	}
 	timeri = snd_timer_instance_new(owner, timer);
 	if (!timeri) {
-		mutex_unlock(&register_mutex);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto unlock;
 	}
 	/* take a card refcount for safe disconnection */
 	if (timer->card)
@@ -321,16 +320,16 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	timeri->slave_id = slave_id;
 
 	if (list_empty(&timer->open_list_head) && timer->hw.open) {
-		int err = timer->hw.open(timer);
+		err = timer->hw.open(timer);
 		if (err) {
 			kfree(timeri->owner);
 			kfree(timeri);
+			timeri = NULL;
 
 			if (timer->card)
 				put_device(&timer->card->card_dev);
 			module_put(timer->module);
-			mutex_unlock(&register_mutex);
-			return err;
+			goto unlock;
 		}
 	}
 
@@ -341,6 +340,8 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		snd_timer_close_locked(timeri);
 		timeri = NULL;
 	}
+
+ unlock:
 	mutex_unlock(&register_mutex);
 	*ti = timeri;
 	return err;
-- 
2.20.1



