Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4871990FD
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgCaJQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgCaJQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B52D20675;
        Tue, 31 Mar 2020 09:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646175;
        bh=WQvMr/ngd0lBROOe+mFZKIghsFBX1dLvcFkiWF5f0P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApFnucclszOzJ9LJbUOkoWqgo5aQ+JzfkwBrkrYzIJnpQ+llMv40cH87xWTjZZMAi
         1HieYlghoell4aKLN4kSn/qiRWyIzCvzwIWKQp6M1zNmu7dnU95+VG2uwTRhkKFBEL
         rBJon0+6j+ipK5OU91U7hMGPASggBW81s38aBkYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/155] scsi: ipr: Fix softlockup when rescanning devices in petitboot
Date:   Tue, 31 Mar 2020 10:58:28 +0200
Message-Id: <20200331085426.045704871@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

[ Upstream commit 394b61711f3ce33f75bf70a3e22938464a13b3ee ]

When trying to rescan disks in petitboot shell, we hit the following
softlockup stacktrace:

Kernel panic - not syncing: System is deadlocked on memory
[  241.223394] CPU: 32 PID: 693 Comm: sh Not tainted 5.4.16-openpower1 #1
[  241.223406] Call Trace:
[  241.223415] [c0000003f07c3180] [c000000000493fc4] dump_stack+0xa4/0xd8 (unreliable)
[  241.223432] [c0000003f07c31c0] [c00000000007d4ac] panic+0x148/0x3cc
[  241.223446] [c0000003f07c3260] [c000000000114b10] out_of_memory+0x468/0x4c4
[  241.223461] [c0000003f07c3300] [c0000000001472b0] __alloc_pages_slowpath+0x594/0x6d8
[  241.223476] [c0000003f07c3420] [c00000000014757c] __alloc_pages_nodemask+0x188/0x1a4
[  241.223492] [c0000003f07c34a0] [c000000000153e10] alloc_pages_current+0xcc/0xd8
[  241.223508] [c0000003f07c34e0] [c0000000001577ac] alloc_slab_page+0x30/0x98
[  241.223524] [c0000003f07c3520] [c0000000001597fc] new_slab+0x138/0x40c
[  241.223538] [c0000003f07c35f0] [c00000000015b204] ___slab_alloc+0x1e4/0x404
[  241.223552] [c0000003f07c36c0] [c00000000015b450] __slab_alloc+0x2c/0x48
[  241.223566] [c0000003f07c36f0] [c00000000015b754] kmem_cache_alloc_node+0x9c/0x1b4
[  241.223582] [c0000003f07c3760] [c000000000218c48] blk_alloc_queue_node+0x34/0x270
[  241.223599] [c0000003f07c37b0] [c000000000226574] blk_mq_init_queue+0x2c/0x78
[  241.223615] [c0000003f07c37e0] [c0000000002ff710] scsi_mq_alloc_queue+0x28/0x70
[  241.223631] [c0000003f07c3810] [c0000000003005b8] scsi_alloc_sdev+0x184/0x264
[  241.223647] [c0000003f07c38a0] [c000000000300ba0] scsi_probe_and_add_lun+0x288/0xa3c
[  241.223663] [c0000003f07c3a00] [c000000000301768] __scsi_scan_target+0xcc/0x478
[  241.223679] [c0000003f07c3b20] [c000000000301c64] scsi_scan_channel.part.9+0x74/0x7c
[  241.223696] [c0000003f07c3b70] [c000000000301df4] scsi_scan_host_selected+0xe0/0x158
[  241.223712] [c0000003f07c3bd0] [c000000000303f04] store_scan+0x104/0x114
[  241.223727] [c0000003f07c3cb0] [c0000000002d5ac4] dev_attr_store+0x30/0x4c
[  241.223741] [c0000003f07c3cd0] [c0000000001dbc34] sysfs_kf_write+0x64/0x78
[  241.223756] [c0000003f07c3cf0] [c0000000001da858] kernfs_fop_write+0x170/0x1b8
[  241.223773] [c0000003f07c3d40] [c0000000001621fc] __vfs_write+0x34/0x60
[  241.223787] [c0000003f07c3d60] [c000000000163c2c] vfs_write+0xa8/0xcc
[  241.223802] [c0000003f07c3db0] [c000000000163df4] ksys_write+0x70/0xbc
[  241.223816] [c0000003f07c3e20] [c00000000000b40c] system_call+0x5c/0x68

As a part of the scan process Linux will allocate and configure a
scsi_device for each target to be scanned. If the device is not present,
then the scsi_device is torn down. As a part of scsi_device teardown a
workqueue item will be scheduled and the lockups we see are because there
are 250k workqueue items to be processed.  Accoding to the specification of
SIS-64 sas controller, max_channel should be decreased on SIS-64 adapters
to 4.

The patch fixes softlockup issue.

Thanks for Oliver Halloran's help with debugging and explanation!

Link: https://lore.kernel.org/r/1583510248-23672-1-git-send-email-wenxiong@linux.vnet.ibm.com
Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ipr.c | 3 ++-
 drivers/scsi/ipr.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 079c04bc448af..7a57b61f0340e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9947,6 +9947,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 	ioa_cfg->max_devs_supported = ipr_max_devs;
 
 	if (ioa_cfg->sis64) {
+		host->max_channel = IPR_MAX_SIS64_BUSES;
 		host->max_id = IPR_MAX_SIS64_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_SIS64_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_SIS64_DEVS)
@@ -9955,6 +9956,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					   + ((sizeof(struct ipr_config_table_entry64)
 					       * ioa_cfg->max_devs_supported)));
 	} else {
+		host->max_channel = IPR_VSET_BUS;
 		host->max_id = IPR_MAX_NUM_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_NUM_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_PHYSICAL_DEVS)
@@ -9964,7 +9966,6 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					       * ioa_cfg->max_devs_supported)));
 	}
 
-	host->max_channel = IPR_VSET_BUS;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	host->can_queue = ioa_cfg->max_cmds;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index a67baeb36d1f7..b97aa9ac2ffe5 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1300,6 +1300,7 @@ struct ipr_resource_entry {
 #define IPR_ARRAY_VIRTUAL_BUS			0x1
 #define IPR_VSET_VIRTUAL_BUS			0x2
 #define IPR_IOAFP_VIRTUAL_BUS			0x3
+#define IPR_MAX_SIS64_BUSES			0x4
 
 #define IPR_GET_RES_PHYS_LOC(res) \
 	(((res)->bus << 24) | ((res)->target << 8) | (res)->lun)
-- 
2.20.1



