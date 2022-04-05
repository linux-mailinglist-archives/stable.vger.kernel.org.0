Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC764F2BBF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbiDEK2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiDEJbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3078D638C;
        Tue,  5 Apr 2022 02:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4733561576;
        Tue,  5 Apr 2022 09:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5434EC385A3;
        Tue,  5 Apr 2022 09:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150317;
        bh=icmzaQjTA2AMAeSYFVcRD2WKyO+/3zIAb8Ggsg0MqkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4EV08XUgfUy43TuGczAxpKlfjVhfRuYeoa7JbJ9bsHcq+AiR9mKpfsUhta9k+Po9
         HWcMipond7iViyx99Tziqhaz7h/mQ33aJwojcZiKnwP9bhoFKLe9cFsAVOFd4L5PM2
         fEPEXr6U3RJg51dz1aoHX56d/c83lL6nq0Jt/uCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/913] ethernet: sun: Free the coherent when failing in probing
Date:   Tue,  5 Apr 2022 09:17:57 +0200
Message-Id: <20220405070340.272075166@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 62f81b0d14ed..b05ee2e0e305 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3139,7 +3139,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3172,6 +3172,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.34.1



