Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758E863D9D4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiK3PsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiK3Pr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:47:58 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B62275D6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r26so22509595edc.10
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fLIsVAH72GYN4wSnEbMTMIto1VdntwqvQJh4XKX1N8=;
        b=RLfl+m/7E/E0w+XzZDQvyhYuzJclHPZLb/xSf+gTZ1X7y2BNXGynHFx0l2nbPf2//u
         QVuR8KoO0bXq/0ozfPU06OZ1ONR6QEfqUq2KJ24AvftES2ghu4Sqfn2ST/mcihAn89Nw
         DoGH5G8fkqo6dsa7Pf7WSY5UXM7UtHAfjZSvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fLIsVAH72GYN4wSnEbMTMIto1VdntwqvQJh4XKX1N8=;
        b=GGCWtzHAbXLvJFeyv+g2I+sk0VyArrWkkUReAzeXqc1Vc6PlNZ7uE91EZMadMSnQzo
         Rd/hVsQlcP9xvbUhrThA3v4rlDGfvEc9PeWuy/7yAeyVHbcsOcsMkSidyb23yhVnaW0H
         tCxURc2Wgo0sBGXjqVRgsGNSVNmmc4QfrPP69TVf0OjVWWMPVQif6jQK7iYv9KEvNVS4
         85tpOVX/fbWUnExxlG2CiXnPQImNYMDO285oDxxvCVbsFIRFnQvUlCi16iixB+CWVJkX
         q/Gfox/PC1ZPN/ccb5bQe9GazSfa+9bhUDM7hfXXENj6jM/36lxdURm0P43N1OsBg78x
         OLPQ==
X-Gm-Message-State: ANoB5pmXFP+fTWoG+YsqrO8WHgc+plI1eRQBGhb1uzO5ZmCAhocTaGgt
        I1cfiGBwqpbZatSd+TA2aaJAwg==
X-Google-Smtp-Source: AA0mqf4IYiD9H16IuGz/np51rmxmX2exbBKAoU9sx6CGbOo8xnMm+kZ7DVDgJ9emxgRoPNGt2ivddw==
X-Received: by 2002:a05:6402:1f85:b0:462:2410:9720 with SMTP id c5-20020a0564021f8500b0046224109720mr12193484edc.84.1669823266173;
        Wed, 30 Nov 2022 07:47:46 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:5b33:e3f2:6a0b:dcdd])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b007bf24b8f80csm775075ejg.63.2022.11.30.07.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:47:45 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 16:47:16 +0100
Subject: [PATCH v6 2/2] ASoC: SOF: Fix deadlock when shutdown a frozen userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v6-2-3e90553f64a5@chromium.org>
References: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
In-Reply-To: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
To:     Chromeos Kdump <chromeos-kdump@google.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        kexec@lists.infradead.org, sound-open-firmware@alsa-project.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=2174; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=z1BRJ78WvLmPHnisXXoQjw9rs0LQQZ8YHVqPdLBDGn8=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjh3scbdrJzfpRqMNqZtaSFQjjhLnKBxlJMQeOOkOM
 m5234GiJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4d7HAAKCRDRN9E+zzrEiN/ID/
 9+jG5ZH/OSbpevz4Xx7ZmZUrjhaPMR5rVP35OfUsqfj/ADrCAhJC2vlwQpcs2lie7FAUKfb1BM4VWQ
 7EozfqEAJPYlbN6HiKf8Xidp9z8sW4/g/0gSEQ60cMBSEnM8UlVrqt2eFXi4ARZeoUzjr58IEXMjVu
 Rr37vapYJMliIJKpJ8oI3Bn8vwDFjC1hLjhEb5ZgTCIESl+/ZZb+jfCIlS2qytNrH4zjpoX5Hk8QZR
 GiiHXMQVXR/ynfZbB8tJI7mn024lZ/0OWniech+uJArvwaJxOM5zt5kxzweiQ9QH/L6IwPwzhfSYJV
 i2rmkKdEI1PYKK1MbUH0ep2XRYWO/B8w8MHBLK6JsqA8fSwJ+5YRMAnN96rHs7hUD6+J8P7rPrkkO0
 cIpHzcnsBkm8JJTTLEkkQI8gzeNzRjjW8yNlqoFnQnR7wi+wgcKAGzESkwWWysMGq7kvLU7+Q6Bwn6
 T9c+1s/pVqGANlQ4BuVOKgO1pgLNzRqfef1yz7c53cJ+VBHCGYGOZDIc29r/tH+Cep1mpSbhJSA2vj
 IGcfgZhuOGIhR9dctOZ/M8+g2BC5LwhhncH5hK6xPdecknFPpzElV3oXw8U8w9FLa/Bhgje6cPjGmS
 Phput94//O2tfEsQ92F9dOxUP5sj5cBNz6LJljSdByoRowt/YVTcfvnHkNkw==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During kexec(), the userspace is frozen. Therefore we cannot wait for it
to complete.

Avoid running snd_sof_machine_unregister during shutdown.

This fixes:

[   84.943749] Freezing user space processes ... (elapsed 0.111 seconds) done.
[  246.784446] INFO: task kexec-lite:5123 blocked for more than 122 seconds.
[  246.819035] Call Trace:
[  246.821782]  <TASK>
[  246.824186]  __schedule+0x5f9/0x1263
[  246.828231]  schedule+0x87/0xc5
[  246.831779]  snd_card_disconnect_sync+0xb5/0x127
...
[  246.889249]  snd_sof_device_shutdown+0xb4/0x150
[  246.899317]  pci_device_shutdown+0x37/0x61
[  246.903990]  device_shutdown+0x14c/0x1d6
[  246.908391]  kernel_kexec+0x45/0xb9

And:

[  246.893222] INFO: task kexec-lite:4891 blocked for more than 122 seconds.
[  246.927709] Call Trace:
[  246.930461]  <TASK>
[  246.932819]  __schedule+0x5f9/0x1263
[  246.936855]  ? fsnotify_grab_connector+0x5c/0x70
[  246.942045]  schedule+0x87/0xc5
[  246.945567]  schedule_timeout+0x49/0xf3
[  246.949877]  wait_for_completion+0x86/0xe8
[  246.954463]  snd_card_free+0x68/0x89
...
[  247.001080]  platform_device_unregister+0x12/0x35

Cc: stable@vger.kernel.org
Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 sound/soc/sof/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 3e6141d03770..4301f347bb90 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -9,6 +9,7 @@
 //
 
 #include <linux/firmware.h>
+#include <linux/kexec.h>
 #include <linux/module.h>
 #include <sound/soc.h>
 #include <sound/sof.h>
@@ -484,7 +485,8 @@ int snd_sof_device_shutdown(struct device *dev)
 	 * make sure clients and machine driver(s) are unregistered to force
 	 * all userspace devices to be closed prior to the DSP shutdown sequence
 	 */
-	sof_unregister_clients(sdev);
+	if (!kexec_with_frozen_processes())
+		sof_unregister_clients(sdev);
 
 	snd_sof_machine_unregister(sdev, pdata);
 

-- 
2.38.1.584.g0f3c55d4c2-goog-b4-0.11.0-dev-696ae
