Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1AC1F2DA1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbgFIAfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729824AbgFHXOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013CB20C09;
        Mon,  8 Jun 2020 23:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658069;
        bh=1SXGO42ArmKLcBXx+m3RGId2KHzSNDSpEYoeyqJ7ot4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbPqf1RErbaXcGCYfYuvnb4pvc0TKR47xi/XgHtI6eEVA/OyrtVxRF56Ekk8z5zeg
         SZ8GMdVcea2FDcWsTUg3GXcXesSirlbo71UpOCR9Uc/Vt/FUzFqLMD4M6eIYx5ZoP+
         EWEk9pc7yptXaFz8jTXVZ9TQhDiKK02TkVz0EHd4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.6 115/606] scsi: ibmvscsi: Fix WARN_ON during event pool release
Date:   Mon,  8 Jun 2020 19:04:00 -0400
Message-Id: <20200608231211.3363633-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit b36522150e5b85045f868768d46fbaaa034174b2 ]

While removing an ibmvscsi client adapter a WARN_ON like the following is
seen in the kernel log:

drmgr: drmgr: -r -c slot -s U9080.M9S.783AEC8-V11-C11 -w 5 -d 1
WARNING: CPU: 9 PID: 24062 at ../kernel/dma/mapping.c:311 dma_free_attrs+0x78/0x110
Supported: No, Unreleased kernel
CPU: 9 PID: 24062 Comm: drmgr Kdump: loaded Tainted: G               X 5.3.18-12-default
NIP:  c0000000001fa758 LR: c0000000001fa744 CTR: c0000000001fa6e0
REGS: c0000002173375d0 TRAP: 0700   Tainted: G               X (5.3.18-12-default)
MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28088282  XER: 20000000
CFAR: c0000000001fbf0c IRQMASK: 1
GPR00: c0000000001fa744 c000000217337860 c00000000161ab00 0000000000000000
GPR04: 0000000000000000 c000011e12250000 0000000018010000 0000000000000000
GPR08: 0000000000000000 0000000000000001 0000000000000001 c0080000190f4fa8
GPR12: c0000000001fa6e0 c000000007fc2a00 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 000000011420e310 0000000000000000 0000000000000000 0000000018010000
GPR28: c00000000159de50 c000011e12250000 0000000000006600 c000011e5c994848
NIP [c0000000001fa758] dma_free_attrs+0x78/0x110
LR [c0000000001fa744] dma_free_attrs+0x64/0x110
Call Trace:
[c000000217337860] [000000011420e310] 0x11420e310 (unreliable)
[c0000002173378b0] [c0080000190f0280] release_event_pool+0xd8/0x120 [ibmvscsi]
[c000000217337930] [c0080000190f3f74] ibmvscsi_remove+0x6c/0x160 [ibmvscsi]
[c000000217337960] [c0000000000f3cac] vio_bus_remove+0x5c/0x100
[c0000002173379a0] [c00000000087a0a4] device_release_driver_internal+0x154/0x280
[c0000002173379e0] [c0000000008777cc] bus_remove_device+0x11c/0x220
[c000000217337a60] [c000000000870fc4] device_del+0x1c4/0x470
[c000000217337b10] [c0000000008712a0] device_unregister+0x30/0xa0
[c000000217337b80] [c0000000000f39ec] vio_unregister_device+0x2c/0x60
[c000000217337bb0] [c00800001a1d0964] dlpar_remove_slot+0x14c/0x250 [rpadlpar_io]
[c000000217337c50] [c00800001a1d0bcc] remove_slot_store+0xa4/0x110 [rpadlpar_io]
[c000000217337cd0] [c000000000c091a0] kobj_attr_store+0x30/0x50
[c000000217337cf0] [c00000000057c934] sysfs_kf_write+0x64/0x90
[c000000217337d10] [c00000000057be10] kernfs_fop_write+0x1b0/0x290
[c000000217337d60] [c000000000488c4c] __vfs_write+0x3c/0x70
[c000000217337d80] [c00000000048c648] vfs_write+0xd8/0x260
[c000000217337dd0] [c00000000048ca8c] ksys_write+0xdc/0x130
[c000000217337e20] [c00000000000b488] system_call+0x5c/0x70
Instruction dump:
7c840074 f8010010 f821ffb1 20840040 eb830218 7c8407b4 48002019 60000000
2fa30000 409e003c 892d0988 792907e0 <0b090000> 2fbd0000 419e0028 2fbc0000
---[ end trace 5955b3c0cc079942 ]---
rpadlpar_io: slot U9080.M9S.783AEC8-V11-C11 removed

This is tripped as a result of irqs being disabled during the call to
dma_free_coherent() by release_event_pool(). At this point in the code path
we have quiesced the adapter and it is overly paranoid to be holding the
host lock.

[mkp: fixed build warning reported by sfr]

Link: https://lore.kernel.org/r/1588027793-17952-1-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7f66a7783209..59f0f1030c54 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2320,16 +2320,12 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
-	unsigned long flags;
 
 	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
 
 	purge_requests(hostdata, DID_ERROR);
-
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	release_event_pool(&hostdata->pool, hostdata);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
-- 
2.25.1

