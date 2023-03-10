Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDA6B464A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbjCJOlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjCJOlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:41:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DC511F62D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E3160F11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BACC4339E;
        Fri, 10 Mar 2023 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459299;
        bh=Q4pY6Vuso7R22lRpu5bLa0CR9HFE/MNmbS1Rg/Ml1Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFmhDLhnUmmaUZNY/AhSmofpvLYZUpLgfceIAj2vJ9R4Vvl6cy6EAWt5VbYAJ1XxF
         1DDY0BlLa1CTb1sJkuqe0641fiwU+yDwM2Ws45W9iyOje9kkCG1s/kK0aHaZ76ttZ+
         BGauZrAzVAU+mrhxUnDGQCC1tqrwpiKfaCuQRoYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 314/357] net: fix __dev_kfree_skb_any() vs drop monitor
Date:   Fri, 10 Mar 2023 14:40:03 +0100
Message-Id: <20230310133748.548296099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ac3ad19584b26fae9ac86e4faebe790becc74491 ]

dev_kfree_skb() is aliased to consume_skb().

When a driver is dropping a packet by calling dev_kfree_skb_any()
we should propagate the drop reason instead of pretending
the packet was consumed.

Note: Now we have enum skb_drop_reason we could remove
enum skb_free_reason (for linux-6.4)

v2: added an unlikely(), suggested by Yunsheng Lin.

Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 615cdaac3e729..1a4e20c4ba053 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2735,8 +2735,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_irq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (unlikely(reason == SKB_REASON_DROPPED))
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
-- 
2.39.2



