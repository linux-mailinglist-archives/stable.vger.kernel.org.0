Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFCA541C04
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382592AbiFGVz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383122AbiFGVwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF3C2428CA;
        Tue,  7 Jun 2022 12:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4611CB82182;
        Tue,  7 Jun 2022 19:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD1C385A5;
        Tue,  7 Jun 2022 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629031;
        bh=qXt8HYzvC389/LYL+hw9trysoaLCoG40Dj9ZAx+tflY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMWtfw5BfygyZCU6xY/yA/trrls5N8ENxd2jkX8y0C3NatWW67gyCujUg3QS2yvJH
         Mzh041MAZip4r101TbTO1DfW3nyY/vYb85v6onysbs7yEROJBocSBAz+hNz1zlIueO
         Ly8FJvWyqWCC3/idUA1knZyTs6buRC6sMhx21P4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 542/879] PCI: cadence: Fix find_first_zero_bit() limit
Date:   Tue,  7 Jun 2022 19:01:00 +0200
Message-Id: <20220607165018.603099483@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0aa3a0937feeb91a0e4e438c3c063b749b194192 ]

The ep->ob_region_map bitmap is a long and it has BITS_PER_LONG bits.

Link: https://lore.kernel.org/r/20220315065829.GA13572@kili
Fixes: 37dddf14f1ae ("PCI: cadence: Add EndPoint Controller driver for Cadence PCIe controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-ep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-ep.c b/drivers/pci/controller/cadence/pcie-cadence-ep.c
index 4b1c4bc4e003..b8b655d4047e 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -187,8 +187,7 @@ static int cdns_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 	struct cdns_pcie *pcie = &ep->pcie;
 	u32 r;
 
-	r = find_first_zero_bit(&ep->ob_region_map,
-				sizeof(ep->ob_region_map) * BITS_PER_LONG);
+	r = find_first_zero_bit(&ep->ob_region_map, BITS_PER_LONG);
 	if (r >= ep->max_regions - 1) {
 		dev_err(&epc->dev, "no free outbound region\n");
 		return -EINVAL;
-- 
2.35.1



