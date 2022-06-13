Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54254894E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354464AbiFMLcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354376AbiFML3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F7223159;
        Mon, 13 Jun 2022 03:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E96860F9A;
        Mon, 13 Jun 2022 10:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A543DC34114;
        Mon, 13 Jun 2022 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117023;
        bh=OpqL0ntLTcZ9fhuT4HdoHr/HvbsByJpZdVcFHVWrTsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6Y4US1AXpU6eh3xtaxkNvG+JZhok9XAFU4aOtf2FESX46hl2eRHSMNGeQy4ouEyu
         BPfeFF7M21tA+R2+r3M5Yf8RvpXK0YgpVFiiEdpvpqdWPg4k1aGui4ikl9F5pUNTzw
         rRHUCvEZ/dXBmMNyUgh9fMBCgyg2gumv+xv/OYms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 270/411] phy: qcom-qmp: fix reset-controller leak on probe errors
Date:   Mon, 13 Jun 2022 12:09:03 +0200
Message-Id: <20220613094936.856541482@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 4d2900f20edfe541f75756a00deeb2ffe7c66bc1 upstream.

Make sure to release the lane reset controller in case of a late probe
error (e.g. probe deferral).

Note that due to the reset controller being defined in devicetree in
"lane" child nodes, devm_reset_control_get_exclusive() cannot be used
directly.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org      # 4.12
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220427063243.32576-3-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -1860,6 +1860,11 @@ static const struct phy_ops qcom_qmp_ufs
 	.owner		= THIS_MODULE,
 };
 
+static void qcom_qmp_reset_control_put(void *data)
+{
+	reset_control_put(data);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 {
@@ -1951,6 +1956,10 @@ int qcom_qmp_phy_create(struct device *d
 			dev_err(dev, "failed to get lane%d reset\n", id);
 			return PTR_ERR(qphy->lane_rst);
 		}
+		ret = devm_add_action_or_reset(dev, qcom_qmp_reset_control_put,
+					       qphy->lane_rst);
+		if (ret)
+			return ret;
 	}
 
 	if (qmp->cfg->type == PHY_TYPE_UFS)


