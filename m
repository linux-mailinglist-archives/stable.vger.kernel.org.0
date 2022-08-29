Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB55A49C5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiH2L34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiH2L3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B24272854;
        Mon, 29 Aug 2022 04:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B0B6118C;
        Mon, 29 Aug 2022 11:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912DEC433C1;
        Mon, 29 Aug 2022 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771244;
        bh=MPqYKtaN3m8iUW50zVcvP16RP0F0zXsjL+Z0G2USGs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxLbwy/FkMuA7lvry8dFqF2Jlc5L4SR3CmyR8l3+d56emjqJBJp8OF9D5jPyBmulo
         4XzVYPwgBqRbyAB8Eor59LqOU2nvuDdlL16if+Jl33qbHUmqKlSwDWYKOifSkPCnG+
         vpOsiF+oImhW31vZAJMACVehekw01GiCrse8UvMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/136] net: Fix a data-race around netdev_budget_usecs.
Date:   Mon, 29 Aug 2022 12:59:10 +0200
Message-Id: <20220829105808.051402613@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

[ Upstream commit fa45d484c52c73f79db2c23b0cdfc6c6455093ad ]

While reading netdev_budget_usecs, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fefe8ddd282fd..276cca563325e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7137,7 +7137,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(netdev_budget_usecs);
+		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
-- 
2.35.1



