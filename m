Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14134E75B8
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359517AbiCYPHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359518AbiCYPHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:07:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13B1D9EB6;
        Fri, 25 Mar 2022 08:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F9D5CE2A4D;
        Fri, 25 Mar 2022 15:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB23C340EE;
        Fri, 25 Mar 2022 15:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220716;
        bh=UqsmNB3MGUm9F2hcODQq0vKd0GEvegVF20uiRTemZ7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8ecOTqcB56hkDSydmMC8+W/n66rMm1uAcuyiZcKtLhx25/I3DjPAgFZ+EMcaVdAc
         Cmt8KDAZu0D5sMu5VU9TNtHD374Ic95kj6cXewjx4MCOAxPmePp+EntcZEnv5MKczJ
         T+x2KOcxXmX8RK/XJWRU4OWBkg3eowJ61KaBrAl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 05/14] ALSA: pcm: Add stream lock during PCM reset ioctl operations
Date:   Fri, 25 Mar 2022 16:04:33 +0100
Message-Id: <20220325150415.857136189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150415.694544076@linuxfoundation.org>
References: <20220325150415.694544076@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 1f68915b2efd0d6bfd6e124aa63c94b3c69f127c upstream.

snd_pcm_reset() is a non-atomic operation, and it's allowed to run
during the PCM stream running.  It implies that the manipulation of
hw_ptr and other parameters might be racy.

This patch adds the PCM stream lock at appropriate places in
snd_pcm_*_reset() actions for covering that.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322171325.4355-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1489,21 +1489,25 @@ static int snd_pcm_do_reset(struct snd_p
 	int err = substream->ops->ioctl(substream, SNDRV_PCM_IOCTL1_RESET, NULL);
 	if (err < 0)
 		return err;
+	snd_pcm_stream_lock_irq(substream);
 	runtime->hw_ptr_base = 0;
 	runtime->hw_ptr_interrupt = runtime->status->hw_ptr -
 		runtime->status->hw_ptr % runtime->period_size;
 	runtime->silence_start = runtime->status->hw_ptr;
 	runtime->silence_filled = 0;
+	snd_pcm_stream_unlock_irq(substream);
 	return 0;
 }
 
 static void snd_pcm_post_reset(struct snd_pcm_substream *substream, int state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	snd_pcm_stream_lock_irq(substream);
 	runtime->control->appl_ptr = runtime->status->hw_ptr;
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
 	    runtime->silence_size > 0)
 		snd_pcm_playback_silence(substream, ULONG_MAX);
+	snd_pcm_stream_unlock_irq(substream);
 }
 
 static const struct action_ops snd_pcm_action_reset = {


