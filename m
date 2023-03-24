Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7985F6C8525
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 19:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjCXSdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 14:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCXScp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 14:32:45 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3132194E
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 11:32:19 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id t14so2674713ljd.5
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 11:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679682737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yY6V3Tjs6zxi6BjLzPF15U7XdNHaXpUkdzLeZ7Wn2xE=;
        b=sbZu9PFnQweeaf1+jqq5hADnAnGhhw2esoT+nm1gBi8rCWstMnqJnITd/fWWfPAbZf
         frwAZx6qfGDC0ndVdODw2mZYnnqgPKln9Igrri+/Dlgh+l8cpBXNvwIgsrflq6tkESjS
         ZyViIkNWBrRz7B7+cj63QJYbAFK396lL1IJbApyvG1FIKur/f7iVUNu5LsA6bDJKSz7w
         KsJGtYxJkBZZ2QdRRm7evOxe5EVydSPrJtqpacPfqFHqsYkUuJMJTKNRVoQI5Se3EYya
         SJSioztCON1DLOrHKcqVa3waepRKVZNRHF2uoUDu7lCG77BIOaDhtB+9rc8vIGvFNPDn
         kNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679682737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yY6V3Tjs6zxi6BjLzPF15U7XdNHaXpUkdzLeZ7Wn2xE=;
        b=DE+h4b+Fh90603qCwou/TViB+k6gNkDVXqId/hnZPiDGMdvPtuUhNbvzx5hiVh4D0+
         8tIjNcYqDhVcc6Gh3FiKt2e0ggSb3zvx7Tu5NdsPdys/DmfOCjrX+Kt5Z7sYRtPitGhW
         me4AR4kAHJga7RwNvbrserpa3Eyd62/Axox40n8NeDaoFhMysIl1rVWqpXLJ1GQ7cDo4
         EoMMfEqSd1ODf5VP3GnsqTrgtWmEeAENa2HNweWwmjQe87CiT27INNk6VbRbpDb3vZDQ
         +SjGROwkjJa/dMW32sg9FoYKZE3AUGvjFgrkLPO4sqQLB+69xyaSCMY/i7DoqLS9L+Rk
         0MFQ==
X-Gm-Message-State: AAQBX9dEJLexLkpoPqVxsnjqsjOJhBpjLZtDl7M2J/8G8vf32rELrQsG
        soJv5ZOa/EvBW3p2a3kftwg6sQ==
X-Google-Smtp-Source: AKy350YwDn/JpmS5YEHi0X/GC8KrRmlaZ5RCtAok0cG6V/8mzGml1BxIC2tlqDFH8XoPwB2ch2EmgA==
X-Received: by 2002:a2e:6817:0:b0:29b:d35c:f0a4 with SMTP id c23-20020a2e6817000000b0029bd35cf0a4mr1137364lja.37.1679682737276;
        Fri, 24 Mar 2023 11:32:17 -0700 (PDT)
Received: from umbar.unikie.fi ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id x5-20020a2e8805000000b0029c0918867bsm2558458ljh.62.2023.03.24.11.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 11:32:16 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] phy: qcom-qmp-pcie: sc8180x PCIe PHY has 2 lanes
Date:   Fri, 24 Mar 2023 21:32:14 +0300
Message-Id: <20230324183215.1880655-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All PCIe PHYs on sc8180x platform have 2 lanes, so change the number of
lanes to 2.

Fixes: f839f14e24f2 ("phy: qcom-qmp: Add sc8180x PCIe support")
Cc: stable@vger.kernel.org # 5.15
Sgned-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---

Changes since v1:
- Fixed the Fixes tag according to Johan's recommendation
- Added cc stable.

---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index d671748bc097..c39c8a680166 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2198,7 +2198,7 @@ static const struct qmp_phy_cfg msm8998_pciephy_cfg = {
 };
 
 static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
-	.lanes			= 1,
+	.lanes			= 2,
 
 	.tbls = {
 		.serdes		= sc8180x_qmp_pcie_serdes_tbl,
-- 
2.30.2

