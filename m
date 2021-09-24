Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9DA41737D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345179AbhIXM4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344450AbhIXMzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF52613A3;
        Fri, 24 Sep 2021 12:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487852;
        bh=WLLtukK5s2B5j/CTdls1eQsed9a0wt9nyzPJt/PMd4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQusAtqU9AsU0O7A36HDskuuyWGFS7VihXsXi+M+vZ5MwS8i8/LaI6wpiRHV5Ycgw
         9YVm09EcFgxt+tbrJjZe+5EM8V53ZAtB9VqZtNmaU3u/yMYyz2N4eftC32CP/6AGJ4
         4AV2+DVtKJyiSWM2x8QJNG7Bhodx9IHdZSdofMbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tuan Phan <tuanphan@os.amperecomputing.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.4 05/50] PCI/ACPI: Add Ampere Altra SOC MCFG quirk
Date:   Fri, 24 Sep 2021 14:43:54 +0200
Message-Id: <20210924124332.419622318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuan Phan <tuanphan@os.amperecomputing.com>

commit 877c1a5f79c6984bbe3f2924234c08e2f4f1acd5 upstream.

Ampere Altra SOC supports only 32-bit ECAM reads.  Add an MCFG quirk for
the platform.

Link: https://lore.kernel.org/r/1596751055-12316-1-git-send-email-tuanphan@os.amperecomputing.com
Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[ dannf: backport drops const qualifier from pci_32b_read_ops for
  consistency with the other quirks that weren't yet constified in v5.4 ]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/pci_mcfg.c  |   20 ++++++++++++++++++++
 drivers/pci/ecam.c       |   10 ++++++++++
 include/linux/pci-ecam.h |    1 +
 3 files changed, 31 insertions(+)

--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -142,6 +142,26 @@ static struct mcfg_fixup mcfg_quirks[] =
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
--- a/drivers/pci/ecam.c
+++ b/drivers/pci/ecam.c
@@ -164,4 +164,14 @@ struct pci_ecam_ops pci_32b_ops = {
 		.write		= pci_generic_config_write32,
 	}
 };
+
+/* ECAM ops for 32-bit read only (non-compliant) */
+struct pci_ecam_ops pci_32b_read_ops = {
+	.bus_shift	= 20,
+	.pci_ops	= {
+		.map_bus	= pci_ecam_map_bus,
+		.read		= pci_generic_config_read32,
+		.write		= pci_generic_config_write,
+	}
+};
 #endif
--- a/include/linux/pci-ecam.h
+++ b/include/linux/pci-ecam.h
@@ -51,6 +51,7 @@ extern struct pci_ecam_ops pci_generic_e
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS)
 extern struct pci_ecam_ops pci_32b_ops;		/* 32-bit accesses only */
+extern struct pci_ecam_ops pci_32b_read_ops; /* 32-bit read only */
 extern struct pci_ecam_ops hisi_pcie_ops;	/* HiSilicon */
 extern struct pci_ecam_ops thunder_pem_ecam_ops; /* Cavium ThunderX 1.x & 2.x */
 extern struct pci_ecam_ops pci_thunder_ecam_ops; /* Cavium ThunderX 1.x */


