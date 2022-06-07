Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7E542213
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiFHBy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383192AbiFHBtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC9B262700;
        Tue,  7 Jun 2022 12:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59EB66077B;
        Tue,  7 Jun 2022 19:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F15C385A2;
        Tue,  7 Jun 2022 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629618;
        bh=/nNAardFfiQn0gwg6L9rBRgNKDK5zGiak1Jzhu1Sbq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1n9vxLrEOS/xa//9rf8g2SImKHjI8uoSEYz/kr6xuyclZflAJdT/O/NC2BEvt+LJP
         Ju3NeEh0jQZ9djWUVkLC3vrfIfikesJ0HNu8T77HjPSOQfsduTHBjXlNc2QrSM8yUE
         rYSwwgUIsR227Kqwu/FgIwCfQoCOiphbAk5DOjlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.18 755/879] PCI: qcom: Fix pipe clock imbalance
Date:   Tue,  7 Jun 2022 19:04:33 +0200
Message-Id: <20220607165024.776463778@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1238,12 +1238,6 @@ static int qcom_pcie_init_2_7_0(struct q
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
 


