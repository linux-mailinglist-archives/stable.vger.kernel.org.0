Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5B059238C
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbiHNQWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240947AbiHNQVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:21:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B811C;
        Sun, 14 Aug 2022 09:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 664C460F49;
        Sun, 14 Aug 2022 16:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108B2C433D6;
        Sun, 14 Aug 2022 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494016;
        bh=mwmDbCfw/ao0izZKovfnIvnOORITV54RWHghuELPKFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuPsd0b3em2aKzU0hTYRB/aKuxMmCzHDS6md7hbvQhgKR1Ig5u2uo0wZ3txHVzRIT
         y4J4XQHx0u7sxAx5U9+0Shm4N0vc2Uw6G1RWXSrJsgv/yxboOtNVfiypyf5+Dq+tTK
         dNrBIBNC9UUBjXfbENY7DinSlVott7zIGbvCSxOvW1X1E32cHWpvz7a4MO/xWBoSkM
         dI/Jj3ZPmYC04v4yEZmEeZyddfar/nHWyHQm46maEtxaSHVDRZ5AaQXeoI86ZoqzTD
         t0LsVaGL5t+EbZeISnbDJLGkAF7wTLD7gJhDAW5AuWi+7rz41I0r8UgYUhiG7qvpjL
         x4ORL+KlSLGtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 12/48] ASoC: SOF: Intel: cnl: Do not process IPC reply before firmware boot
Date:   Sun, 14 Aug 2022 12:19:05 -0400
Message-Id: <20220814161943.2394452-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit acacd9eefd0def5a83244d88e5483b5f38ee7287 ]

It is not yet clear, but it is possible to create a firmware so broken
that it will send a reply message before a FW_READY message (it is not
yet clear if FW_READY will arrive later).
Since the reply_data is allocated only after the FW_READY message, this
will lead to a NULL pointer dereference if not filtered out.

The issue was reported with IPC4 firmware but the same condition is present
for IPC3.

Reported-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220712122357.31282-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/cnl.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index cd6e5f8a5eb4..6c98f65635fc 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -60,17 +60,23 @@ irqreturn_t cnl_ipc4_irq_thread(int irq, void *context)
 
 		if (primary & SOF_IPC4_MSG_DIR_MASK) {
 			/* Reply received */
-			struct sof_ipc4_msg *data = sdev->ipc->msg.reply_data;
+			if (likely(sdev->fw_state == SOF_FW_BOOT_COMPLETE)) {
+				struct sof_ipc4_msg *data = sdev->ipc->msg.reply_data;
 
-			data->primary = primary;
-			data->extension = extension;
+				data->primary = primary;
+				data->extension = extension;
 
-			spin_lock_irq(&sdev->ipc_lock);
+				spin_lock_irq(&sdev->ipc_lock);
 
-			snd_sof_ipc_get_reply(sdev);
-			snd_sof_ipc_reply(sdev, data->primary);
+				snd_sof_ipc_get_reply(sdev);
+				snd_sof_ipc_reply(sdev, data->primary);
 
-			spin_unlock_irq(&sdev->ipc_lock);
+				spin_unlock_irq(&sdev->ipc_lock);
+			} else {
+				dev_dbg_ratelimited(sdev->dev,
+						    "IPC reply before FW_READY: %#x|%#x\n",
+						    primary, extension);
+			}
 		} else {
 			/* Notification received */
 			notification_data.primary = primary;
@@ -124,15 +130,20 @@ irqreturn_t cnl_ipc_irq_thread(int irq, void *context)
 					CNL_DSP_REG_HIPCCTL,
 					CNL_DSP_REG_HIPCCTL_DONE, 0);
 
-		spin_lock_irq(&sdev->ipc_lock);
+		if (likely(sdev->fw_state == SOF_FW_BOOT_COMPLETE)) {
+			spin_lock_irq(&sdev->ipc_lock);
 
-		/* handle immediate reply from DSP core */
-		hda_dsp_ipc_get_reply(sdev);
-		snd_sof_ipc_reply(sdev, msg);
+			/* handle immediate reply from DSP core */
+			hda_dsp_ipc_get_reply(sdev);
+			snd_sof_ipc_reply(sdev, msg);
 
-		cnl_ipc_dsp_done(sdev);
+			cnl_ipc_dsp_done(sdev);
 
-		spin_unlock_irq(&sdev->ipc_lock);
+			spin_unlock_irq(&sdev->ipc_lock);
+		} else {
+			dev_dbg_ratelimited(sdev->dev, "IPC reply before FW_READY: %#x\n",
+					    msg);
+		}
 
 		ipc_irq = true;
 	}
-- 
2.35.1

