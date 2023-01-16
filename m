Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863BE66C754
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjAPQ3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjAPQ3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1238D302A4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C38A2B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D62C433EF;
        Mon, 16 Jan 2023 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885874;
        bh=rdddXxFhLkjA0k7kHGBqXgaOotGVWezcNMj/RA0RRzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4NmSQUayodpmhUtrlIPJd6/7RqMM1R4ZpTL9Qnm2ZrWpfJ7FImGyt2KMlDhK3nEo
         /xCFwDeoZF1Vvr9elMbaUHdPS8rzui1lWAuZiu17SlP4EvBbLnJg/P8rYzUpS+gWmr
         G4IFqS2kid7vkjgkx6c3kiPnNXtvaecNqb7dZ/lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/658] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
Date:   Mon, 16 Jan 2023 16:45:03 +0100
Message-Id: <20230116154919.298951572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit f150b63f3fa5fdd81e0dd6151e8850268e29438c ]

The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
some error handling case, which will lead to a memory leak. Fix this up
by adding kfree_skb() to release skb.

Compile tested only.

Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index ba03a2d77434..e65577f1da54 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1614,12 +1614,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 	}
 
 	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	ret = dev_set_promiscuity(priv->dev, 1);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	skb_set_queue_mapping(skb, 0);
 	ret = dev_queue_xmit(skb);
-- 
2.35.1



