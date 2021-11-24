Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C445C488
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351933AbhKXNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348874AbhKXNrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:47:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF74611EE;
        Wed, 24 Nov 2021 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758894;
        bh=0FRINFgcE0ibNBsRgxN0z4DIDom9Wgkvbxes2h9kzaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGobgB0myASpP77CVSX71svO1dKMDCVQglk/jQePElwVEj8avXnkp/KqTC+3Z7QII
         RGexHyCfWR3xqABv8NOVcH8aE7GhCoTp3tTz9S9nlh6ec5LcnZ+Zw/bmZyiia+IlvF
         B9iAYazG+Knb07ikbarxXGDpk5ZZn9/YLB+vSLPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wangyugui <wangyugui@e16-tech.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/279] RDMA/core: Use kvzalloc when allocating the struct ib_port
Date:   Wed, 24 Nov 2021 12:55:53 +0100
Message-Id: <20211124115720.989595278@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangyugui <wangyugui@e16-tech.com>

[ Upstream commit 911a81c9c7092bfd75432ce79b2ef879127ea065 ]

The 'struct attribute' flex array contains some struct lock_class_key's
which become big when lockdep is turned on. Big enough that some drivers
will not load when CONFIG_PROVE_LOCKING=y because they cannot allocate
enough memory:

 WARNING: CPU: 36 PID: 8 at mm/page_alloc.c:5350 __alloc_pages+0x27e/0x3e0
  Call Trace:
   kmalloc_order+0x2a/0xb0
   kmalloc_order_trace+0x19/0xf0
   __kmalloc+0x231/0x270
   ib_setup_port_attrs+0xd8/0x870 [ib_core]
   ib_register_device+0x419/0x4e0 [ib_core]
   bnxt_re_task+0x208/0x2d0 [bnxt_re]

Link: https://lore.kernel.org/r/20211019002656.17745-1-wangyugui@e16-tech.com
Signed-off-by: wangyugui <wangyugui@e16-tech.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 6146c3c1cbe5c..8d709986b88c7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -757,7 +757,7 @@ static void ib_port_release(struct kobject *kobj)
 	if (port->hw_stats_data)
 		kfree(port->hw_stats_data->stats);
 	kfree(port->hw_stats_data);
-	kfree(port);
+	kvfree(port);
 }
 
 static void ib_port_gid_attr_release(struct kobject *kobj)
@@ -1189,7 +1189,7 @@ static struct ib_port *setup_port(struct ib_core_device *coredev, int port_num,
 	struct ib_port *p;
 	int ret;
 
-	p = kzalloc(struct_size(p, attrs_list,
+	p = kvzalloc(struct_size(p, attrs_list,
 				attr->gid_tbl_len + attr->pkey_tbl_len),
 		    GFP_KERNEL);
 	if (!p)
-- 
2.33.0



