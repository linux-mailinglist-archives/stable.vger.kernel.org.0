Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343425AED00
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiIFOFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241209AbiIFODr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:03:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB67314D27;
        Tue,  6 Sep 2022 06:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF0D2B818D2;
        Tue,  6 Sep 2022 13:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018EBC433C1;
        Tue,  6 Sep 2022 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471796;
        bh=GvYzmwFJBHnX/Btdl9COJ1mM95E3NP0pN92h77YHe8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ml1fgeGb28+m7Kwi+AKR6n9bSEnUZ9SCe4H/HFEtPaftCVfeodvMsiLj/PUwEizqe
         cB1l/k1tJAwlvBm2LWmTajPWlUWXWr7OoHSAI2c65Do6KZQLiInk0nRSzzWDMFePmI
         h7Bl16V7MeuUJDGY/K/TyTLstux8bTZM6o7WPiW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 042/155] net: lan966x: improve error handle in lan966x_fdma_rx_get_frame()
Date:   Tue,  6 Sep 2022 15:29:50 +0200
Message-Id: <20220906132831.194542674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 13a9d08c296228d18289de60b83792c586e1d073 ]

Don't just print a warning.  Clean up and return an error as well.

Fixes: c8349639324a ("net: lan966x: Add FDMA functionality")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/YwjgDm/SVd5c1tQU@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 6dea7f8c14814..51f8a08163777 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -425,7 +425,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	lan966x_ifh_get_src_port(skb->data, &src_port);
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
-	WARN_ON(src_port >= lan966x->num_phys_ports);
+	if (WARN_ON(src_port >= lan966x->num_phys_ports))
+		goto free_skb;
 
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
@@ -449,6 +450,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 
 	return skb;
 
+free_skb:
+	kfree_skb(skb);
 unmap_page:
 	dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
 		       FDMA_DCB_STATUS_BLOCKL(db->status),
-- 
2.35.1



