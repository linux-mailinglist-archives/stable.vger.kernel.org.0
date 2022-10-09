Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F745F94D5
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJJAM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJJAMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F5212626;
        Sun,  9 Oct 2022 16:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D6A60D3D;
        Sun,  9 Oct 2022 23:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AA6C433D6;
        Sun,  9 Oct 2022 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359389;
        bh=DBhVd95XpZutQyzgeXjErPc70e6GrTLKwZc/rk2PCZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTAXnGc3bBW8hVojdZY7HgrOgp6ZWLd0Gogb5w8MaFzD1hx7mMtEvUHVDqZF7JQDW
         Lz47Fn4jFAY+RJzRWggojc8JAikOE6U0qDuxr/vSs+eIod1lTM/8s4tVTiTygCFGk0
         qWbGDM9NHOkgKhcSDhIOiaHRRYRimGEv4DBe9TpjTGhydv4MC2Qh0ZCz2WtD1GEpuz
         t01N1xfX1tIUZcKSIM1/NR8ywL8VqyMUzZ9oMlCX3sCtoRPVN5hMvZA1dWRDjUa5yb
         B1IcZhaYpghUnaeAY9wX7YjkVZZZShrIcRcavgp/SldjRndGqkFB1BXDPFvCgITaaV
         5V9puwWd8K9hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, mkumard@nvidia.com,
        peter.ujfalusi@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 07/44] ALSA: hda: Fix page fault in snd_hda_codec_shutdown()
Date:   Sun,  9 Oct 2022 19:48:55 -0400
Message-Id: <20221009234932.1230196-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 ]

If early probe of HDAudio bus driver fails e.g.: due to missing
firmware file, snd_hda_codec_shutdown() ends in manipulating
uninitialized codec->pcm_list_head causing page fault.

Initialization of HDAudio codec in ASoC is split in two:
- snd_hda_codec_device_init()
- snd_hda_codec_device_new()

snd_hda_codec_device_init() is called during probe_codecs() by HDAudio
bus driver while snd_hda_codec_device_new() is called by
codec-component's ->probe(). The second call will not happen until all
components required by related sound card are present within the ASoC
framework. With firmware failing to load during the PCI's deferred
initialization i.e.: probe_work(), no platform components are ever
registered. HDAudio codec enumeration is done at that point though, so
the codec components became registered to ASoC framework, calling
snd_hda_codec_device_init() in the process.

Now, during platform reboot snd_hda_codec_shutdown() is called for every
codec found on the HDAudio bus causing oops if any of them has not
completed both of their initialization steps. Relocating field
initialization fixes the issue.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220816111727.3218543-7-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 41 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 384426d7e9dd..4ae8b9574778 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -931,8 +931,28 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	}
 
 	codec->bus = bus;
+	codec->depop_delay = -1;
+	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
+	codec->core.dev.release = snd_hda_codec_dev_release;
+	codec->core.exec_verb = codec_exec_verb;
 	codec->core.type = HDA_DEV_LEGACY;
 
+	mutex_init(&codec->spdif_mutex);
+	mutex_init(&codec->control_mutex);
+	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
+	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
+	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
+	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
+	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
+	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
+	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
+	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
+	INIT_LIST_HEAD(&codec->conn_list);
+	INIT_LIST_HEAD(&codec->pcm_list_head);
+	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
+	refcount_set(&codec->pcm_ref, 1);
+	init_waitqueue_head(&codec->remove_sleep);
+
 	return codec;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_device_init);
@@ -985,29 +1005,8 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 	if (snd_BUG_ON(codec_addr > HDA_MAX_CODEC_ADDRESS))
 		return -EINVAL;
 
-	codec->core.dev.release = snd_hda_codec_dev_release;
-	codec->core.exec_verb = codec_exec_verb;
-
 	codec->card = card;
 	codec->addr = codec_addr;
-	mutex_init(&codec->spdif_mutex);
-	mutex_init(&codec->control_mutex);
-	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
-	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
-	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
-	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
-	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
-	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
-	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
-	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
-	INIT_LIST_HEAD(&codec->conn_list);
-	INIT_LIST_HEAD(&codec->pcm_list_head);
-	refcount_set(&codec->pcm_ref, 1);
-	init_waitqueue_head(&codec->remove_sleep);
-
-	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
-	codec->depop_delay = -1;
-	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
 
 #ifdef CONFIG_PM
 	codec->power_jiffies = jiffies;
-- 
2.35.1

