Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AC20112B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404621AbgFSPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393149AbgFSPaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0EDD2193E;
        Fri, 19 Jun 2020 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580611;
        bh=H0Cr8s7qPm9bdoHFRUYwPfpzfeVz+yr8kTajovyiCZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOiGqMN1+4bb6oSlTKRa25gWVHo9VKiXcOCIjw2L1C7JYnkvU3PLr/a/8gBuuLVEp
         eyi7gFvXKK/wFf84k5Hqe+U4klwf0EfSnq6eqaUs52K2lbTljdDMk0TdNjRTKfEerd
         t8nxbURPGqVNSD6/8EVdf5v3WRkCJiimPiTI/2MY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Scriven <marcos@scriven.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 285/376] PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0
Date:   Fri, 19 Jun 2020 16:33:23 +0200
Message-Id: <20200619141723.823523643@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Scriven <marcos@scriven.org>

[ Upstream commit 0d14f06cd6657ba3446a5eb780672da487b068e7 ]

The AMD Matisse HD Audio & USB 3.0 devices advertise Function Level Reset
support, but hang when an FLR is triggered.

To reproduce the problem, attach the device to a VM, then detach and try to
attach again.

Rename the existing quirk_intel_no_flr(), which was not Intel-specific, to
quirk_no_flr(), and apply it to prevent the use of FLR on these AMD
devices.

Link: https://lore.kernel.org/r/CAAri2DpkcuQZYbT6XsALhx2e6vRqPHwtbjHYeiH7MNp4zmt1RA@mail.gmail.com
Signed-off-by: Marcos Scriven <marcos@scriven.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 268f74d43a73..9d00ecb1f5b5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5129,13 +5129,23 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
 
-/* FLR may cause some 82579 devices to hang */
-static void quirk_intel_no_flr(struct pci_dev *dev)
+/*
+ * FLR may cause the following to devices to hang:
+ *
+ * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Matisse USB 3.0 Host Controller 0x149c
+ * Intel 82579LM Gigabit Ethernet Controller 0x1502
+ * Intel 82579V Gigabit Ethernet Controller 0x1503
+ *
+ */
+static void quirk_no_flr(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_intel_no_flr);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_intel_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
 static void quirk_no_ext_tags(struct pci_dev *pdev)
 {
-- 
2.25.1



