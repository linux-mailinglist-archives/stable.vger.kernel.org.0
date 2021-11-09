Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2AD44B714
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhKIWcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343811AbhKIWaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8909161251;
        Tue,  9 Nov 2021 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496444;
        bh=0FRINFgcE0ibNBsRgxN0z4DIDom9Wgkvbxes2h9kzaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUzWLk7Zpefp2Np/NDKGamUhX3HM+hoHl4/KFyWjZRqqIgxotfUICBC3of8gQTHd6
         BmTlcD7LI+OMcrdfKwBHRzGngI4xItgKxibL48g/9UT9dJ21tgxduG9uCK1ndF8f5R
         zL6jx8laq02hR30P2iBmZiIQkvYg6Fv//HuPYXh2Owp9LK8ZEKSNP6rxhFOlPpvIg/
         hblD/mJvMLwEn0ri7x5Kf4HoK2sUcfP7lZduBs9TtZJrYGogg4N1/8KEhTk7SuHQsj
         sFnQ26kuwphu+ndMNyBGBprxZ4b3dYT2iOxWdZBlSe8ml4sl3yk7zOJMKWEqgEtzYl
         Ftfg1kTvti4lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangyugui <wangyugui@e16-tech.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, dledford@redhat.com,
        sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 63/75] RDMA/core: Use kvzalloc when allocating the struct ib_port
Date:   Tue,  9 Nov 2021 17:18:53 -0500
Message-Id: <20211109221905.1234094-63-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

