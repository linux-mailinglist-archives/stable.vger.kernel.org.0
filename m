Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19611206091
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391640AbgFWUoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403984AbgFWUoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:44:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E48218AC;
        Tue, 23 Jun 2020 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945057;
        bh=/FvxPPIPe+dQTXQL6FxQuEEeAiwkRfiSX57QfrrFAq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABByXPlXZMHARrcyp1tq7Nj0bjRti3nwy7cbiy8Y1otR20y7hh2AjuNoysnq82kT2
         3OfxfmwuYljXC3o5NxsGvj0kdZPgu5YMnQ0fKXoU5A/zTzTi5cvTiXfFjfbmkWdiEs
         YTxhdhmWOw7d0xMJ2N4GUuNTeV4rJKcap5IlCqUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/136] vfio/pci: fix memory leaks in alloc_perm_bits()
Date:   Tue, 23 Jun 2020 21:57:58 +0200
Message-Id: <20200623195304.747247165@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 3e63b94b6274324ff2e7d8615df31586de827c4e ]

vfio_pci_disable() calls vfio_config_free() but forgets to call
free_perm_bits() resulting in memory leaks,

unreferenced object 0xc000000c4db2dee0 (size 16):
  comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
  hex dump (first 16 bytes):
    00 00 ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
  backtrace:
    [<00000000a6a4552d>] alloc_perm_bits+0x58/0xe0 [vfio_pci]
    [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
    init_pci_cap_msi_perm at drivers/vfio/pci/vfio_pci_config.c:1125
    (inlined by) vfio_msi_cap_len at drivers/vfio/pci/vfio_pci_config.c:1180
    (inlined by) vfio_cap_len at drivers/vfio/pci/vfio_pci_config.c:1241
    (inlined by) vfio_cap_init at drivers/vfio/pci/vfio_pci_config.c:1468
    (inlined by) vfio_config_init at drivers/vfio/pci/vfio_pci_config.c:1707
    [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
    [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
    [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
    [<000000006577923d>] sys_ioctl+0x28/0x40
    [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
    [<0000000008ea7dd5>] system_call_common+0xf0/0x278
unreferenced object 0xc000000c4db2e330 (size 16):
  comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
  hex dump (first 16 bytes):
    00 ff ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
  backtrace:
    [<000000004c71914f>] alloc_perm_bits+0x44/0xe0 [vfio_pci]
    [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
    [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
    [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
    [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
    [<000000006577923d>] sys_ioctl+0x28/0x40
    [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
    [<0000000008ea7dd5>] system_call_common+0xf0/0x278

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Signed-off-by: Qian Cai <cai@lca.pw>
[aw: rolled in follow-up patch]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 423ea1f98441a..c2d300bc37f64 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1732,8 +1732,11 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 	vdev->vconfig = NULL;
 	kfree(vdev->pci_config_map);
 	vdev->pci_config_map = NULL;
-	kfree(vdev->msi_perm);
-	vdev->msi_perm = NULL;
+	if (vdev->msi_perm) {
+		free_perm_bits(vdev->msi_perm);
+		kfree(vdev->msi_perm);
+		vdev->msi_perm = NULL;
+	}
 }
 
 /*
-- 
2.25.1



