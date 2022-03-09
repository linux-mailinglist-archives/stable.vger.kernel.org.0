Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA784D344E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiCIQYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiCIQVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64691520E1;
        Wed,  9 Mar 2022 08:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6377D615F1;
        Wed,  9 Mar 2022 16:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D015C340E8;
        Wed,  9 Mar 2022 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842735;
        bh=yv24BEIQB2Wa9G21wq5trSJnLc3FQVzB/HOeXIspnWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l19KADzZvjJH/kZ4pJpMw0pHtWPr6vwS0mk+NN3BHpzZiufSxCruRKbHWLnuFAqYi
         h22e4VVXv2gXjMALPHk2c6fZzB2NDJUys44OgUVHJIUs95HxQF66bhUjXiVt/8wqhB
         zqBxu0k4XrkK6uA67lUtODJZsi0BKhe7wmqSkPFwBrxVcP/YjFzBtimuaFe6UJJGKl
         QYqjAn8pzXiCxyPJl1apxPM2xRp1jjOxaBwST1utsTVQHZnnfYhb9j+aafDT+52PUw
         s+4rXYji73igRwBrfaWnXfkvISIGa6bwR1KfgunxMPGbjEXBZ3L3BI0kxBlRmWp5Ei
         BgVPktjXNI/9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH AUTOSEL 5.16 18/27] netfilter: egress: silence egress hook lockdep splats
Date:   Wed,  9 Mar 2022 11:16:55 -0500
Message-Id: <20220309161711.135679-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

