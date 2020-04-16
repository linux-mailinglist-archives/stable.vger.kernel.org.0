Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ED41ACA40
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441485AbgDPPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898373AbgDPNlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:41:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8269A20732;
        Thu, 16 Apr 2020 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044508;
        bh=S7FgOGEPXO+mwEgvwhgh8BwzMsUFhgiQCOTY+wSpslw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFxnD3yQBEdEgPmFKilkew6aiie4FWcZytTOJ8Hhq/dF6Xf9M06WZDsd7EZT6m8Zv
         jXW8USFcFhwakHBcmXcbH9tN9Yh77sAoYtXw5XHwqxIfNGUcUZXzUdewEKHsK9L4oS
         Aw9xkjDlYMDGBcZ5zXJf4OHF7wHfRPaNfXK397rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 244/257] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Thu, 16 Apr 2020 15:24:55 +0200
Message-Id: <20200416131356.268277949@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit cc41f11a21a51d6869d71e525a7264c748d7c0d7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9747,8 +9747,8 @@ static void scsih_remove(struct pci_dev
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -9831,8 +9831,8 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 


