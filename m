Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BEC603E7B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiJSJP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiJSJN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF5CCA8AA;
        Wed, 19 Oct 2022 02:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F8061830;
        Wed, 19 Oct 2022 09:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5B8C433C1;
        Wed, 19 Oct 2022 09:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170185;
        bh=g5t/hZ0fNgoFIR61nY0PEk2xBx40TJC1T+SjBz4tOpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEJpbvj+TINxNMVrA85WD5R1viaRMp4P3hZbmASu233gM7VTHhrzTpBnZxXJ0Kc2F
         NjWn3k2epMR1TYR+AiUC7783H7dFqOZykD0MCE4xY2tnlwjKRXcv2bp/UAtwE8qidA
         SfWjvtXCV7z/CfnSlFG0rJe4OJvD17E2MtA8KTjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 523/862] phy: qcom-qmp-pcie: add pcs_misc sanity check
Date:   Wed, 19 Oct 2022 10:30:10 +0200
Message-Id: <20221019083313.087411998@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit ecd5507e72ea03659dc2cc3e4393fbf8f4e2e02a ]

Make sure that the (otherwise) optional pcs_misc IO region has been
provided in case the configuration specifies a corresponding
initialisation table to avoid crashing with malformed device trees.

Note that the related debug message is now superfluous as the region is
only used when the configuration has a pcs_misc table.

Fixes: 421c9a0e9731 ("phy: qcom: qmp: Add SDM845 PCIe QMP PHY support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 2d65e1f56bfc..0e0f2482827a 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2371,8 +2371,10 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
 	    of_device_is_compatible(dev->of_node, "qcom,ipq6018-qmp-pcie-phy"))
 		qphy->pcs_misc = qphy->pcs + 0x400;
 
-	if (!qphy->pcs_misc)
-		dev_vdbg(dev, "PHY pcs_misc-reg not used\n");
+	if (!qphy->pcs_misc) {
+		if (cfg->pcs_misc_tbl || cfg->pcs_misc_tbl_sec)
+			return -EINVAL;
+	}
 
 	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);
 	qphy->pipe_clk = devm_get_clk_from_child(dev, np, prop_name);
-- 
2.35.1



