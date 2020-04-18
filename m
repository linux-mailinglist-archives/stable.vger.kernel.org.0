Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825A41AED27
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgDRNuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgDRNtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD11022240;
        Sat, 18 Apr 2020 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217781;
        bh=LVsekz8INTXKUjpo9fil8pH2pEYtmSNN2pVUrHyIdXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDrVrIhxnxJqrg75eqzSZcJv/yWIbZYiWjHKKKKKHA6IocMlw7eSErKckhJOZjb8y
         frrufM715uyqoNeCDJp2IpnXCttrS2ww63LVJ9K06ys7jAboCnTVmzl/PXX3e/SzC6
         ZGw58QBNkOYWZ8fT43liedB1bLkQDV6fqct45uQA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 69/73] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Sat, 18 Apr 2020 09:48:11 -0400
Message-Id: <20200418134815.6519-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit cc41f11a21a51d6869d71e525a7264c748d7c0d7 ]

Generic protection fault type kernel panic is observed when user performs
soft (ordered) HBA unplug operation while IOs are running on drives
connected to HBA.

When user performs ordered HBA removal operation, the kernel calls PCI
device's .remove() call back function where driver is flushing out all the
outstanding SCSI IO commands with DID_NO_CONNECT host byte and also unmaps
sg buffers allocated for these IO commands.

However, in the ordered HBA removal case (unlike of real HBA hot removal),
HBA device is still alive and hence HBA hardware is performing the DMA
operations to those buffers on the system memory which are already unmapped
while flushing out the outstanding SCSI IO commands and this leads to
kernel panic.

Don't flush out the outstanding IOs from .remove() path in case of ordered
removal since HBA will be still alive in this case and it can complete the
outstanding IOs. Flush out the outstanding IOs only in case of 'physical
HBA hot unplug' where there won't be any communication with the HBA.

During shutdown also it is possible that HBA hardware can perform DMA
operations on those outstanding IO buffers which are completed with
DID_NO_CONNECT by the driver from .shutdown(). So same above fix is applied
in shutdown path as well.

It is safe to drop the outstanding commands when HBA is inaccessible such
as when permanent PCI failure happens, when HBA is in non-operational
state, or when someone does a real HBA hot unplug operation. Since driver
knows that HBA is inaccessible during these cases, it is safe to drop the
outstanding commands instead of waiting for SCSI error recovery to kick in
and clear these outstanding commands.

Link: https://lore.kernel.org/r/1585302763-23007-1-git-send-email-sreekanth.reddy@broadcom.com
Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
Cc: stable@vger.kernel.org #v4.14.174+
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c597d544eb392..a8ec1caf9c77c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -9992,8 +9992,8 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
-- 
2.20.1

