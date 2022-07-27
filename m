Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C554D582C66
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbiG0QpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiG0Qob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855635F110;
        Wed, 27 Jul 2022 09:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0363061A39;
        Wed, 27 Jul 2022 16:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08706C433D6;
        Wed, 27 Jul 2022 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939474;
        bh=13RiAq2LeTI+XWlG9cn39gAKHDTZwrE6XL+Hm4O2hfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK1Gstok0x80cb0cV+h4UvYH8bA9TJBqmDZH17rvnGWtzDpdoS++Voyw8rjUfFRPV
         NPRVJTWQ0llNDdMLcbIaYzJoMVvMRhPvCBo3PuY9FVow95YAPvQesnvmcpHWI1hO4F
         vHwFCCqoMzG9Q1SORn9krK/3MwNqS1e+qRmnbA3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/87] tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
Date:   Wed, 27 Jul 2022 18:10:44 +0200
Message-Id: <20220727161011.138419746@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1a63cb91f0c2fcdeced6d6edee8d1d886583d139 ]

While reading sysctl_tcp_retrans_collapse, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5d9a1a498a18..97f29ece3800 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2871,7 +2871,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 	struct sk_buff *skb = to, *tmp;
 	bool first = true;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse))
 		return;
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		return;
-- 
2.35.1



