Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37AE47287A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhLMKNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:13:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39792 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbhLMJuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:50:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10F12CE0E83;
        Mon, 13 Dec 2021 09:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6069C00446;
        Mon, 13 Dec 2021 09:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389001;
        bh=uAiqZR3IvrFrXzJGBI0LYMHFB0Cq9UInD/O8AAugYSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPcNCryKnhThZNiOAQEVSKZ6xGkFwvEby2FiHvUe6Gx3U9mJ00vtknnKKsgnX41sp
         lpRpzNF7pZMWp7I4jhYbeYedVpNUSNCgzKYylPgml8bmxjkwEgMsdiuTDjLKD0x/Nb
         wValuB5jSi76mGqWBj9Ob1tdv3o5+pihayEnNirs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 050/132] ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()
Date:   Mon, 13 Dec 2021 10:29:51 +0100
Message-Id: <20211213092940.835515687@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6665bb30a6b1a4a853d52557c05482ee50e71391 upstream.

A couple of calls in snd_pcm_oss_change_params_locked() ignore the
possible errors.  Catch those errors and abort the operation for
avoiding further problems.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211201073606.11660-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -884,8 +884,15 @@ static int snd_pcm_oss_change_params_loc
 		err = -EINVAL;
 		goto failure;
 	}
-	choose_rate(substream, sparams, runtime->oss.rate);
-	snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_CHANNELS, runtime->oss.channels, NULL);
+
+	err = choose_rate(substream, sparams, runtime->oss.rate);
+	if (err < 0)
+		goto failure;
+	err = snd_pcm_hw_param_near(substream, sparams,
+				    SNDRV_PCM_HW_PARAM_CHANNELS,
+				    runtime->oss.channels, NULL);
+	if (err < 0)
+		goto failure;
 
 	format = snd_pcm_oss_format_from(runtime->oss.format);
 


