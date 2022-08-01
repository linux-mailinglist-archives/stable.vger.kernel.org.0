Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F08586A46
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiHAMOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiHAMNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E690481E9;
        Mon,  1 Aug 2022 04:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E936B81171;
        Mon,  1 Aug 2022 11:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D943C433C1;
        Mon,  1 Aug 2022 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355055;
        bh=ePWGX+bbxWDVQoSt3seWjrZ7mLoFd68cBPHxv+NdNG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI0NeQecpr59Vh8Q6icPUG5WYtNT9NYd5hszKXVFKSPTshjjfAq+QkgAgS8YybFHX
         imWxaL2CVbOc+kkE0HlJ6cG/11ar7B3nUc94u6jC1xZRql14WGzLweqOlRzuivUqtK
         CT6tZl87piky22vga/zQeqA12CElr1XxYwcIrJW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 46/88] tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
Date:   Mon,  1 Aug 2022 13:47:00 +0200
Message-Id: <20220801114140.147738956@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

[ Upstream commit e0bb4ab9dfddd872622239f49fb2bd403b70853b ]

While reading sysctl_tcp_min_tso_segs, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 95bd09eb2750 ("tcp: TSO packets automatic sizing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6a3adb0222f4..08466421e7e0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1990,7 +1990,7 @@ static u32 tcp_tso_segs(struct sock *sk, unsigned int mss_now)
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);
-- 
2.35.1



