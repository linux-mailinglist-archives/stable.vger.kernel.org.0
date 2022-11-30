Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F376063DA9E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiK3Q3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiK3Q3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:29:47 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00D984DF3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:29:45 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v8so24828336edi.3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ETFY98Djerultq4KLtR6AVoerFeGGcqSarOrF7urjY=;
        b=mOuVUHz6VN9M0sllJmsb8AWyBmul/XEfCrj9eIQSCZjFUDF2baPxWJOeDVOMZSnvsC
         oM6RwONvZ3w12cZNmJ2WZFy0tsZnMQ+WSa7DS7CobK466Rr9nc5/LzgOdRYMc+GKKsFD
         WvEoE1qPjS5SexDn61VP+p0uIRiEE8bDv8VtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ETFY98Djerultq4KLtR6AVoerFeGGcqSarOrF7urjY=;
        b=0Mk63AbBZa30IlyPmfFl+BnjFCxnoEMJbK7CIn6I3n4MMeEkEPVClOOfAesvwr9REx
         8bsNJiArbT727cO6j+7hMgiT54f65Gu3mteU3XkEwyUmmWHiQIcdgWYuhLpvKrWuXpeO
         V526VvZaSrGwHl4wGZhQc2md7T03wDVg9ecJXnlZFC2v2BdfU8tx4jLZHEz1GHM9u1vR
         jHJczgRrjukAjqxhhRuuNMC0YuZ0RC+9aGkaQIpAQcs1x+Wlip8dTgMSU7m6pYMavKns
         nmTxkUBuXzbJZYWyDElsuz6l236vTJXoblrZpVXsjyaF43iY+UwFU2gt725AzYsGMTgt
         JfMg==
X-Gm-Message-State: ANoB5pnGqKa335hlnRvOsoDM+xBGFRk6yZceVgZ3YtIDJijoh3gd2YWw
        uzEWbtqo57DUv7KU7+04uUfxPw==
X-Google-Smtp-Source: AA0mqf4PjxFiboFRsFVuSbBdqbmaMnkL1+svg0ftRlMBulSysWMsHV2ZIZrCJx8REYR+ImWj8qndAA==
X-Received: by 2002:a05:6402:3226:b0:461:37c2:e85c with SMTP id g38-20020a056402322600b0046137c2e85cmr46479326eda.74.1669825784487;
        Wed, 30 Nov 2022 08:29:44 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id cz15-20020a0564021caf00b004589da5e5cesm786114edb.41.2022.11.30.08.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 08:29:44 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 17:29:21 +0100
Subject: [PATCH v7 2/2] ASoC: SOF: Fix deadlock when shutdown a frozen userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v7-2-127c582f1ca4@chromium.org>
References: <20221127-snd-freeze-v7-0-127c582f1ca4@chromium.org>
In-Reply-To: <20221127-snd-freeze-v7-0-127c582f1ca4@chromium.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Mark Brown <broonie@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.com>
Cc:     alsa-devel@alsa-project.org, sound-open-firmware@alsa-project.org,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=2186; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=s0WnrFHmqOACfzcMu26gBeBYl3edpjiybthmxKpH+/s=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjh4Tz1DIcr4kWbbZ1fXNR7GOJEmWiNmJULPm1G4vq
 7JEKT8SJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4eE8wAKCRDRN9E+zzrEiCmTD/
 9r90EMfLYitLj+CAj5pTW15Y84UH1h3P61FQVh32MliSSUHIdaXNjseCKrv7e+tRpc41lSmcj/OW74
 WxrUoPxQ1Hktiy++0SXNp4dS91cD+tbXSaBxWj4qoKjJOq0JH+W60hWylFoZ2/Om+iyC2ul4p4tlqS
 dLqbMKMExGlamGKbby4s30fBpiAf8AlaeucTa92XDjOkMh27VVRldIAwqJWJopV9PuD8JzoMUGZ90L
 /bXspDsLDMWxAklJhaDhZXnyaUb/nXV4fyfpMkrIVptlxBnU7Bjt7lnxMRO6nmXIE0ukVeedXvacU5
 8mxayfCFK1shZEtL7dOFQsmKWJFX3dFCX6NGYbw1A452mgfZZS4rLwkVpBlzKdrir8u6NwERyd5sEI
 InfH5v89rrFOTctLuieBszRFPTd6pZhoS0reV7c1tyqR87MJvAXGNdvnEJawj9LSFmQXUOF3fxBho+
 NXeyIahMvQZrYm43EwYWLNdvflN+eBi5mRkOWJlLb1IsHfDZdZV3Esdzse4iw2k/dHLRN2j2cN4NMq
 evboar7x2Z0aZo1yEP9zFjFAS3V7tnv2ZayHWT3F5veuN2sPxKpy4/MQSY8tibH0uGYZDi7/UCdIlX
 4+H6VL5A+bSxCSTd/vzO13wZs8Y+XagJNmDmIxBL/e3Tf4M7ZjMznFTHqfuw==
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

During kexec(), the userspace might frozen. Therefore we cannot wait
for it to complete.

During a kexec with frozen processe do not unregister the clients.

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
