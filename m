Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441DC1018C1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfKSF3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbfKSF3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2902121939;
        Tue, 19 Nov 2019 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141371;
        bh=gCbS15XtXj4oIuSuRwt5i3q+8lCfPki4Urq31VaAOrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsLMGc9QxTXcIabn5cUFXAucA/JieAw5lG0cDI81/jfdnktGu4xP5w5+lyVp1nSWi
         W53fUpp5MAiGuIkeyIH2LvbDu+7x65dJl2ZWpSyYG5BjMaJx+2Phy4t7AB7ZEWFr9M
         7vuN0yxfNKOARWpvKB2dnyYJHJqsJzJgYSJFdUuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suman Trpathi <stripathi@amperecomputing.com>,
        Rameshwar Prasad Sahu <rameshwar.sahu@amperecomputing.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/422] ata: Disable AHCI ALPM feature for Ampere Computing eMAG SATA
Date:   Tue, 19 Nov 2019 06:15:33 +0100
Message-Id: <20191119051407.639411260@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Tripathi <stripathi@amperecomputing.com>

[ Upstream commit 20bdc376b427cb420836f39ee8f281ea85dbaeef ]

Due to hardware errata, Ampere Computing eMAG SATA can't support
AHCI ALPM feature. This patch disables the AHCI ALPM feature for
eMAG SATA.

Signed-off-by: Suman Trpathi <stripathi@amperecomputing.com>
Signed-off-by: Rameshwar Prasad Sahu <rameshwar.sahu@amperecomputing.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_platform.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 46f0bd75eff79..cf1e0e18a7a98 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -33,6 +33,13 @@ static const struct ata_port_info ahci_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static const struct ata_port_info ahci_port_info_nolpm = {
+	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_LPM,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_platform_ops,
+};
+
 static struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
@@ -41,6 +48,7 @@ static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
+	const struct ata_port_info *port;
 	int rc;
 
 	hpriv = ahci_platform_get_resources(pdev,
@@ -58,7 +66,11 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
+	port = acpi_device_get_match_data(dev);
+	if (!port)
+		port = &ahci_port_info;
+
+	rc = ahci_platform_init_host(pdev, hpriv, port,
 				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
@@ -85,6 +97,7 @@ static const struct of_device_id ahci_of_match[] = {
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
 static const struct acpi_device_id ahci_acpi_match[] = {
+	{ "APMC0D33", (unsigned long)&ahci_port_info_nolpm },
 	{ ACPI_DEVICE_CLASS(PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff) },
 	{},
 };
-- 
2.20.1



