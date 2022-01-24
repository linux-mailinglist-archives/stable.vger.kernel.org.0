Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11976499444
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388961AbiAXUkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59758 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385843AbiAXUel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:34:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB8561382;
        Mon, 24 Jan 2022 20:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F6C340E5;
        Mon, 24 Jan 2022 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056480;
        bh=udChFAOK6Mu/2axyC3InlsNabDd0Alqgds7LNRaJXn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojSaKvIfy5aXLDtg0b5H9iiTh1wd+WvsonkNV54H0iChkE5fl3/U9OVofE6jwCBpb
         0pYOHlF+lwNNSQcMWn/IjE3QUiIGVDFtSxMl++VMAh4IFfa95xIuCZvEOVFwC13BWj
         Ue5wPovQCDJhD/bnayppu0zBzICAIEvfiowMfdtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/846] mlxsw: pci: Add shutdown method in PCI driver
Date:   Mon, 24 Jan 2022 19:40:14 +0100
Message-Id: <20220124184118.156097507@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit c1020d3cf4752f61a6a413f632ea2ce2370e150d ]

On an arm64 platform with the Spectrum ASIC, after loading and executing
a new kernel via kexec, the following trace [1] is observed. This seems
to be caused by the fact that the device is not properly shutdown before
executing the new kernel.

Fix this by implementing a shutdown method which mirrors the remove
method, as recommended by the kexec maintainer [2][3].

[1]
BUG: Bad page state in process devlink pfn:22f73d
page:fffffe00089dcf40 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x2ffff00000000000()
raw: 2ffff00000000000 0000000000000000 ffffffff089d0201 0000000000000000
raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
page dumped because: nonzero _refcount
Modules linked in:
CPU: 1 PID: 16346 Comm: devlink Tainted: G B 5.8.0-rc6-custom-273020-gac6b365b1bf5 #44
Hardware name: Marvell Armada 7040 TX4810M (DT)
Call trace:
 dump_backtrace+0x0/0x1d0
 show_stack+0x1c/0x28
 dump_stack+0xbc/0x118
 bad_page+0xcc/0xf8
 check_free_page_bad+0x80/0x88
 __free_pages_ok+0x3f8/0x418
 __free_pages+0x38/0x60
 kmem_freepages+0x200/0x2a8
 slab_destroy+0x28/0x68
 slabs_destroy+0x60/0x90
 ___cache_free+0x1b4/0x358
 kfree+0xc0/0x1d0
 skb_free_head+0x2c/0x38
 skb_release_data+0x110/0x1a0
 skb_release_all+0x2c/0x38
 consume_skb+0x38/0x130
 __dev_kfree_skb_any+0x44/0x50
 mlxsw_pci_rdq_fini+0x8c/0xb0
 mlxsw_pci_queue_fini.isra.0+0x28/0x58
 mlxsw_pci_queue_group_fini+0x58/0x88
 mlxsw_pci_aqs_fini+0x2c/0x60
 mlxsw_pci_fini+0x34/0x50
 mlxsw_core_bus_device_unregister+0x104/0x1d0
 mlxsw_devlink_core_bus_device_reload_down+0x2c/0x48
 devlink_reload+0x44/0x158
 devlink_nl_cmd_reload+0x270/0x290
 genl_rcv_msg+0x188/0x2f0
 netlink_rcv_skb+0x5c/0x118
 genl_rcv+0x3c/0x50
 netlink_unicast+0x1bc/0x278
 netlink_sendmsg+0x194/0x390
 __sys_sendto+0xe0/0x158
 __arm64_sys_sendto+0x2c/0x38
 el0_svc_common.constprop.0+0x70/0x168
 do_el0_svc+0x28/0x88
 el0_sync_handler+0x88/0x190
 el0_sync+0x140/0x180

[2]
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1195432.html

[3]
https://patchwork.kernel.org/project/linux-scsi/patch/20170212214920.28866-1-anton@ozlabs.org/#20116693

Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index fcace73eae40f..01c3235ab2bdf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1973,6 +1973,7 @@ int mlxsw_pci_driver_register(struct pci_driver *pci_driver)
 {
 	pci_driver->probe = mlxsw_pci_probe;
 	pci_driver->remove = mlxsw_pci_remove;
+	pci_driver->shutdown = mlxsw_pci_remove;
 	return pci_register_driver(pci_driver);
 }
 EXPORT_SYMBOL(mlxsw_pci_driver_register);
-- 
2.34.1



