Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF33F54F5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhHXA6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234357AbhHXA4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE6B961440;
        Tue, 24 Aug 2021 00:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766517;
        bh=XmfFrVRY0rOuV9JryH8DCWide7HqkddN8WML/NnQJl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vm+iCmzbufivAoUDpiyaswG1Q+RsgBGvDtBD8s1lGm49k25Rd7tbMPUKdz7F/dETt
         cLhvvFYSRzRHwCsQiEkgfNwf0rfHQxKcC/ZBo894yGR8ti0hT1G1KcT7n1KIRgPWg8
         l5SUDsFsv7IEdvYmorKSkuT/STGnLzJPtogbH8BPoOc2zcxyuRnQrRQee4VwHFjiOt
         6hlOXKB4Q+Tx2/LIpZKjJPmyI2mFHKTxVoxRn1MYn2YXhD9EfqmvnjlW1IWQe4mOWy
         LBz87ZSKj3v3D48kBHwSJx1eGRXv7LpIeZiQHgXnJJ94Fq59Cl3tZxw51vmJCJAPLN
         WNQ+h32XzY+zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 03/10] virtio_pci: Support surprise removal of virtio pci device
Date:   Mon, 23 Aug 2021 20:55:05 -0400
Message-Id: <20210824005513.631557-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005513.631557-1-sashal@kernel.org>
References: <20210824005513.631557-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 43bb40c5b92659966bdf4bfe584fde0a3575a049 ]

When a virtio pci device undergo surprise removal (aka async removal in
PCIe spec), mark the device as broken so that any upper layer drivers can
abort any outstanding operation.

When a virtio net pci device undergo surprise removal which is used by a
NetworkManager, a below call trace was observed.

kernel:watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [kworker/1:1:27059]
watchdog: BUG: soft lockup - CPU#1 stuck for 52s! [kworker/1:1:27059]
CPU: 1 PID: 27059 Comm: kworker/1:1 Tainted: G S      W I  L    5.13.0-hotplug+ #8
Hardware name: Dell Inc. PowerEdge R640/0H28RR, BIOS 2.9.4 11/06/2020
Workqueue: events linkwatch_event
RIP: 0010:virtnet_send_command+0xfc/0x150 [virtio_net]
Call Trace:
 virtnet_set_rx_mode+0xcf/0x2a7 [virtio_net]
 ? __hw_addr_create_ex+0x85/0xc0
 __dev_mc_add+0x72/0x80
 igmp6_group_added+0xa7/0xd0
 ipv6_mc_up+0x3c/0x60
 ipv6_find_idev+0x36/0x80
 addrconf_add_dev+0x1e/0xa0
 addrconf_dev_config+0x71/0x130
 addrconf_notify+0x1f5/0xb40
 ? rtnl_is_locked+0x11/0x20
 ? __switch_to_asm+0x42/0x70
 ? finish_task_switch+0xaf/0x2c0
 ? raw_notifier_call_chain+0x3e/0x50
 raw_notifier_call_chain+0x3e/0x50
 netdev_state_change+0x67/0x90
 linkwatch_do_dev+0x3c/0x50
 __linkwatch_run_queue+0xd2/0x220
 linkwatch_event+0x21/0x30
 process_one_work+0x1c8/0x370
 worker_thread+0x30/0x380
 ? process_one_work+0x370/0x370
 kthread+0x118/0x140
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30

Hence, add the ability to abort the command on surprise removal
which prevents infinite loop and system lockup.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://lore.kernel.org/r/20210721142648.1525924-5-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 45b04bc91f24..b7cc63f556ee 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -579,6 +579,13 @@ static void virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 	struct device *dev = get_device(&vp_dev->vdev.dev);
 
+	/*
+	 * Device is marked broken on surprise removal so that virtio upper
+	 * layers can abort any ongoing operation.
+	 */
+	if (!pci_device_is_present(pci_dev))
+		virtio_break_device(&vp_dev->vdev);
+
 	pci_disable_sriov(pci_dev);
 
 	unregister_virtio_device(&vp_dev->vdev);
-- 
2.30.2

