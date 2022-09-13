Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B505B6F93
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiIMOL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiIMOKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A18E5D0F3;
        Tue, 13 Sep 2022 07:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0663DB80EF7;
        Tue, 13 Sep 2022 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F18C433C1;
        Tue, 13 Sep 2022 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078161;
        bh=R1o2qTd0IZwQ5v/5GWJHyyVKOL2uPBxZwvCG8Kb23nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8b0oPgKLiTAE0vGG/bqEuyeDPi4+vjAOzHD6BNHaeF4xBz84xWJj5YHJAVjRggTF
         Ny/ejzWISlwuakchv7RYb5aLdd84HDmvBi743i+O1Q8ZdmDPIhowFauPBuDvbkzK6t
         8D+fCs82JrJOzVTHAgECRO1uxyFS1u3vvpmEgWy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 5.19 035/192] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Date:   Tue, 13 Sep 2022 16:02:21 +0200
Message-Id: <20220913140411.664801553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

commit 8423f0b6d513b259fdab9c9bf4aaa6188d054c2d upstream.

There is a small race window at snd_pcm_oss_sync() that is called from
OSS PCM SNDCTL_DSP_SYNC ioctl; namely the function calls
snd_pcm_oss_make_ready() at first, then takes the params_lock mutex
for the rest.  When the stream is set up again by another thread
between them, it leads to inconsistency, and may result in unexpected
results such as NULL dereference of OSS buffer as a fuzzer spotted
recently.

The fix is simply to cover snd_pcm_oss_make_ready() call into the same
params_lock mutex with snd_pcm_oss_make_ready_locked() variant.

Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAFcO6XN7JDM4xSXGhtusQfS2mSBcx50VJKwQpCq=WeLt57aaZA@mail.gmail.com
Link: https://lore.kernel.org/r/20220905060714.22549-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1672,14 +1672,14 @@ static int snd_pcm_oss_sync(struct snd_p
 		runtime = substream->runtime;
 		if (atomic_read(&substream->mmap_count))
 			goto __direct;
-		err = snd_pcm_oss_make_ready(substream);
-		if (err < 0)
-			return err;
 		atomic_inc(&runtime->oss.rw_ref);
 		if (mutex_lock_interruptible(&runtime->oss.params_lock)) {
 			atomic_dec(&runtime->oss.rw_ref);
 			return -ERESTARTSYS;
 		}
+		err = snd_pcm_oss_make_ready_locked(substream);
+		if (err < 0)
+			goto unlock;
 		format = snd_pcm_oss_format_from(runtime->oss.format);
 		width = snd_pcm_format_physical_width(format);
 		if (runtime->oss.buffer_used > 0) {


