Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD805107F1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351052AbiDZTFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350783AbiDZTFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9034F19916B;
        Tue, 26 Apr 2022 12:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B06D9619B9;
        Tue, 26 Apr 2022 19:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE86C385AA;
        Tue, 26 Apr 2022 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999720;
        bh=0wa8R2ae7L5HvBja6cgYpwoZNRFRA5di92a2dlL7/Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQrhIvv5cSV+xbheXI4gmS7HafKBEpY1H585Z8pXQuQalOW6Ci+TPUC8MCMJGKqK8
         s3a2kUS913wA3A05MTT1gSjmtsMwhEkjg7uTKcFv+fkc0/hzJqL5mjhFzI1z8zsGA2
         zUb3kVUpIyrMkUOR+wNxz5w/B+Fo/ImG6YSI5Iw7UyU5euGVnTuRjf+qN1fdUuwZQy
         KjaK4QRILGM5e3Mh/BYC2+vzR9wEm2FVHAlXKgVg49r0T718iLQeKgicddpFwzKsCU
         uh/arpViRmHc0wosCVr0SmVV2fzS2ZFmLdnfYzI4uOEjTNk8DOyE9iynxppNJDbnGA
         2A2MqiQikPCGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 06/22] ASoC: Intel: sof_es8336: Add a quirk for Huawei Matebook D15
Date:   Tue, 26 Apr 2022 15:01:29 -0400
Message-Id: <20220426190145.2351135-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]

Based on experimental tests, Huawei Matebook D15 actually uses
both gpio0 and gpio1: the first one controls the speaker, while
the other one controls the headphone.

Also, the headset is mapped as MIC1, instead of MIC2.

So, add a quirk for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/d678aef9fc9a07aced611aa7cb8c9b800c649e5a.1649357263.git.mchehab@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 28d7670b8f8f..b18951a8f309 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -252,6 +252,15 @@ static const struct dmi_system_id sof_es8336_quirk_table[] = {
 					SOF_ES8336_TGL_GPIO_QUIRK |
 					SOF_ES8336_ENABLE_DMIC)
 	},
+	{
+		.callback = sof_es8336_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HUAWEI"),
+			DMI_MATCH(DMI_BOARD_NAME, "BOHB-WAX9-PCB-B2"),
+		},
+		.driver_data = (void *)(SOF_ES8336_HEADPHONE_GPIO |
+					SOC_ES8336_HEADSET_MIC1)
+	},
 	{}
 };
 
-- 
2.35.1

