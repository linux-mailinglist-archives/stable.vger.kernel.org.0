Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27D1D0E64
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgEMJwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387853AbgEMJwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D49C20753;
        Wed, 13 May 2020 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363572;
        bh=6Nj0ivymC0ECNsWFCc3YPYlbmxZtWC1YnpOr92BuU0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihePZmXs0ox3WdiS50DfNw10BYQ7X0kpAdSUG0sWK1XCEIWL7jsuysR7qqaJOOH03
         I9U9TU8p598K1XsUymybBXgcDif6Hm6kRdqnwjq7ICO3Qht2gZWkOB1KejCBq2w705
         ZerkcJMbjwIHlTIn55DPGCCd1Ij24FPXdOZcUPS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 039/118] tipc: fix partial topology connection closure
Date:   Wed, 13 May 2020 11:44:18 +0200
Message-Id: <20200513094420.799732773@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 980d69276f3048af43a045be2925dacfb898a7be ]

When an application connects to the TIPC topology server and subscribes
to some services, a new connection is created along with some objects -
'tipc_subscription' to store related data correspondingly...
However, there is one omission in the connection handling that when the
connection or application is orderly shutdown (e.g. via SIGQUIT, etc.),
the connection is not closed in kernel, the 'tipc_subscription' objects
are not freed too.
This results in:
- The maximum number of subscriptions (65535) will be reached soon, new
subscriptions will be rejected;
- TIPC module cannot be removed (unless the objects  are somehow forced
to release first);

The commit fixes the issue by closing the connection if the 'recvmsg()'
returns '0' i.e. when the peer is shutdown gracefully. It also includes
the other unexpected cases.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/topsrv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -402,10 +402,11 @@ static int tipc_conn_rcv_from_sock(struc
 		read_lock_bh(&sk->sk_callback_lock);
 		ret = tipc_conn_rcv_sub(srv, con, &s);
 		read_unlock_bh(&sk->sk_callback_lock);
+		if (!ret)
+			return 0;
 	}
-	if (ret < 0)
-		tipc_conn_close(con);
 
+	tipc_conn_close(con);
 	return ret;
 }
 


