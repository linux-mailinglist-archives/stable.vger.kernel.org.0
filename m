Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616EA4F3804
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359840AbiDELVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349295AbiDEJtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EF813CC5;
        Tue,  5 Apr 2022 02:43:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEAA0B81B76;
        Tue,  5 Apr 2022 09:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043E5C385A3;
        Tue,  5 Apr 2022 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151823;
        bh=k5xEwT2EpCrvE2/ecRxQ9L6o9jtoomLXGOZUR/EcBEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnfscOi39nXOoGnCWUqdUi5gY8SM1gGWj+vlka3NWNH8OR1aY9hQbDUWsOYGiB87U
         7jBmxaH34700WEctNRzp1gwitkl2ySt+YTL+84CNw2JBkF0m+aYfQ+uCnIFfyixtR7
         ACqjw4R2rKdLdkHNm41BGMnmllsmMNhwvGMlgk10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/913] af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
Date:   Tue,  5 Apr 2022 09:26:56 +0200
Message-Id: <20220405070356.453123879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit e82025c623e2bf04d162bafceb66a59115814479 ]

Out-of-band data automatically places a "mark" showing wherein the
sequence the out-of-band data would have been.  If the out-of-band data
implies cancelling everything sent so far, the "mark" is helpful to flush
them.  When the socket's read pointer reaches the "mark", the ioctl() below
sets a non zero value to the arg `atmark`:

The out-of-band data is queued in sk->sk_receive_queue as well as ordinary
data and also saved in unix_sk(sk)->oob_skb.  It can be used to test if the
head of the receive queue is the out-of-band data meaning the socket is at
the "mark".

While testing that, unix_ioctl() reads unix_sk(sk)->oob_skb locklessly.
Thus, all accesses to oob_skb need some basic protection to avoid
load/store tearing which KCSAN detects when these are called concurrently:

  - ioctl(fd_a, SIOCATMARK, &atmark, sizeof(atmark))
  - send(fd_b_connected_to_a, buf, sizeof(buf), MSG_OOB)

BUG: KCSAN: data-race in unix_ioctl / unix_stream_sendmsg

write to 0xffff888003d9cff0 of 8 bytes by task 175 on cpu 1:
 unix_stream_sendmsg (net/unix/af_unix.c:2087 net/unix/af_unix.c:2191)
 sock_sendmsg (net/socket.c:705 net/socket.c:725)
 __sys_sendto (net/socket.c:2040)
 __x64_sys_sendto (net/socket.c:2048)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

read to 0xffff888003d9cff0 of 8 bytes by task 176 on cpu 0:
 unix_ioctl (net/unix/af_unix.c:3101 (discriminator 1))
 sock_do_ioctl (net/socket.c:1128)
 sock_ioctl (net/socket.c:1242)
 __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:874 fs/ioctl.c:860 fs/ioctl.c:860)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

value changed: 0xffff888003da0c00 -> 0xffff888003da0d00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 176 Comm: unix_race_oob_i Not tainted 5.17.0-rc5-59529-g83dc4c2af682 #12
Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b0bfc78e421c..826ac391a7a4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1996,7 +1996,7 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (ousk->oob_skb)
 		consume_skb(ousk->oob_skb);
 
-	ousk->oob_skb = skb;
+	WRITE_ONCE(ousk->oob_skb, skb);
 
 	scm_stat_add(other, skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
@@ -2514,9 +2514,8 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 
 	oob_skb = u->oob_skb;
 
-	if (!(state->flags & MSG_PEEK)) {
-		u->oob_skb = NULL;
-	}
+	if (!(state->flags & MSG_PEEK))
+		WRITE_ONCE(u->oob_skb, NULL);
 
 	unix_state_unlock(sk);
 
@@ -2551,7 +2550,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 				skb = NULL;
 			} else if (sock_flag(sk, SOCK_URGINLINE)) {
 				if (!(flags & MSG_PEEK)) {
-					u->oob_skb = NULL;
+					WRITE_ONCE(u->oob_skb, NULL);
 					consume_skb(skb);
 				}
 			} else if (!(flags & MSG_PEEK)) {
@@ -3006,11 +3005,10 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCATMARK:
 		{
 			struct sk_buff *skb;
-			struct unix_sock *u = unix_sk(sk);
 			int answ = 0;
 
 			skb = skb_peek(&sk->sk_receive_queue);
-			if (skb && skb == u->oob_skb)
+			if (skb && skb == READ_ONCE(unix_sk(sk)->oob_skb))
 				answ = 1;
 			err = put_user(answ, (int __user *)arg);
 		}
-- 
2.34.1



