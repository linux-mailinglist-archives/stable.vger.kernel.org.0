Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3E450C1A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhKORer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237517AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A098632AE;
        Mon, 15 Nov 2021 17:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996859;
        bh=B8xlh5f37BRK0juDXELLjso8XTlpeEs1RRGGLw6bQ9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaYirD6j4OnKjoDTo01lE2s/tBbPcQXS2ePy6qLYMxh3jDqxWZNrN7vN/5Y/AjT2W
         WdrX3hLn9Xy6njgdZBgtWZGEKtgPESf5flzf98Cyfgl5BBxrS98lpC7+4mJm8XEXr7
         9Ys5LoLbkG3g6U9ydppjn+QEIIaKgn9+B8yFxX/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/355] PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated bridge
Date:   Mon, 15 Nov 2021 18:03:38 +0100
Message-Id: <20211115165323.233902768@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d419052bc6c60fa4ab2b5a51d5f1e55a66e2b4ff ]

Commit 43f5c77bcbd2 ("PCI: aardvark: Fix reporting CRS value") started
using CRSSVE flag for handling CRS responses.

PCI_EXP_RTCTL_CRSSVE flag is stored only in emulated config space buffer
and there is handler for PCI_EXP_RTCTL register. So every read operation
from config space automatically clears CRSSVE flag as it is not defined in
PCI_EXP_RTCTL read handler.

Fix this by reading current CRSSVE bit flag from emulated space buffer and
appending it to PCI_EXP_RTCTL read response.

Link: https://lore.kernel.org/r/20211005180952.6812-5-kabel@kernel.org
Fixes: 43f5c77bcbd2 ("PCI: aardvark: Fix reporting CRS value")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 785f7ad4ac9c0..45794ba643d40 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -580,6 +580,7 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 	case PCI_EXP_RTCTL: {
 		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
 		*value = (val & PCIE_MSG_PM_PME_MASK) ? 0 : PCI_EXP_RTCTL_PMEIE;
+		*value |= le16_to_cpu(bridge->pcie_conf.rootctl) & PCI_EXP_RTCTL_CRSSVE;
 		*value |= PCI_EXP_RTCAP_CRSVIS << 16;
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
-- 
2.33.0



