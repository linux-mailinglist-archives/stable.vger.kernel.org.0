Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070CB4F34B6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiDEI0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5DEBD7D5;
        Tue,  5 Apr 2022 01:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9588BB81B90;
        Tue,  5 Apr 2022 08:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043EEC385A0;
        Tue,  5 Apr 2022 08:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146305;
        bh=fk6AeoS7EWVLbpd2rrSsOuFDj8NdQxR72Dj86UJiotQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSghk8OeKOffZsstSWe/HM8WhuMaytXWUy0i76xZeYk7CDo2zsi/Qqk0hcHcAmwnC
         tN/PJ/NQPiPXVNPMEjSwTcTbd+rDS5JESJtD3OsGKQFgGYmqUF20DpW793TQkFWBiK
         YTKdZyjLluuwRgIcz7xpGdXN7AcRMnGjbTuc1O1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Zhu <hongxing.zhu@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0678/1126] PCI: imx6: Invoke the PHY exit function after PHY power off
Date:   Tue,  5 Apr 2022 09:23:45 +0200
Message-Id: <20220405070427.523167527@linuxfoundation.org>
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

[ Upstream commit deaf7a2c2e4b5072a743633bf37c45f34426a093 ]

To balance phy->init_count, invoke the phy_exit() after phy_power_off().

Link: https://lore.kernel.org/r/1646289275-17813-1-git-send-email-hongxing.zhu@nxp.com
Fixes: 178e244cb6e2 ("PCI: imx: Add the imx8mm pcie support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -977,6 +977,7 @@ static int imx6_pcie_suspend_noirq(struc
 	case IMX8MM:
 		if (phy_power_off(imx6_pcie->phy))
 			dev_err(dev, "unable to power off PHY\n");
+		phy_exit(imx6_pcie->phy);
 		break;
 	default:
 		break;


