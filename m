Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0E3B63B0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhF1O6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236995AbhF1O4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF0D61CC5;
        Mon, 28 Jun 2021 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891223;
        bh=RVPtrFADfjza2zULrp6PbGAxR2RcXL0gYJlsZQbCXow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmact7jcI7piuFO+Oo8Da7BQgdpE+A15I+x0vH/a89yGZvqGbvmPiFQuOQvXWpMi4
         +XXkOrDIcfI0s4VZ7kasyvfKcav6x8Wls1HsLEH8NSNSOsbWmoyHmyOzcdGWnXx9om
         u3MC85i0LBXbVsQJzKEpiz8zxW0G5Ig2PrINlhEoqawn4OKSTvHQQPo/x8XgZugMUZ
         liyL3EboELiC8VP1xeFnKKziVqBCkO8nQgsSNZWBtre+XEVCa0KWSqRuYUrpCFJTCA
         UhvPs5KPFsQIxPVs43Iwf/hedy2ryOCFgHAdbKQwhB5o97g8swWiuJn6usQRBNKxVt
         Awpg7EOCN+Zvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/71] net: rds: fix memory leak in rds_recvmsg
Date:   Mon, 28 Jun 2021 10:39:12 -0400
Message-Id: <20210628144003.34260-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 488a198be3e1..4bd307e31b40 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -596,7 +596,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (rds_cmsg_recv(inc, msg, rs)) {
 			ret = -EFAULT;
-			goto out;
+			break;
 		}
 
 		rds_stats_inc(s_recv_delivered);
-- 
2.30.2

