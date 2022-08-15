Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF22594DD2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbiHPBE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348907AbiHPBCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6E4B9F86;
        Mon, 15 Aug 2022 13:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8AE5B811AC;
        Mon, 15 Aug 2022 20:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412EFC433C1;
        Mon, 15 Aug 2022 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596635;
        bh=RZ1/XKi6ZZB/5Yh58YWyGEnCsTUCnClIq0g2pJhdLjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbCXXetj665IUObSpC9/m5FxICqzUSIVf3ickhZboXVTeBvr/4mqb1n4C6gT3k/kJ
         R/7doKoElLZ6ap1tjC8E0nr3iMkA3TsC1tEsiyzl66eIyAlVpP09pHsEsJ5jmzdwt8
         VXgs1iOO9ml7dA7xqE7gYpRQUWs9CEvgHf2kGDJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 1142/1157] raw: remove unused variables from raw6_icmp_error()
Date:   Mon, 15 Aug 2022 20:08:18 +0200
Message-Id: <20220815180526.163822703@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit c4fceb46add65481ef0dfb79cad24c3c269b4cad upstream.

saddr and daddr are set but not used.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Link: https://lore.kernel.org/r/20220622032303.159394-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -332,7 +332,6 @@ static void rawv6_err(struct sock *sk, s
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32 info)
 {
-	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
@@ -345,8 +344,6 @@ void raw6_icmp_error(struct sk_buff *skb
 	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
-		saddr = &ip6h->saddr;
-		daddr = &ip6h->daddr;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
 				  inet6_iif(skb), inet6_iif(skb)))


