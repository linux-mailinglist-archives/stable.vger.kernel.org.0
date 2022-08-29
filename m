Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0E5A49CC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiH2L3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiH2L3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FC26BCE6;
        Mon, 29 Aug 2022 04:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A975161214;
        Mon, 29 Aug 2022 11:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D2C433C1;
        Mon, 29 Aug 2022 11:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771713;
        bh=3atjrCF4bTBJ7Czyu6rwJ5nPUCtBgLWsV7O/DA09F+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/2El6v4IjyfhnkTtEoi+44JQoORLQ6TmTqwTVRsRmm8gwHxlaZ3lqkC0/F5bNXQH
         xv/3dj/Hp6y5onnbQxSsIYdgfoskhCHV9uiADgwWnXWTcYmQ1RCcdkCrjedMRVhy6v
         3L9sPKcKzKFFuCBYWH6d+XI5u1hEvLLgcB5Dklmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 071/158] net: Fix a data-race around sysctl_tstamp_allow_data.
Date:   Mon, 29 Aug 2022 12:58:41 +0200
Message-Id: <20220829105811.988472460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

[ Upstream commit d2154b0afa73c0159b2856f875c6b4fe7cf6a95e ]

While reading sysctl_tstamp_allow_data, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: b245be1f4db1 ("net-timestamp: no-payload only sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d827..bebf58464d667 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4772,7 +4772,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
-- 
2.35.1



