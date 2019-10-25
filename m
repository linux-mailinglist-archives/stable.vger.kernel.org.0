Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1FE4D05
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502418AbfJYN5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632860AbfJYN5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5D8222CD;
        Fri, 25 Oct 2019 13:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011837;
        bh=Sj36tnrRRQFdrL/jhKlFBZYqwV2M/qzEaEe5cOTJFlc=;
        h=From:To:Cc:Subject:Date:From;
        b=WRUB6OsM0lVcKXbpJQhnCi/+p5PCnFV/zhLm4bHNZQIQRKBr6wrShqQpsH+WUXjnF
         ffErS/2HU5GPtEYpHjTLLPIg/rrV8KXZ1MJNVHNEQtgBZv0a8WLAzRkNVLyWKUI1sU
         2iJX/ZHWTcZZkRCfkk8MlTWP7oX5iR1I4oLkZSuI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Talbert <ptalbert@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/25] PCI/ASPM: Do not initialize link state when aspm_disabled is set
Date:   Fri, 25 Oct 2019 09:56:49 -0400
Message-Id: <20191025135715.25468-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Talbert <ptalbert@redhat.com>

[ Upstream commit 17c91487364fb33797ed84022564ee7544ac4945 ]

Now that ASPM is configured for *all* PCIe devices at boot, a problem is
seen with systems that set the FADT NO_ASPM bit.  This bit indicates that
the OS should not alter the ASPM state, but when
pcie_aspm_init_link_state() runs it only checks for !aspm_support_enabled.
This misses the ACPI_FADT_NO_ASPM case because that is setting
aspm_disabled.

The result is systems may hang at boot after 1302fcf; avoidable if they
boot with pcie_aspm=off (sets !aspm_support_enabled).

Fix this by having aspm_init_link_state() check for either
!aspm_support_enabled or acpm_disabled.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=201001
Fixes: 1302fcf0d03e ("PCI: Configure *all* devices, not just hot-added ones")
Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 6b4e82a4b64e0..370c3459e8845 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -858,7 +858,7 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
 	struct pcie_link_state *link;
 	int blacklist = !!pcie_aspm_sanity_check(pdev);
 
-	if (!aspm_support_enabled)
+	if (!aspm_support_enabled || aspm_disabled)
 		return;
 
 	if (pdev->link_state)
-- 
2.20.1

