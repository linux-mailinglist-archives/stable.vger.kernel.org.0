Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7940163AA0F
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 14:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiK1Nvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 08:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiK1Nv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 08:51:29 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D061EEE3
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 05:51:27 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id e27so25891604ejc.12
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 05:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u0aFE9hwoiDA9DAFcyLG3BFl8PO/QcXwrWjXOf4VrKU=;
        b=cqcFidLCG7P1nRRXUrY6Wczsjq+vlOMWQBWRKAGQAJag9JhXDGCStVKjB3evQ1osTP
         5o/VWgcvkSpum0KuPN8l5n8g77R1N4Wg9LlC6r60Dlu5M/nIWhmu1So0Icm1+qXsvBmv
         lro6OCQdo1XMwWXbdPOeDa0WzWQTT/QFTFBT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u0aFE9hwoiDA9DAFcyLG3BFl8PO/QcXwrWjXOf4VrKU=;
        b=7ixDzjmgid0rFcPCyJzjEY8I5tKgmREbDFJR0fVsKZUTr+fpJC0H6i/3AmR2iGksg9
         7uZ00RElLC7EiIiV720mGaugHmofisdqeSQzJ1G9XAL7z9WSfhuK24+0JzsM5WM3Ndjk
         BKKkFku1vVJMb/HGKkZy0zR8U1N0q7LVkOO6fbVwHlE7eXPqZbTscphji17+XP35toXM
         JWs+cFjWjBD2iGOLIzdITHx8lz9y87dx1rSyx74xwKqbuolVt96WnOx3G78fOtUU8Yaw
         If+ygiy9Mn+BqMMaA+u9cc/D7EGpOdRQdsXK6no4iO7NpkGR4wYRhOCANtpx6N88gOJz
         9W1w==
X-Gm-Message-State: ANoB5pliX20RS13yQwzy/1L5wazmkONBxHcPCMcWuD3PlRG9Pl1gvBLn
        mcuInf4cjo3z8Bjr4FuDJemM6KNxILg8KFoP
X-Google-Smtp-Source: AA0mqf7Rmen/HaHAQVDi1zQLlrY4aMrBvWcHVRGZepkeZXRyYpvN5BIoFVuZLsusAELdX8Y6vakWTg==
X-Received: by 2002:a17:906:9e20:b0:7af:206:9327 with SMTP id fp32-20020a1709069e2000b007af02069327mr43793648ejc.154.1669643485755;
        Mon, 28 Nov 2022 05:51:25 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id p10-20020aa7cc8a000000b0045b4b67156fsm5184139edt.45.2022.11.28.05.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 05:51:25 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 28 Nov 2022 14:51:17 +0100
Subject: [PATCH v5] ASoC: SOF: Fix deadlock when shutdown a frozen userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v5-0-4ededeb08ba0@chromium.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     stable@vger.kernel.org, sound-open-firmware@alsa-project.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=3662; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=cBG13C+fPS/DJeUsnf0v/AEnFrjuy57sBmvYSvNH+dk=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjhLza87LzpLuJ3ZQRnkqEP+vHTB3FYi2nW0tShU23
 chrKhb+JAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4S82gAKCRDRN9E+zzrEiPqyD/
 0UDRVIY44q4CF1+moNWAABqGFppwuGECc97NFAtgwaKhT8UaRwgDuN6puIQPR75vU0IHk4tf66+aG7
 yeN5RZS4XLUchnB0HBDGEatHGpPKaJjR5ZLtMDHYws9kIT30lz2nvvpPey96hYptEiT+/M2ym3s1NZ
 fIg+rOEI/5mdUY0FOI4IKTfxXuaclcgyi/qJujr/Ev6mAXZk0IEeBmlh/8cyMviVy030gihr2St+j+
 Q3QlZpTu+pgNtlCLMUHiiO5kO5DquovKi34iL9VRzzLyyhX9xK0O0t7oq0zmKLyKbsD2S8cOD13UBC
 BSC6Siw2vn1KsyHazGdNYJm3dzMtYvCVVFw+QyJNzZss+e4fS6+WEZqgVjq83Ce/Qq8FyPtmG4odSP
 cNS/T3yiF+jEtYxSk2uZ70LxHU+6/7fGezKQRO3t1fW2baKXzPWmSYBK4VsTuWbBFgWUyz2wtSaPkW
 9cO4RUuuUcwL3b4UnIhZHFMrT/eoCBhh82MKVqEkd+0yw3LysZy2QCkYMKaAgAGh2RFfS3mmURDn8A
 w4+3mRPv2CATgQtd+lwrXjjsWttGZUGAz029xaJwGEtShXy5eVlizKVfrAFMT7+sqY+g3/XFJv1/QT
 2ITQGtymEzbnlWS7JzlF9YW9YW62UKJuKlhmGRJw4yAfzqxhGMxwg7hzQ6Og==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Changes in v5:
- Edit subject prefix
- Link to v4: https://lore.kernel.org/r/20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org

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
