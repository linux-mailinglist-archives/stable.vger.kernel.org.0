Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8A75B756A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiIMPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiIMPlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F618305C;
        Tue, 13 Sep 2022 07:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5BAB80F02;
        Tue, 13 Sep 2022 14:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772ABC433D6;
        Tue, 13 Sep 2022 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079538;
        bh=9BgiPP6OCpWvSkGqFHD61EJ8AiegDO/o1o7/clXSep4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgUt1iH0o/WJY6acfyaRQ4IIVV9dknx64giRZU7i4HjQEJCMHXlgp6JlD1p4HKNOI
         q2fyvcNJV61RKNkQ+YzN7rZxcOeYoL4heikiT/cuW1H1CsQSOmOQP/wDrwZ5wVhcCk
         OvZJU1gEWIH0Lg6UF0x/gyXbmhGHGpmNcSPlHR4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 57/79] ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()
Date:   Tue, 13 Sep 2022 16:07:15 +0200
Message-Id: <20220913140351.660224693@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Tasos Sahanidis <tasos@tasossah.com>

commit d29f59051d3a07b81281b2df2b8c9dfe4716067f upstream.

The voice allocator sometimes begins allocating from near the end of the
array and then wraps around, however snd_emu10k1_pcm_channel_alloc()
accesses the newly allocated voices as if it never wrapped around.

This results in out of bounds access if the first voice has a high enough
index so that first_voice + requested_voice_count > NUM_G (64).
The more voices are requested, the more likely it is for this to occur.

This was initially discovered using PipeWire, however it can be reproduced
by calling aplay multiple times with 16 channels:
aplay -r 48000 -D plughw:CARD=Live,DEV=3 -c 16 /dev/zero

UBSAN: array-index-out-of-bounds in sound/pci/emu10k1/emupcm.c:127:40
index 65 is out of range for type 'snd_emu10k1_voice [64]'
CPU: 1 PID: 31977 Comm: aplay Tainted: G        W IOE      6.0.0-rc2-emu10k1+ #7
Hardware name: ASUSTEK COMPUTER INC P5W DH Deluxe/P5W DH Deluxe, BIOS 3002    07/22/2010
Call Trace:
<TASK>
dump_stack_lvl+0x49/0x63
dump_stack+0x10/0x16
ubsan_epilogue+0x9/0x3f
__ubsan_handle_out_of_bounds.cold+0x44/0x49
snd_emu10k1_playback_hw_params+0x3bc/0x420 [snd_emu10k1]
snd_pcm_hw_params+0x29f/0x600 [snd_pcm]
snd_pcm_common_ioctl+0x188/0x1410 [snd_pcm]
? exit_to_user_mode_prepare+0x35/0x170
? do_syscall_64+0x69/0x90
? syscall_exit_to_user_mode+0x26/0x50
? do_syscall_64+0x69/0x90
? exit_to_user_mode_prepare+0x35/0x170
snd_pcm_ioctl+0x27/0x40 [snd_pcm]
__x64_sys_ioctl+0x95/0xd0
do_syscall_64+0x5c/0x90
? do_syscall_64+0x69/0x90
? do_syscall_64+0x69/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3707dcab-320a-62ff-63c0-73fc201ef756@tasossah.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/emu10k1/emupcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -137,7 +137,7 @@ static int snd_emu10k1_pcm_channel_alloc
 	epcm->voices[0]->epcm = epcm;
 	if (voices > 1) {
 		for (i = 1; i < voices; i++) {
-			epcm->voices[i] = &epcm->emu->voices[epcm->voices[0]->number + i];
+			epcm->voices[i] = &epcm->emu->voices[(epcm->voices[0]->number + i) % NUM_G];
 			epcm->voices[i]->epcm = epcm;
 		}
 	}


