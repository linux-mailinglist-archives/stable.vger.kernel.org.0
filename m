Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DFC14D77
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfEFOst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfEFOst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:48:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C4221655;
        Mon,  6 May 2019 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154127;
        bh=NIqcF1Fz1SPVxGY+utGxnIfpAZPTwn+MIczPKsUWh1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvvZvQz3EMuqnTHgDQWOFXGspnyjhaQMKTsOtfSO7axFeTgeqxiWLJMOVkUoLJS7s
         9EPgpYsfXw9iUYQEbstFXsrhnx+y8Xrp1MbX/eBgF9pU7YyvUv+QQ+zvJEavsAhwT5
         4BEnNQJ3VDGg9tYtV5zeIr8f1pQcIW43QDcQln6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 48/62] net: hns: Fix WARNING when remove HNS driver with SMMU enabled
Date:   Mon,  6 May 2019 16:33:19 +0200
Message-Id: <20190506143055.422198455@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8601a99d7c0256b7a7fdd1ab14cf6c1f1dfcadc6 ]

When enable SMMU, remove HNS driver will cause a WARNING:

[  141.924177] WARNING: CPU: 36 PID: 2708 at drivers/iommu/dma-iommu.c:443 __iommu_dma_unmap+0xc0/0xc8
[  141.954673] Modules linked in: hns_enet_drv(-)
[  141.963615] CPU: 36 PID: 2708 Comm: rmmod Tainted: G        W         5.0.0-rc1-28723-gb729c57de95c-dirty #32
[  141.983593] Hardware name: Huawei D05/D05, BIOS Hisilicon D05 UEFI Nemo 1.8 RC0 08/31/2017
[  142.000244] pstate: 60000005 (nZCv daif -PAN -UAO)
[  142.009886] pc : __iommu_dma_unmap+0xc0/0xc8
[  142.018476] lr : __iommu_dma_unmap+0xc0/0xc8
[  142.027066] sp : ffff000013533b90
[  142.033728] x29: ffff000013533b90 x28: ffff8013e6983600
[  142.044420] x27: 0000000000000000 x26: 0000000000000000
[  142.055113] x25: 0000000056000000 x24: 0000000000000015
[  142.065806] x23: 0000000000000028 x22: ffff8013e66eee68
[  142.076499] x21: ffff8013db919800 x20: 0000ffffefbff000
[  142.087192] x19: 0000000000001000 x18: 0000000000000007
[  142.097885] x17: 000000000000000e x16: 0000000000000001
[  142.108578] x15: 0000000000000019 x14: 363139343a70616d
[  142.119270] x13: 6e75656761705f67 x12: 0000000000000000
[  142.129963] x11: 00000000ffffffff x10: 0000000000000006
[  142.140656] x9 : 1346c1aa88093500 x8 : ffff0000114de4e0
[  142.151349] x7 : 6662666578303d72 x6 : ffff0000105ffec8
[  142.162042] x5 : 0000000000000000 x4 : 0000000000000000
[  142.172734] x3 : 00000000ffffffff x2 : ffff0000114de500
[  142.183427] x1 : 0000000000000000 x0 : 0000000000000035
[  142.194120] Call trace:
[  142.199030]  __iommu_dma_unmap+0xc0/0xc8
[  142.206920]  iommu_dma_unmap_page+0x20/0x28
[  142.215335]  __iommu_unmap_page+0x40/0x60
[  142.223399]  hnae_unmap_buffer+0x110/0x134
[  142.231639]  hnae_free_desc+0x6c/0x10c
[  142.239177]  hnae_fini_ring+0x14/0x34
[  142.246540]  hnae_fini_queue+0x2c/0x40
[  142.254080]  hnae_put_handle+0x38/0xcc
[  142.261619]  hns_nic_dev_remove+0x54/0xfc [hns_enet_drv]
[  142.272312]  platform_drv_remove+0x24/0x64
[  142.280552]  device_release_driver_internal+0x17c/0x20c
[  142.291070]  driver_detach+0x4c/0x90
[  142.298259]  bus_remove_driver+0x5c/0xd8
[  142.306148]  driver_unregister+0x2c/0x54
[  142.314037]  platform_driver_unregister+0x10/0x18
[  142.323505]  hns_nic_dev_driver_exit+0x14/0xf0c [hns_enet_drv]
[  142.335248]  __arm64_sys_delete_module+0x214/0x25c
[  142.344891]  el0_svc_common+0xb0/0x10c
[  142.352430]  el0_svc_handler+0x24/0x80
[  142.359968]  el0_svc+0x8/0x7c0
[  142.366104] ---[ end trace 60ad1cd58e63c407 ]---

The tx ring buffer map when xmit and unmap when xmit done. So in
hnae_init_ring() did not map tx ring buffer, but in hnae_fini_ring()
have a unmap operation for tx ring buffer, which is already unmapped
when xmit done, than cause this WARNING.

The hnae_alloc_buffers() is called in hnae_init_ring(),
so the hnae_free_buffers() should be in hnae_fini_ring(), not in
hnae_free_desc().

In hnae_fini_ring(), adds a check is_rx_ring() as in hnae_init_ring().
When the ring buffer is tx ring, adds a piece of code to ensure that
the tx ring is unmap.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 06bc8638501e..66e7a5fd4249 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -146,7 +146,6 @@ static int hnae_alloc_buffers(struct hnae_ring *ring)
 /* free desc along with its attached buffer */
 static void hnae_free_desc(struct hnae_ring *ring)
 {
-	hnae_free_buffers(ring);
 	dma_unmap_single(ring_to_dev(ring), ring->desc_dma_addr,
 			 ring->desc_num * sizeof(ring->desc[0]),
 			 ring_to_dma_dir(ring));
@@ -179,6 +178,9 @@ static int hnae_alloc_desc(struct hnae_ring *ring)
 /* fini ring, also free the buffer for the ring */
 static void hnae_fini_ring(struct hnae_ring *ring)
 {
+	if (is_rx_ring(ring))
+		hnae_free_buffers(ring);
+
 	hnae_free_desc(ring);
 	kfree(ring->desc_cb);
 	ring->desc_cb = NULL;
-- 
2.20.1



