Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2036B53E96F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiFFMWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbiFFMWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF6DC1
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA985B81895
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A80C385A9;
        Mon,  6 Jun 2022 12:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518132;
        bh=1ujrGwoNb15cCO+dNMziqcbsMCsuIqTdXcYUemfZn/k=;
        h=Subject:To:Cc:From:Date:From;
        b=VVCV8MxKa2w0HJo62WZzYbDzk1uREAOO3K/v8zz21QqtXCsygBGpBO55pqbpOkls7
         Qy4ytDEw4/H4ANgVEzIEIsXIQgsSCwzH/CyShtQLeItz6uT1msxV0HhJK56P42ThWy
         wRSu2VjUWyx/T7YutXsiGo/B9spnX0xKXOVLE0ok=
Subject: FAILED: patch "[PATCH] PCI: qcom: Fix pipe clock imbalance" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, bhelgaas@google.com,
        bjorn.andersson@linaro.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:21:59 +0200
Message-ID: <1654518119204239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fdf6a2f533115ec5d4d9629178f8196331f1ac50 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Fri, 1 Apr 2022 15:33:51 +0200
Subject: [PATCH] PCI: qcom: Fix pipe clock imbalance

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

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 375f27ab9403..925324dece64 100644
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
 

