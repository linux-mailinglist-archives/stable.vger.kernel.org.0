Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8B66C088
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjAPOCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjAPOCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A63C3A;
        Mon, 16 Jan 2023 06:02:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6993BB80F52;
        Mon, 16 Jan 2023 14:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B327EC433F1;
        Mon, 16 Jan 2023 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877719;
        bh=We4AOABTCrlp9F1jwtkkQL4Oz6PzYUIHv8bU4uce94M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhVbiC5VuxVgnFlze6h+c0CA4eB/roBtnO2JExucH0g9FyhDi4tMD6HAnbeIFnZVL
         3+MTmkX38kdnE64WVdGZJOsUrUEQAaeM8oMYurYtvLRMOmwADhh/OaQIC3LIdaHbY5
         g30dce1n/ieunFMXxs/sCKZLksvUM/bDsGaWdtj9BsJLFBxakZq0X9C/MYtL6hVNEA
         9ttUkpz2NJO5+Ja1xVBi+MYEIaLSXGMvk4RfubfhV02bZif9SFPSPBBtAMn+DG29mI
         m2triDAhKNDf+XWHJeovcALpRNxQ6vReELx7PToRSMKhRVTjgk7fcZwWdW35ftDMP9
         NG5WU9nBopA7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 02/53] ASoC: SOF: pm: Set target state earlier
Date:   Mon, 16 Jan 2023 09:01:02 -0500
Message-Id: <20230116140154.114951-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 6f95eec6fb89e195dbdf30de65553c7fc57d9372 ]

If the DSP crashes before the system suspends, the setting of target state
will be skipped because the firmware state will no longer be
SOF_FW_BOOT_COMPLETE. This leads to the incorrect assumption that the
DSP should suspend to D0I3 instead of suspending to D3. To fix this,
set the target_state before we skip to DSP suspend even when the DSP has
crashed.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221220125629.8469-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index df740be645e8..5f88c4a01fa3 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -182,7 +182,7 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	const struct sof_ipc_pm_ops *pm_ops = sdev->ipc->ops->pm;
 	const struct sof_ipc_tplg_ops *tplg_ops = sdev->ipc->ops->tplg;
 	pm_message_t pm_state;
-	u32 target_state = 0;
+	u32 target_state = snd_sof_dsp_power_target(sdev);
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
@@ -206,7 +206,6 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 		}
 	}
 
-	target_state = snd_sof_dsp_power_target(sdev);
 	pm_state.event = target_state;
 
 	/* Skip to platform-specific suspend if DSP is entering D0 */
-- 
2.35.1

