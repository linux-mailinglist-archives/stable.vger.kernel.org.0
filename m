Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C015E5B72E7
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiIMPBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiIMO7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:59:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0049437F9D;
        Tue, 13 Sep 2022 07:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 895E9B80EFA;
        Tue, 13 Sep 2022 14:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CEBC43140;
        Tue, 13 Sep 2022 14:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079295;
        bh=Wuk+drh6qbtD/vL+GLzc8Y3Itg7gjLro5Tx5Nu2jaAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuBgvl4+rv5zhXLoJBxapF2925WtrTeQ06OmLf9aat68bhAFJ8HXfIJIbo1wzQ9/a
         5hVpv7wE+Xg9l3L8jCqVDphbfanAaDwxsUb/6Ud47G3mm8BjOhhSJ2PpylwaBl6geL
         gxbemeXYJcK1iDCbGZ+BzXxe3Otqv2C/84kID6zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pattara Teerapong <pteerapong@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 078/108] ALSA: aloop: Fix random zeros in capture data when using jiffies timer
Date:   Tue, 13 Sep 2022 16:06:49 +0200
Message-Id: <20220913140356.985352235@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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

From: Pattara Teerapong <pteerapong@chromium.org>

commit 3e48940abee88b8dbbeeaf8a07e7b2b6be1271b3 upstream.

In loopback_jiffies_timer_pos_update(), we are getting jiffies twice.
First time for playback, second time for capture. Jiffies can be updated
between these two calls and if the capture jiffies is larger, extra zeros
will be filled in the capture buffer.

Change to get jiffies once and use it for both playback and capture.

Signed-off-by: Pattara Teerapong <pteerapong@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220901144036.4049060-1-pteerapong@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/aloop.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -463,17 +463,18 @@ static unsigned int loopback_pos_update(
 			cable->streams[SNDRV_PCM_STREAM_PLAYBACK];
 	struct loopback_pcm *dpcm_capt =
 			cable->streams[SNDRV_PCM_STREAM_CAPTURE];
-	unsigned long delta_play = 0, delta_capt = 0;
+	unsigned long delta_play = 0, delta_capt = 0, cur_jiffies;
 	unsigned int running, count1, count2;
 
+	cur_jiffies = jiffies;
 	running = cable->running ^ cable->pause;
 	if (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) {
-		delta_play = jiffies - dpcm_play->last_jiffies;
+		delta_play = cur_jiffies - dpcm_play->last_jiffies;
 		dpcm_play->last_jiffies += delta_play;
 	}
 
 	if (running & (1 << SNDRV_PCM_STREAM_CAPTURE)) {
-		delta_capt = jiffies - dpcm_capt->last_jiffies;
+		delta_capt = cur_jiffies - dpcm_capt->last_jiffies;
 		dpcm_capt->last_jiffies += delta_capt;
 	}
 


