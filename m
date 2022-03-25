Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F410B4E777B
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377079AbiCYP2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377625AbiCYPYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7252DD96F;
        Fri, 25 Mar 2022 08:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6422EB827DC;
        Fri, 25 Mar 2022 15:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA52C340E9;
        Fri, 25 Mar 2022 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221501;
        bh=5rCFA85s5S+qiRWrhD5HCF9nWwgiP1x6tSx3WyKd6t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lehHPUHPcM2HmzqfuaBuAqp0rjeyuAchPpG3rbdnQZRo3Y4jXTymeLF6wJ2skA1Qr
         JBWqV2y0zSzQikKr5JhbANkkl18yzLIegx7pm4P6V49oAcTi53qvvBjvwOgX3pJyjT
         HLVx3D21dLs3ZpeuWmcX5/JPPDj4xHgW+EpgxlLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 16/37] ALSA: pcm: Fix races among concurrent prealloc proc writes
Date:   Fri, 25 Mar 2022 16:14:26 +0100
Message-Id: <20220325150420.511592283@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
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

commit 69534c48ba8ce552ce383b3dfdb271ffe51820c3 upstream.

We have no protection against concurrent PCM buffer preallocation
changes via proc files, and it may potentially lead to UAF or some
weird problem.  This patch applies the PCM open_mutex to the proc
write operation for avoiding the racy proc writes and the PCM stream
open (and further operations).

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -163,19 +163,20 @@ static void snd_pcm_lib_preallocate_proc
 	size_t size;
 	struct snd_dma_buffer new_dmab;
 
+	mutex_lock(&substream->pcm->open_mutex);
 	if (substream->runtime) {
 		buffer->error = -EBUSY;
-		return;
+		goto unlock;
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
 		size = simple_strtoul(str, NULL, 10) * 1024;
 		if ((size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
-			return;
+			goto unlock;
 		}
 		if (substream->dma_buffer.bytes == size)
-			return;
+			goto unlock;
 		memset(&new_dmab, 0, sizeof(new_dmab));
 		new_dmab.dev = substream->dma_buffer.dev;
 		if (size > 0) {
@@ -189,7 +190,7 @@ static void snd_pcm_lib_preallocate_proc
 					 substream->pcm->card->number, substream->pcm->device,
 					 substream->stream ? 'c' : 'p', substream->number,
 					 substream->pcm->name, size);
-				return;
+				goto unlock;
 			}
 			substream->buffer_bytes_max = size;
 		} else {
@@ -201,6 +202,8 @@ static void snd_pcm_lib_preallocate_proc
 	} else {
 		buffer->error = -EINVAL;
 	}
+ unlock:
+	mutex_unlock(&substream->pcm->open_mutex);
 }
 
 static inline void preallocate_info_init(struct snd_pcm_substream *substream)


