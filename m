Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9340965A2E7
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 07:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiLaGPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 01:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLaGPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 01:15:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25B82184;
        Fri, 30 Dec 2022 22:15:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso27609028pjp.4;
        Fri, 30 Dec 2022 22:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTxSay/i9WQ4dxCAUT2dz6zIVT7ol76fefUCP0UN/RM=;
        b=Nt1W8xTdkGOYoPUijeeuX8s4YIjNS2wjWPGIyapdWzeqemIj3EnvavGfK5yJYT95i0
         q1Xb2UUL+WsnClwsFDvV/I3ww6sSYUid/tq0a8c4Z6jFPSvFDF3G8izJLvOTJumsio9R
         sdmxRR6yFMPHG+TwKlpBCuXpxbtw42seDida5Km+OW13zKdEYsXfd3PmlKEleJPTnfIz
         ga1fdyNStt2/EP2zhi+2CKsjxd9mLyMwrqIQH0IKDEvtosZ6EEji1Z8vHEp1GnBGBJNi
         MwIh80/BKyODFDtbBPp98hZrRpU2CRAcGSnpGmIlOJwmLjyu1PRC1o7Lvp3LlDxPVT7c
         rZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XTxSay/i9WQ4dxCAUT2dz6zIVT7ol76fefUCP0UN/RM=;
        b=gqzO0BrLa8tIzycQN8xRLrUOAp17rExvmbWOcHCNBoAI6guNlaevDtooh9U1Sva/L8
         a9V0m4POyJZhF6VWM2pmlguPm2q162oCZame28pqM2l3MB5HM2rLmc1beEzpDTbA3m9E
         4BYpJ83w7uza5Xa7gmDI5eDdllPESrKF64fMOLTBkqK0NUllh82D4Gvwcw+Kfs4Z0nnR
         eCrvwMrMonte/wISK1NDterty3hg+4fplFd8M3nBJWs3SioTB1f0kGxv4mX7SmV2L57y
         wfOhx2jZlXKhQjcnxvbMe+RyvwkvY195ELJjpHOH1BbfU2zhofJLAMryt6UwogUs2UXG
         sqEA==
X-Gm-Message-State: AFqh2komzmfTtLwqJGsAkwlIMikbRZp0DDkR5booalo2YzLbWEEA4k6J
        N0SwlIrXOF44obmvJN/0V9Xd3nMOK70=
X-Google-Smtp-Source: AMrXdXuuW8jn2iRfFI4TbEOIbR62mXJMnebxxJCl1+fnOSYBovjnIRVBN5Woet1CD1g0lWPR63lybQ==
X-Received: by 2002:a17:902:c382:b0:191:4378:ec06 with SMTP id g2-20020a170902c38200b001914378ec06mr40443201plg.61.1672467350329;
        Fri, 30 Dec 2022 22:15:50 -0800 (PST)
Received: from localhost ([2600:1700:38c1:1d7f:f66d:4ff:fe3c:3ceb])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b00176dc67df44sm15977840plf.132.2022.12.30.22.15.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Dec 2022 22:15:49 -0800 (PST)
From:   Brian Norris <computersforpeace@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: qcom: lpass-cpu: Fix fallback SD line index handling
Date:   Fri, 30 Dec 2022 22:15:45 -0800
Message-Id: <20221231061545.2110253-1-computersforpeace@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These indices should reference the ID placed within the dai_driver
array, not the indices of the array itself.

This fixes commit 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD
lines configurable"), which among others, broke IPQ8064 audio
(sound/soc/qcom/lpass-ipq806x.c) because it uses ID 4 but we'd stop
initializing the mi2s_playback_sd_mode and mi2s_capture_sd_mode arrays
at ID 0.

Fixes: 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD lines configurable")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 sound/soc/qcom/lpass-cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 54353842dc07..dbdaaa85ce48 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1037,10 +1037,11 @@ static void of_lpass_cpu_parse_dai_data(struct device *dev,
 					struct lpass_data *data)
 {
 	struct device_node *node;
-	int ret, id;
+	int ret, i, id;
 
 	/* Allow all channels by default for backwards compatibility */
-	for (id = 0; id < data->variant->num_dai; id++) {
+	for (i = 0; i < data->variant->num_dai; i++) {
+		id = data->variant->dai_driver[i].id;
 		data->mi2s_playback_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 		data->mi2s_capture_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 	}
-- 
2.39.0

