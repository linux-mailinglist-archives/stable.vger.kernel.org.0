Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5749A59D946
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbiHWJWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbiHWJVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4C08A7E4;
        Tue, 23 Aug 2022 01:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28301B81C4C;
        Tue, 23 Aug 2022 08:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7945AC433D6;
        Tue, 23 Aug 2022 08:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243604;
        bh=mwmDbCfw/ao0izZKovfnIvnOORITV54RWHghuELPKFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZVGWGz+ehC/nk/FSVG6XcBEX9vW2svqCJf89hZ/dn5ugJx+jrCRKIIeRlTZnx+t8
         nLGC/k6Qh2vIIBsdTFs5nOsBPaiePxU7oEyfGF4jRUhGPGE9ckiBfMdNrs1GR0+R2f
         BePyXx2BHIO1A5P7HBT+NBrTSWWMGcPZKCLvhtbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 328/365] ASoC: SOF: Intel: cnl: Do not process IPC reply before firmware boot
Date:   Tue, 23 Aug 2022 10:03:49 +0200
Message-Id: <20220823080131.919228424@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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



