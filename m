Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB94A147A8F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgAXJec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgAXJea (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:34:30 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756E0208C4;
        Fri, 24 Jan 2020 09:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858470;
        bh=UWe+avLKYhIBVih7UNmNgdeVUfUXLjmEhVY+iKT1I38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeXboqjiJKGgNqD89G/87KdvyWIic6WDv26QHcHrs4gXYL6I/NWWAFcFhPrGw/zw0
         d7tIgU9vT3aeldXBOYLnifY2cwgpoOsMb0cY2wLMbk5LS2Zl1nIl3J2dwIcwMU0I+u
         87Lq+hXnrWpae2pR2Z55yIU+229XOR4rc2M/q3jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 026/102] tipc: fix wrong socket reference counter after tipc_sk_timeout() returns
Date:   Fri, 24 Jan 2020 10:30:27 +0100
Message-Id: <20200124092810.129279017@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

commit 91a4a3eb433e4d786420c41f3c08d1d16c605962 upstream.

When tipc_sk_timeout() is executed but user space is grabbing
ownership, this function rearms itself and returns. However, the
socket reference counter is not reduced. This causes potential
unexpected behavior.

This commit fixes it by calling sock_put() before tipc_sk_timeout()
returns in the above-mentioned case.

Fixes: afe8792fec69 ("tipc: refactor function tipc_sk_timeout()")
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2687,6 +2687,7 @@ static void tipc_sk_timeout(struct timer
 	if (sock_owned_by_user(sk)) {
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + HZ / 20);
 		bh_unlock_sock(sk);
+		sock_put(sk);
 		return;
 	}
 


