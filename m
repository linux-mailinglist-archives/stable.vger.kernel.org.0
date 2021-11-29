Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B200F461F52
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380186AbhK2Spy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378241AbhK2Snx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB93EB81637;
        Mon, 29 Nov 2021 18:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01535C53FCD;
        Mon, 29 Nov 2021 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211233;
        bh=9blOShvMbrmjZkPjvmWtij5JnAYoJQDe7JToON5Qh1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mt6ll6tC7EdFxmWpff+bPXE4dAPL5wsC9oN9nHbPFVe8s1rRVzjpOzkxQUJ4wEl3N
         O1WZRvYRoCeGWTDzvN8ezolD+eAX5mxN5lNqDYNg/7mVhnKYfL76pJkXlFv/GhCpql
         gnIToOzx2bwtWV1CgOFuIAY1+fdg02NllTywpnXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/179] net: vlan: fix underflow for the real_dev refcnt
Date:   Mon, 29 Nov 2021 19:19:03 +0100
Message-Id: <20211129181723.847656420@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 01d9cc2dea3fde3bad6d27f464eff463496e2b00 ]

Inject error before dev_hold(real_dev) in register_vlan_dev(),
and execute the following testcase:

ip link add dev dummy1 type dummy
ip link add name dummy1.100 link dummy1 type vlan id 100
ip link del dev dummy1

When the dummy netdevice is removed, we will get a WARNING as following:

=======================================================================
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 2 PID: 0 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0

and an endless loop of:

=======================================================================
unregister_netdevice: waiting for dummy1 to become free. Usage count = -1073741824

That is because dev_put(real_dev) in vlan_dev_free() be called without
dev_hold(real_dev) in register_vlan_dev(). It makes the refcnt of real_dev
underflow.

Move the dev_hold(real_dev) to vlan_dev_init() which is the call-back of
ndo_init(). That makes dev_hold() and dev_put() for vlan's real_dev
symmetrical.

Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
Reported-by: Petr Machata <petrm@nvidia.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20211126015942.2918542-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c     | 3 ---
 net/8021q/vlan_dev.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index a3a0a5e994f5a..abaa5d96ded24 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -184,9 +184,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (err)
 		goto out_unregister_netdev;
 
-	/* Account for reference in struct vlan_dev_priv */
-	dev_hold(real_dev);
-
 	vlan_stacked_transfer_operstate(real_dev, dev, vlan);
 	linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index aeeb5f90417b5..8602885c8a8e0 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -615,6 +615,9 @@ static int vlan_dev_init(struct net_device *dev)
 	if (!vlan->vlan_pcpu_stats)
 		return -ENOMEM;
 
+	/* Get vlan's reference to real_dev */
+	dev_hold(real_dev);
+
 	return 0;
 }
 
-- 
2.33.0



