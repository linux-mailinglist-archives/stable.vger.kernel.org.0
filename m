Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81F76E621B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjDRMaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjDRMaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C02CC23
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D13631C9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC6CC4339B;
        Tue, 18 Apr 2023 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820977;
        bh=cgUwJQyKAZpayqlO9i4gPVmd2gWqu4AR6tdlHirGaiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqIKTMEujoqjZAzcxW4haui86//Bn5CuL9UxtkEp2WSMmkTP7vHi5VcLMOZH7ewE6
         J8Xmo0FiQ47JesDnP0Ar50LKSS7nO58BQ9k2rGBQ3y/nArziFXJkNY25aUDWezIxEu
         sASHIMlVyOU1pmAwtOkLvstGEYYYN+NDAA6EskEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 45/92] ALSA: emu10k1: fix capture interrupt handler unlinking
Date:   Tue, 18 Apr 2023 14:21:20 +0200
Message-Id: <20230418120306.416973841@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit b09c551c77c7e01dc6e4f3c8bf06b5ffa7b06db5 upstream.

Due to two copy/pastos, closing the MIC or EFX capture device would
make a running ADC capture hang due to unsetting its interrupt handler.
In principle, this would have also allowed dereferencing dangling
pointers, but we're actually rather thorough at disabling and flushing
the ints.

While it may sound like one, this actually wasn't a hypothetical bug:
PortAudio will open a capture stream at startup (and close it right
away) even if not asked to. If the first device is busy, it will just
proceed with the next one ... thus killing a concurrent capture.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197923-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emupcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1244,7 +1244,7 @@ static int snd_emu10k1_capture_mic_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_mic_interrupt = NULL;
 	emu->pcm_capture_mic_substream = NULL;
 	return 0;
 }
@@ -1352,7 +1352,7 @@ static int snd_emu10k1_capture_efx_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_efx_interrupt = NULL;
 	emu->pcm_capture_efx_substream = NULL;
 	return 0;
 }


