Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4D4690656
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjBILQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjBILPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB6566FAA;
        Thu,  9 Feb 2023 03:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD0C61A1E;
        Thu,  9 Feb 2023 11:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB672C433EF;
        Thu,  9 Feb 2023 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941335;
        bh=2KHn4SYMmwidIr5JYfKHTCQ0IIRhcvyKS7hBDZnQ3hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7IaXhNSUvoUrzVQnsvomiD+w9QByr41iRd7X7GoWdpQEtOahwjkDBRIZHbcTur6m
         +k3dfbLVxCy1RE2070dcnXgzTtRetyvc2hkuLK1cJiBZdvSu18IZGxVbOtP1ua8IMV
         us9WdreVtbb5Fnt4FGT6MDbPnhf+4XPZAVHTQzFOVkyDHcdlDBwMb/72+EPKQKgKyS
         N3v/oMtQUqxSxEWhQZwJvuILpkLGQuQ5f71L2ZzV5bjh4ThMK9Eoo9kZtS76OhUCFK
         tqgr18PDqz8zJnbmkcqw2pYCTft7qkd8WlOQvZm1qxgRKTvFOFg6zIA4CC2YHF9uPg
         pXzq7xcKJAnGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        kai.vehmanen@linux.intel.com, pierre-louis.bossart@linux.intel.com,
        mkumard@nvidia.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 09/38] ALSA: hda: Do not unset preset when cleaning up codec
Date:   Thu,  9 Feb 2023 06:14:28 -0500
Message-Id: <20230209111459.1891941-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1a868dd9dc4b6..890c2f7c33fc2 100644
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
index edd653ece70d7..ac1cc7c5290e3 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -795,7 +795,6 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	snd_array_free(&codec->cvt_setups);
 	snd_array_free(&codec->spdif_out);
 	snd_array_free(&codec->verbs);
-	codec->preset = NULL;
 	codec->follower_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	snd_array_free(&codec->mixers);
-- 
2.39.0

