Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75B4549964
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiFMQ7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243774AbiFMQ7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA47C17EE;
        Mon, 13 Jun 2022 04:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68B61B80EE6;
        Mon, 13 Jun 2022 11:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28B1C341C0;
        Mon, 13 Jun 2022 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121190;
        bh=VvzoZRc7ScJXjHZiyQgNDzsK+acLotFz7v/FX7+Bod0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjFDB0tBjaRs1tggUxTiZpVFUAw1qrhoatlmFdv4MzadiWU7TG1MIySGayVWaZ351
         b3sQyJA7pGwrsM3mh0y9zVBlyRpgE47heJWQ5b/la7MrUW9QeMFVkJ6/5LTTWwI2ar
         ovxeUrNAcgzo6PUjX77YjCdfJGfxjOwIVFBH4dm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.17 297/298] PCI: qcom: Fix pipe clock imbalance
Date:   Mon, 13 Jun 2022 12:13:11 +0200
Message-Id: <20220613094934.084443165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
@@ -1230,12 +1230,6 @@ static int qcom_pcie_init_2_7_0(struct q
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
 


