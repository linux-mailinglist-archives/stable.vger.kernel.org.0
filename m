Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28DF3CA60C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbhGOSp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236971AbhGOSpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C9561396;
        Thu, 15 Jul 2021 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374580;
        bh=pzV0TO+GBJ8LSqk5I/LiZ5KgXN2MACgT5QmQXiGibMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQAhOuerGU99iRIcT1uurHtBzRdu3RDedLu9gVhEbSgx6W4JLbrssKiGKIHpN80SB
         UcrP1ysiSsCYwjIaftEPDnik63n4j/40OnSq9HZ0gg1OKPBqe7ZEgzS+r/Zn5qjJ/i
         1yna73gHMdOaLNnW2k7pstK5uUDSSD4GnCLXYz8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/122] sfc: avoid double pci_remove of VFs
Date:   Thu, 15 Jul 2021 20:38:25 +0200
Message-Id: <20210715182504.678611891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 45423cff1db66cf0993e8a9bd0ac93e740149e49 ]

If pci_remove was called for a PF with VFs, the removal of the VFs was
called twice from efx_ef10_sriov_fini: one directly with pci_driver->remove
and another implicit by calling pci_disable_sriov, which also perform
the VFs remove. This was leading to crashing the kernel on the second
attempt.

Given that pci_disable_sriov already calls to pci remove function, get
rid of the direct call to pci_driver->remove from the driver.

2 different ways to trigger the bug:
- Create one or more VFs, then attach the PF to a virtual machine (at
  least with qemu/KVM)
- Create one or more VFs, then remove the PF with:
  echo 1 > /sys/bus/pci/devices/PF_PCI_ID/remove

Removing sfc module does not trigger the error, at least for me, because
it removes the VF first, and then the PF.

Example of a log with the error:
    list_del corruption, ffff967fd20a8ad0->next is LIST_POISON1 (dead000000000100)
    ------------[ cut here ]------------
    kernel BUG at lib/list_debug.c:47!
    [...trimmed...]
    RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
    [...trimmed...]
    Call Trace:
    efx_dissociate+0x1f/0x140 [sfc]
    efx_pci_remove+0x27/0x150 [sfc]
    pci_device_remove+0x3b/0xc0
    device_release_driver_internal+0x103/0x1f0
    pci_stop_bus_device+0x69/0x90
    pci_stop_and_remove_bus_device+0xe/0x20
    pci_iov_remove_virtfn+0xba/0x120
    sriov_disable+0x2f/0xe0
    efx_ef10_pci_sriov_disable+0x52/0x80 [sfc]
    ? pcie_aer_is_native+0x12/0x40
    efx_ef10_sriov_fini+0x72/0x110 [sfc]
    efx_pci_remove+0x62/0x150 [sfc]
    pci_device_remove+0x3b/0xc0
    device_release_driver_internal+0x103/0x1f0
    unbind_store+0xf6/0x130
    kernfs_fop_write+0x116/0x190
    vfs_write+0xa5/0x1a0
    ksys_write+0x4f/0xb0
    do_syscall_64+0x5b/0x1a0
    entry_SYSCALL_64_after_hwframe+0x65/0xca

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 52bd43f45761..695e3508b4d8 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -440,7 +440,6 @@ int efx_ef10_sriov_init(struct efx_nic *efx)
 void efx_ef10_sriov_fini(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	unsigned int i;
 	int rc;
 
 	if (!nic_data->vf) {
@@ -450,14 +449,7 @@ void efx_ef10_sriov_fini(struct efx_nic *efx)
 		return;
 	}
 
-	/* Remove any VFs in the host */
-	for (i = 0; i < efx->vf_count; ++i) {
-		struct efx_nic *vf_efx = nic_data->vf[i].efx;
-
-		if (vf_efx)
-			vf_efx->pci_dev->driver->remove(vf_efx->pci_dev);
-	}
-
+	/* Disable SRIOV and remove any VFs in the host */
 	rc = efx_ef10_pci_sriov_disable(efx, true);
 	if (rc)
 		netif_dbg(efx, drv, efx->net_dev,
-- 
2.30.2



