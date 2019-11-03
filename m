Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B98ED407
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfKCRlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 12:41:04 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32957 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbfKCRlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 12:41:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E21721391;
        Sun,  3 Nov 2019 12:41:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 03 Nov 2019 12:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wjdcTZ
        HWPiKLXblHPm1KXL0zi/X4MWp1IPfVo7G0SV8=; b=ie4pNUrYEPYZMNQVjbapFt
        tKOBDdkyYj5J5xfYRKYzagG+RVZInlecUMoMI24dDIqwgZQOtMgv4J3BqzOnt6KH
        Mv7qYsHQIGQI2bntP9cBar1OijOnKrqenjhh+d61BfuOoAqji2Lqpou/UJwZQKtp
        91Q+jvf3zDO6P1CyDYK0Ctc/I/4eElmteMPqW8Z/v8z46hQgPZW7ZSBKAj9OwtDp
        w6JZ62TOVuonUC7PcuAxYiqAuF0sXhXbUAkMrW+esW61wLZCCyYpGAmJXXAeo0cd
        c/9kVO3KJg748fHDRztmQvb81DRO4adcbqdX685mreUbV/NrFjkH39S7y+p/tSSg
        ==
X-ME-Sender: <xms:LRG_XTpUXYMmBFHzibeZD_1Fx_dtb5tlGGtgYmDQTJdJupvdgvB6NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduuddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LRG_XRLeoiDJxT4qEC4WunvHdmN9lA71okTAmhGF4mnjD31cniL9qg>
    <xmx:LRG_XYtghlOaB7xmFbgH6DMzT_wWa_kvcD_KuHDI8KV1iPXPgasTfg>
    <xmx:LRG_XZuZEqPQYtggrf_JWPsgJWVmpF1QvSwzWPANOQGlQ8yA3ZcU4A>
    <xmx:LhG_XTrGyH5HCPEmER7jAU8Tp1yBJHTgZtPsHhHee6lXaD81zWR1Ag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69AC0306005C;
        Sun,  3 Nov 2019 12:41:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: timer: Fix mutex deadlock at releasing card" failed to apply to 4.19-stable tree
To:     tiwai@suse.de, kirill.shutemov@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Nov 2019 18:40:59 +0100
Message-ID: <1572802859163107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a39331867335d4a94b6165e306265c9e24aca073 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 30 Oct 2019 22:42:57 +0100
Subject: [PATCH] ALSA: timer: Fix mutex deadlock at releasing card

When a card is disconnected while in use, the system waits until all
opened files are closed then releases the card.  This is done via
put_device() of the card device in each device release code.

The recently reported mutex deadlock bug happens in this code path;
snd_timer_close() for the timer device deals with the global
register_mutex and it calls put_device() there.  When this timer
device is the last one, the card gets freed and it eventually calls
snd_timer_free(), which has again the protection with the global
register_mutex -- boom.

Basically put_device() call itself is race-free, so a relative simple
workaround is to move this put_device() call out of the mutex.  For
achieving that, in this patch, snd_timer_close_locked() got a new
argument to store the card device pointer in return, and each caller
invokes put_device() with the returned object after the mutex unlock.

Reported-and-tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 5c9fbf3f4340..6b724d2ee2de 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -226,7 +226,8 @@ static int snd_timer_check_master(struct snd_timer_instance *master)
 	return 0;
 }
 
-static int snd_timer_close_locked(struct snd_timer_instance *timeri);
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put);
 
 /*
  * open a timer instance
@@ -238,6 +239,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *timeri = NULL;
+	struct device *card_dev_to_put = NULL;
 	int err;
 
 	mutex_lock(&register_mutex);
@@ -261,7 +263,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
 		err = snd_timer_check_slave(timeri);
 		if (err < 0) {
-			snd_timer_close_locked(timeri);
+			snd_timer_close_locked(timeri, &card_dev_to_put);
 			timeri = NULL;
 		}
 		goto unlock;
@@ -313,7 +315,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 			timeri = NULL;
 
 			if (timer->card)
-				put_device(&timer->card->card_dev);
+				card_dev_to_put = &timer->card->card_dev;
 			module_put(timer->module);
 			goto unlock;
 		}
@@ -323,12 +325,15 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	timer->num_instances++;
 	err = snd_timer_check_master(timeri);
 	if (err < 0) {
-		snd_timer_close_locked(timeri);
+		snd_timer_close_locked(timeri, &card_dev_to_put);
 		timeri = NULL;
 	}
 
  unlock:
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	*ti = timeri;
 	return err;
 }
@@ -338,7 +343,8 @@ EXPORT_SYMBOL(snd_timer_open);
  * close a timer instance
  * call this with register_mutex down.
  */
-static int snd_timer_close_locked(struct snd_timer_instance *timeri)
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put)
 {
 	struct snd_timer *timer = timeri->timer;
 	struct snd_timer_instance *slave, *tmp;
@@ -395,7 +401,7 @@ static int snd_timer_close_locked(struct snd_timer_instance *timeri)
 			timer->hw.close(timer);
 		/* release a card refcount for safe disconnection */
 		if (timer->card)
-			put_device(&timer->card->card_dev);
+			*card_devp_to_put = &timer->card->card_dev;
 		module_put(timer->module);
 	}
 
@@ -407,14 +413,18 @@ static int snd_timer_close_locked(struct snd_timer_instance *timeri)
  */
 int snd_timer_close(struct snd_timer_instance *timeri)
 {
+	struct device *card_dev_to_put = NULL;
 	int err;
 
 	if (snd_BUG_ON(!timeri))
 		return -ENXIO;
 
 	mutex_lock(&register_mutex);
-	err = snd_timer_close_locked(timeri);
+	err = snd_timer_close_locked(timeri, &card_dev_to_put);
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	return err;
 }
 EXPORT_SYMBOL(snd_timer_close);

