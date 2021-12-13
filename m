Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9335472489
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhLMJhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:37:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbhLMJfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:35:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D511AB80E0B;
        Mon, 13 Dec 2021 09:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D388C00446;
        Mon, 13 Dec 2021 09:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388144;
        bh=2lQQV2AdZeLhqUi8ROkX7ISwexafR6Z6QmPxhwRh4po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEQltIwt7JPGA1fVCrrHmvBD6EDRafgtmqG+tKzemzRnvQ6DK+qkDlAF+tXn1RZRi
         HrB0kUFeMBL+nrQEaJHzIOMeMN+EoSloNhcassq9pF3FWTwdbKqLcNTXKkbHGlmpJn
         RbVu2zcuMD5ISEBcdlwfH+55PRQOrKyKwadMv5kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 15/42] ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()
Date:   Mon, 13 Dec 2021 10:29:57 +0100
Message-Id: <20211213092927.076253534@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
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
@@ -910,8 +910,15 @@ static int snd_pcm_oss_change_params_loc
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
 


