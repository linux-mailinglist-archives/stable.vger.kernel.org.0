Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4671A60E569
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiJZQXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiJZQXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5FA10EA27;
        Wed, 26 Oct 2022 09:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5477461F8A;
        Wed, 26 Oct 2022 16:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F73C433D7;
        Wed, 26 Oct 2022 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666801381;
        bh=NoVmt4lw5dBehEnWuBhKo9Ma1EMADExTiZUi93ce3vQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SRvZW8S3ytnUt5NLSB1BE547CW9CDCQyuLxToUfMqYCN5q09KoXQn48p6awu7QmoL
         NsRZU9+Epy1tIRPtOIBinq4F440RQ5KxYMR+WFj4U5QRkjp2w6YuAWlgzW9M0nF+h7
         62eYv3oTWUtbRyHcft24m7SILOPH1P+Q3iNxIpLoXIIPPcgJvXgZoK0onnWE776W1z
         4KL/ACSIxynSLN2Ky8+yFPMjQk4myP8qVtwtrjFDPfccdAlZG5u8sleSQTJh33ysWP
         OIJCZUJmPzWkynXZOAuvbVhUAB4MAmpguX0I9nmfvM0FSt6eAsjMlkcnJDnTJgJsoB
         8LOEaZ00+smOg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1onjAz-0006uI-DF; Wed, 26 Oct 2022 18:22:45 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] phy: qcom-qmp-combo: fix NULL-deref on runtime resume
Date:   Wed, 26 Oct 2022 18:21:16 +0200
Message-Id: <20221026162116.26462-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate
PCS_USB region") started treating the PCS_USB registers as potentially
separate from the PCS registers but used the wrong base when no PCS_USB
offset has been provided.

Fix the PCS_USB base used at runtime resume to prevent dereferencing a
NULL pointer on platforms that do not provide a PCS_USB offset (e.g.
SC7180).

Fixes: fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate PCS_USB region")
Cc: stable@vger.kernel.org	# 5.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index f6328434c61e..ad6a0fd7ba8e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2144,7 +2144,7 @@ static void qmp_combo_enable_autonomous_mode(struct qmp_phy *qphy)
 static void qmp_combo_disable_autonomous_mode(struct qmp_phy *qphy)
 {
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
-	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs_usb;
+	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs;
 	void __iomem *pcs_misc = qphy->pcs_misc;
 
 	/* Disable i/o clamp_n on resume for normal mode */
-- 
2.37.3

