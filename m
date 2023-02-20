Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799CB69CDB1
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjBTNvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBTNvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006241E5C3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9528060B74
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE690C433D2;
        Mon, 20 Feb 2023 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901106;
        bh=oePXfbpF/+zX1IsYlzhJ0N2jEXssdJojoV7L75QJXMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0V07w3rHe1WPUGnRuHRHkLUuLIIHIflGxF3n+JdhebZTIELuo0PM+/u+clqXUCEX
         00JQYHwOsGowei9cO6ueBf9OyE+0HqGiwT8OatPYaJ9gMimVXq++P+vQBiSmmybPdY
         7mVFmwqmY/4xV6YeW6+CuVhQ+T8/Y/RLQ6cVM0/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/83] ALSA: hda: Do not unset preset when cleaning up codec
Date:   Mon, 20 Feb 2023 14:35:41 +0100
Message-Id: <20230220133553.983964965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 87978e6ad45a16835cc58234451111091be3c59a ]

Several functions that take part in codec's initialization and removal
are re-used by ASoC codec drivers implementations. Drivers mimic the
behavior of hda_codec_driver_probe/remove() found in
sound/pci/hda/hda_bind.c with their component->probe/remove() instead.

One of the reasons for that is the expectation of
snd_hda_codec_device_new() to receive a valid pointer to an instance of
struct snd_card. This expectation can be met only once sound card
components probing commences.

As ASoC sound card may be unbound without codec device being actually
removed from the system, unsetting ->preset in
snd_hda_codec_cleanup_for_unbind() interferes with module unload -> load
scenario causing null-ptr-deref. Preset is assigned only once, during
device/driver matching whereas ASoC codec driver's module reloading may
occur several times throughout the lifetime of an audio stack.

Suggested-by: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20230119143235.1159814-1-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_bind.c  | 2 ++
 sound/pci/hda/hda_codec.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 7af2515735957..8e35009ec25cb 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -144,6 +144,7 @@ static int hda_codec_driver_probe(struct device *dev)
 
  error:
 	snd_hda_codec_cleanup_for_unbind(codec);
+	codec->preset = NULL;
 	return err;
 }
 
@@ -166,6 +167,7 @@ static int hda_codec_driver_remove(struct device *dev)
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
 	snd_hda_codec_cleanup_for_unbind(codec);
+	codec->preset = NULL;
 	module_put(dev->driver->owner);
 	return 0;
 }
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f552785d301e0..19be60bb57810 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -791,7 +791,6 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	snd_array_free(&codec->cvt_setups);
 	snd_array_free(&codec->spdif_out);
 	snd_array_free(&codec->verbs);
-	codec->preset = NULL;
 	codec->follower_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	snd_array_free(&codec->mixers);
-- 
2.39.0



