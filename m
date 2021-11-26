Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5408C45E575
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352524AbhKZCmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358363AbhKZCkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF8D61247;
        Fri, 26 Nov 2021 02:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894059;
        bh=lOC0U+Fq2q0Qs5BjmLJs7H49f8MTa/3byvciRDLBDZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8fxbezmZYmOQZJQezCBu0l3i6gERIwLagzfKY0gZ7qfCr+d93LPuHMacAq6ylHnR
         Kxk+cqOZSdkQSSbQ0lob5mjb6kiqUzlIZHdLnWrQel15zYgntAItxBTy+eE3E/nn10
         /0OAJpliaB36mfbhqPJ69vQ//DVKaHVjDgKXtSTQVMQMukvSTqNyDVEoSTN1F+m4px
         jHqZ9audiqd5kCEed8vOFENPaNIiaUSlJ1TkA6Qx+Zcc97dNq1JRJ6u40iWHbNLAVo
         rdLnQyuzzQP+rtkSI7GFdoVQGRespxZ5k8rKJyeD4vJyAJuXT+S6jvpfSxN/BUK8K0
         DstDluGcr2FnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 21/28] ata: libahci: Adjust behavior when StorageD3Enable _DSD is set
Date:   Thu, 25 Nov 2021 21:33:36 -0500
Message-Id: <20211126023343.442045-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7c5f641a5914ce0303b06bcfcd7674ee64aeebe9 ]

The StorageD3Enable _DSD is used for the vendor to indicate that the disk
should be opted into or out of a different behavior based upon the platform
design.

For AMD's Renoir and Green Sardine platforms it's important that any
attached SATA storage has transitioned into DevSlp when s2idle is used.

If the disk is left in active/partial/slumber, then the system is not able
to resume properly.

When the StorageD3Enable _DSD is detected, check the system is using s2idle
and DevSlp is enabled and if so explicitly wait long enough for the disk to
enter DevSlp.

Cc: Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214091
Link: https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/power-management-for-storage-hardware-devices-intro
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index fec2e9754aed2..d0d6efc9370d0 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2304,6 +2304,18 @@ int ahci_port_resume(struct ata_port *ap)
 EXPORT_SYMBOL_GPL(ahci_port_resume);
 
 #ifdef CONFIG_PM
+static void ahci_handle_s2idle(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 devslp;
+
+	if (pm_suspend_via_firmware())
+		return;
+	devslp = readl(port_mmio + PORT_DEVSLP);
+	if ((devslp & PORT_DEVSLP_ADSE))
+		ata_msleep(ap, devslp_idle_timeout);
+}
+
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
 	const char *emsg = NULL;
@@ -2317,6 +2329,9 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ata_port_freeze(ap);
 	}
 
+	if (acpi_storage_d3(ap->host->dev))
+		ahci_handle_s2idle(ap);
+
 	ahci_rpm_put_port(ap);
 	return rc;
 }
-- 
2.33.0

