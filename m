Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F9535BEDD
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbhDLJCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239196AbhDLI7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9BC61353;
        Mon, 12 Apr 2021 08:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217870;
        bh=BugsZkqrERlsJErcRlrgYuqkNzz+IXa+0QJs+9KPk1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4lrLA4EQqC3fJlwfbGLhUP+K7ys2FHWH9zUKsOc/yGIDU0UaSvrW+xLAHJ/NVc+W
         6SiMh+LkW8rmvONl68s7sNZjQ+d/y7CecmXW+N+Q0PFNE65plEr25EuTPkMouyd7HW
         H4wXsfrED/LW8vWxPHNQkMF67gj8g6hMcIRNtWbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/188] mptcp: forbit mcast-related sockopt on MPTCP sockets
Date:   Mon, 12 Apr 2021 10:40:55 +0200
Message-Id: <20210412084018.320400737@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 86581852d7710990d8af9dadfe9a661f0abf2114 ]

Unrolling mcast state at msk dismantel time is bug prone, as
syzkaller reported:

======================================================
WARNING: possible circular locking dependency detected
5.11.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor905/8822 is trying to acquire lock:
ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323

but task is already holding lock:
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3507

which lock already depends on the new lock.

Instead we can simply forbit any mcast-related setsockopt

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f56b2e331bb6..27f6672589ce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2245,6 +2245,48 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 	return ret;
 }
 
+static bool mptcp_unsupported(int level, int optname)
+{
+	if (level == SOL_IP) {
+		switch (optname) {
+		case IP_ADD_MEMBERSHIP:
+		case IP_ADD_SOURCE_MEMBERSHIP:
+		case IP_DROP_MEMBERSHIP:
+		case IP_DROP_SOURCE_MEMBERSHIP:
+		case IP_BLOCK_SOURCE:
+		case IP_UNBLOCK_SOURCE:
+		case MCAST_JOIN_GROUP:
+		case MCAST_LEAVE_GROUP:
+		case MCAST_JOIN_SOURCE_GROUP:
+		case MCAST_LEAVE_SOURCE_GROUP:
+		case MCAST_BLOCK_SOURCE:
+		case MCAST_UNBLOCK_SOURCE:
+		case MCAST_MSFILTER:
+			return true;
+		}
+		return false;
+	}
+	if (level == SOL_IPV6) {
+		switch (optname) {
+		case IPV6_ADDRFORM:
+		case IPV6_ADD_MEMBERSHIP:
+		case IPV6_DROP_MEMBERSHIP:
+		case IPV6_JOIN_ANYCAST:
+		case IPV6_LEAVE_ANYCAST:
+		case MCAST_JOIN_GROUP:
+		case MCAST_LEAVE_GROUP:
+		case MCAST_JOIN_SOURCE_GROUP:
+		case MCAST_LEAVE_SOURCE_GROUP:
+		case MCAST_BLOCK_SOURCE:
+		case MCAST_UNBLOCK_SOURCE:
+		case MCAST_MSFILTER:
+			return true;
+		}
+		return false;
+	}
+	return false;
+}
+
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
@@ -2253,6 +2295,9 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
+	if (mptcp_unsupported(level, optname))
+		return -ENOPROTOOPT;
+
 	if (level == SOL_SOCKET)
 		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
-- 
2.30.2



