Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169516E639B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjDRMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjDRMmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524A146C5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C746332E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12319C433EF;
        Tue, 18 Apr 2023 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821706;
        bh=kJYfukdJ863JzUgQwEqwOLn1+LPDE3QziNMDK1i2+rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vPyI3Uxyg6PmE6HHSiTLnIEKvf2dHiDi9jeqgfh0M4Dgk0XmRDMJ+JO9ASjGYpmY
         X+p4oTkK+HpPqbzlMkypNXtBMsLkNwZh0naV4RnwtxLC9DUSW8a9mEJgKeLzwT/0tq
         jaeSTkupr5N0HvxNrlMLuP7YOoiYJagEpQpr/ROI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 003/134] ALSA: emu10k1: fix capture interrupt handler unlinking
Date:   Tue, 18 Apr 2023 14:20:59 +0200
Message-Id: <20230418120313.134676891@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
@@ -1236,7 +1236,7 @@ static int snd_emu10k1_capture_mic_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_mic_interrupt = NULL;
 	emu->pcm_capture_mic_substream = NULL;
 	return 0;
 }
@@ -1344,7 +1344,7 @@ static int snd_emu10k1_capture_efx_close
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_efx_interrupt = NULL;
 	emu->pcm_capture_efx_substream = NULL;
 	return 0;
 }


