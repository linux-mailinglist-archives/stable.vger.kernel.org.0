Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3839A472753
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhLMJ7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44338 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbhLMJ5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB201B80E66;
        Mon, 13 Dec 2021 09:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECA1C34600;
        Mon, 13 Dec 2021 09:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389468;
        bh=BWWtnEHKN6jPmSi5QmZYSF6LyQnpOVoDOYF0FPYxRhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GioUmLAsra6ShMiBK8lt0z0U1MhngGsHDK11Sc5wWPrm06bl9bCSDNYOrrrDCKv9j
         cNfafKtiIL2+YO1rCUvgXW/WLcn5VJvcb5l+UtZ5OSI/Y0yVU28QpOQv8MZ/e9vf0D
         v5AjoSYZk5S5TIhuCYOyrxoICvFQQvkaAImdtnaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivia Mackintosh <livvy@base.nu>,
        Takashi Iwai <tiwai@suse.de>,
        Geraldo Nascimento <geraldogabriel@gmail.com>
Subject: [PATCH 5.15 105/171] ALSA: usb-audio: Reorder snd_djm_devices[] entries
Date:   Mon, 13 Dec 2021 10:30:20 +0100
Message-Id: <20211213092948.590341009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geraldo Nascimento <geraldogabriel@gmail.com>

commit fb1af5bea4670c835e42fc0c14c49d3499468774 upstream.

Olivia Mackintosh has posted to alsa-devel reporting that
there's a potential bug that could break mixer quirks for Pioneer
devices introduced by 6d27788160362a7ee6c0d317636fe4b1ddbe59a7
"ALSA: usb-audio: Add support for the Pioneer DJM 750MK2
Mixer/Soundcard".

This happened because the DJM 750 MK2 was added last to the Pioneer DJM
device table index and defined as 0x4 but was added to snd_djm_devices[]
just after the DJM 750 (MK1) entry instead of last, after the DJM 900
NXS2. This escaped review.

To prevent that from ever happening again, Takashi Iwai suggested to use
C99 array designators in snd_djm_devices[] instead of simply reordering
the entries.

Fixes: 6d2778816036 ("ALSA: usb-audio: Add support for the Pioneer DJM 750MK2")
Reported-by: Olivia Mackintosh <livvy@base.nu>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Link: https://lore.kernel.org/r/Yau46FDzoql0SNnW@geday
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3016,11 +3016,11 @@ static const struct snd_djm_ctl snd_djm_
 
 
 static const struct snd_djm_device snd_djm_devices[] = {
-	SND_DJM_DEVICE(250mk2),
-	SND_DJM_DEVICE(750),
-	SND_DJM_DEVICE(750mk2),
-	SND_DJM_DEVICE(850),
-	SND_DJM_DEVICE(900nxs2)
+	[SND_DJM_250MK2_IDX] = SND_DJM_DEVICE(250mk2),
+	[SND_DJM_750_IDX] = SND_DJM_DEVICE(750),
+	[SND_DJM_850_IDX] = SND_DJM_DEVICE(850),
+	[SND_DJM_900NXS2_IDX] = SND_DJM_DEVICE(900nxs2),
+	[SND_DJM_750MK2_IDX] = SND_DJM_DEVICE(750mk2),
 };
 
 


