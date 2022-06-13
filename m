Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF0549150
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245682AbiFMKdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346880AbiFMKbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:31:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49B3275F4;
        Mon, 13 Jun 2022 03:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0286CE1167;
        Mon, 13 Jun 2022 10:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF867C34114;
        Mon, 13 Jun 2022 10:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115693;
        bh=uKnl2EJ1eFFTQAHXO15f5y/ajrIMAWXllM2S4FtiUA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpskR6ozVvsVOgQPGrDcvx/Wd8tqJQG81ayDnZfM+EsT7d1RFBGFge2EY41fkWvZ9
         cNefxYtWKmhUNS0LLsQDqX7XEVQSbcpkysWhYX3jMJXuYo8HPRabL8M1lh+jWe3aI7
         iIHvwukHE4Sw+zd+qsstu0+j/lE+5+F7G2eVvdTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 4.9 167/167] PCI: qcom: Fix unbalanced PHY init on probe errors
Date:   Mon, 13 Jun 2022 12:10:41 +0200
Message-Id: <20220613094920.173799133@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

commit 83013631f0f9961416abd812e228c8efbc2f6069 upstream.

Undo the PHY initialisation (e.g. balance runtime PM) if host
initialisation fails during probe.

Link: https://lore.kernel.org/r/20220401133854.10421-3-johan+linaro@kernel.org
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org      # 4.5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pcie-qcom.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/host/pcie-qcom.c
+++ b/drivers/pci/host/pcie-qcom.c
@@ -562,10 +562,15 @@ static int qcom_pcie_probe(struct platfo
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		return ret;
+		goto err_phy_exit;
 	}
 
 	return 0;
+
+err_phy_exit:
+	phy_exit(pcie->phy);
+
+	return ret;
 }
 
 static const struct of_device_id qcom_pcie_match[] = {


