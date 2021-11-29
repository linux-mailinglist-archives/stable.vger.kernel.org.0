Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62B94624EE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhK2WdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhK2WdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:33:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2008C141B31;
        Mon, 29 Nov 2021 10:32:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87554B815E5;
        Mon, 29 Nov 2021 18:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6052C53FAD;
        Mon, 29 Nov 2021 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210749;
        bh=s58OlvY8efyiJI+qG6Tfe5JQ7Aj0Mj6BOdRWmZF3R3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy55BTtTWcULPbGR2tJ//Vw3u4IyCgJT+24fWOISRGmCWTn5dAaYcOxVDtM+zjmho
         QjJZ6D5/TSIV4JaW9JgikD0lCUs8SOgI1byZ26HeMCe8AhNiwMZKrLyETHYBMh02SB
         MzLRWVBukUUbbLQI8MeHolH89VILCkwnUWtpVhMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/121] net: vlan: fix underflow for the real_dev refcnt
Date:   Mon, 29 Nov 2021 19:18:47 +0100
Message-Id: <20211129181714.902979217@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index ad3780067a7d8..d12c9a8a9953e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -181,9 +181,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (err)
 		goto out_unregister_netdev;
 
-	/* Account for reference in struct vlan_dev_priv */
-	dev_hold(real_dev);
-
 	vlan_stacked_transfer_operstate(real_dev, dev, vlan);
 	linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index c7eba7dab0938..86a1c99025ea0 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -606,6 +606,9 @@ static int vlan_dev_init(struct net_device *dev)
 	if (!vlan->vlan_pcpu_stats)
 		return -ENOMEM;
 
+	/* Get vlan's reference to real_dev */
+	dev_hold(real_dev);
+
 	return 0;
 }
 
-- 
2.33.0



