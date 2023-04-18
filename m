Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB16E6338
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjDRMiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjDRMiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C8613864
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B070E632CA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D6CC433D2;
        Tue, 18 Apr 2023 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821523;
        bh=T+bcKzURiSu7tT9sZV8X4D3tDFSjNO+KceGYoPkhe1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k77AROvNqay9jZCFZqKfSI/HAipnrmplnwU2qGCXzOvbiWPl4XRePTSyHhxnitEMF
         kNrfNiXlf5lsfs0cxjZbfqrcQSqEkwT6LCOjZ1hvsQlb3tPjSDr2eeetJXCw3NWzZj
         /HldKesWFgdQrwpzXZX5BFqHfByIK7PBuz2MATHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 06/91] ALSA: emu10k1: dont create old pass-through playback device on Audigy
Date:   Tue, 18 Apr 2023 14:21:10 +0200
Message-Id: <20230418120305.761666212@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit 8dd13214a810c695044aa168c0ddba1a9c433e4f upstream.

It could have never worked, as snd_emu10k1_fx8010_playback_prepare() and
snd_emu10k1_fx8010_playback_hw_free() assume the emu10k1 offset for the
ETRAM, and the default DSP code includes no handler for it. It also
wouldn't make a lot of sense to make it work, as Audigy has an own, much
simpler, pass-through mechanism. So just skip creation of the device.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197938-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emupcm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1781,17 +1781,21 @@ int snd_emu10k1_pcm_efx(struct snd_emu10
 	struct snd_kcontrol *kctl;
 	int err;
 
-	err = snd_pcm_new(emu->card, "emu10k1 efx", device, 8, 1, &pcm);
+	err = snd_pcm_new(emu->card, "emu10k1 efx", device, emu->audigy ? 0 : 8, 1, &pcm);
 	if (err < 0)
 		return err;
 
 	pcm->private_data = emu;
 
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
+	if (!emu->audigy)
+		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_emu10k1_fx8010_playback_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_emu10k1_capture_efx_ops);
 
 	pcm->info_flags = 0;
-	strcpy(pcm->name, "Multichannel Capture/PT Playback");
+	if (emu->audigy)
+		strcpy(pcm->name, "Multichannel Capture");
+	else
+		strcpy(pcm->name, "Multichannel Capture/PT Playback");
 	emu->pcm_efx = pcm;
 
 	/* EFX capture - record the "FXBUS2" channels, by default we connect the EXTINs 


