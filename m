Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C1B5941D3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244195AbiHOU4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346987AbiHOU4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07062D1E6;
        Mon, 15 Aug 2022 12:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCFF60ABC;
        Mon, 15 Aug 2022 19:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9BFC433D6;
        Mon, 15 Aug 2022 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590708;
        bh=QBGjRJFtEU+iElACBkJr5j4kRG4AHRygAmG1sCA7G9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTWWs3AL2OrfdSCgcFodbikH1OxYLFz7pXDBX+mvrkWPMK5T6RBHCbsPbriVYoJPU
         pyNtqYsC0bRM8p9KDUCN8P4PXBEQxMpSV1TznWPflX23cwI7u+dGuaKTAZeZPLPfQ2
         MB+BV9vFNNFCxkMM+xEeMTMH1pJoDgcE7ePApwJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0346/1095] raw: Fix mixed declarations error in raw_icmp_error().
Date:   Mon, 15 Aug 2022 19:55:45 +0200
Message-Id: <20220815180444.104879966@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 5da39e31b1b0eb62b8ed369ad9615da850239e9e ]

The trailing semicolon causes a compiler error, so let's remove it.

net/ipv4/raw.c: In function ‘raw_icmp_error’:
net/ipv4/raw.c:266:2: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
  266 |  struct hlist_nulls_head *hlist;
      |  ^~~~~~

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 2961421dfa68..0d534f4720c4 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -262,7 +262,7 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 
 void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 {
-	struct net *net = dev_net(skb->dev);;
+	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
 	int dif = skb->dev->ifindex;
-- 
2.35.1



