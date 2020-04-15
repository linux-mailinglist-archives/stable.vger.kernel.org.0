Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97361A99E5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896156AbgDOKH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 06:07:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58423 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896150AbgDOKHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 06:07:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 053495C01C5;
        Wed, 15 Apr 2020 06:07:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 06:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nTVWHs
        FMs8LWNWNyOgDemmtN+WHAM8S6pn1M6BJJDxc=; b=FofK0WCnJRaeIvx8BLDxOs
        fDo/aplBsusMyfbgTQ7MZUW8ks1zbHz80e8r+aUJ01a29lXnB7Dy+2MqYELe7zw+
        z6XUJMeKa2XPJZZQwyebntFhFHW2A1X341GZfSsNhnRc742uKvaAqLRZTf2zHjjd
        Of5795OJG3v2VztqAEhADhD5XKpvGLBYZZflvD62xEDtw/IatRJNsD4AbbZvQSpF
        r2jrS0eFofIanvpgJoA0tUxBQtR0qHKF23QB/bPZb3eN+BWEiqsTYTXI7sQd1Z+e
        dqteYpcJ6yDaC4/kovF6zrvzRCxpeFNKmnDKUc7H5VL19kLdxn5GM7CgHfbqEYtg
        ==
X-ME-Sender: <xms:29yWXjrD8xnZ3vzeNvH4qP81Yzk_6JsqElYxQRnyfKpSjvZfmOl4kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:29yWXrBHd_pTv51vx2Cen-AbRQ55lXNHv9yukNN-xEMgnPm4501NbA>
    <xmx:29yWXl3TXy8HH1NtIg8Qt3phwpCDg8k13tD4PJ-HSoMHsWSJP4Sh9g>
    <xmx:29yWXheP0RR27R7qu7s1Si3cbYQpPklP3vOzRQy0H5a3zD_aeXdeUg>
    <xmx:3NyWXka8hsN-CcUm9EEX_6JNwiXnsEwevHrrG6vkQROwKYCoX8ezhQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C9873060067;
        Wed, 15 Apr 2020 06:07:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug" failed to apply to 5.5.y-stable tree
To:     sreekanth.reddy@broadcom.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 12:07:22 +0200
Message-ID: <158694524252229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5.y-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc41f11a21a51d6869d71e525a7264c748d7c0d7 Mon Sep 17 00:00:00 2001
From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date: Fri, 27 Mar 2020 05:52:43 -0400
Subject: [PATCH] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

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

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 778d5e6ce385..04a40afe60e3 100644
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
 

