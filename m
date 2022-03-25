Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6D54E7678
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245122AbiCYPPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376435AbiCYPM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286D2652FC;
        Fri, 25 Mar 2022 08:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1DF61C11;
        Fri, 25 Mar 2022 15:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0274C340E9;
        Fri, 25 Mar 2022 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220980;
        bh=PqcOjKsdakPKA5/vVG+F6cn+MgRgtv9RKNhlRz2Ugow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPgxUwN/mRB8PddjZTmG3122vGVSD6wnQCb9XmDEMGl6G8sPqVne9pbnMVZiEgDiS
         Gn6suU9WvDMeZtNnb2fmAaiVYK6AWy2S+HlUqyiOhsaO4GSXVkv2SDl9SSaFK+kQO0
         DyhIEFUetuv7GPTPo4WV/ohkgks23wkI+rnlNO70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 24/38] ALSA: usb-audio: Add mute TLV for playback volumes on RODE NT-USB
Date:   Fri, 25 Mar 2022 16:05:08 +0100
Message-Id: <20220325150420.446579289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 0f306cca42fe879694fb5e2382748c43dc9e0196 upstream.

For the RODE NT-USB the lowest Playback mixer volume setting mutes the
audio output. But it is not reported as such causing e.g. PulseAudio to
accidentally mute the device when selecting a low volume.

Fix this by applying the existing quirk for this kind of issue when the
device is detected.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220311201400.235892-1-lars@metafoo.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3135,9 +3135,10 @@ void snd_usb_mixer_fu_apply_quirk(struct
 		if (unitid == 7 && cval->control == UAC_FU_VOLUME)
 			snd_dragonfly_quirk_db_scale(mixer, cval, kctl);
 		break;
-	/* lowest playback value is muted on C-Media devices */
-	case USB_ID(0x0d8c, 0x000c):
-	case USB_ID(0x0d8c, 0x0014):
+	/* lowest playback value is muted on some devices */
+	case USB_ID(0x0d8c, 0x000c): /* C-Media */
+	case USB_ID(0x0d8c, 0x0014): /* C-Media */
+	case USB_ID(0x19f7, 0x0003): /* RODE NT-USB */
 		if (strstr(kctl->id.name, "Playback"))
 			cval->min_mute = 1;
 		break;


