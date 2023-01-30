Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FAC681054
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbjA3OCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbjA3OCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA663B64E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8D360FE0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF67C433EF;
        Mon, 30 Jan 2023 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087331;
        bh=87Nq8yIQcX+ngUxRzowe7GKX7skhkxSFpKUsvXocuCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiwPkQTxmfGH1Y0dISyK+XH1udbJPaT/+F9KWo6CJaRZ9e8ZWB8CNHKatLwbFAY5s
         lMSuUgm5TXHTfzUWrfkmppaIBPEDSANxiMu6e0dtnIxw6lWYYPTg/R9H6f/euM0zDA
         qFvsIlNudQNWI6dUQKmaJjjZSx/D3YEUEhRPXIas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/313] ASoC: SOF: pm: Set target state earlier
Date:   Mon, 30 Jan 2023 14:49:37 +0100
Message-Id: <20230130134343.274767061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.39.0



