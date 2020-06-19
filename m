Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27F200DDD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390821AbgFSPCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390819AbgFSPCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A241620734;
        Fri, 19 Jun 2020 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578939;
        bh=y/+T3sAqOIXoIccp6M2Le5955EgIiy+8DcPf4Vzw8xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpYEaStg8SE0AqmFnYLAxB4RvTaEc6p+nVxa7C0r7el+cBrTGacuyQCpFas54ysQD
         eLgKz7l7qUS6CWoDp9aD7og/E1O3JXNDx3htYqpQlAerHiYjvVl/mbMIJ79XOoeNho
         NRH22w5lLTJTwjOv3TDGgcSrkl0bxZj84AsJFpcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Joao Pinto <jpinto@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/267] PCI: Add Synopsys endpoint EDDA Device ID
Date:   Fri, 19 Jun 2020 16:33:18 +0200
Message-Id: <20200619141658.949200653@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>

[ Upstream commit 1f418f46503d72594bbe6407d97fd2ae1ce15ee6 ]

Create and add Synopsys Endpoint EDDA Device ID to PCI ID list, since
this ID is now being use on two different drivers (pci_endpoint_test.ko
and dw-edma-pcie.ko).

Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 2 +-
 include/linux/pci_ids.h          | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 2c472f9cc135..7d166f57f624 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -810,7 +810,7 @@ static const struct pci_device_id pci_endpoint_test_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_DRA74x) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_DRA72x) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, 0x81c0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS, 0xedda) },
+	{ PCI_DEVICE_DATA(SYNOPSYS, EDDA, NULL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_AM654),
 	  .driver_data = (kernel_ulong_t)&am654_data
 	},
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 5c395f52d681..47833d8f8928 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2366,6 +2366,7 @@
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3		0xabcd
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3_AXI	0xabce
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB31	0xabcf
+#define PCI_DEVICE_ID_SYNOPSYS_EDDA	0xedda
 
 #define PCI_VENDOR_ID_USR		0x16ec
 
-- 
2.25.1



