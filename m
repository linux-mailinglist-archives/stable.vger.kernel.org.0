Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4A569CE78
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjBTN7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbjBTN7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F181F483
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54136B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F345C4339B;
        Mon, 20 Feb 2023 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901549;
        bh=ppxyXvM1RtZA8O+zbZe1DiAvDN7Ji5RszCir4ckcyFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evPGliaUUEALMhde/keWifX63t0Mq2ColnnKl8MwvtI0Dgmd8NVkDyBEVN7pTpvjH
         DGzna1SQ+0sP7ucTGiuol2mOTuAVtgLTY3NTXvBzBQ23KGFGHbdReo01UWIneKDpyW
         WwmlxodS2Lzh5xi9s3emtadtmcZDh2bpvLZqUMK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Montleon <jmontleo@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 059/118] ALSA: hda: Fix codec device field initializan
Date:   Mon, 20 Feb 2023 14:36:15 +0100
Message-Id: <20230220133602.799819031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 3af4a4f7a20c94009adba65764fa5a0269d70a82 upstream.

Commit f2bd1c5ae2cb ("ALSA: hda: Fix page fault in
snd_hda_codec_shutdown()") relocated initialization of several codec
device fields. Due to differences between codec_exec_verb() and
snd_hdac_bus_exec_bus() in how they handle VERB execution - the latter
does not touch PM - assigning ->exec_verb to codec_exec_verb() causes PM
to be engaged before it is configured for the device. Configuration of
PM for the ASoC HDAudio sound card is done with snd_hda_set_power_save()
during skl_hda_audio_probe() whereas the assignment happens early, in
snd_hda_codec_device_init().

Revert to previous behavior to avoid problems caused by too early PM
manipulation.

Suggested-by: Jason Montleon <jmontleo@redhat.com>
Link: https://lore.kernel.org/regressions/CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com
Fixes: f2bd1c5ae2cb ("ALSA: hda: Fix page fault in snd_hda_codec_shutdown()")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20230210165541.3543604-1-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ac1cc7c5290e..2e728aad6771 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -927,7 +927,6 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	codec->depop_delay = -1;
 	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
 	codec->core.dev.release = snd_hda_codec_dev_release;
-	codec->core.exec_verb = codec_exec_verb;
 	codec->core.type = HDA_DEV_LEGACY;
 
 	mutex_init(&codec->spdif_mutex);
@@ -998,6 +997,7 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 	if (snd_BUG_ON(codec_addr > HDA_MAX_CODEC_ADDRESS))
 		return -EINVAL;
 
+	codec->core.exec_verb = codec_exec_verb;
 	codec->card = card;
 	codec->addr = codec_addr;
 
-- 
2.39.1



