Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4499B10BF87
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfK0Uhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfK0Uhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AAB1215B2;
        Wed, 27 Nov 2019 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887056;
        bh=I0rchmJGs8cAxxh9kh0r3kMYrLFrSYXfgcupkO1Fj4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFhbIc/IUyEcSanrfxrxkY6vrKel0Y20FVHCVPJ1R3rLOvZ2Cg8NQhqT/Gs5tKhtL
         RXqpATMB34pUmjaENaDotyCjVlqIyyxOsmuablbR/FV/KC2ItDPCBDd5ZiAYB5lzar
         VPAbcChA22Fx+4FZnZi1CzLA7KtL2ZS9gHy51UUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 096/132] PCI: keystone: Use quirk to limit MRRS for K2G
Date:   Wed, 27 Nov 2019 21:31:27 +0100
Message-Id: <20191127203022.002864472@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
 drivers/pci/host/pci-keystone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
index fb682e8af74d5..bdb808ba90d2a 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -42,6 +42,7 @@
 #define PCIE_RC_K2HK		0xb008
 #define PCIE_RC_K2E		0xb009
 #define PCIE_RC_K2L		0xb00a
+#define PCIE_RC_K2G		0xb00b
 
 #define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
 
@@ -56,6 +57,8 @@ static void quirk_limit_mrrs(struct pci_dev *dev)
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2L),
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2G),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ 0, },
 	};
 
-- 
2.20.1



