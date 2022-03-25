Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC66C4E76D2
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiCYPUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376269AbiCYPT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:19:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98C0DFF99;
        Fri, 25 Mar 2022 08:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C348760ABA;
        Fri, 25 Mar 2022 15:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5079C340E9;
        Fri, 25 Mar 2022 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221313;
        bh=xdY4I81YJ/lcJTydX2z5QiXTyr0xfg7lp1PlCRneQis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUFs6Ngwmu9viLPtH7sU51pcexAo7+4P2Kvd8va/wuOf1iXv4Oa5gD0/F7gNls9D3
         zbzOqqpabZuxDXT6OcIMBfmGHdKZYO1L66B2+dlt51pswxC+yMiicxnjLhKg1Elrmi
         ZXJIAXu1fzYOl/n2gcE9yikfAUdL2DZ+4YT0wdsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 18/37] ALSA: usb-audio: Add mute TLV for playback volumes on RODE NT-USB
Date:   Fri, 25 Mar 2022 16:14:19 +0100
Message-Id: <20220325150420.454812029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
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
@@ -3362,9 +3362,10 @@ void snd_usb_mixer_fu_apply_quirk(struct
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


