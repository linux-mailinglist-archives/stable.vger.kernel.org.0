Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92D63AEF69
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFUQi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhFUQgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:36:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A396D613F0;
        Mon, 21 Jun 2021 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292907;
        bh=sSqpAn7G0ikQJoVp8p7II5Rh1NHr2QgcB5MqOwTUOHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfHoMyxTXp9lfLVRv6+C4maD1/8MoUmfU8qY6sp8j29ZjwwW/YjmMcfJSlBX0rcUi
         +mpmHkRefsoaII6gCnEZ1uWmqJDxxO7SsvJCvh62ObbUvPD+6aqpQ5n7Fm3stpBrqF
         18HAp0+/8ziPEV+GcF4Ad84U/0q/aoEfOV2yJwPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Subject: [PATCH 5.12 021/178] net: rds: fix memory leak in rds_recvmsg
Date:   Mon, 21 Jun 2021 18:13:55 +0200
Message-Id: <20210621154922.458070829@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 49bfcbfd989a8f1f23e705759a6bb099de2cff9f ]

Syzbot reported memory leak in rds. The problem
was in unputted refcount in case of error.

int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
		int msg_flags)
{
...

	if (!rds_next_incoming(rs, &inc)) {
		...
	}

After this "if" inc refcount incremented and

	if (rds_cmsg_recv(inc, msg, rs)) {
		ret = -EFAULT;
		goto out;
	}
...
out:
	return ret;
}

in case of rds_cmsg_recv() fail the refcount won't be
decremented. And it's easy to see from ftrace log, that
rds_inc_addref() don't have rds_inc_put() pair in
rds_recvmsg() after rds_cmsg_recv()

 1)               |  rds_recvmsg() {
 1)   3.721 us    |    rds_inc_addref();
 1)   3.853 us    |    rds_message_inc_copy_to_user();
 1) + 10.395 us   |    rds_cmsg_recv();
 1) + 34.260 us   |  }

Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Reported-and-tested-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index aba4afe4dfed..967d115f97ef 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -714,7 +714,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (rds_cmsg_recv(inc, msg, rs)) {
 			ret = -EFAULT;
-			goto out;
+			break;
 		}
 		rds_recvmsg_zcookie(rs, msg);
 
-- 
2.30.2



