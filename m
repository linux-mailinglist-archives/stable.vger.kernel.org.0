Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF4918A513
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgCRU47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbgCRU47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1748208E0;
        Wed, 18 Mar 2020 20:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565018;
        bh=hkxNcg/79RZUrIF0LmkAbhCdyGUHXAfcHDI/kypsLlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmZ/ss7Kaf2/3Pe/oH9eJH3yy1+5c6cyupMaiNWKptWbsqyjUqd8qpGY8N8IVnKlg
         tKxFGKna9vVgBCisZg2IDEjVvBqyTlPlJeXNtebV9V5vxt5cujoRRnyJqpz9hCk6ki
         +NoqvmW6UYav4cUeKE4kUugulDFBAiUxArYd1u9A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/12] scsi: ipr: Fix softlockup when rescanning devices in petitboot
Date:   Wed, 18 Mar 2020 16:56:44 -0400
Message-Id: <20200318205648.17937-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205648.17937-1-sashal@kernel.org>
References: <20200318205648.17937-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2f61d8cd58828..c321d73f602d7 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9730,6 +9730,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 	ioa_cfg->max_devs_supported = ipr_max_devs;
 
 	if (ioa_cfg->sis64) {
+		host->max_channel = IPR_MAX_SIS64_BUSES;
 		host->max_id = IPR_MAX_SIS64_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_SIS64_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_SIS64_DEVS)
@@ -9738,6 +9739,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					   + ((sizeof(struct ipr_config_table_entry64)
 					       * ioa_cfg->max_devs_supported)));
 	} else {
+		host->max_channel = IPR_VSET_BUS;
 		host->max_id = IPR_MAX_NUM_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_NUM_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_PHYSICAL_DEVS)
@@ -9747,7 +9749,6 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					       * ioa_cfg->max_devs_supported)));
 	}
 
-	host->max_channel = IPR_VSET_BUS;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	host->can_queue = ioa_cfg->max_cmds;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index a34c7a5a995e4..9c82ea000c117 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1301,6 +1301,7 @@ struct ipr_resource_entry {
 #define IPR_ARRAY_VIRTUAL_BUS			0x1
 #define IPR_VSET_VIRTUAL_BUS			0x2
 #define IPR_IOAFP_VIRTUAL_BUS			0x3
+#define IPR_MAX_SIS64_BUSES			0x4
 
 #define IPR_GET_RES_PHYS_LOC(res) \
 	(((res)->bus << 24) | ((res)->target << 8) | (res)->lun)
-- 
2.20.1

