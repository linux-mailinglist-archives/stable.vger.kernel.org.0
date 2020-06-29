Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C59720DA3C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgF2TzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387664AbgF2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C0724811;
        Mon, 29 Jun 2020 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444333;
        bh=xiHZeVbkn0uJvIcAhgkE6AUFOK1vtmvL1otQOIYYmE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pATzCdRiq+cwvamuYzE8VjSRr2oVtFYM2w6lxv9vDi6/KBbNAR+f92h0W4xNMhhol
         Ifvugk8dy466leNu16GZTfSVRcRIMjffcCIFA5w+tI/NuyjewMa+rOydELFgdS0qMI
         fHlB8nF80T2wgcUoF0IpvUY+cNtCndBx2t/McJgI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Martitz <t.martitz@avm.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 007/178] net: bridge: enfore alignment for ethernet address
Date:   Mon, 29 Jun 2020 11:22:32 -0400
Message-Id: <20200629152523.2494198-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Martitz <t.martitz@avm.de>

[ Upstream commit db7202dec92e6caa2706c21d6fc359af318bde2e ]

The eth_addr member is passed to ether_addr functions that require
2-byte alignment, therefore the member must be properly aligned
to avoid unaligned accesses.

The problem is in place since the initial merge of multicast to unicast:
commit 6db6f0eae6052b70885562e1733896647ec1d807 bridge: multicast to unicast

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Martitz <t.martitz@avm.de>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ce2ab14ee6057..cecb4223440e7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -208,8 +208,8 @@ struct net_bridge_port_group {
 	struct rcu_head			rcu;
 	struct timer_list		timer;
 	struct br_ip			addr;
+	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
-	unsigned char			eth_addr[ETH_ALEN];
 };
 
 struct net_bridge_mdb_entry {
-- 
2.25.1

