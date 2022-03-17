Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835984DC696
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiCQMzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiCQMyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94FB1EC6D;
        Thu, 17 Mar 2022 05:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B1E61578;
        Thu, 17 Mar 2022 12:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AE9C340E9;
        Thu, 17 Mar 2022 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521586;
        bh=yv24BEIQB2Wa9G21wq5trSJnLc3FQVzB/HOeXIspnWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCWssIRfFt7sPSBBx3n8wRbQtkSr84RgCLDw1ijymaxg6AxsVAurp9TYLoczn29bS
         DhAwupciTm+SxqJp3yK9llc5pvSM61TFNkS80HLyUGg2BhANZV5DwrB1tg7LevIOeu
         itNTrQLjOfDSItVkL3buf/D4bc1Xng3ijuuRH8js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 18/28] netfilter: egress: silence egress hook lockdep splats
Date:   Thu, 17 Mar 2022 13:46:09 +0100
Message-Id: <20220317124527.285482124@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 17a8f31bba7bac8cce4bd12bab50697da96e7710 ]

Netfilter assumes its called with rcu_read_lock held, but in egress
hook case it may be called with BH readlock.

This triggers lockdep splat.

In order to avoid to change all rcu_dereference() to
rcu_dereference_check(..., rcu_read_lock_bh_held()), wrap nf_hook_slow
with read lock/unlock pair.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_netdev.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b4dd96e4dc8d..e6487a691136 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -101,7 +101,11 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
 			   NFPROTO_NETDEV, dev, NULL, NULL,
 			   dev_net(dev), NULL);
+
+	/* nf assumes rcu_read_lock, not just read_lock_bh */
+	rcu_read_lock();
 	ret = nf_hook_slow(skb, &state, e, 0);
+	rcu_read_unlock();
 
 	if (ret == 1) {
 		return skb;
-- 
2.34.1



