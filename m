Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19285657DA9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiL1Ppf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiL1Ppe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B70175BE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA7BB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C94C433D2;
        Wed, 28 Dec 2022 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242330;
        bh=gaX2EA+0i5+uWOb8V/ekuvtOzAQeu4uTFtlGJmSCzm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYnSK/Ui4jTEDO4unGgB/HzY82LU1WmBF+CX56ALn2sENlnyllqyr3TUCVYv1Cvkn
         Dj2VuDYLIdbtI4MNvV8SlE0UtI1Qn6FugfhKEL01c4sjVwh1r8z3+ygYHYVUb+Isv1
         w5oo54NOX6ZleevufdS2fX8PmHG7BwxgcaijvRSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kirill Tkhai <tkhai@ya.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 591/731] unix: Fix race in SOCK_SEQPACKETs unix_dgram_sendmsg()
Date:   Wed, 28 Dec 2022 15:41:38 +0100
Message-Id: <20221228144313.674498074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <tkhai@ya.ru>

[ Upstream commit 3ff8bff704f4de125dca2262e5b5b963a3da1d87 ]

There is a race resulting in alive SOCK_SEQPACKET socket
may change its state from TCP_ESTABLISHED to TCP_CLOSE:

unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
  sock_orphan(peer)
    sock_set_flag(peer, SOCK_DEAD)
                                           sock_alloc_send_pskb()
                                             if !(sk->sk_shutdown & SEND_SHUTDOWN)
                                               OK
                                           if sock_flag(peer, SOCK_DEAD)
                                             sk->sk_state = TCP_CLOSE
  sk->sk_shutdown = SHUTDOWN_MASK

After that socket sk remains almost normal: it is able to connect, listen, accept
and recvmsg, while it can't sendmsg.

Since this is the only possibility for alive SOCK_SEQPACKET to change
the state in such way, we should better fix this strange and potentially
danger corner case.

Note, that we will return EPIPE here like this is normally done in sock_alloc_send_pskb().
Originally used ECONNREFUSED looks strange, since it's strange to return
a specific retval in dependence of race in kernel, when user can't affect on this.

Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
to fix race with unix_dgram_connect():

unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
                                       unix_peer(sk) = NULL
                                       unix_state_unlock(sk)
  unix_state_double_lock(sk, other)
  sk->sk_state  = TCP_ESTABLISHED
  unix_peer(sk) = other
  unix_state_double_unlock(sk, other)
                                       sk->sk_state  = TCP_CLOSED

This patch fixes both of these races.

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Link: https://lore.kernel.org/r/135fda25-22d5-837a-782b-ceee50e19844@ya.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 545823c1d5ed..0a59a00cb581 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1865,13 +1865,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			unix_state_lock(sk);
 
 		err = 0;
-		if (unix_peer(sk) == other) {
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			/* We are here only when racing with unix_release_sock()
+			 * is clearing @other. Never change state to TCP_CLOSE
+			 * unlike SOCK_DGRAM wants.
+			 */
+			unix_state_unlock(sk);
+			err = -EPIPE;
+		} else if (unix_peer(sk) == other) {
 			unix_peer(sk) = NULL;
 			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
 
+			sk->sk_state = TCP_CLOSE;
 			unix_state_unlock(sk);
 
-			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;
-- 
2.35.1



