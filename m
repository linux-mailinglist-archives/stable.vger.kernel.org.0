Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EAE54636A
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbiFJKUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 06:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245415AbiFJKUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 06:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6885B40934;
        Fri, 10 Jun 2022 03:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C70961FA9;
        Fri, 10 Jun 2022 10:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAB5C3411D;
        Fri, 10 Jun 2022 10:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654856404;
        bh=FhYDRCSqPldOOqIsWfKTZqDwNGGJRG4SY0AMoIQzzuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uIwKZGbgKW+IHqzONys2A1e3ShYXsXsnw52BFyXQHd01pd1ggU5nA6xoVSohGt+sT
         P/adhkwed/VTWUtIhRzPDT9FznYdXqjd8FHplIAV/4KuMSkgXs1asHe6GVcvSpQpFt
         AE5K4Fk9aE9NOHtGqFJ0Swu2coVU6Hj7tNhZ8c/cbfmdpXocBKRGDDeMjAWRvcDY94
         2VQWnTx72cuxLXuxXPhqZYMkS0HoCarbsj/MesR4U31SmUsaKcohDKg9VmhQKKt2pN
         YMMyGb1KwvX28FgJmb4CIGNJCFJWMgoY0dHItUlcVcC7VbGduTCOf/31iD6DQzKHg7
         cipL3F3yLKLjg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1nzbkF-0001m1-Ta; Fri, 10 Jun 2022 12:19:59 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH stable-5.17] PCI: qcom: Fix pipe clock imbalance
Date:   Fri, 10 Jun 2022 12:19:45 +0200
Message-Id: <20220610101945.6808-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

commit fdf6a2f533115ec5d4d9629178f8196331f1ac50 upstream.

Fix a clock imbalance introduced by ed8cc3b1fc84 ("PCI: qcom: Add support
for SDM845 PCIe controller"), which enables the pipe clock both in init()
and in post_init() but only disables in post_deinit().

Note that the pipe clock was also never disabled in the init() error
paths and that enabling the clock before powering up the PHY looks
questionable.

Link: https://lore.kernel.org/r/20220401133351.10113-1-johan+linaro@kernel.org
Fixes: ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe controller")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org      # 5.6
[ johan: adjust context for 5.17 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index c19cd506ed3f..18d571f08cdc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1230,12 +1230,6 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 		goto err_disable_clocks;
 	}
 
-	ret = clk_prepare_enable(res->pipe_clk);
-	if (ret) {
-		dev_err(dev, "cannot prepare/enable pipe clock\n");
-		goto err_disable_clocks;
-	}
-
 	/* configure PCIe to RC mode */
 	writel(DEVICE_TYPE_RC, pcie->parf + PCIE20_PARF_DEVICE_TYPE);
 
-- 
2.35.1

