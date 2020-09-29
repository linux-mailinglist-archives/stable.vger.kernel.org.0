Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C61227C803
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgI2LmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbgI2Ll5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C72D206A5;
        Tue, 29 Sep 2020 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379716;
        bh=mQuNhQ2qow8drIVBTh6YiAbV1CoN1qj3OWdYWoENEcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzHrawHXFIHxS7I/A+Te3n8WqNpXZKNc40WTr9jI3GaSXRgqLyKXVHWy0b4WHbIAn
         BN3z6v3/pdlDx90LBNRI5rQQwGzHs+rFmB1SeCKtbDhKVgY0HqlHzbQBzb8sXNxRqE
         TBiiigjWl5UWxw90RtKtVYkWpu5N36owKsb25aJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Thang Ngo <thang.h.ngo@dektech.com.au>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/388] tipc: fix memory leak in service subscripting
Date:   Tue, 29 Sep 2020 12:59:48 +0200
Message-Id: <20200929110022.914885230@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 0771d7df819284d46cf5cfb57698621b503ec17f ]

Upon receipt of a service subscription request from user via a topology
connection, one 'sub' object will be allocated in kernel, so it will be
able to send an event of the service if any to the user correspondingly
then. Also, in case of any failure, the connection will be shutdown and
all the pertaining 'sub' objects will be freed.

However, there is a race condition as follows resulting in memory leak:

       receive-work       connection        send-work
              |                |                |
        sub-1 |<------//-------|                |
        sub-2 |<------//-------|                |
              |                |<---------------| evt for sub-x
        sub-3 |<------//-------|                |
              :                :                :
              :                :                :
              |       /--------|                |
              |       |        * peer closed    |
              |       |        |                |
              |       |        |<-------X-------| evt for sub-y
              |       |        |<===============|
        sub-n |<------/        X    shutdown    |
    -> orphan |                                 |

That is, the 'receive-work' may get the last subscription request while
the 'send-work' is shutting down the connection due to peer close.

We had a 'lock' on the connection, so the two actions cannot be carried
out simultaneously. If the last subscription is allocated e.g. 'sub-n',
before the 'send-work' closes the connection, there will be no issue at
all, the 'sub' objects will be freed. In contrast the last subscription
will become orphan since the connection was closed, and we released all
references.

This commit fixes the issue by simply adding one test if the connection
remains in 'connected' state right after we obtain the connection lock,
then a subscription object can be created as usual, otherwise we ignore
it.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Reported-by: Thang Ngo <thang.h.ngo@dektech.com.au>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 73dbed0c4b6b8..931c426673c02 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -400,7 +400,9 @@ static int tipc_conn_rcv_from_sock(struct tipc_conn *con)
 		return -EWOULDBLOCK;
 	if (ret == sizeof(s)) {
 		read_lock_bh(&sk->sk_callback_lock);
-		ret = tipc_conn_rcv_sub(srv, con, &s);
+		/* RACE: the connection can be closed in the meantime */
+		if (likely(connected(con)))
+			ret = tipc_conn_rcv_sub(srv, con, &s);
 		read_unlock_bh(&sk->sk_callback_lock);
 		if (!ret)
 			return 0;
-- 
2.25.1



