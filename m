Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4664D6580BD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiL1QTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiL1QTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:19:06 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE521A079
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d15so16445443pls.6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSAJAAdg+x2pOzW2h8I4DWXP2kQcq5rdUpJcuztv9EE=;
        b=zFtugpRj2SGg96qrJKKPlr+MyyNnNyuUCPvH4PdjNFsVHhZZmMIN/KOq4JeyQA8bys
         /Stl7IcHO4xx7yHuC3VjLzsueyqi0DOdGuZNyG7Uubuhene+VMbN6+vikXMigsNF05SZ
         zvcmwRX0TQ6HsWH3zzwpQ/vCnnK24FznH+UGjIwOWQ71x9sI+GgiaQziNz5Uj25Q28Uy
         xw5CcVwNaSFP/o1xg49J+RJdoV50/Mh/HnQfFslJNO4BOnMOMSLOeDNawr1LF5r4lKfg
         rU9UckkH2uomLEmwOiR8a0qewI0P2yFgk+YeXZFwJoJDB5zVNwYalIWdtpxnLG9FeUC5
         UK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSAJAAdg+x2pOzW2h8I4DWXP2kQcq5rdUpJcuztv9EE=;
        b=BcBqZ4/C+cbaoiL256EIsF3pQ12kxLyK1pV/dBi9XrPeAI0+IE6UDlDPoRoi61ctXD
         WLPB+hCAQAOU5hkzpj5cWTFv7AkIbXy2lRpxftFLqcNUfWSd8Amtc03uDSs1FlBEkh+C
         YP4/D6rvMRI2e225elLnV3HzkFkeJR0v+0kvpX46cxtTXj+N8ozNOMc4Sz7AUC3oYxEK
         4A10l83z1bfOCZh0OioM5reJ7YMkzhhTJyNUty6LtXyc2qIyL6NzRSNSx+3oYOchn082
         HQOEoWS2p6Jtd52ZgoxsAtlnxpKjS6KNaKBzPAW0i2MKVokwbVEoWrR9ubQBgZl3XBZ1
         PeqA==
X-Gm-Message-State: AFqh2kqLkKNuykjc60xBFPEFVVGELWBUrLogc46g9M414fBfMBZfyftl
        y7bfvBylaS0ZejlgKa3nmPxZ
X-Google-Smtp-Source: AMrXdXu7mmaMcjNI9HxR+d1DxaBtYiq2bLtKfidJoFb02M79IzccfjmBnBfUTVaiydWpiO50zOQ4dQ==
X-Received: by 2002:a17:902:edd1:b0:192:50fe:504a with SMTP id q17-20020a170902edd100b0019250fe504amr23724967plk.16.1672244258560;
        Wed, 28 Dec 2022 08:17:38 -0800 (PST)
Received: from localhost.localdomain ([117.217.178.100])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902c64300b00186abb95bfdsm11256798pls.25.2022.12.28.08.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 08:17:37 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 6/6] bus: mhi: ep: Save channel state locally during suspend and resume
Date:   Wed, 28 Dec 2022 21:47:04 +0530
Message-Id: <20221228161704.255268-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221228161704.255268-1-manivannan.sadhasivam@linaro.org>
References: <20221228161704.255268-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During suspend and resume, the channel state needs to be saved locally.
Otherwise, the endpoint may access the channels while they were being
suspended and causing access violations.

Fix it by saving the channel state locally during suspend and resume.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: e4b7b5f0f30a ("bus: mhi: ep: Add support for suspending and resuming channels")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/ep/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 2362fcc8b32c..bcaaba97ef63 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1122,6 +1122,7 @@ void mhi_ep_suspend_channels(struct mhi_ep_cntrl *mhi_cntrl)
 
 		dev_dbg(&mhi_chan->mhi_dev->dev, "Suspending channel\n");
 		/* Set channel state to SUSPENDED */
+		mhi_chan->state = MHI_CH_STATE_SUSPENDED;
 		tmp &= ~CHAN_CTX_CHSTATE_MASK;
 		tmp |= FIELD_PREP(CHAN_CTX_CHSTATE_MASK, MHI_CH_STATE_SUSPENDED);
 		mhi_cntrl->ch_ctx_cache[i].chcfg = cpu_to_le32(tmp);
@@ -1151,6 +1152,7 @@ void mhi_ep_resume_channels(struct mhi_ep_cntrl *mhi_cntrl)
 
 		dev_dbg(&mhi_chan->mhi_dev->dev, "Resuming channel\n");
 		/* Set channel state to RUNNING */
+		mhi_chan->state = MHI_CH_STATE_RUNNING;
 		tmp &= ~CHAN_CTX_CHSTATE_MASK;
 		tmp |= FIELD_PREP(CHAN_CTX_CHSTATE_MASK, MHI_CH_STATE_RUNNING);
 		mhi_cntrl->ch_ctx_cache[i].chcfg = cpu_to_le32(tmp);
-- 
2.25.1

