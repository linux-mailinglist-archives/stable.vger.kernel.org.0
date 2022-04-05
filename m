Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307B04F2D4F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiDEI0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbiDEIUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F89BD897;
        Tue,  5 Apr 2022 01:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB9CB81B90;
        Tue,  5 Apr 2022 08:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9670C385A0;
        Tue,  5 Apr 2022 08:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146308;
        bh=lHHOGHVmr7qWwaPYUHQ99Hm9LnXzzyxu1DtucskLisY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLbKGDLfBZWcJ+kylj0xGw3jOJ2QDi2/tezIO2SZK4STsLBu9C5OLk03QQF3ZiYV7
         LqqEs/xAMavRgQhq03p6qM+WD2gWlpsaU5sseBoah/vWbPDGmJ6ovQ9LhbFK4DLA5f
         XDBy3XA5GB5nU6Clf6jeC9VEDW9bnZD7idwqj7G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Zhu <hongxing.zhu@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0679/1126] PCI: imx6: Assert i.MX8MM CLKREQ# even if no device present
Date:   Tue,  5 Apr 2022 09:23:46 +0200
Message-Id: <20220405070427.551805233@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 45514f78c65cc9a09437f20e180625f94f769863 ]

The CLKREQ# signal is an open drain, active low signal that is driven
low by the remote Endpoint device. But it might not be driven low if no
Endpoint device is connected.

On i.MX8MM PCIe, phy_init() may fail and system boot may hang if no
Endpoint is connected to assert CLKREQ#.

Handle this as on i.MX8MQ, where we explicitly assert CLKREQ# so the
PHY can be initialized.

Link: https://lore.kernel.org/r/1645672013-8949-1-git-send-email-hongxing.zhu@nxp.com
Fixes: 178e244cb6e2 ("PCI: imx: Add the imx8mm pcie support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 77fc510c6d0d..d09ad4e1f432 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -453,10 +453,6 @@ static int imx6_pcie_enable_ref_clk(struct imx6_pcie *imx6_pcie)
 	case IMX7D:
 		break;
 	case IMX8MM:
-		ret = clk_prepare_enable(imx6_pcie->pcie_aux);
-		if (ret)
-			dev_err(dev, "unable to enable pcie_aux clock\n");
-		break;
 	case IMX8MQ:
 		ret = clk_prepare_enable(imx6_pcie->pcie_aux);
 		if (ret) {
-- 
2.34.1



