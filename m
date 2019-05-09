Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A535319088
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfEISpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfEISpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEF921848;
        Thu,  9 May 2019 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427546;
        bh=3AaFu5/9xyech9Rm2gGCieosPJRXBsveYZw1we/emSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CArYw++lIBmodtr4/xqlOaZGGciNVS2z9Iubjgpj52qGHP1/MRiT3uGDW4x7osoip
         pF5KHi7mNPMjA1yh9377eDUpsdRxaCFUChv5rjgf74qxrOylyz6Fh82iKDIxDxBV9X
         udGwHoOp69vgOBzHONmgWIHGz0HNw2c1FXKwV0+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>,
        Longpeng <longpeng2@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/42] virtio_pci: fix a NULL pointer reference in vp_del_vqs
Date:   Thu,  9 May 2019 20:42:11 +0200
Message-Id: <20190509181257.144468524@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6a8aae68c87349dbbcd46eac380bc43cdb98a13b ]

If the msix_affinity_masks is alloced failed, then we'll
try to free some resources in vp_free_vectors() that may
access it directly.

We met the following stack in our production:
[   29.296767] BUG: unable to handle kernel NULL pointer dereference at  (null)
[   29.311151] IP: [<ffffffffc04fe35a>] vp_free_vectors+0x6a/0x150 [virtio_pci]
[   29.324787] PGD 0
[   29.333224] Oops: 0000 [#1] SMP
[...]
[   29.425175] RIP: 0010:[<ffffffffc04fe35a>]  [<ffffffffc04fe35a>] vp_free_vectors+0x6a/0x150 [virtio_pci]
[   29.441405] RSP: 0018:ffff9a55c2dcfa10  EFLAGS: 00010206
[   29.453491] RAX: 0000000000000000 RBX: ffff9a55c322c400 RCX: 0000000000000000
[   29.467488] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9a55c322c400
[   29.481461] RBP: ffff9a55c2dcfa20 R08: 0000000000000000 R09: ffffc1b6806ff020
[   29.495427] R10: 0000000000000e95 R11: 0000000000aaaaaa R12: 0000000000000000
[   29.509414] R13: 0000000000010000 R14: ffff9a55bd2d9e98 R15: ffff9a55c322c400
[   29.523407] FS:  00007fdcba69f8c0(0000) GS:ffff9a55c2840000(0000) knlGS:0000000000000000
[   29.538472] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.551621] CR2: 0000000000000000 CR3: 000000003ce52000 CR4: 00000000003607a0
[   29.565886] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.580055] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   29.594122] Call Trace:
[   29.603446]  [<ffffffffc04fe8a2>] vp_request_msix_vectors+0xe2/0x260 [virtio_pci]
[   29.618017]  [<ffffffffc04fedc5>] vp_try_to_find_vqs+0x95/0x3b0 [virtio_pci]
[   29.632152]  [<ffffffffc04ff117>] vp_find_vqs+0x37/0xb0 [virtio_pci]
[   29.645582]  [<ffffffffc057bf63>] init_vq+0x153/0x260 [virtio_blk]
[   29.658831]  [<ffffffffc057c1e8>] virtblk_probe+0xe8/0x87f [virtio_blk]
[...]

Cc: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng <longpeng2@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 1c4797e53f686..80a3704939cdc 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -254,9 +254,11 @@ void vp_del_vqs(struct virtio_device *vdev)
 	for (i = 0; i < vp_dev->msix_used_vectors; ++i)
 		free_irq(pci_irq_vector(vp_dev->pci_dev, i), vp_dev);
 
-	for (i = 0; i < vp_dev->msix_vectors; i++)
-		if (vp_dev->msix_affinity_masks[i])
-			free_cpumask_var(vp_dev->msix_affinity_masks[i]);
+	if (vp_dev->msix_affinity_masks) {
+		for (i = 0; i < vp_dev->msix_vectors; i++)
+			if (vp_dev->msix_affinity_masks[i])
+				free_cpumask_var(vp_dev->msix_affinity_masks[i]);
+	}
 
 	if (vp_dev->msix_enabled) {
 		/* Disable the vector used for configuration */
-- 
2.20.1



