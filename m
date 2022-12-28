Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A10F657A60
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiL1PLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiL1PKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B82113E00
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE1C961552
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C130DC433EF;
        Wed, 28 Dec 2022 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240216;
        bh=l9AOlS29MLEVOvw/Jr0qb7P4Cmzp6IpF/g+zdJHvoBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR4eVWxv7aHkziUp4gzMZ1lyZjwxF59DLUx5EVcVLnkZWot8wgyoSLCvM5IZ8Xh3z
         aY7UYrhyQSbSB1DrKLuw62Sro2A1SUc7KzmWNdwPCFB2yEDpbLSOQGVoy8a4qwa3AD
         PnMv4UzZwg7KIaorhvJA9Eu2qNNT2OEsc6x2gPzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/731] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
Date:   Wed, 28 Dec 2022 15:37:11 +0100
Message-Id: <20221228144305.964885957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index dd5c4ef92ef3..ea7200b7b647 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
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
 
 	ret = dev_direct_xmit(skb, 0);
 	if (ret)
-- 
2.35.1



