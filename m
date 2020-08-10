Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EC5240A14
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgHJPiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgHJPZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E01DA20658;
        Mon, 10 Aug 2020 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073157;
        bh=LoCBf9smeqKX90IxjUKH7UtGhuBKcdKjGFseDosWpvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdCZFuWycpAmThkbxzZE4jOO3I8WqZXDjRRdZW7OL7+3Q6rptxFyrBSi5Z7JMER9I
         dJwykivaK8xiwr4DLcbnwuAuSJcpKTlIHYRrr/Guzv2t+vp+jK7VP3ZTE5QMNIfh5X
         F9W5GHmBZzq/7TGp2PK3+6XeYM8gYXlbEb4XYr3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 77/79] mptcp: fix bogus sendmsg() return code under pressure
Date:   Mon, 10 Aug 2020 17:21:36 +0200
Message-Id: <20200810151816.018579465@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8555c6bfd5fddb1cf363d3cd157d70a1bb27f718 ]

In case of memory pressure, mptcp_sendmsg() may call
sk_stream_wait_memory() after succesfully xmitting some
bytes. If the latter fails we currently return to the
user-space the error code, ignoring the succeful xmit.

Address the issue always checking for the xmitted bytes
before mptcp_sendmsg() completes.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -802,7 +802,6 @@ fallback:
 
 	mptcp_set_timeout(sk, ssk);
 	if (copied) {
-		ret = copied;
 		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
 
@@ -815,7 +814,7 @@ fallback:
 	release_sock(ssk);
 out:
 	release_sock(sk);
-	return ret;
+	return copied ? : ret;
 }
 
 static void mptcp_wait_data(struct sock *sk, long *timeo)


