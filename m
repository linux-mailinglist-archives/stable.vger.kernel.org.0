Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F934EEB15
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiDAKRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbiDAKRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:17:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9791C196D73
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 499C3B8236C
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07280C2BBE4;
        Fri,  1 Apr 2022 10:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648808113;
        bh=r82SGIEEGSj5B3fhbiw7CtUZHvdkA9X0+yOsjHaDiRY=;
        h=From:To:Cc:Subject:Date:From;
        b=FQKwabptlXmEL8D6SU5bCsyoaJ7nwYW0tfGtuqpjVACYVwKJbbIQqs+HFJoyzq7Ql
         4z1mkQGHJiJp8SlIdkTR56NISCd//Vu1S+tBCV3EYubZRd7aty2J2LpfQqp+GPtZQJ
         lYZMa5b3Aii+xZxpBkuIQ0aciUQeAYxdCXrv84YcGLDrz76lGT4+5JX2aQgw5w+97n
         rR3QeBqLnKyeoAweUykYgQcTaHloFhK3JtUX+aBVrqvEByXHgnmLXtPeb3perTq6eO
         qNjtAMYay0swd3kdHcU0ECQGS/WvFWvfHmsYQWhpoOnpyV82cjRPh++Ke0eSTqChJa
         TBA1+Ki4lqCsQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1naEJE-0004RD-J9; Fri, 01 Apr 2022 12:15:12 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] PCI: qcom: fix pipe clock imbalance
Date:   Fri,  1 Apr 2022 12:13:25 +0200
Message-Id: <20220401101325.16983-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe
controller") introduced a clock imbalance by enabling the pipe clock
both in init() and in post_init() but only disabling in post_deinit().

Note that the pipe clock was also never disabled in the init() error
paths and that enabling the clock before powering up the PHY looks
questionable.

Fixes: ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe controller")
Cc: stable@vger.kernel.org      # 5.6
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index b79d98e5e228..20a0e6533a1c 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1238,12 +1238,6 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 		goto err_disable_clocks;
 	}
 
-	ret = clk_prepare_enable(res->pipe_clk);
-	if (ret) {
-		dev_err(dev, "cannot prepare/enable pipe clock\n");
-		goto err_disable_clocks;
-	}
-
 	/* Wait for reset to complete, required on SM8450 */
 	usleep_range(1000, 1500);
 
-- 
2.35.1

