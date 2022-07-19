Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8F579E39
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbiGSM7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbiGSM6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2555E32F;
        Tue, 19 Jul 2022 05:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C780A618F1;
        Tue, 19 Jul 2022 12:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7952C341C6;
        Tue, 19 Jul 2022 12:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233417;
        bh=6IOMZz7gILfFZJHf3t+fgNOMfg8Rc7QlheseHOz1F5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2ZpCfvh2WGzP4U/VpdTRjlu4+NziJlsIIVsS61PQW+chCdeb5yfe1M9PHFE9PFjx
         SVn83Y4RFb40Pq9ouLOlbX35e84gkyzj38uMGZxP2GToIINBML4gCjNkixL4mDaWsA
         mOqdUjKrL+oFT/invJpSULkXZ59aa/lphU1k9aE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 115/231] icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
Date:   Tue, 19 Jul 2022 13:53:20 +0200
Message-Id: <20220719114724.188064907@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b04f9b7e85c7d7aecbada620e8759a662af068d3 ]

While reading sysctl_icmp_ignore_bogus_error_responses, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c            | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2c402b4671a1..1a061d10949f 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -930,7 +930,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 	 *	get the other vendor to fix their kit.
 	 */
 
-	if (!net->ipv4.sysctl_icmp_ignore_bogus_error_responses &&
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_ignore_bogus_error_responses) &&
 	    inet_addr_type_dev_table(net, skb->dev, iph->daddr) == RTN_BROADCAST) {
 		net_warn_ratelimited("%pI4 sent an invalid ICMP type %u, code %u error to a broadcast: %pI4 on %s\n",
 				     &ip_hdr(skb)->saddr,
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6613351094ce..4cf2a6f560d4 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -630,6 +630,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_errors_use_inbound_ifaddr",
-- 
2.35.1



