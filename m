Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4C8541E01
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381440AbiFGWVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381770AbiFGWSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE35C2629C6;
        Tue,  7 Jun 2022 12:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0834B82182;
        Tue,  7 Jun 2022 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4CBC385A2;
        Tue,  7 Jun 2022 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629621;
        bh=qbauNjF61MCv+D9NJt4OXenPxXHOClS2n7guB7XxnK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVTdz6GNZDwismMNVSVJCMwenkQF4auIMjFA7gotlSZZD/RvnSBWTaj0g+chnUHP1
         mSjRCos7ufp133/QVksJvC5mTtJ69K5DbwT/FZRkJEHtK1aT9KkNaxaozKKwqHPqlb
         v4tOYoLAyxDUm+7mGSs9iY50bjPl55XQELo3vOn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.18 756/879] PCI: qcom: Fix runtime PM imbalance on probe errors
Date:   Tue,  7 Jun 2022 19:04:34 +0200
Message-Id: <20220607165024.806157230@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

commit 87d83b96c8d6c6c2d2096bd0bdba73bcf42b8ef0 upstream.

Drop the leftover pm_runtime_disable() calls from the late probe error
paths that would, for example, prevent runtime PM from being reenabled
after a probe deferral.

Link: https://lore.kernel.org/r/20220401133854.10421-2-johan+linaro@kernel.org
Fixes: 6e5da6f7d824 ("PCI: qcom: Fix error handling in runtime PM support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org      # 4.20
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1621,17 +1621,14 @@ static int qcom_pcie_probe(struct platfo
 	pp->ops = &qcom_pcie_dw_ops;
 
 	ret = phy_init(pcie->phy);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
+	if (ret)
 		goto err_pm_runtime_put;
-	}
 
 	platform_set_drvdata(pdev, pcie);
 
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		pm_runtime_disable(&pdev->dev);
 		goto err_pm_runtime_put;
 	}
 


