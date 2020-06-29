Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15A320E592
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgF2Vir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgF2Skc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0DF23F38;
        Mon, 29 Jun 2020 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443915;
        bh=Qp3WQi3mUWW6e1xm4+yonVEJCVbUNaBsHU1YJMvnbXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QG1l74y69VjegtAlIoy1Ja8/mGT7g2rTOGoY69NKrySnNUzNehUXPdnkdhNmq0Eob
         9I58z/QdgM8VNYRucQcTygyvNXROrAkReh15/8k31Ak+22+wmGGSqHFMqqo0rjlQ+f
         AchXof7qQ6zE/wCr7EvZssYjDTIVI4eauOWC0s+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     guodeqing <geffrey.guo@huawei.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 015/265] net: Fix the arp error in some cases
Date:   Mon, 29 Jun 2020 11:14:08 -0400
Message-Id: <20200629151818.2493727-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: guodeqing <geffrey.guo@huawei.com>

[ Upstream commit 5eea3a63ff4aba6a26002e657a6d21934b7e2b96 ]

ie.,
$ ifconfig eth0 6.6.6.6 netmask 255.255.255.0

$ ip rule add from 6.6.6.6 table 6666

$ ip route add 9.9.9.9 via 6.6.6.6

$ ping -I 6.6.6.6 9.9.9.9
PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.

3 packets transmitted, 0 received, 100% packet loss, time 2079ms

$ arp
Address     HWtype  HWaddress           Flags Mask            Iface
6.6.6.6             (incomplete)                              eth0

The arp request address is error, this is because fib_table_lookup in
fib_check_nh lookup the destnation 9.9.9.9 nexthop, the scope of
the fib result is RT_SCOPE_LINK,the correct scope is RT_SCOPE_HOST.
Here I add a check of whether this is RT_TABLE_MAIN to solve this problem.

Fixes: 3bfd847203c6 ("net: Use passed in table for nexthop lookups")
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 55ca2e5218280..871c035be31f2 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1109,7 +1109,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 		if (fl4.flowi4_scope < RT_SCOPE_LINK)
 			fl4.flowi4_scope = RT_SCOPE_LINK;
 
-		if (table)
+		if (table && table != RT_TABLE_MAIN)
 			tbl = fib_get_table(net, table);
 
 		if (tbl)
-- 
2.25.1

