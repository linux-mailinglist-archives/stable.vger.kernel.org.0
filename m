Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4408206670
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388840AbgFWVmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388329AbgFWUFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:05:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10DF2078A;
        Tue, 23 Jun 2020 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942721;
        bh=jYH2ofygeD+0zmgRGpm0zRKztlE5jlZuot/MKcHt1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/CcdlIn4dDIkMXlFKfLkFG299ILJrbxa2nK97bJQ7HBJupPaEaSj15TWU5OU3zkA
         MMkMWk9P2NWCbsVX2Gs/tqwPiqj8ou2Gn1H8gks36nHv7ZBI6MFpEVLFNzNaa2rFbX
         5hfjUW4XAsC+ryxLY4SZsndZalgQ4fyGADPDUKic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 110/477] bpf: tcp: Recv() should return 0 when the peer socket is closed
Date:   Tue, 23 Jun 2020 21:51:47 +0200
Message-Id: <20200623195412.789436573@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 2c7269b231194aae23fb90ab65842573a91acbc9 ]

If the peer is closed, we will never get more data, so
tcp_bpf_wait_data will get stuck forever. In case we passed
MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
0.

>From man 2 recv:

    RETURN VALUE

    When a stream socket peer has performed an orderly shutdown, the
    return value will be 0 (the traditional "end-of-file" return).

This patch makes tcp_bpf_wait_data always return 1 when the peer
socket has been shutdown. Either we have data available, and it would
have returned 1 anyway, or there isn't, in which case we'll call
tcp_recvmsg which does the right thing in this situation.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 629aaa9a1eb99..9c5540887fbe5 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -242,6 +242,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int ret = 0;
 
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
 	if (!timeo)
 		return ret;
 
-- 
2.25.1



