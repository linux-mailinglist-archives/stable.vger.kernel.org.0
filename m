Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB163A9D1
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 14:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiK1NnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 08:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiK1NnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 08:43:00 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E71FCC9
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 05:42:55 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ml11so984694ejb.6
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 05:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8xdIjoOikGdAZKov94FlnwSjqEqsO1SC5byhX9Q9RLU=;
        b=jEvKo4Xz7BCEk5NFMOWgRBT/TrETg2qR5X6hoc/aB/wXvdRIsbpe2NAzulkGQxZrHu
         RLxjxQBfTIAxEHmK/FBOhhMItJbRKUaqD2gCLiH4qrTnyxOUpRQAAadH/5fX/rfkFySY
         ZCD3BJnuyzNHoFJOjRR5/RFZmhAM7rd9nHyvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8xdIjoOikGdAZKov94FlnwSjqEqsO1SC5byhX9Q9RLU=;
        b=IAf5CcVRWLQmlHTaZts63n1uEDqKNBTf0kAjExNNN5uOtdsG2ziOAQ2Sp5J7LlY82I
         9VX1Yn519cb2o4TalTRXKpRagV6gRhF9fs1UT0o5sWu+09AqpUY/hzfgHPQdG9Zm9FGl
         shdKI2NeY+SV3HUZDHFdeDJT3eZQLPzILM5MzT+Kak4hDyDO/mgdP0SEf6kdn9VJYxQ2
         cglbq0QX8CiAvgF4ZwIKup3qirPJIjPhc1XWEKrK4LZFezLAyaXkirI5iI1Ct6oHuR8r
         XkCaPf0TKB4izZN9sOz4bAjo5T3g+r0lJNPPA10nGTtL1SX0+jYF9KNOuaGJ00V2yFqn
         E/OA==
X-Gm-Message-State: ANoB5plAdy1Jbk92FXG6SEd2hDijNJ2leL2ra025tvbtpjqrZo/xzwOT
        A9uTM/OcIHJF04tM8O6jptrSPA==
X-Google-Smtp-Source: AA0mqf6G9vDib77cW89TEqFeVynYGAWhQXTzNKEAXZ/8an8V7OwVpUyq4BDFXkDyZblg+YlHgxqGCA==
X-Received: by 2002:a17:906:692:b0:7ad:49b8:1687 with SMTP id u18-20020a170906069200b007ad49b81687mr33385064ejb.407.1669642973563;
        Mon, 28 Nov 2022 05:42:53 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id vt4-20020a170907a60400b0073d7b876621sm4959667ejc.205.2022.11.28.05.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 05:42:53 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 28 Nov 2022 14:42:49 +0100
Subject: [PATCH v4] ALSA: core: Fix deadlock when shutdown a frozen userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org>
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        stable@vger.kernel.org, sound-open-firmware@alsa-project.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=3529; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=CuZgvNcaSIcLqEhNVxL+uczDhS4EM71Cxydwohy6ArE=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjhLraAkpShzLacNLIjWc+7CfukKCbU2FcaQSEkkOd
 E8G3s4KJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4S62gAKCRDRN9E+zzrEiGH7EA
 CNcjEMcS8oZDbadEJ0IDQyhibQPQceQUEVYKPeBv62cDgSKswxDoYu7I21X8O3OW/ETvQDNB35/q+/
 zePdiuhYJAeq1gaZ0ZIQp1gnjL9UXoYe06jde9gfB2aSfGhIhftVfaonKSf8Htyc/QMGq5D9oOZp4Q
 dYHsRJz4U/vgGfQH+jw6e9OTfOrMPK3eYsBGj5KoLFHloSVasKuWkhbUew0gkoUwQ/alk1/D2wnc3x
 +L7Hb+PaA81/r27oPmxZsAyS5j/b0a+MOZQHklYy057opBh2yFiBzxtHHVAaMkfWSDNkP1TlQb0G+k
 yGL+d1q6+Tr20HenI6fYnRlZqLSsemE71t/IDYLqaqBzw3rb5HSgOE4Rvoflp0rvehq7SbPg5a4nBV
 0xqBwSM0EhLUmkO8uelk8FP36MCIEqMgb1f2WZk1tnKow0opnWYhYxVEI+S+glbxB0M6PnIThE8v+t
 srJTQmnIL6SyHOYuPyixoYX74/acbjKa/aNBVtpVhI/9vImy2CcNVSJvs+iUfBcueS/D9bQd77BUb8
 rp84vTCAMUWPQRwbZPWXYf7XbUjWrBerTZKGq3rD6omJ6zuReFxmAHWhCtr0kk4SFFGCauSoGeN63s
 eaC7xewSghyIwwa1bFPaIqN0Hsd9ukkUo1nUInfZPdx3d5lQxv6NGnPBjCRg==
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
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To: Bard Liao <yung-chuan.liao@linux.intel.com>
To: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To: Kai Vehmanen <kai.vehmanen@linux.intel.com>
To: Daniel Baluta <daniel.baluta@nxp.com>
To: Mark Brown <broonie@kernel.org>
To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
Cc: sound-open-firmware@alsa-project.org
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
---
Changes in v4:
- Do not call snd_sof_machine_unregister from shutdown.
- Link to v3: https://lore.kernel.org/r/20221127-snd-freeze-v3-0-a2eda731ca14@chromium.org

Changes in v3:
- Wrap pm_freezing in a function
- Link to v2: https://lore.kernel.org/r/20221127-snd-freeze-v2-0-d8a425ea9663@chromium.org

Changes in v2:
- Only use pm_freezing if CONFIG_FREEZER 
- Link to v1: https://lore.kernel.org/r/20221127-snd-freeze-v1-0-57461a366ec2@chromium.org
---
 sound/soc/sof/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 3e6141d03770..9616ba607ded 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -475,19 +475,16 @@ EXPORT_SYMBOL(snd_sof_device_remove);
 int snd_sof_device_shutdown(struct device *dev)
 {
 	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
-	struct snd_sof_pdata *pdata = sdev->pdata;
 
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
 	/*
-	 * make sure clients and machine driver(s) are unregistered to force
-	 * all userspace devices to be closed prior to the DSP shutdown sequence
+	 * make sure clients are unregistered prior to the DSP shutdown
+	 * sequence.
 	 */
 	sof_unregister_clients(sdev);
 
-	snd_sof_machine_unregister(sdev, pdata);
-
 	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
 		return snd_sof_shutdown(sdev);
 

---
base-commit: 4312098baf37ee17a8350725e6e0d0e8590252d4
change-id: 20221127-snd-freeze-1ee143228326

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
