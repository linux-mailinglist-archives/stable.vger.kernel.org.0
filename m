Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D325E586A65
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiHAMQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiHAMPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301C17A519;
        Mon,  1 Aug 2022 04:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76E7D601BD;
        Mon,  1 Aug 2022 11:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC71C433D6;
        Mon,  1 Aug 2022 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355107;
        bh=o8COW7HGUbdghPKHXH+743bq+xK9nKbl1dSwaMzfLyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKARKcSN+nb6WqmzQzB/OGywAuYhrlnbnR9XiUF6RfKu+SX68IdiTIrwHAT1vENau
         8CELF4+P6WwRMdpuV54etP5ns4quZZk7XDthCwu8sU+XFAGL5ibxG8aI5seSPsZuZ5
         dfLQm3o9b0QrHzxXPhEEWfFNvaj3LZtcL3GlHmWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 35/88] tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
Date:   Mon,  1 Aug 2022 13:46:49 +0200
Message-Id: <20220801114139.634683929@linuxfoundation.org>
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

commit 780476488844e070580bfc9e3bc7832ec1cea883 upstream.

While reading sysctl_tcp_moderate_rcvbuf, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 net/mptcp/protocol.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -724,7 +724,7 @@ void tcp_rcv_space_adjust(struct sock *s
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1882,7 +1882,7 @@ static void mptcp_rcv_space_adjust(struc
 	if (msk->rcvq_space.copied <= msk->rcvq_space.space)
 		goto new_measure;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;


