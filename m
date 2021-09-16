Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D20C40E5E4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbhIPRQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244114AbhIPRNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEF96142A;
        Thu, 16 Sep 2021 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810317;
        bh=tecI0xFXGZah/qzfpOPocp2W8hgrOZ2sSXszrl8VFlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjwL7HWCWGQi9sxx2wcrpmPAJ+wxQsAvUNvAfLEaW0SanlxEKjg0630c2x8hm/6eW
         ZHQttuCs+gwTnLk2ERRPil19k4+GMqzwbM0cw9i32+nMdBcNla71Rhclatf3ER6PcC
         MUZNBNZ2X8rSTMyNEVIFUxklPAPWNXYHNLEBeFNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.14 064/432] PCI/portdrv: Enable Bandwidth Notification only if port supports it
Date:   Thu, 16 Sep 2021 17:56:53 +0200
Message-Id: <20210916155812.959996732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Hayes <stuart.w.hayes@gmail.com>

commit 00823dcbdd415c868390feaca16f0265101efab4 upstream.

Previously we assumed that all Root Ports and Switch Downstream Ports
supported Link Bandwidth Notification.  Per spec, this is only required
for Ports supporting Links wider than x1 and/or multiple Link speeds
(PCIe r5.0, sec 7.5.3.6).

Because we assumed all Ports supported it, we tried to set up a Bandwidth
Notification IRQ, which failed for devices that don't support IRQs at all,
which meant pcieport didn't attach to the Port at all.

Check the Link Bandwidth Notification Capability bit and enable the service
only when the Port supports it.

[bhelgaas: commit log]
Fixes: e8303bb7a75c ("PCI/LINK: Report degraded links via link bandwidth notification")
Link: https://lore.kernel.org/r/20210512213314.7778-1-stuart.w.hayes@gmail.com
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/portdrv_core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -257,8 +257,13 @@ static int get_port_device_capability(st
 		services |= PCIE_PORT_SERVICE_DPC;
 
 	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||
-	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT)
-		services |= PCIE_PORT_SERVICE_BWNOTIF;
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
+		u32 linkcap;
+
+		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &linkcap);
+		if (linkcap & PCI_EXP_LNKCAP_LBNC)
+			services |= PCIE_PORT_SERVICE_BWNOTIF;
+	}
 
 	return services;
 }


