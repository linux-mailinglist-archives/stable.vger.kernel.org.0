Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003BB55DB4E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiF1Cae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244808AbiF1C2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5203926114;
        Mon, 27 Jun 2022 19:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11AA7B81C0A;
        Tue, 28 Jun 2022 02:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BCAC385A5;
        Tue, 28 Jun 2022 02:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383186;
        bh=zrAyaFapqko+OKphU5GEF1mHMbCDxCUYsWwHGUS7jsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4hXigOaqTpl/Vb8LEWm8z1b3nJ2Z1amgZgN6k9aKG1aS1JXtp70tJX9ukbrGKtSk
         ZIfU3lMkZ46HA40cT9Vb8O2nQmFNnKhItf1HKe9qF+s8vfOqf05UkyuRnI4WmMZJsg
         bOnfyHoslmPPCF2qKe3xiKpn4HJpfis94GkElJNVHInDR04+N6qhECgwCGdf+XrgUQ
         ERjXP0+mGPtkkqdkD5GDoeVZsORfLvwRIK8xPkD0amhTWus45riDLiOLdZwi4xjEKk
         vURM2JMqw/Ud/20ZP32e0gdN9SMQCYG19tsv3NPKyLUpxsoSTtLCu3usqWK0dQBRGK
         dZcqMalDSwzew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, nizhen@uniontech.com,
        jiasheng@iscas.ac.cn, gushengxian@yulong.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 05/17] ALSA: x86: intel_hdmi_audio: enable pm_runtime and set autosuspend delay
Date:   Mon, 27 Jun 2022 22:26:03 -0400
Message-Id: <20220628022615.596977-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022615.596977-1-sashal@kernel.org>
References: <20220628022615.596977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e87c65aeb46ca4f5b7dc08531200bcb8a426c62e ]

The existing code uses pm_runtime_get_sync/put_autosuspend, but
pm_runtime was not explicitly enabled. The autosuspend delay was not
set either, the value is set to 5s since HDMI is rather painful to
resume.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220616222910.136854-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index bf894087e5fa..84ac01b6e93d 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -42,6 +42,8 @@
 #include <drm/intel_lpe_audio.h>
 #include "intel_hdmi_audio.h"
 
+#define INTEL_HDMI_AUDIO_SUSPEND_DELAY_MS  5000
+
 #define for_each_pipe(card_ctx, pipe) \
 	for ((pipe) = 0; (pipe) < (card_ctx)->num_pipes; (pipe)++)
 #define for_each_port(card_ctx, port) \
@@ -1885,8 +1887,11 @@ static int hdmi_lpe_audio_probe(struct platform_device *pdev)
 	pdata->notify_audio_lpe = notify_audio_lpe;
 	spin_unlock_irq(&pdata->lpe_audio_slock);
 
+	pm_runtime_set_autosuspend_delay(&pdev->dev, INTEL_HDMI_AUDIO_SUSPEND_DELAY_MS);
 	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
 
 	dev_dbg(&pdev->dev, "%s: handle pending notification\n", __func__);
 	for_each_port(card_ctx, port) {
-- 
2.35.1

