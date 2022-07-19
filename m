Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6E579E32
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242572AbiGSM6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbiGSM6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F665F106;
        Tue, 19 Jul 2022 05:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D0E6618F1;
        Tue, 19 Jul 2022 12:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4BFC341C6;
        Tue, 19 Jul 2022 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233411;
        bh=JFj+LVCeBm8RwxCHRYQqnzhufZo45CcRt8VNjkTJA6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA3YbHojfMvEDxXhiuTRllr+bq7xoOrBzP6XHBBmhrdhzD+FSu/ozwl5qUCqhY9DA
         H1OEjaTknaywBAzWn/CIvhQiM8LSj/wmMhG8tqBAqxi1foSJfdrtjj1pJTRO8yUCS9
         WKm6bXWG2zZT2p/wF03nmF+TVA/rVL2wXQn6Ja6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 113/231] icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
Date:   Tue, 19 Jul 2022 13:53:18 +0200
Message-Id: <20220719114724.048794263@linuxfoundation.org>
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

[ Upstream commit 4a2f7083cc6cb72dade9a63699ca352fad26d1cd ]

While reading sysctl_icmp_echo_enable_probe, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Fixes: 1fd07f33c3ea ("ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 2 +-
 net/ipv6/icmp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 92eaa96a9ff1..7edc8a3b1646 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1025,7 +1025,7 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	u16 ident_len;
 	u8 status;
 
-	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 		return false;
 
 	/* We currently only support probing interfaces on the proxy node
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e6b978ea0e87..26554aa6fc1b 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -919,7 +919,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		break;
 	case ICMPV6_EXT_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
-		    net->ipv4.sysctl_icmp_echo_enable_probe)
+		    READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 			icmpv6_echo_reply(skb);
 		break;
 
-- 
2.35.1



