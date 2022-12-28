Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82D56579D3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiL1PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiL1PFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FF913D60
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839F861540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B11C433EF;
        Wed, 28 Dec 2022 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239906;
        bh=A81OPmsbg3MY1IXMU7guZBwmSFZMZT9M/mVvPlZmTrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4XOI3TA4BG8y+5XkzTDLvYbPr7lWI1O4RpAaLvWTR/VG/U4/AEpONJJUa3j4x/Dk
         6WeCsUoZ4WpfDw1HfQe3VOe3EXcoGkKqJeo7fE3adJgM6Qrk3aTp3eTKpvNlE4f0BA
         vxT+OxtNhPaTYwR/3UuKQQ1bUwGou9fWrCZe3X6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/731] ALSA: pcm: Set missing stop_operating flag at undoing trigger start
Date:   Wed, 28 Dec 2022 15:36:31 +0100
Message-Id: <20221228144304.804347993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5c8cc93b06d1ff860327a273abf3ac006290d242 ]

When a PCM trigger-start fails at snd_pcm_do_start(), PCM core tries
to undo the action at snd_pcm_undo_start() by issuing the trigger STOP
manually.  At that point, we forgot to set the stop_operating flag,
hence the sync-stop won't be issued at the next prepare or other
calls.

This patch adds the missing stop_operating flag at
snd_pcm_undo_start().

Fixes: 1e850beea278 ("ALSA: pcm: Add the support for sync-stop operation")
Link: https://lore.kernel.org/r/b4e71631-4a94-613-27b2-fb595792630@carlh.net
Link: https://lore.kernel.org/r/20221205132124.11585-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index f38c2e5e9a29..44e06ef4ff0b 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1419,8 +1419,10 @@ static int snd_pcm_do_start(struct snd_pcm_substream *substream,
 static void snd_pcm_undo_start(struct snd_pcm_substream *substream,
 			       snd_pcm_state_t state)
 {
-	if (substream->runtime->trigger_master == substream)
+	if (substream->runtime->trigger_master == substream) {
 		substream->ops->trigger(substream, SNDRV_PCM_TRIGGER_STOP);
+		substream->runtime->stop_operating = true;
+	}
 }
 
 static void snd_pcm_post_start(struct snd_pcm_substream *substream,
-- 
2.35.1



