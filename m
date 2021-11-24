Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19645B165
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 02:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhKXBzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 20:55:33 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28098 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237665AbhKXBzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 20:55:32 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HzP8C3dCPz1DJcH;
        Wed, 24 Nov 2021 09:49:47 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:52:19 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:52:18 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <sgarzare@redhat.com>, <mgurtovoy@nvidia.com>, <parav@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>,
        Longpeng <longpeng2@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] vdpa_sim: avoid putting an uninitialized iova_domain
Date:   Wed, 24 Nov 2021 09:52:15 +0800
Message-ID: <20211124015215.119-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

The system will crash if we put an uninitialized iova_domain, this
could happen when an error occurs before initializing the iova_domain
in vdpasim_create().

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
RIP: 0010:__cpuhp_state_remove_instance+0x96/0x1c0
...
Call Trace:
 <TASK>
 put_iova_domain+0x29/0x220
 vdpasim_free+0xd1/0x120 [vdpa_sim]
 vdpa_release_dev+0x21/0x40 [vdpa]
 device_release+0x33/0x90
 kobject_release+0x63/0x160
 vdpasim_create+0x127/0x2a0 [vdpa_sim]
 vdpasim_net_dev_add+0x7d/0xfe [vdpa_sim_net]
 vdpa_nl_cmd_dev_add_set_doit+0xe1/0x1a0 [vdpa]
 genl_family_rcv_msg_doit+0x112/0x140
 genl_rcv_msg+0xdf/0x1d0
 ...

So we must make sure the iova_domain is already initialized before
put it.

In addition, we may get the following warning in this case:
WARNING: ... drivers/iommu/iova.c:344 iova_cache_put+0x58/0x70

So we must make sure the iova_cache_put() is invoked only if the
iova_cache_get() is already invoked. Let's fix it together.

Cc: stable@vger.kernel.org
Fixes: 4080fc106750 ("vdpa_sim: use iova module to allocate IOVA addresses")
Signed-off-by: Longpeng <longpeng2@huawei.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
Changes v2 -> v1:
 - add "Fixes" tag [Parav, Jason]

---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 5f484ff..41b0cd1 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -591,8 +591,11 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 		vringh_kiov_cleanup(&vdpasim->vqs[i].in_iov);
 	}
 
-	put_iova_domain(&vdpasim->iova);
-	iova_cache_put();
+	if (vdpa_get_dma_dev(vdpa)) {
+		put_iova_domain(&vdpasim->iova);
+		iova_cache_put();
+	}
+
 	kvfree(vdpasim->buffer);
 	if (vdpasim->iommu)
 		vhost_iotlb_free(vdpasim->iommu);
-- 
1.8.3.1

