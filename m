Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599EC59D982
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238349AbiHWJUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbiHWJTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:19:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CD512615;
        Tue, 23 Aug 2022 01:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB67BB81C35;
        Tue, 23 Aug 2022 08:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA62C433C1;
        Tue, 23 Aug 2022 08:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243595;
        bh=kRV+Gn5xEpmPrAnDCd4cDOvjWBXX8T4006MlWRjYqyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mub/mPu6zBk1dzsrkt+N61WSRy6gxbT9xkdlIs5c06rGZihJZZNBpbRM7Ev0m1Zwc
         ypSgpPzVUhA3A4aG6V2CQBK1qXtPu4S73eMzcMRFdSSMv6Iehp+jA8YXbggVceHIB8
         B/8JS4JIMEKtR4vcA9da2CRHmD0Zd9n4lC45I/fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 326/365] ALSA: hda: Fix page fault in snd_hda_codec_shutdown()
Date:   Tue, 23 Aug 2022 10:03:47 +0200
Message-Id: <20220823080131.817356112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 980b3a8790b402e959a6d773b38b771019682be1 ]

If early probe of HDAudio bus driver fails e.g.: due to missing
firmware file, snd_hda_codec_shutdown() ends in manipulating
uninitialized codec->pcm_list_head causing page fault.

Iinitialization of HDAudio codec in ASoC is split in two:
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

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220706120230.427296-7-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 41 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ccb195b7cb08..8828fc3a5c3f 100644
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
@@ -980,29 +1000,8 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
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



