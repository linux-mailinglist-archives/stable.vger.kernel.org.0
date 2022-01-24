Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBED498F70
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiAXTwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356705AbiAXTrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:47:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001EEC038ADC;
        Mon, 24 Jan 2022 11:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B9FEB8123F;
        Mon, 24 Jan 2022 19:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EFFC340E5;
        Mon, 24 Jan 2022 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052163;
        bh=mJ7EnTXoE+3TzNWISKOxh44ytbpCqkpAZk/lHkYoLTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sReFaDQoXuD53fU5UKCSfXMc6vC61oD/njv/23l5UTwltyP9+ovLcP0vjK4cvRH2U
         pQWrwSDoM5iHaWJb0cwpV5Sxm8GlPFi7QLcDkPsTwSHXrRhMxY0odsZBjmYxP9S+ee
         RPPzNLV5uS5nrIcBimzEBID12Oh09ZtGtnNeJjIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        KaiChieh Chuang <kaichieh.chuang@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Will McVicker <willmcvicker@google.com>
Subject: [PATCH 4.19 208/239] ASoC: dpcm: prevent snd_soc_dpcm use after free
Date:   Mon, 24 Jan 2022 19:44:06 +0100
Message-Id: <20220124183949.720547325@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KaiChieh Chuang <kaichieh.chuang@mediatek.com>

commit a9764869779081e8bf24da07ac040e8f3efcf13a upstream.

The dpcm get from fe_clients/be_clients
may be free before use

Add a spin lock at snd_soc_card level,
to protect the dpcm instance.
The lock may be used in atomic context, so use spin lock.

Use irq spin lock version,
since the lock may be used in interrupts.

