Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06EE11B7D1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbfLKQKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbfLKPL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C222465A;
        Wed, 11 Dec 2019 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077116;
        bh=0vMQkuVvGoPs3sp/Ltqni5dv40RdScQcgEDuMlVgDUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icrxUnTxGn/PSasbjxb3u379alTBaHXiivk7DbyyL0hN5+Isnv0nG7wH73QTOeKIW
         ZOKaqcRUNlzTEECCKYCD6lLWe/PF9CGumGyx4UI/SQt1g380FQLlIUZ+ONASZgxxJl
         YnjV+SXP8JZefBtD4Ss1Cb4UL5Yf18/gDVIspxyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 005/134] scsi: mpt3sas: Reject NVMe Encap cmnds to unsupported HBA
Date:   Wed, 11 Dec 2019 10:09:41 -0500
Message-Id: <20191211151150.19073-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 77fd4f2c88bf83205a21f9ca49fdcc0c7868dba9 ]

If any faulty application issues an NVMe Encapsulated commands to HBA which
doesn't support NVMe protocol then driver should return the command as
invalid with the following message.

"HBA doesn't support NVMe. Rejecting NVMe Encapsulated request."

Otherwise below page fault kernel panic will be observed while building the
PRPs as there is no PRP pools allocated for the HBA which doesn't support
NVMe drives.

RIP: 0010:_base_build_nvme_prp+0x3b/0xf0 [mpt3sas]
Call Trace:
 _ctl_do_mpt_command+0x931/0x1120 [mpt3sas]
 _ctl_ioctl_main.isra.11+0xa28/0x11e0 [mpt3sas]
 ? prepare_to_wait+0xb0/0xb0
 ? tty_ldisc_deref+0x16/0x20
 _ctl_ioctl+0x1a/0x20 [mpt3sas]
 do_vfs_ioctl+0xaa/0x620
 ? vfs_read+0x117/0x140
 ksys_ioctl+0x67/0x90
 __x64_sys_ioctl+0x1a/0x20
 do_syscall_64+0x60/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

[mkp: tweaked error string]

Link: https://lore.kernel.org/r/1568379890-18347-12-git-send-email-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 3c463e8f60740..b95f7d062ea44 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -778,6 +778,18 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	case MPI2_FUNCTION_NVME_ENCAPSULATED:
 	{
 		nvme_encap_request = (Mpi26NVMeEncapsulatedRequest_t *)request;
+		if (!ioc->pcie_sg_lookup) {
+			dtmprintk(ioc, ioc_info(ioc,
+			    "HBA doesn't support NVMe. Rejecting NVMe Encapsulated request.\n"
+			    ));
+
+			if (ioc->logging_level & MPT_DEBUG_TM)
+				_debug_dump_mf(nvme_encap_request,
+				    ioc->request_sz/4);
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
 		/*
 		 * Get the Physical Address of the sense buffer.
 		 * Use Error Response buffer address field to hold the sense
-- 
2.20.1

