Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC835A4ABE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiH2Lu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiH2Luj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B5C6DAFF;
        Mon, 29 Aug 2022 04:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5CB861203;
        Mon, 29 Aug 2022 11:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C94BC433C1;
        Mon, 29 Aug 2022 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771395;
        bh=gME/78e9hQfrVHYhlRezufF0jhw1X1/K8CozhJYSbQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfvkTe8GiDebE/5VwWHvbAZehIIRipxsjmBeIzyuM9vxns4DBjVH18ZZbPxrM7sQA
         j1dvbgmGLS/Hno7n/JUeRimN92QsdrWNQpDe70WekhmqksbCki48da6x+wx4FAWsHr
         xp6VLSo0Wvzxm/l23Z8dzPbpCkn9r7jxmrr2jgDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/86] net: Fix a data-race around netdev_budget.
Date:   Mon, 29 Aug 2022 12:59:22 +0200
Message-Id: <20220829105758.836431771@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 2e0c42374ee32e72948559d2ae2f7ba3dc6b977c ]

While reading netdev_budget, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 51b0bdedb8e7 ("[NET]: Separate two usages of netdev_max_backlog.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1ea75768c5b23..c4eb1b666a21c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6880,7 +6880,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
 		usecs_to_jiffies(netdev_budget_usecs);
-	int budget = netdev_budget;
+	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
-- 
2.35.1



