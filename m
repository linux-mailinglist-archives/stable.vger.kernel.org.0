Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732FB99A0B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbfHVRJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388980AbfHVRJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:28 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C14A23405;
        Thu, 22 Aug 2019 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493766;
        bh=Pj3+j9qoBtsbQQTuBKJ89d0pJQH7ZMN6lmj1GPfksW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMT2cSyRXH+fHGJAQ20mR6ogeLIF39Ah5CTIS3UeOg4YDdfGWTuiKd37iIYKily45
         Gj+lbO8nEQ5hZWDLrJ62g+RF4k3YP98ElgSo5kObBX6F5VLVWb1ZE4xFHu+ixQ778x
         tmGlHhHIyy2vB9eHkrUHIXJoRZvJhTpY1duatdcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 134/135] netlink: Fix nlmsg_parse as a wrapper for strict message parsing
Date:   Thu, 22 Aug 2019 13:08:10 -0400
Message-Id: <20190822170811.13303-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit d00ee64e1dcf09b3afefd1340f3e9eb637272714 ]

Eric reported a syzbot warning:

BUG: KMSAN: uninit-value in nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
CPU: 0 PID: 11812 Comm: syz-executor444 Not tainted 5.3.0-rc3+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
 nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
 rtm_del_nexthop+0x1b1/0x610 net/ipv4/nexthop.c:1543
 rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
 netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
 __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
 do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x63/0xe7

The root cause is nlmsg_parse calling __nla_parse which means the
header struct size is not checked.

nlmsg_parse should be a wrapper around __nlmsg_parse with
NL_VALIDATE_STRICT for the validate argument very much like
nlmsg_parse_deprecated is for NL_VALIDATE_LIBERAL.

Fixes: 3de6440354465 ("netlink: re-add parse/validate functions in strict mode")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netlink.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 395b4406f4b08..222af2046086e 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -680,9 +680,8 @@ static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
 			      const struct nla_policy *policy,
 			      struct netlink_ext_ack *extack)
 {
-	return __nla_parse(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
-			   nlmsg_attrlen(nlh, hdrlen), policy,
-			   NL_VALIDATE_STRICT, extack);
+	return __nlmsg_parse(nlh, hdrlen, tb, maxtype, policy,
+			     NL_VALIDATE_STRICT, extack);
 }
 
 /**
-- 
2.20.1

