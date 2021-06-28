Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889EF3B6278
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhF1OsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234759AbhF1OmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB2E61CDA;
        Mon, 28 Jun 2021 14:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890814;
        bh=N+bc8aPhuQ+t5a9BqUHfSsshRban8HeyM3RwcPgJgGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/Io4GqoaD8Vd69pQHKufhdFFJUtUD+TspFATfAXjwf7iUHpvs6biZZcKfVEojhpF
         VqwA2kLNU049vmxf41dA0BBafL6BrB6FMfqHFlTUmLrzevXpoVk0S0J4LlFRsBtypf
         hEaWI5gN88/WofWYDgtSEo1tYNBc1x/Dni5NFrRXDjRBdGP8krsCdtQDR06+s5q0DW
         kFCmupiBecsQfs7phk5SxpTHN8ad2qOuTkP/0dXS/JFCK7zqfoaBeY7wdTWP3RO617
         KlH7Hu6MDcAKIlXu7G6x7u+uIH0ZxWi3rpWjGRR4ly4JkMtMDPWYhhhDgJVjix6DHl
         afvzWE9JT98kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/109] rtnetlink: Fix regression in bridge VLAN configuration
Date:   Mon, 28 Jun 2021 10:31:46 -0400
Message-Id: <20210628143305.32978-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d2e381c4963663bca6f30c3b996fa4dbafe8fcb5 ]

Cited commit started returning errors when notification info is not
filled by the bridge driver, resulting in the following regression:

 # ip link add name br1 type bridge vlan_filtering 1
 # bridge vlan add dev br1 vid 555 self pvid untagged
 RTNETLINK answers: Invalid argument

As long as the bridge driver does not fill notification info for the
bridge device itself, an empty notification should not be considered as
an error. This is explained in commit 59ccaaaa49b5 ("bridge: dont send
notification when skb->len == 0 in rtnl_bridge_notify").

Fix by removing the error and add a comment to avoid future bugs.

Fixes: a8db57c1d285 ("rtnetlink: Fix missing error code in rtnl_bridge_notify()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7f2dda27f9e7..055fd09ac111 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4102,10 +4102,12 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len) {
-		err = -EINVAL;
+	/* Notification info is only filled for bridge ports, not the bridge
+	 * device itself. Therefore, a zero notification length is valid and
+	 * should not result in an error.
+	 */
+	if (!skb->len)
 		goto errout;
-	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.30.2

