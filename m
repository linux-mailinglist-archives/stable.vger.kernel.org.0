Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB7C66C08C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjAPOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjAPOCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C57BBA1;
        Mon, 16 Jan 2023 06:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E944B80F3B;
        Mon, 16 Jan 2023 14:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CCC433F2;
        Mon, 16 Jan 2023 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877721;
        bh=gd6nnAxCXX6nRwCMcVtm0qxihQ4usvTBVYQsxON9ZlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7VYT2FlXIS5w2rDCSnB2KQBhT/fWc/g5qeby3PrjLiM1eVrdv/NPTwdlen0LOcuj
         5oYP55PiHZgXYSzzbs7KTDuLKNZAzFDKBtcIfN1l3ePOjy1lkzLX7FpxfTmaeUfkkQ
         WVxT3Ke6R6L956eJ8BWUkTjpB3/0bCTKSwx2VJsYoSvsNH9v6sfVBcig4+pZjTx1q4
         3+WCYLju/Riv6HhnciIbgHcMS36fVLwt6kMdtgNWQAU5/bkX2bbje6MwZaKYyTtoy0
         SQmCSmLCGzXtHRWSc+I9Wn26JJBOxmGHYik8ZIegmIZbpIAYUtireUrEnuWht4KX80
         76ezWsYI8AjBA==
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
Subject: [PATCH AUTOSEL 6.1 03/53] ASoC: SOF: pm: Always tear down pipelines before DSP suspend
Date:   Mon, 16 Jan 2023 09:01:03 -0500
Message-Id: <20230116140154.114951-3-sashal@kernel.org>
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

[ Upstream commit d185e0689abc98ef55fb7a7d75aa0c48a0ed5838 ]

When the DSP is suspended while the firmware is in the crashed state, we
skip tearing down the pipelines. This means that the widget reference
counts will not get to reset to 0 before suspend. This will lead to
errors with resuming audio after system resume. To fix this, invoke the
tear_down_all_pipelines op before skipping to DSP suspend.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221220125629.8469-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 5f88c4a01fa3..8722bbd7fd3d 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -192,6 +192,9 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	if (runtime_suspend && !sof_ops(sdev)->runtime_suspend)
 		return 0;
 
+	if (tplg_ops && tplg_ops->tear_down_all_pipelines)
+		tplg_ops->tear_down_all_pipelines(sdev, false);
+
 	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)
 		goto suspend;
 
@@ -216,9 +219,6 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 		goto suspend;
 	}
 
-	if (tplg_ops->tear_down_all_pipelines)
-		tplg_ops->tear_down_all_pipelines(sdev, false);
-
 	/* suspend DMA trace */
 	sof_fw_trace_suspend(sdev, pm_state);
 
-- 
2.35.1

