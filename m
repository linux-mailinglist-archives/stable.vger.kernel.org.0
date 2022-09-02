Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D845AB069
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbiIBMxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiIBMws (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07873F8EF2;
        Fri,  2 Sep 2022 05:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 399446215D;
        Fri,  2 Sep 2022 12:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A968C433C1;
        Fri,  2 Sep 2022 12:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121492;
        bh=12bl4ZDThM0MI4U8an5jo2OECDpPHdp23b10tvR/9nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAWEWfzJeDJOhoWLcb4OX9LnYhpYitNlPO7LLGmIfK/prCPLgbQaidxVKf7AHAVTm
         ZyDDtiTlpZJxqYLACXu2z5Z2OrLbCfaorb33R8v2lxJBGozi4iLCufhG5Ap+C9dM8Q
         fEEja1dzWfvpc+dGpOawhMDlOLxhoh3vk0jCW1Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/56] net: Fix a data-race around netdev_budget.
Date:   Fri,  2 Sep 2022 14:18:45 +0200
Message-Id: <20220902121401.076805275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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
index d5bef2bb0b7c8..c93068ea2e4f2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6336,7 +6336,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
 		usecs_to_jiffies(netdev_budget_usecs);
-	int budget = netdev_budget;
+	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
-- 
2.35.1



