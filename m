Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0592554154F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378220AbiFGUfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359527AbiFGU24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36C1DE8C4;
        Tue,  7 Jun 2022 11:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E324B612EC;
        Tue,  7 Jun 2022 18:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE3C385A2;
        Tue,  7 Jun 2022 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626846;
        bh=vunQDCvuQuaj6mRDAwxLJ/9p0HZBW9BBYRrbU+3Ge+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lhq9m65IxCDE8JpzTAG09PMsabZiJBYe4ljtL2pIJwO6ua2pXGv78D6iKXovb5RA
         HcCsx5DCPeuJLRqop9MvGfzPehr3wzxcrUko2AP3ZRXUPnf2LtLezeHnhmJnmQF19H
         ekAN4prr1I8krKUDs5n7AleuWz11eHD7gRTuwJjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 526/772] PCI: mediatek-gen3: Assert resets to ensure expected init state
Date:   Tue,  7 Jun 2022 19:01:58 +0200
Message-Id: <20220607165004.473525111@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d565935e3b9ccc682631e0bc6e415a7f48295d9 ]

The controller may have been left out of reset by the bootloader,
in which case, before the powerup sequence, the controller will be
found preconfigured with values that were set before booting the
kernel: this produces a controller failure, with the result of
a failure during the mtk_pcie_startup_port() sequence as the PCIe
link never gets up.

To ensure that we get a clean start in an expected state, assert
both the PHY and MAC resets before executing the controller
power-up sequence.

Link: https://lore.kernel.org/r/20220404144858.92390-1-angelogioacchino.delregno@collabora.com
Fixes: d3bf75b579b9 ("PCI: mediatek-gen3: Add MediaTek Gen3 driver for MT8192")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 7705d61fba4c..0e27a49ae0c2 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -838,6 +838,14 @@ static int mtk_pcie_setup(struct mtk_gen3_pcie *pcie)
 	if (err)
 		return err;
 
+	/*
+	 * The controller may have been left out of reset by the bootloader
+	 * so make sure that we get a clean start by asserting resets here.
+	 */
+	reset_control_assert(pcie->phy_reset);
+	reset_control_assert(pcie->mac_reset);
+	usleep_range(10, 20);
+
 	/* Don't touch the hardware registers before power up */
 	err = mtk_pcie_power_up(pcie);
 	if (err)
-- 
2.35.1



