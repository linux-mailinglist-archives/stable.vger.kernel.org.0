Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3C45E519
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358293AbhKZCjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358024AbhKZChY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40A5E611F0;
        Fri, 26 Nov 2021 02:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893978;
        bh=m8EP3TX7Rf5n7v8iLem9Gcb1SZbqROT3RUewYS5ruD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd+Z2cXnlYAsFgWkhZSQjlbl8czv9vA/2gVz19lVRQO51AyfhG0rrF8IdBRIIVOge
         NlAMLH4MkAjsS8ML7/5Dciyo+GkiJliQ3H3u38Dv7iNld8T3VYp3KkQCStDe8EMsu+
         5ym6+lHQ2JG3abgalfLUfLS+ke7+qNbo+b1r8xpSRkBxUpGN7oIAadDvrycF5uPBqg
         5dqLXlqfnvlHjVCVrrsdUfJi4QIRa/Sp9pusYhgYgLpssxkpzT5qZ45ezyDMexJauP
         U7l4WOJ1jOwKLvySxJ7PMtj6SPBhDgQEID1h+HePS0RICLHllPpgc0PB0n8zhxzUUA
         wib05OE2NN0DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/39] ata: libahci: Adjust behavior when StorageD3Enable _DSD is set
Date:   Thu, 25 Nov 2021 21:31:45 -0500
Message-Id: <20211126023156.441292-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index 5b3fa2cbe7223..395772fa39432 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2305,6 +2305,18 @@ int ahci_port_resume(struct ata_port *ap)
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
@@ -2318,6 +2330,9 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
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

