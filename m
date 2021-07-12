Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271473C4D68
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbhGLHNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244599AbhGLHLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8AF6052B;
        Mon, 12 Jul 2021 07:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073691;
        bh=JzJXunBpyugOcEoZj7h7ZllonnCTSMiHh4QQbNuMvrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMKIH+YU53uQSHxwmU5qoKV8TV/r0nikRaDUEmGSsixn82nBYTjaHzm6l4ICNcoz8
         JIC7KQMBJgqbQA42NV787DXpD2dpUWvqKZkF7DM3eePeuMIdZy3kjWrDrHHy870nkm
         kuTP6PIK47RAbifOIzROrl3zzfuyrA9pOV+0cFgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang Prike <Prike.Liang@amd.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 327/700] nvme-pci: look for StorageD3Enable on companion ACPI device instead
Date:   Mon, 12 Jul 2021 08:06:50 +0200
Message-Id: <20210712061011.175089519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e21e0243e7b0f1c2a21d21f4d115f7b37175772a ]

The documentation around the StorageD3Enable property hints that it
should be made on the PCI device.  This is where newer AMD systems set
the property and it's required for S0i3 support.

So rather than look for nodes of the root port only present on Intel
systems, switch to the companion ACPI device for all systems.
David Box from Intel indicated this should work on Intel as well.

Link: https://lore.kernel.org/linux-nvme/YK6gmAWqaRmvpJXb@google.com/T/#m900552229fa455867ee29c33b854845fce80ba70
Link: https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/power-management-for-storage-hardware-devices-intro
Fixes: df4f9bc4fb9c ("nvme-pci: add support for ACPI StorageD3Enable property")
Suggested-by: Liang Prike <Prike.Liang@amd.com>
Acked-by: Raul E Rangel <rrangel@chromium.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4555e9202851..2a3ef79f96f9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2834,10 +2834,7 @@ static unsigned long check_vendor_combination_bug(struct pci_dev *pdev)
 #ifdef CONFIG_ACPI
 static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 {
-	struct acpi_device *adev;
-	struct pci_dev *root;
-	acpi_handle handle;
-	acpi_status status;
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
 	u8 val;
 
 	/*
@@ -2845,28 +2842,9 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	 * must use D3 to support deep platform power savings during
 	 * suspend-to-idle.
 	 */
-	root = pcie_find_root_port(dev);
-	if (!root)
-		return false;
 
-	adev = ACPI_COMPANION(&root->dev);
 	if (!adev)
 		return false;
-
-	/*
-	 * The property is defined in the PXSX device for South complex ports
-	 * and in the PEGP device for North complex ports.
-	 */
-	status = acpi_get_handle(adev->handle, "PXSX", &handle);
-	if (ACPI_FAILURE(status)) {
-		status = acpi_get_handle(adev->handle, "PEGP", &handle);
-		if (ACPI_FAILURE(status))
-			return false;
-	}
-
-	if (acpi_bus_get_device(handle, &adev))
-		return false;
-
 	if (fwnode_property_read_u8(acpi_fwnode_handle(adev), "StorageD3Enable",
 			&val))
 		return false;
-- 
2.30.2



