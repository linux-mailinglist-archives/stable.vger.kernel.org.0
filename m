Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92322604419
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJSL6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiJSL5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:57:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714C3181CA2;
        Wed, 19 Oct 2022 04:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7CA6CE2165;
        Wed, 19 Oct 2022 09:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3590C433C1;
        Wed, 19 Oct 2022 09:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170254;
        bh=XyyJvjno3/eowPKmgIE2dZVJj4PyKKovVsa8PFz8u30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm/aBJ2g78/ylR92QyGOevzCO3ej5xh4UWy6+PumftgcuY2da154XD5ctS88MixpR
         ZZdbHbn/H54Po29AH5c31y7J5IxZZxoGEF2sIb6Jt07Eyg5gHyxrLGoR/MvfjN1bg6
         JqIohx/cZE0dZcoXyd19Q4kGSIoCd2y0qrYZNWLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 585/862] phy: qcom-qmp-pcie: fix resource mapping for SDM845 QHP PHY
Date:   Wed, 19 Oct 2022 10:31:12 +0200
Message-Id: <20221019083315.815097879@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0a40891b83f257b25a2b983758f72f6813f361cb ]

On SDM845 one of PCIe PHYs (the QHP one) has the same region for TX and
RX registers. Since the commit 4be26f695ffa ("phy: qcom-qmp-pcie: fix
memleak on probe deferral") added checking that resources are not
allocated beforehand, this PHY can not be probed anymore. Fix this by
skipping the map of ->rx resource on the QHP PHY and assign it manually.

Fixes: 4be26f695ffa ("phy: qcom-qmp-pcie: fix memleak on probe deferral")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220926172514.880776-1-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 819bcd975ba4..0baf62d80214 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2333,7 +2333,10 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
 	if (IS_ERR(qphy->tx))
 		return PTR_ERR(qphy->tx);
 
-	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
+	if (of_device_is_compatible(dev->of_node, "qcom,sdm845-qhp-pcie-phy"))
+		qphy->rx = qphy->tx;
+	else
+		qphy->rx = devm_of_iomap(dev, np, 1, NULL);
 	if (IS_ERR(qphy->rx))
 		return PTR_ERR(qphy->rx);
 
-- 
2.35.1