possible race condition between
void dpcm_be_disconnect(
	...
	list_del(&dpcm->list_be);
	list_del(&dpcm->list_fe);
	kfree(dpcm);
	...

and
	for_each_dpcm_fe()
	for_each_dpcm_be*()

race condition example
Thread 1:
    snd_soc_dapm_mixer_update_power()
        -> soc_dpcm_runtime_update()
            -> dpcm_be_disconnect()
                -> kfree(dpcm);
Thread 2:
    dpcm_fe_dai_trigger()
        -> dpcm_be_dai_trigger()
            -> snd_soc_dpcm_can_be_free_stop()
                -> if (dpcm->fe == fe)

Excpetion Scenario:
	two FE link to same BE
	FE1 -> BE
	FE2 ->

	Thread 1: switch of mixer between FE2 -> BE
	Thread 2: pcm_stop FE1

Exception:

Unable to handle kernel paging request at virtual address dead0000000000e0

pc=<> [<ffffff8960e2cd10>] dpcm_be_dai_trigger+0x29c/0x47c
	sound/soc/soc-pcm.c:3226
		if (dpcm->fe == fe)
lr=<> [<ffffff8960e2f694>] dpcm_fe_dai_do_trigger+0x94/0x26c

Backtrace:
[<ffffff89602dba80>] notify_die+0x68/0xb8
[<ffffff896028c7dc>] die+0x118/0x2a8
[<ffffff89602a2f84>] __do_kernel_fault+0x13c/0x14c
[<ffffff89602a27f4>] do_translation_fault+0x64/0xa0
[<ffffff8960280cf8>] do_mem_abort+0x4c/0xd0
[<ffffff8960282ad0>] el1_da+0x24/0x40
[<ffffff8960e2cd10>] dpcm_be_dai_trigger+0x29c/0x47c
[<ffffff8960e2f694>] dpcm_fe_dai_do_trigger+0x94/0x26c
[<ffffff8960e2edec>] dpcm_fe_dai_trigger+0x3c/0x44
[<ffffff8960de5588>] snd_pcm_do_stop+0x50/0x5c
[<ffffff8960dded24>] snd_pcm_action+0xb4/0x13c
[<ffffff8960ddfdb4>] snd_pcm_drop+0xa0/0x128
[<ffffff8960de69bc>] snd_pcm_common_ioctl+0x9d8/0x30f0
[<ffffff8960de1cac>] snd_pcm_ioctl_compat+0x29c/0x2f14
[<ffffff89604c9d60>] compat_SyS_ioctl+0x128/0x244
[<ffffff8960283740>] el0_svc_naked+0x34/0x38
[<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: KaiChieh Chuang <kaichieh.chuang@mediatek.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[willmcvicker: move spinlock to bottom of struct snd_soc_card]
Signed-off-by: Will McVicker <willmcvicker@google.com>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/soc.h  |    2 ++
 sound/soc/soc-core.c |    1 +
 sound/soc/soc-pcm.c  |   40 +++++++++++++++++++++++++++++++++-------
 3 files changed, 36 insertions(+), 7 deletions(-)

--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1113,6 +1113,8 @@ struct snd_soc_card {
 	u32 pop_time;
 
 	void *drvdata;
+
+	spinlock_t dpcm_lock;
 };
 
 /* SoC machine DAI configuration, glues a codec and cpu DAI together */
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2752,6 +2752,7 @@ int snd_soc_register_card(struct snd_soc
 	card->instantiated = 0;
 	mutex_init(&card->mutex);
 	mutex_init(&card->dapm_mutex);
+	spin_lock_init(&card->dpcm_lock);
 
 	ret = snd_soc_instantiate_card(card);
 	if (ret != 0)
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1221,6 +1221,7 @@ static int dpcm_be_connect(struct snd_so
 		struct snd_soc_pcm_runtime *be, int stream)
 {
 	struct snd_soc_dpcm *dpcm;
+	unsigned long flags;
 
 	/* only add new dpcms */
 	list_for_each_entry(dpcm, &fe->dpcm[stream].be_clients, list_be) {
@@ -1236,8 +1237,10 @@ static int dpcm_be_connect(struct snd_so
 	dpcm->fe = fe;
 	be->dpcm[stream].runtime = fe->dpcm[stream].runtime;
 	dpcm->state = SND_SOC_DPCM_LINK_STATE_NEW;
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_add(&dpcm->list_be, &fe->dpcm[stream].be_clients);
 	list_add(&dpcm->list_fe, &be->dpcm[stream].fe_clients);
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 	dev_dbg(fe->dev, "connected new DPCM %s path %s %s %s\n",
 			stream ? "capture" : "playback",  fe->dai_link->name,
@@ -1283,6 +1286,7 @@ static void dpcm_be_reparent(struct snd_
 void dpcm_be_disconnect(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	struct snd_soc_dpcm *dpcm, *d;
+	unsigned long flags;
 
 	list_for_each_entry_safe(dpcm, d, &fe->dpcm[stream].be_clients, list_be) {
 		dev_dbg(fe->dev, "ASoC: BE %s disconnect check for %s\n",
@@ -1302,8 +1306,10 @@ void dpcm_be_disconnect(struct snd_soc_p
 #ifdef CONFIG_DEBUG_FS
 		debugfs_remove(dpcm->debugfs_state);
 #endif
+		spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 		list_del(&dpcm->list_be);
 		list_del(&dpcm->list_fe);
+		spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 		kfree(dpcm);
 	}
 }
@@ -1557,10 +1563,13 @@ int dpcm_process_paths(struct snd_soc_pc
 void dpcm_clear_pending_state(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	struct snd_soc_dpcm *dpcm;
+	unsigned long flags;
 
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_for_each_entry(dpcm, &fe->dpcm[stream].be_clients, list_be)
 		dpcm->be->dpcm[stream].runtime_update =
 						SND_SOC_DPCM_UPDATE_NO;
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 }
 
 static void dpcm_be_dai_startup_unwind(struct snd_soc_pcm_runtime *fe,
@@ -2626,6 +2635,7 @@ static int dpcm_run_update_startup(struc
 	struct snd_soc_dpcm *dpcm;
 	enum snd_soc_dpcm_trigger trigger = fe->dai_link->trigger[stream];
 	int ret;
+	unsigned long flags;
 
 	dev_dbg(fe->dev, "ASoC: runtime %s open on FE %s\n",
 			stream ? "capture" : "playback", fe->dai_link->name);
@@ -2695,11 +2705,13 @@ close:
 	dpcm_be_dai_shutdown(fe, stream);
 disconnect:
 	/* disconnect any non started BEs */
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_for_each_entry(dpcm, &fe->dpcm[stream].be_clients, list_be) {
 		struct snd_soc_pcm_runtime *be = dpcm->be;
 		if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
 				dpcm->state = SND_SOC_DPCM_LINK_STATE_FREE;
 	}
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 	return ret;
 }
@@ -3278,7 +3290,10 @@ int snd_soc_dpcm_can_be_free_stop(struct
 {
 	struct snd_soc_dpcm *dpcm;
 	int state;
+	int ret = 1;
+	unsigned long flags;
 
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_for_each_entry(dpcm, &be->dpcm[stream].fe_clients, list_fe) {
 
 		if (dpcm->fe == fe)
@@ -3287,12 +3302,15 @@ int snd_soc_dpcm_can_be_free_stop(struct
 		state = dpcm->fe->dpcm[stream].state;
 		if (state == SND_SOC_DPCM_STATE_START ||
 			state == SND_SOC_DPCM_STATE_PAUSED ||
-			state == SND_SOC_DPCM_STATE_SUSPEND)
-			return 0;
+			state == SND_SOC_DPCM_STATE_SUSPEND) {
+			ret = 0;
+			break;
+		}
 	}
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 	/* it's safe to free/stop this BE DAI */
-	return 1;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dpcm_can_be_free_stop);
 
@@ -3305,7 +3323,10 @@ int snd_soc_dpcm_can_be_params(struct sn
 {
 	struct snd_soc_dpcm *dpcm;
 	int state;
+	int ret = 1;
+	unsigned long flags;
 
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_for_each_entry(dpcm, &be->dpcm[stream].fe_clients, list_fe) {
 
 		if (dpcm->fe == fe)
@@ -3315,12 +3336,15 @@ int snd_soc_dpcm_can_be_params(struct sn
 		if (state == SND_SOC_DPCM_STATE_START ||
 			state == SND_SOC_DPCM_STATE_PAUSED ||
 			state == SND_SOC_DPCM_STATE_SUSPEND ||
-			state == SND_SOC_DPCM_STATE_PREPARE)
-			return 0;
+			state == SND_SOC_DPCM_STATE_PREPARE) {
+			ret = 0;
+			break;
+		}
 	}
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 	/* it's safe to change hw_params */
-	return 1;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dpcm_can_be_params);
 
@@ -3359,6 +3383,7 @@ static ssize_t dpcm_show_state(struct sn
 	struct snd_pcm_hw_params *params = &fe->dpcm[stream].hw_params;
 	struct snd_soc_dpcm *dpcm;
 	ssize_t offset = 0;
+	unsigned long flags;
 
 	/* FE state */
 	offset += scnprintf(buf + offset, size - offset,
@@ -3386,6 +3411,7 @@ static ssize_t dpcm_show_state(struct sn
 		goto out;
 	}
 
+	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 	list_for_each_entry(dpcm, &fe->dpcm[stream].be_clients, list_be) {
 		struct snd_soc_pcm_runtime *be = dpcm->be;
 		params = &dpcm->hw_params;
@@ -3406,7 +3432,7 @@ static ssize_t dpcm_show_state(struct sn
 				params_channels(params),
 				params_rate(params));
 	}
-
+	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 out:
 	return offset;
 }


