Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F072E433C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408471AbgL1PeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407188AbgL1Nwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680FA20715;
        Mon, 28 Dec 2020 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163535;
        bh=C/gBNapSyXLn8ieLTufOfneQYnWUQ9QESDsfm6uBEFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWsnmyp0JUBBTZNcAwl1e0htxDvr+WRXF6LGBIEkiGem0snm+VKAKGOwDwAX2pf95
         qE2x55pwgSZpcHIQGwQmRfFCF8rMGl+PDQGPmZ8lJdZ/ORP4SPP9l0tb5OmKDWTTre
         fV/FX8sLefuUWzOONVE5cVuz54SFUG4igt7RgmQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 320/453] vfio/pci/nvlink2: Do not attempt NPU2 setup on POWER8NVL NPU
Date:   Mon, 28 Dec 2020 13:49:16 +0100
Message-Id: <20201228124952.610173617@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit d22f9a6c92de96304c81792942ae7c306f08ac77 upstream.

We execute certain NPU2 setup code (such as mapping an LPID to a device
in NPU2) unconditionally if an Nvlink bridge is detected. However this
cannot succeed on POWER8NVL machines as the init helpers return an error
other than ENODEV which means the device is there is and setup failed so
vfio_pci_enable() fails and pass through is not possible.

This changes the two NPU2 related init helpers to return -ENODEV if
there is no "memory-region" device tree property as this is
the distinction between NPU and NPU2.

Tested on
- POWER9 pvr=004e1201, Ubuntu 19.04 host, Ubuntu 18.04 vm,
  NVIDIA GV100 10de:1db1 driver 418.39
- POWER8 pvr=004c0100, RHEL 7.6 host, Ubuntu 16.10 vm,
  NVIDIA P100 10de:15f9 driver 396.47

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Cc: stable@vger.kernel.org # 5.0
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_nvlink2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -231,7 +231,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(str
 		return -EINVAL;
 
 	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
-		return -EINVAL;
+		return -ENODEV;
 
 	mem_node = of_find_node_by_phandle(mem_phandle);
 	if (!mem_node)
@@ -393,7 +393,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_p
 	int ret;
 	struct vfio_pci_npu2_data *data;
 	struct device_node *nvlink_dn;
-	u32 nvlink_index = 0;
+	u32 nvlink_index = 0, mem_phandle = 0;
 	struct pci_dev *npdev = vdev->pdev;
 	struct device_node *npu_node = pci_device_to_OF_node(npdev);
 	struct pci_controller *hose = pci_bus_to_host(npdev->bus);
@@ -408,6 +408,9 @@ int vfio_pci_ibm_npu2_init(struct vfio_p
 	if (!pnv_pci_get_gpu_dev(vdev->pdev))
 		return -ENODEV;
 
+	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
+		return -ENODEV;
+
 	/*
 	 * NPU2 normally has 8 ATSD registers (for concurrency) and 6 links
 	 * so we can allocate one register per link, using nvlink index as


