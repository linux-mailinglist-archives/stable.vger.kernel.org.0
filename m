Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4B4F33CB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbiDEIyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbiDEIdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9E6C4;
        Tue,  5 Apr 2022 01:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D90B81BB1;
        Tue,  5 Apr 2022 08:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA24C385A1;
        Tue,  5 Apr 2022 08:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147481;
        bh=VneNOaM9mJpTwqnsaz3AMAgYN5lJVKmSjFQ175D3ec4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+w4Sn/pDfkD+oWqWZBK2hpo52IBXS7J12FSJI+3MYXHQamnfE7ZxTu+JrLPZrYyY
         65gPjewLO5OVws0ZM71r174HgZuIGXAjMqbzZlifWfoK+1OCMNI1uk0Ru3FiBBeUDw
         wVpCJjGYcj83+Y+TnDwEKBD6cZqJunklOxuDnqO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0014/1017] ethernet: sun: Free the coherent when failing in probing
Date:   Tue,  5 Apr 2022 09:15:27 +0200
Message-Id: <20220405070354.596557807@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit bb77bd31c281f70ec77c9c4f584950a779e05cf8 ]

When the driver fails to register net device, it should free the DMA
region first, and then do other cleanup.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index ad9029ae6848..77e5dffb558f 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3146,7 +3146,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3179,6 +3179,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.34.1



