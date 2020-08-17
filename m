Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4252475FA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390650AbgHQTbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgHQPbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96AB020709;
        Mon, 17 Aug 2020 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678304;
        bh=wITwGc/iA9hZ7809WDDKU8at8eq9U1abe8a8Alu0yAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZdGVzSk2I4v4yywXQW7uUSmheSKBspvYH05AtkJ1FNYZn4kh0i3eE/VAqn1pJlm7
         o4g4RlGj9ZnpdHXy3DJd5Z+ezO9roDLrFinQebnIa/dhjmo7zlMIOMi1Z9SPsfOuT9
         NuJNEHYufp/M7BWvr8foSWIfcItkrWnVbouQaRWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 257/464] PCI: loongson: Use DECLARE_PCI_FIXUP_EARLY for bridge_class_quirk()
Date:   Mon, 17 Aug 2020 17:13:30 +0200
Message-Id: <20200817143846.102226905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 14110af606965ce07abe4d121c100241c2e73b86 ]

According to the datasheet of Loongson LS7A bridge chip, the old version
of Loongson LS7A PCIE port has a wrong value about PCI class which is
0x060000, the correct value should be 0x060400, this bug can be fixed by
"dev->class = PCI_CLASS_BRIDGE_PCI << 8;" at the software level and it
was fixed in hardware in the latest LS7A versions.

In order to maintain downward compatibility, use DECLARE_PCI_FIXUP_EARLY
instead of DECLARE_PCI_FIXUP_HEADER for bridge_class_quirk() to fix it as
early as possible.

Otherwise, in the function pci_setup_device(), the related code about
"dev->class" such as "class = dev->class >> 8;" and "dev->transparent
= ((dev->class & 0xff) == 1);" maybe get wrong value without EARLY fixup.

Link: https://lore.kernel.org/r/1595065176-460-1-git-send-email-yangtiezhu@loongson.cn
Fixes: 1f58cca5cf2b ("PCI: Add Loongson PCI Controller support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-loongson.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 459009c8a4a02..58b862aaa6e94 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -37,11 +37,11 @@ static void bridge_class_quirk(struct pci_dev *dev)
 {
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_LOONGSON,
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_PCIE_PORT_0, bridge_class_quirk);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_LOONGSON,
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_PCIE_PORT_1, bridge_class_quirk);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_LOONGSON,
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_PCIE_PORT_2, bridge_class_quirk);
 
 static void system_bus_quirk(struct pci_dev *pdev)
-- 
2.25.1



