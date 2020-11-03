Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706DA2A58ED
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgKCWDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbgKCUos (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C3E1223BF;
        Tue,  3 Nov 2020 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436287;
        bh=1UA0wVtyeiQxf/9Al/n6Ece31QInsgTbu3Vz3pLk7js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfrkNAAdHeg+4H5le5AvWs9FNKuz13Gq5guVHSgstaCsPltY7QtsnJ1U+5zrW10gI
         rrnDBY399yt67dZETZWegKM39Y2oE3d09cx9e/RemFava8/0aFFKtV4Ccb6Bqe2B1T
         ZwGQi9ljbbJwG9OXTITy/ZPhj3yZ9B3vvba7N/MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tuan Phan <tuanphan@os.amperecomputing.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 147/391] PCI/ACPI: Add Ampere Altra SOC MCFG quirk
Date:   Tue,  3 Nov 2020 21:33:18 +0100
Message-Id: <20201103203356.750556365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuan Phan <tuanphan@os.amperecomputing.com>

[ Upstream commit 877c1a5f79c6984bbe3f2924234c08e2f4f1acd5 ]

Ampere Altra SOC supports only 32-bit ECAM reads.  Add an MCFG quirk for
the platform.

Link: https://lore.kernel.org/r/1596751055-12316-1-git-send-email-tuanphan@os.amperecomputing.com
Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_mcfg.c  | 20 ++++++++++++++++++++
 drivers/pci/ecam.c       | 10 ++++++++++
 include/linux/pci-ecam.h |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/acpi/pci_mcfg.c b/drivers/acpi/pci_mcfg.c
index 54b36b7ad47d9..e526571e0ebdb 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -142,6 +142,26 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	XGENE_V2_ECAM_MCFG(4, 0),
 	XGENE_V2_ECAM_MCFG(4, 1),
 	XGENE_V2_ECAM_MCFG(4, 2),
+
+#define ALTRA_ECAM_QUIRK(rev, seg) \
+	{ "Ampere", "Altra   ", rev, seg, MCFG_BUS_ANY, &pci_32b_read_ops }
+
+	ALTRA_ECAM_QUIRK(1, 0),
+	ALTRA_ECAM_QUIRK(1, 1),
+	ALTRA_ECAM_QUIRK(1, 2),
+	ALTRA_ECAM_QUIRK(1, 3),
+	ALTRA_ECAM_QUIRK(1, 4),
+	ALTRA_ECAM_QUIRK(1, 5),
+	ALTRA_ECAM_QUIRK(1, 6),
+	ALTRA_ECAM_QUIRK(1, 7),
+	ALTRA_ECAM_QUIRK(1, 8),
+	ALTRA_ECAM_QUIRK(1, 9),
+	ALTRA_ECAM_QUIRK(1, 10),
+	ALTRA_ECAM_QUIRK(1, 11),
+	ALTRA_ECAM_QUIRK(1, 12),
+	ALTRA_ECAM_QUIRK(1, 13),
+	ALTRA_ECAM_QUIRK(1, 14),
+	ALTRA_ECAM_QUIRK(1, 15),
 };
 
 static char mcfg_oem_id[ACPI_OEM_ID_SIZE];
diff --git a/drivers/pci/ecam.c b/drivers/pci/ecam.c
index 8f065a42fc1a2..b54d32a316693 100644
--- a/drivers/pci/ecam.c
+++ b/drivers/pci/ecam.c
@@ -168,4 +168,14 @@ const struct pci_ecam_ops pci_32b_ops = {
 		.write		= pci_generic_config_write32,
 	}
 };
+
+/* ECAM ops for 32-bit read only (non-compliant) */
+const struct pci_ecam_ops pci_32b_read_ops = {
+	.bus_shift	= 20,
+	.pci_ops	= {
+		.map_bus	= pci_ecam_map_bus,
+		.read		= pci_generic_config_read32,
+		.write		= pci_generic_config_write,
+	}
+};
 #endif
diff --git a/include/linux/pci-ecam.h b/include/linux/pci-ecam.h
index 1af5cb02ef7f9..033ce74f02e81 100644
--- a/include/linux/pci-ecam.h
+++ b/include/linux/pci-ecam.h
@@ -51,6 +51,7 @@ extern const struct pci_ecam_ops pci_generic_ecam_ops;
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS)
 extern const struct pci_ecam_ops pci_32b_ops;	/* 32-bit accesses only */
+extern const struct pci_ecam_ops pci_32b_read_ops; /* 32-bit read only */
 extern const struct pci_ecam_ops hisi_pcie_ops;	/* HiSilicon */
 extern const struct pci_ecam_ops thunder_pem_ecam_ops; /* Cavium ThunderX 1.x & 2.x */
 extern const struct pci_ecam_ops pci_thunder_ecam_ops; /* Cavium ThunderX 1.x */
-- 
2.27.0



