Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BEB5B7071
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiIMO3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiIMO2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B17A67CB1;
        Tue, 13 Sep 2022 07:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0318614A8;
        Tue, 13 Sep 2022 14:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2BEC433D6;
        Tue, 13 Sep 2022 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078644;
        bh=qRQW+muWBPSl7sHCwotcWqrZn+BiLWa7TJMN3kN75d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIpt7JkDcq2M+lrnxzcNvSaGLguuE7Ubfm+prw9tOaAhcRnM097FbnokC5PDTV8Hd
         BwOp84cPcjuWEX64JD686USL7+kCai6KZq8TxrsxFplQveBhZDZ5vTqckP/atjgjbK
         MwGBPUdXKZDMh9x5VIWs8F2wfLfaj/Ald+X1rKXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 5.15 027/121] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Date:   Tue, 13 Sep 2022 16:03:38 +0200
Message-Id: <20220913140358.515208714@linuxfoundation.org>
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
@@ -1664,14 +1664,14 @@ static int snd_pcm_oss_sync(struct snd_p
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


