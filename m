Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0A6541C5C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382921AbiFGV6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382510AbiFGV56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D024CC93;
        Tue,  7 Jun 2022 12:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23C30B823AE;
        Tue,  7 Jun 2022 19:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936EAC385A5;
        Tue,  7 Jun 2022 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629235;
        bh=BosxUKO/27/7KBdUbBO+j64psIFPo88G9Hi6DZud58k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwgiBwqpsRGjvVkV1v4D6tWjvmiztU3PYCMSyiKC8kk7I0jiC4tYiVwgBekyYTekV
         NvwoliY7Iz915/9jcs2GNOnYNhYHvqGmBVMu8WzqXbXeNw7aFLKfoGuWCwoPZkVZdH
         QEQBmAAw2NCcXYFxLECy0sdG/N0GFmFpEmXKCW2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 617/879] PCI: mediatek-gen3: Assert resets to ensure expected init state
Date:   Tue,  7 Jun 2022 19:02:15 +0200
Message-Id: <20220607165020.757146074@linuxfoundation.org>
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
index 3e8d70bfabc6..5d9fd36b02d1 100644
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



