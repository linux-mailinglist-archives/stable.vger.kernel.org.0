Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D13579B0C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiGSMY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiGSMYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81B45FAD2;
        Tue, 19 Jul 2022 05:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44DDE616FD;
        Tue, 19 Jul 2022 12:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DEFC341C6;
        Tue, 19 Jul 2022 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232464;
        bh=/zK32ft4S+oGulxYs7170gjT3SrkyDPt0R3DVNAN6xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOsD66bZUKIa82G7ifV91TazDJpH99AnmdnB5sRuhtvDLJECipeUTX4MTEG0vvySz
         b0z/2iqgWwDy6BI1XP2ecrKM2uQso8b1M1XY8KeXjTiQJ945omQ3Hu84Guzcw5axFY
         STnRUrw1LTdC+z99W52p7dCSdVplquN6X2VXXl9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanghang Liu <yanghliu@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/112] sfc: fix use after free when disabling sriov
Date:   Tue, 19 Jul 2022 13:54:00 +0200
Message-Id: <20220719114633.002242858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit ebe41da5d47ac0fff877e57bd14c54dccf168827 ]

Use after free is detected by kfence when disabling sriov. What was read
after being freed was vf->pci_dev: it was freed from pci_disable_sriov
and later read in efx_ef10_sriov_free_vf_vports, called from
efx_ef10_sriov_free_vf_vswitching.

Set the pointer to NULL at release time to not trying to read it later.

Reproducer and dmesg log (note that kfence doesn't detect it every time):
$ echo 1 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
$ echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs

 BUG: KFENCE: use-after-free read in efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]

 Use-after-free read at 0x00000000ff3c1ba5 (in kfence-#224):
  efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
  efx_ef10_pci_sriov_disable+0x38/0x70 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xfe/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 kfence-#224: 0x00000000edb8ef95-0x00000000671f5ce1, size=2792, cache=kmalloc-4k

 allocated by task 6771 on cpu 10 at 3137.860196s:
  pci_alloc_dev+0x21/0x60
  pci_iov_add_virtfn+0x2a2/0x320
  sriov_enable+0x212/0x3e0
  efx_ef10_sriov_configure+0x67/0x80 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xba/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 freed by task 6771 on cpu 12 at 3170.991309s:
  device_release+0x34/0x90
  kobject_cleanup+0x3a/0x130
  pci_iov_remove_virtfn+0xd9/0x120
  sriov_disable+0x30/0xe0
  efx_ef10_pci_sriov_disable+0x57/0x70 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xfe/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 3c5eb87605e85 ("sfc: create vports for VFs and assign random MAC addresses")
Reported-by: Yanghang Liu <yanghliu@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20220712062642.6915-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 84041cd587d7..b44acb6e3953 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -411,8 +411,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int vfs_assigned = pci_vfs_assigned(dev);
-	int rc = 0;
+	int i, rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -420,10 +421,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 		return -EBUSY;
 	}
 
-	if (!vfs_assigned)
+	if (!vfs_assigned) {
+		for (i = 0; i < efx->vf_count; i++)
+			nic_data->vf[i].pci_dev = NULL;
 		pci_disable_sriov(dev);
-	else
+	} else {
 		rc = -EBUSY;
+	}
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
-- 
2.35.1



