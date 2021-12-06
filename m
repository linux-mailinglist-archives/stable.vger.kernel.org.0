Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A06469EB7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388086AbhLFPns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357924AbhLFPh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:37:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F66C08C5CF;
        Mon,  6 Dec 2021 07:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A5A6131B;
        Mon,  6 Dec 2021 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F2AC341C2;
        Mon,  6 Dec 2021 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804223;
        bh=m8EP3TX7Rf5n7v8iLem9Gcb1SZbqROT3RUewYS5ruD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxAzsJ6WklrI6JroHiE+JpC2YhKIrvyTiCScX0LLNU9yGw+LFIuXKLIjXFRWjHGvE
         smKYHt9mZxNr3QumJVtyZGRUuq0IiJqG2U4thnAzf7mfUn6/+6ChUvD+9OAhBBEPI7
         tPYCc9/6hqF/MKRio6zFO/iCeEb+dQfT8sJUW54s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/207] ata: libahci: Adjust behavior when StorageD3Enable _DSD is set
Date:   Mon,  6 Dec 2021 15:54:52 +0100
Message-Id: <20211206145611.536654383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



