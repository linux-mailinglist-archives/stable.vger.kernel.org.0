Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF06B71AE
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 09:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCMIyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 04:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCMIxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 04:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77B4FF2D;
        Mon, 13 Mar 2023 01:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D518561149;
        Mon, 13 Mar 2023 08:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFB5C433EF;
        Mon, 13 Mar 2023 08:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678697456;
        bh=UTxAK37bDA3EVcUJ2I3cJfHTWjh0McAXEajETjzOVq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2yww4OelgDzAjGUZXFWezscNGRWs+NxhWiIpHVNVTJqzgh1hChaDrJTlEHIfsvfW
         WxpiTngKuBp/IYlB5ACOY8Sz7/SjSOCQjL3Z+RMoZchNNKkepo6S2ghlug2zfJyzWG
         6R8XoC8gI5RHt9gyKAKv8IukPPrI0jNwfLS5f9hNXWOFSji+vwzHHrr5iRahFOyME7
         8tutOqENoqBo6Hn4spl53Qlae7nDXLKvmWQkbevu/mc29XcMrSPzwShdhoDDc6IEhK
         K65J2mMPGUoxxNv9EugoTqwFKyokhrFmU4QoCD75EQrMzeLXSkpKmn4cRCqRAm9U2U
         KmWqwRhP/e1Dg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pbduO-0006Hu-LH; Mon, 13 Mar 2023 09:51:56 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] interconnect: qcom: rpm: fix msm8996 interconnect registration
Date:   Mon, 13 Mar 2023 09:49:52 +0100
Message-Id: <20230313084953.24088-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313084953.24088-1-johan+linaro@kernel.org>
References: <20230313084953.24088-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit broke interconnect provider registration for the msm8996
platform by accidentally removing a conditional when adding the missing
clock disable in the power-domain lookup error path.

Fixes: b6edcc7570b2 ("interconnect: qcom: rpm: fix probe PM domain error handling")
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/641d04a3-9236-fe76-a20f-11466a01460e@wanadoo.fr
Cc: stable@vger.kernel.org      # 5.17
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 4d0997b210f7..3b055cd893ea 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -498,7 +498,8 @@ int qnoc_probe(struct platform_device *pdev)
 
 	if (desc->has_bus_pd) {
 		ret = dev_pm_domain_attach(dev, true);
-		goto err_disable_clks;
+		if (ret)
+			goto err_disable_clks;
 	}
 
 	provider = &qp->provider;
-- 
2.39.2

