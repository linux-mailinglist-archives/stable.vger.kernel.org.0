Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039D510B960
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfK0Uwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbfK0Uwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61AB21847;
        Wed, 27 Nov 2019 20:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887952;
        bh=hZs1P9plDIJ8W2ENJ7RonhFFJIGU5K6ekGDrHHqkUQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+V7X/td3v90QbR1GRkpSG5oZLMyusQORKuKRbSEq5lUxNuyOKD7YNrP+5vToQ7D4
         j+Us0cJ8VjnTaEza/yaJbG4T3KwEf/QOox1PpCplbyr3mYEF7lM0gjsf+pmBUmdjbs
         0ws7jkCfizatSlE8n43RRvVVU6AaUhH6xs7DuwgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/211] PCI: keystone: Use quirk to limit MRRS for K2G
Date:   Wed, 27 Nov 2019 21:31:31 +0100
Message-Id: <20191127203108.891006511@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 148e340c0696369fadbbddc8f4bef801ed247d71 ]

PCI controller in K2G also has a limitation that memory read request
size (MRRS) must not exceed 256 bytes. Use the quirk to limit MRRS
(added for K2HK, K2L and K2E) for K2G as well.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/dwc/pci-keystone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/dwc/pci-keystone.c b/drivers/pci/dwc/pci-keystone.c
index 9bc52e4cf52a0..3ea8288c16053 100644
--- a/drivers/pci/dwc/pci-keystone.c
+++ b/drivers/pci/dwc/pci-keystone.c
@@ -39,6 +39,7 @@
 #define PCIE_RC_K2HK		0xb008
 #define PCIE_RC_K2E		0xb009
 #define PCIE_RC_K2L		0xb00a
+#define PCIE_RC_K2G		0xb00b
 
 #define to_keystone_pcie(x)	dev_get_drvdata((x)->dev)
 
@@ -53,6 +54,8 @@ static void quirk_limit_mrrs(struct pci_dev *dev)
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2L),
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2G),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ 0, },
 	};
 
-- 
2.20.1



