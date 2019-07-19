Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A3B6DA54
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfGSEBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbfGSEBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FDB21851;
        Fri, 19 Jul 2019 04:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508883;
        bh=T9m1EC5vw6Ony5vr7aqVEUoO4PYsNMhEV4akTk7qcXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up6PljohJ9Evk4434M3BpHN+mI+ufgfOEycmVO1hlEKZPRBMca87OEPYAA3lA8Cqc
         4Lmb+tp35ekcwSjI33EjIB+gzLVTsCuS1zOTsVXTKhEZBT5A3SOpDjqAUxQW/iWiJD
         9lSJFy008oo+sarcSc7qOqLekyvGA4CIW0CeK934=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dag Moxnes <dag.moxnes@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 134/171] RDMA/core: Fix race when resolving IP address
Date:   Thu, 18 Jul 2019 23:56:05 -0400
Message-Id: <20190719035643.14300-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>

[ Upstream commit d8d9ec7dc5abbb3f11d866e983c4984f5c2de9d6 ]

Use the neighbour lock when copying the MAC address from the neighbour
data struct in dst_fetch_ha.

When not using the lock, it is possible for the function to race with
neigh_update(), causing it to copy an torn MAC address:

rdma_resolve_addr()
  rdma_resolve_ip()
    addr_resolve()
      addr_resolve_neigh()
        fetch_ha()
          dst_fetch_ha()
	     memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN)

and

net_ioctl()
  arp_ioctl()
    arp_rec_delete()
      arp_invalidate()
        neigh_update()
          __neigh_update()
	    memcpy(&neigh->ha, lladdr, dev->addr_len)

It is possible to provoke this error by calling rdma_resolve_addr() in a
tight loop, while deleting the corresponding ARP entry in another tight
loop.

Fixes: 51d45974515c ("infiniband: addr: Consolidate code to fetch neighbour hardware address from dst.")
Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 2f7d14159841..9b76a8fcdd24 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -337,7 +337,7 @@ static int dst_fetch_ha(const struct dst_entry *dst,
 		neigh_event_send(n, NULL);
 		ret = -ENODATA;
 	} else {
-		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
+		neigh_ha_snapshot(dev_addr->dst_dev_addr, n, dst->dev);
 	}
 
 	neigh_release(n);
-- 
2.20.1

