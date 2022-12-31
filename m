Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05C65A6A2
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 21:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbiLaUFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 15:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiLaUF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 15:05:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641CF63C1;
        Sat, 31 Dec 2022 12:05:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26389B8016A;
        Sat, 31 Dec 2022 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2EC433D2;
        Sat, 31 Dec 2022 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672517125;
        bh=FbV0q6beeAFmQblRc8HSsLotow8WXUVOUrnLu92Y8wE=;
        h=From:To:Cc:Subject:Date:From;
        b=l8kJafGLqcChRfN/XrXHS2ED+Nu1HhAPwJ8toSvtXsfPoessqFZNkWWqPmkJOReak
         QnDjHUqOiALDKAZmt/bSyAwksbTmq4WmKhoqGGPGP0cVNwZBIh5fKEsCHQcRXhy3Ta
         S8ybPo5e93Jpd/rTm4kHOadyDBdhpMGJNBr2cclmyreCYNLQHXU6cthyNrXEr7BAE9
         HZh0M8bw68+7uthXUKPYa3MSW9Q8r9JEAemWICU65XIfA9uhM51jLid+zHtKBKIdjh
         x8WtjV09wZ0GdQpOd5x0w6/39aAUMrJHBkgnmz2JSQSAnzSZVBrbFLeHQZugQ1c82P
         TMjOsrsLDflmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 1/7] ASoC: SOF: Revert: "core: unregister clients and machine drivers in .shutdown"
Date:   Sat, 31 Dec 2022 15:04:56 -0500
Message-Id: <20221231200502.1748784-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 44fda61d2bcfb74a942df93959e083a4e8eff75f ]

The unregister machine drivers call is not safe to do when
kexec is used. Kexec-lite gets blocked with following backtrace:

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

This reverts commit 83bfc7e793b555291785136c3ae86abcdc046887.

Reported-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221209114529.3909192-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index c99b5e6c026c..694a2d94a222 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -472,19 +472,10 @@ EXPORT_SYMBOL(snd_sof_device_remove);
 int snd_sof_device_shutdown(struct device *dev)
 {
 	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
-	struct snd_sof_pdata *pdata = sdev->pdata;
 
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
-	/*
-	 * make sure clients and machine driver(s) are unregistered to force
-	 * all userspace devices to be closed prior to the DSP shutdown sequence
-	 */
-	sof_unregister_clients(sdev);
-
-	snd_sof_machine_unregister(sdev, pdata);
-
 	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
 		return snd_sof_shutdown(sdev);
 
-- 
2.35.1

