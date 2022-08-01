Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A6A58696A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiHAMCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiHAMBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAC84F65C;
        Mon,  1 Aug 2022 04:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD99DB810A2;
        Mon,  1 Aug 2022 11:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C5FC433D6;
        Mon,  1 Aug 2022 11:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354800;
        bh=xxhsfMY3ok9TbG2hC+nbsICfFlUN65e0HBoVgAo4llM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaLwhs3xNdkfljlR0O6egFGZp4vxj584btuqeUagUP0K77Ert2Te8usnqY32JoQDO
         DjxyJQ/RKgv1CJUAc7gd32JaJmidGQcYr6+xKQfEbxzkcjGOIYQcRfrmPfjoHtIjef
         rcxH5dJKghme8W/Mfcywv5Rajxmt1d5S4DBcwsLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 25/69] tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
Date:   Mon,  1 Aug 2022 13:46:49 +0200
Message-Id: <20220801114135.534159123@linuxfoundation.org>
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
@@ -716,7 +716,7 @@ void tcp_rcv_space_adjust(struct sock *s
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1881,7 +1881,7 @@ static void mptcp_rcv_space_adjust(struc
 	if (msk->rcvq_space.copied <= msk->rcvq_space.space)
 		goto new_measure;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;


