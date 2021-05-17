Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307C338372D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhEQPkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244158AbhEQPi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269C661CF7;
        Mon, 17 May 2021 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262459;
        bh=LCJvXIPQx6yoGnRPf/pz2z0summskwhGTtANjV5668k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxSc/FkwTZRCJO40WLPTav3d0RpqL2m0/fAzew0UXTW3mgf6bVgoSxbTrvaitWaAU
         /o9p+XKKQP+lxJs8rkWAMtXVlS+GgAky+VvwMV6YStCzzM0vOK2Qr/xBCDD70jdw3R
         UQwf8qoybjHjNPsFFjdGlc1UaZR4XbfihASNcaiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/289] mptcp: fix splat when closing unaccepted socket
Date:   Mon, 17 May 2021 16:01:57 +0200
Message-Id: <20210517140311.569815577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 578c18eff1627d6a911f08f4cf351eca41fdcc7d ]

If userspace exits before calling accept() on a listener that had at least
one new connection ready, we get:

   Attempt to release TCP socket in state 8

This happens because the mptcp socket gets cloned when the TCP connection
is ready, but the socket is never exposed to userspace.

The client additionally sends a DATA_FIN, which brings connection into
CLOSE_WAIT state.  This in turn prevents the orphan+state reset fixup
in mptcp_sock_destruct() from doing its job.

Fixes: 3721b9b64676b ("mptcp: Track received DATA_FIN sequence number and add related helpers")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/185
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Link: https://lore.kernel.org/r/20210507001638.225468-1-mathew.j.martineau@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6317b9bc8681..01a675fa2aa2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -445,8 +445,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 	 * ESTABLISHED state and will not have the SOCK_DEAD flag.
 	 * Both result in warnings from inet_sock_destruct.
 	 */
-
-	if (sk->sk_state == TCP_ESTABLISHED) {
+	if ((1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
 		sk->sk_state = TCP_CLOSE;
 		WARN_ON_ONCE(sk->sk_socket);
 		sock_orphan(sk);
-- 
2.30.2



