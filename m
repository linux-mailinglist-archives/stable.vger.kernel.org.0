Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8560D579C46
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiGSMiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiGSMhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:37:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE07B371;
        Tue, 19 Jul 2022 05:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB5E617B2;
        Tue, 19 Jul 2022 12:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD07C341C6;
        Tue, 19 Jul 2022 12:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232845;
        bh=7M6lv56eSXqjUd7Uyxbls7iULV5IVYc4PzsEmltCBpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuJLjMYsVu48M7rHfSVUWX2xM06XF/aJ2wIRa34RhbZb2fm9NkLm1ze4C7QywOxFX
         ANoWmSEnSy+VWVKHRXFa8ci4+6GK35/7EE+NyfsrIX+2iX3mdhThJEyB9IVC2cadB9
         A9yymvFpPF1KRaG2AhrjeUpPgnTXn7A3nGXrFOlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/167] icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
Date:   Tue, 19 Jul 2022 13:53:37 +0200
Message-Id: <20220719114704.803039438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 91be44180dd5..6f444b2b7d1a 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -939,7 +939,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 	 *	get the other vendor to fix their kit.
 	 */
 
-	if (!net->ipv4.sysctl_icmp_ignore_bogus_error_responses &&
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_ignore_bogus_error_responses) &&
 	    inet_addr_type_dev_table(net, skb->dev, iph->daddr) == RTN_BROADCAST) {
 		net_warn_ratelimited("%pI4 sent an invalid ICMP type %u, code %u error to a broadcast: %pI4 on %s\n",
 				     &ip_hdr(skb)->saddr,
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6f1e64d49232..51863031b178 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -639,6 +639,8 @@ static struct ctl_table ipv4_net_table[] = {
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



