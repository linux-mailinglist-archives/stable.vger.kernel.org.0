Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4835B717A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiIMOkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiIMOjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:39:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56FE6D55B;
        Tue, 13 Sep 2022 07:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D0C5B80EFD;
        Tue, 13 Sep 2022 14:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A3C433D7;
        Tue, 13 Sep 2022 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078827;
        bh=RzE8TxGjDi2S04MdtkRS+uoCo8hNUqW9GhKvr1kBV10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf5fTv2SSC7uboIUvUEu3AK4+O587dvlO2nyeyk05xuuBYNxw070OnIgxK0evn+Zr
         jXGm/qMVudBwjtHmzQqEK6zRPo/2ygVGvjmu0uML7GrUef34YsfHk7lDC5WPWyoKsy
         DqYEQOpX2zttxiQ371dobFSLr4DTWtk6N8HVtRF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/121] ALSA: usb-audio: Inform the delayed registration more properly
Date:   Tue, 13 Sep 2022 16:04:22 +0200
Message-Id: <20220913140400.417409378@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7e1afce5866e02b45bf88c27dd7de1b9dfade1cc ]

The info message that was added in the commit a4aad5636c72 ("ALSA:
usb-audio: Inform devices that need delayed registration") is actually
useful to know the need for the delayed registration.  However, it
turned out that this doesn't catch the all cases; namely, this warned
only when a PCM stream is attached onto the existing PCM instance, but
it doesn't count for a newly created PCM instance.  This made
confusion as if there were no further delayed registration.

This patch moves the check to the code path for either adding a stream
or creating a PCM instance.  Also, make it simpler by checking the
card->registered flag instead of querying each snd_device state.

Fixes: a4aad5636c72 ("ALSA: usb-audio: Inform devices that need delayed registration")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216082
Link: https://lore.kernel.org/r/20220831125901.4660-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 40ce8a1cb318a..f10f4e6d3fb85 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -495,6 +495,10 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 			return 0;
 		}
 	}
+
+	if (chip->card->registered)
+		chip->need_delayed_register = true;
+
 	/* look for an empty stream */
 	list_for_each_entry(as, &chip->pcm_list, list) {
 		if (as->fmt_type != fp->fmt_type)
@@ -502,9 +506,6 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 		subs = &as->substream[stream];
 		if (subs->ep_num)
 			continue;
-		if (snd_device_get_state(chip->card, as->pcm) !=
-		    SNDRV_DEV_BUILD)
-			chip->need_delayed_register = true;
 		err = snd_pcm_new_stream(as->pcm, stream, 1);
 		if (err < 0)
 			return err;
-- 
2.35.1



