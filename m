Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFE3537F96
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbiE3ODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiE3OBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:01:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F07C3D20;
        Mon, 30 May 2022 06:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1247B80AE8;
        Mon, 30 May 2022 13:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C8FC385B8;
        Mon, 30 May 2022 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917967;
        bh=GTHiEG6Fbnv6d3nL/QXh9DsjWVX96eO95njhrpvwukM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nuwz0usf8oVgkWRNMKAqSrQ9JEvsuh2EF0qAU3cpDtd/ESQfRK3rm6pf4a1e+BRLs
         YptJBORCGFbby3mUofZkwwQZsd12Evc/YUud5f4TQB4VTJDaYWPA3hSBhXAMVYnE2b
         wmavF4tvSDsX3xlJZrglT9zod4ZR8wTCznSgj83g2LGceWtLLsgpb9u+1iOJqWUdsD
         GacZ99cOQEljlhmYxmPzB79WKx2TA07s6NQuD5rlNa88cUAUPJEb0EX+zqnx9ipqeW
         ZcC/dSuLB2PPtq949tqCKY+QR7sWgkOFBf+ThE71jZUFQJT4HLam0zpNi0xlwYY5I2
         ghjuFU1+rC7Ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, xkernel.wang@foxmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 020/109] ALSA: jack: Access input_dev under mutex
Date:   Mon, 30 May 2022 09:36:56 -0400
Message-Id: <20220530133825.1933431-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 1b6a6fc5280e97559287b61eade2d4b363e836f2 ]

It is possible when using ASoC that input_dev is unregistered while
calling snd_jack_report, which causes NULL pointer dereference.
In order to prevent this serialize access to input_dev using mutex lock.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220412091628.3056922-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/jack.h |  1 +
 sound/core/jack.c    | 34 +++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/sound/jack.h b/include/sound/jack.h
index 1181f536557e..1ed90e2109e9 100644
--- a/include/sound/jack.h
+++ b/include/sound/jack.h
@@ -62,6 +62,7 @@ struct snd_jack {
 	const char *id;
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct input_dev *input_dev;
+	struct mutex input_dev_lock;
 	int registered;
 	int type;
 	char name[100];
diff --git a/sound/core/jack.c b/sound/core/jack.c
index d1e3055f2b6a..88493cc31914 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -42,8 +42,11 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct snd_jack *jack = device->device_data;
 
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return 0;
+	}
 
 	/* If the input device is registered with the input subsystem
 	 * then we need to use a different deallocator. */
@@ -52,6 +55,7 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 	else
 		input_free_device(jack->input_dev);
 	jack->input_dev = NULL;
+	mutex_unlock(&jack->input_dev_lock);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 	return 0;
 }
@@ -90,8 +94,11 @@ static int snd_jack_dev_register(struct snd_device *device)
 	snprintf(jack->name, sizeof(jack->name), "%s %s",
 		 card->shortname, jack->id);
 
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return 0;
+	}
 
 	jack->input_dev->name = jack->name;
 
@@ -116,6 +123,7 @@ static int snd_jack_dev_register(struct snd_device *device)
 	if (err == 0)
 		jack->registered = 1;
 
+	mutex_unlock(&jack->input_dev_lock);
 	return err;
 }
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
@@ -517,9 +525,11 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 		return -ENOMEM;
 	}
 
-	/* don't creat input device for phantom jack */
-	if (!phantom_jack) {
 #ifdef CONFIG_SND_JACK_INPUT_DEV
+	mutex_init(&jack->input_dev_lock);
+
+	/* don't create input device for phantom jack */
+	if (!phantom_jack) {
 		int i;
 
 		jack->input_dev = input_allocate_device();
@@ -537,8 +547,8 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 				input_set_capability(jack->input_dev, EV_SW,
 						     jack_switch_types[i]);
 
-#endif /* CONFIG_SND_JACK_INPUT_DEV */
 	}
+#endif /* CONFIG_SND_JACK_INPUT_DEV */
 
 	err = snd_device_new(card, SNDRV_DEV_JACK, jack, &ops);
 	if (err < 0)
@@ -578,10 +588,14 @@ EXPORT_SYMBOL(snd_jack_new);
 void snd_jack_set_parent(struct snd_jack *jack, struct device *parent)
 {
 	WARN_ON(jack->registered);
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return;
+	}
 
 	jack->input_dev->dev.parent = parent;
+	mutex_unlock(&jack->input_dev_lock);
 }
 EXPORT_SYMBOL(snd_jack_set_parent);
 
@@ -629,6 +643,8 @@ EXPORT_SYMBOL(snd_jack_set_key);
 
 /**
  * snd_jack_report - Report the current status of a jack
+ * Note: This function uses mutexes and should be called from a
+ * context which can sleep (such as a workqueue).
  *
  * @jack:   The jack to report status for
  * @status: The current status of the jack
@@ -654,8 +670,11 @@ void snd_jack_report(struct snd_jack *jack, int status)
 					     status & jack_kctl->mask_bits);
 
 #ifdef CONFIG_SND_JACK_INPUT_DEV
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(jack->key); i++) {
 		int testbit = ((SND_JACK_BTN_0 >> i) & ~mask_bits);
@@ -675,6 +694,7 @@ void snd_jack_report(struct snd_jack *jack, int status)
 	}
 
 	input_sync(jack->input_dev);
+	mutex_unlock(&jack->input_dev_lock);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 }
 EXPORT_SYMBOL(snd_jack_report);
-- 
2.35.1

