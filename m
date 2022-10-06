Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B845F6D03
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiJFRbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiJFRbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 13:31:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D58A9243
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 10:31:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 78so2410323pgb.13
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=GRA4ycWRFkZm1ucfJHpaw2c0g8Q5GIhkFkT0UR1L5mI=;
        b=Ptq2un1p9KyWquo7813XSue6AcJqjqUcro1TjWRDhdS2lAlIklc5LCQECbjiBhkSMi
         QzyBPBNKdWpfaVOkHzC+gKFQdHi9YgpmBiqmXeVrAOwzB7j6anYJotyTY00BPyx+afvm
         60znYj5zPxW8MW4Z0pRslURCipa7Iq7vVHLGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=GRA4ycWRFkZm1ucfJHpaw2c0g8Q5GIhkFkT0UR1L5mI=;
        b=CQjW18T2dsbG75UI3crkcBZ4Q3C15L1LyW9cxZhCSOzYMmHWiVvzoq4GKO9KH5bNz9
         +tqyo18ABIzqHSD+XzwjM8nrh+TgF7HQ+4NnhBmUusFVuh78QVl8udeEBU97ERlEnZx1
         SQ0h88Vni4l9tAcDHWRDUXoKongE9MVK1h+Xj1KSMfWPh4HAlF1LYkaV5oCtY6Wlu+SN
         woaGp5ucaNdtIzccyDMTvobjOr9Dka4K5KCyeTjqzlQR0HWS4UjeEFf7UUpRmHzPBZYE
         aLCRgXv4iPKqkY1DHNywx4OVBTHOM1ACz3jClck9aVO5SRwRAbMGCfmQYFt3E+PFpgJa
         NI9A==
X-Gm-Message-State: ACrzQf3fjeLYVOMewEMgIqQEjCQsb2KuzbYSQD9Sz9jAuOWThLzQRKnA
        caJXdr347E+QUPz4CpzuzWelzGLFL8KDs3OY
X-Google-Smtp-Source: AMsMyM40lwewev/NWCr+3LQaFRHC33ymkCUzsFZyKqbMpN8AoGsxOdmrpDmjBJOWrla/Goal0ULpYQ==
X-Received: by 2002:a63:e113:0:b0:439:e032:c879 with SMTP id z19-20020a63e113000000b00439e032c879mr782383pgh.287.1665077495060;
        Thu, 06 Oct 2022 10:31:35 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:9d:2:8303:ab96:100f:af38])
        by smtp.googlemail.com with ESMTPSA id d4-20020a170902654400b001769206a766sm12574441pln.307.2022.10.06.10.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 10:31:34 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
X-Google-Original-From: Zubin Mithra <zsm@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, tiwai@suse.de, perex@perex.cz,
        butterflyhuangxx@gmail.com, groeck@chromium.org
Subject: [PATCH v5.10.y] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Date:   Thu,  6 Oct 2022 10:31:27 -0700
Message-Id: <20221006173127.2895108-1-zsm@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Zubin Mithra <zsm@google.com>
---
Note:
* 8423f0b6d513 is present in linux-5.15.y and linux-5.4.y; missing in
linux-5.10.y.
* Backport addresses conflict due to surrounding context.
* Tests run: build and boot.

 sound/core/oss/pcm_oss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index f88de74da1eb..de6f94bee50b 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1662,13 +1662,14 @@ static int snd_pcm_oss_sync(struct snd_pcm_oss_file *pcm_oss_file)
 		runtime = substream->runtime;
 		if (atomic_read(&substream->mmap_count))
 			goto __direct;
-		if ((err = snd_pcm_oss_make_ready(substream)) < 0)
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
-- 
2.38.0.rc1.362.ged0d419d3c-goog

