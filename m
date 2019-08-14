Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600488DA02
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfHNRO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbfHNRO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D6520665;
        Wed, 14 Aug 2019 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802866;
        bh=GxpXIsPHFbuaZBKjNQf/MJm4SWd/jFG6S2Ae0i4PNOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHUtV3kANXjAYXPeUKQOc8W/kpSKZPxthfPujhuT+izBJ0KOEp66I0AixCsVPeRGi
         jqEJ6uiXKbuYgroabK+T0auO1BLT/4cGb36nLZUhA7x7DkrlPs/ZdOvUsorG0tgWpA
         vsvssTzcAWDHqhUunqy0U/Z6F+xLUFF2buWnGvSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 57/69] ALSA: hda - Dont override global PCM hw info flag
Date:   Wed, 14 Aug 2019 19:01:55 +0200
Message-Id: <20190814165749.343060041@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c1c6c877b0c79fd7e05c931435aa42211eaeebaf upstream.

The commit bfcba288b97f ("ALSA - hda: Add support for link audio time
reporting") introduced the conditional PCM hw info setup, but it
overwrites the global azx_pcm_hw object.  This will cause a problem if
any other HD-audio controller, as it'll inherit the same bit flag
although another controller doesn't support that feature.

Fix the bug by setting the PCM hw info flag locally.

Fixes: bfcba288b97f ("ALSA - hda: Add support for link audio time reporting")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_controller.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -609,11 +609,9 @@ static int azx_pcm_open(struct snd_pcm_s
 	}
 	runtime->private_data = azx_dev;
 
-	if (chip->gts_present)
-		azx_pcm_hw.info = azx_pcm_hw.info |
-			SNDRV_PCM_INFO_HAS_LINK_SYNCHRONIZED_ATIME;
-
 	runtime->hw = azx_pcm_hw;
+	if (chip->gts_present)
+		runtime->hw.info |= SNDRV_PCM_INFO_HAS_LINK_SYNCHRONIZED_ATIME;
 	runtime->hw.channels_min = hinfo->channels_min;
 	runtime->hw.channels_max = hinfo->channels_max;
 	runtime->hw.formats = hinfo->formats;


