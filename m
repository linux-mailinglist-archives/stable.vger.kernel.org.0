Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0B3B643E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhF1PG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235715AbhF1PEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8129361CE8;
        Mon, 28 Jun 2021 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891392;
        bh=80zjMMzXKplIKYNBqWtEYGuxkeFc2XDJqFc2Ge/+TCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEiCipb2rJ+/DGPJTJnJ6LHATu77e7ATdzzwPLcJa6VTo3+ZGbKSSbQEmr89pxZOq
         MkzkqADC8Pjms+2fzP2p2NddHmvJ6JWOdT+tT0cYCOIxYHDTo8hZMpF2/aqI/faiCu
         kziHd7x+9WU4siNtrFYX1rl0ptqVGOATxbHLzhWurOaSqL4PlFQi/W9T7Km6MzXyMY
         nR9wSSwFO4pxu4IdBz0Bta6uT+GA89Ad7CvDZb4vkFg0ssqINtT1tid+skZSpGV1fB
         pwKuwramd0WwMSK9YEshun2VLF9yWJb17lA4RmkAn2OX/9rbc+BvwcvEjQdFUm2gYg
         dkxRafEg4YMsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/57] net: rds: fix memory leak in rds_recvmsg
Date:   Mon, 28 Jun 2021 10:42:15 -0400
Message-Id: <20210628144256.34524-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9bf812509e0e..1ff4bc3237f0 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -482,7 +482,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (rds_cmsg_recv(inc, msg)) {
 			ret = -EFAULT;
-			goto out;
+			break;
 		}
 
 		rds_stats_inc(s_recv_delivered);
-- 
2.30.2

