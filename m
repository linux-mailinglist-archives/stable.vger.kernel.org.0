Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6128558689E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiHALvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiHALuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CCF3D59D;
        Mon,  1 Aug 2022 04:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB26612AB;
        Mon,  1 Aug 2022 11:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B318C433C1;
        Mon,  1 Aug 2022 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354547;
        bh=mn4KD0k0fVIvnt863IwUl1nXyDS8ebDv3M3Jhof39Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07ygNVKQLTh9Z9kjRezo2FRXMBm6QiESxfg/JLK5nSaMNM/yHvQjySxl8ZNtjYJ/n
         OZP4xund8sJL+sG1La570qKIXzf3NDWLO/nmdV83QPDbgakKZX/+Pu1XKP7PvyIPcY
         zIEU/pyRSw6UiMP7xrXDTOgF51t2m9UdP4vhVysA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 04/34] tcp: Fix data-races around sysctl_tcp_dsack.
Date:   Mon,  1 Aug 2022 13:46:44 +0200
Message-Id: <20220801114128.225736271@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
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

commit 58ebb1c8b35a8ef38cd6927431e0fa7b173a632d upstream.

While reading sysctl_tcp_dsack, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4260,7 +4260,7 @@ static void tcp_dsack_set(struct sock *s
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+	if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 		int mib_idx;
 
 		if (before(seq, tp->rcv_nxt))
@@ -4306,7 +4306,7 @@ static void tcp_send_dupack(struct sock
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 
-		if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+		if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 			u32 end_seq = TCP_SKB_CB(skb)->end_seq;
 
 			tcp_rcv_spurious_retrans(sk, skb);


