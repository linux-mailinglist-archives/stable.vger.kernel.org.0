Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7266E61C8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjDRM1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDRM1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321988A45
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D3C63173
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A88C433D2;
        Tue, 18 Apr 2023 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820783;
        bh=+HZ6WLxE5X+mRbWramwYTGQq+ZgB21hXxluc8O0Z2Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuVAVY+T4xXsvftLR4TDxleyYqaSQ6oAcHfz1AbGrQUN7R4yXpyrqhl3db+6QAIPO
         SKgZPd7Ane2mydTuKWevOawICLyzkJbCUHpNRKBP4HzghyMx2TWQF9giaWZg4LQ8Qq
         4bP3gEcMYdh/vtu3hZeFvyIJJCg+FHyk26Hm+Y74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 29/57] ALSA: emu10k1: fix capture interrupt handler unlinking
Date:   Tue, 18 Apr 2023 14:21:29 +0200
Message-Id: <20230418120259.768971600@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
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
@@ -1258,7 +1258,7 @@ static int snd_emu10k1_capture_mic_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_mic_interrupt = NULL;
 	emu->pcm_capture_mic_substream = NULL;
 	return 0;
 }
@@ -1366,7 +1366,7 @@ static int snd_emu10k1_capture_efx_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_efx_interrupt = NULL;
 	emu->pcm_capture_efx_substream = NULL;
 	return 0;
 }


