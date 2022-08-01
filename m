Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA97B586985
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiHAMDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiHAMB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD81A54644;
        Mon,  1 Aug 2022 04:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F17B81170;
        Mon,  1 Aug 2022 11:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FFEC433C1;
        Mon,  1 Aug 2022 11:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354833;
        bh=bxxh2+IAkN+4Lan9mYGUY8Cn1sojk6XXjZ4q9Cgsc3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1r7uWxlceSryZTwwFQf3rD152XTqt3+iNxwpMXDknDXQb+MRDI2kmXVMkAWnQkd/
         xMFAuYciXDE3n+m8Qap3/lkbL2gqZs3UHOksaXv44NrBGKY8/QeaeSIYi6hnUnrkCE
         HZtaNXw8J2lEcDiF6kH5ccdzJXkEETH1EDU3k2ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/69] tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
Date:   Mon,  1 Aug 2022 13:47:00 +0200
Message-Id: <20220801114135.964647047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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
 net/ipv4/tcp_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1986,7 +1986,7 @@ static u32 tcp_tso_segs(struct sock *sk,
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);


