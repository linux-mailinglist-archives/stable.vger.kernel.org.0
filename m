Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD66B420C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjCJN7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjCJN7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC05AF4B6B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59BBC616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C0CC4339B;
        Fri, 10 Mar 2023 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456746;
        bh=vMw/KvoENkUA9MFbFksvsi+yNjoGUrGvqWqocmtou6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLmCIJnaGDsDtVOwxmgDwL1zpJEiGCIzCd3wAaWMGoqKfiuJp4go9mkvnq9uTo2XY
         DVHVEV1uJ3I1odYqA6fmBz5IWCRtRlTXhiBlTpyNPc0ltl+f5YN6JfWMsstpHDZu+a
         EY77y5huUemvNLTeoSt9QTgZzB1/T+peQxTptpag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Anderson <seanga2@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 079/211] net: sunhme: Fix region request
Date:   Fri, 10 Mar 2023 14:37:39 +0100
Message-Id: <20230310133721.185649392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit ee0a735fd97ccde766ab557d1fc722c92cebacda ]

devm_request_region is for I/O regions. Use devm_request_mem_region
instead.  This fixes the driver failing to probe since 99df45c9e0a4
("sunhme: fix an IS_ERR() vs NULL check in probe"), which checked the
result.

Fixes: 914d9b2711dd ("sunhme: switch to devres")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230222204242.2658247-1-seanga2@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cdd..b0c7ab74a82ed 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2894,8 +2894,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0), DRV_NAME);
+	hpreg_res = devm_request_mem_region(&pdev->dev,
+					    pci_resource_start(pdev, 0),
+					    pci_resource_len(pdev, 0),
+					    DRV_NAME);
 	if (!hpreg_res) {
 		err = -EBUSY;
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
-- 
2.39.2



