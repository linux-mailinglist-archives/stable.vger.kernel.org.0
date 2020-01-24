Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890A1147E6E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbgAXKJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgAXKJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:09:01 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B75D20709;
        Fri, 24 Jan 2020 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860540;
        bh=1PhDrFQUblKDeG2RNppE13vr8ZJX73edvGecStNf82w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX3GcEQGwCO3iST6xcLkqklMjkgmPeTdKPPO8egTmmBT1hKHfW/+bQfdNKulv/Pf+
         wkQfOg5QfZihSVjNJaffxzRB2I2Nl6ISdDyOA6or3xIObM/obX9R1Iz1gt6NklDrPj
         mWog75FBjtiVX5/G7lMIy9asEaE2JVbPqvlT5upE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 010/639] tipc: fix wrong timeout input for tipc_wait_for_cond()
Date:   Fri, 24 Jan 2020 10:23:00 +0100
Message-Id: <20200124093048.355200483@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

commit 12db3c8083fcab4270866a88191933f2d9f24f89 upstream.

In function __tipc_shutdown(), the timeout value passed to
tipc_wait_for_cond() is not jiffies.

This commit fixes it by converting that value from milliseconds
to jiffies.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -501,7 +501,7 @@ static void __tipc_shutdown(struct socke
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct net *net = sock_net(sk);
-	long timeout = CONN_TIMEOUT_DEFAULT;
+	long timeout = msecs_to_jiffies(CONN_TIMEOUT_DEFAULT);
 	u32 dnode = tsk_peer_node(tsk);
 	struct sk_buff *skb;
 


