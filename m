Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF3ACE8A
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbfIHMqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbfIHMqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:46:48 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7BDB2190F;
        Sun,  8 Sep 2019 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946808;
        bh=mn1PwR13D/qs8bMX7TRDKEZZ9TcCMuF895PMQM9Labk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbCm2YOhCab/LRO+Y5ww0bR4iN/0HsIfi9M/j++0X+VcuHuvdF7CvH8+2FmP9T1TQ
         Z/vyp2Eze1m4qd4DZ5BxvGTGsLkHHXH8vXzHIoOtvKXn1WE4V7E2RbqTsRW3wBmKhl
         vsQaGaCNyjiFRKqj/8Xi1Wi/zq8ROXIGCC9e3FXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/40] hv_netvsc: Fix a warning of suspicious RCU usage
Date:   Sun,  8 Sep 2019 13:41:35 +0100
Message-Id: <20190908121114.719816254@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d0d779dca73cd5acb649c54f81401f93098b298 ]

This fixes a warning of "suspicious rcu_dereference_check() usage"
when nload runs.

Fixes: 776e726bfb34 ("netvsc: fix RCU warning in get_stats")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index eb92720dd1c4a..33c1f6548fb79 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1170,12 +1170,15 @@ static void netvsc_get_stats64(struct net_device *net,
 			       struct rtnl_link_stats64 *t)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(net);
-	struct netvsc_device *nvdev = rcu_dereference_rtnl(ndev_ctx->nvdev);
+	struct netvsc_device *nvdev;
 	struct netvsc_vf_pcpu_stats vf_tot;
 	int i;
 
+	rcu_read_lock();
+
+	nvdev = rcu_dereference(ndev_ctx->nvdev);
 	if (!nvdev)
-		return;
+		goto out;
 
 	netdev_stats_to_stats64(t, &net->stats);
 
@@ -1214,6 +1217,8 @@ static void netvsc_get_stats64(struct net_device *net,
 		t->rx_packets	+= packets;
 		t->multicast	+= multicast;
 	}
+out:
+	rcu_read_unlock();
 }
 
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
-- 
2.20.1



