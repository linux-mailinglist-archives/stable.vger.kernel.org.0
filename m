Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3B65834B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiL1Qp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiL1Qov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2880E13D56
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D1461563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA7FC433D2;
        Wed, 28 Dec 2022 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245653;
        bh=Hln3OcNAJSj6OQZ6OZoMgGqi4OW8XP9X8jkvduahby0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNuQZf0Bi0pI54QDyi/1Z9klsRGFO+y6lGcFUsWBZoreiGeYuMk3ol1VTtrnRAYvJ
         /vxIfMn3rtPdCpS2UvncLuIZfyaBo7na3q47bD19AMQ51scV5hJvjGw4PfMq10HOuG
         TwI8iR99UgXnsuN+5xu5RyYbrmiN2FW+9M86U8R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kirill Tkhai <tkhai@ya.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0900/1146] unix: Fix race in SOCK_SEQPACKETs unix_dgram_sendmsg()
Date:   Wed, 28 Dec 2022 15:40:39 +0100
Message-Id: <20221228144354.652582564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index ede2b2a140a4..f0c2293f1d3b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1999,13 +1999,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
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



