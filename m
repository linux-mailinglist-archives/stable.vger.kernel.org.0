Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F520DE64
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgF2UZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgF2TZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC3D25365;
        Mon, 29 Jun 2020 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445227;
        bh=T0gmH3sgBcLyLNz5ntfvgUMdlKphavvILj91+klF4Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wliiw2bqRhYp6aGbPNT3LSaQk9hM5fxHjaGnzso0AiisRpwA/vfKucqUyJ0NJ2aF
         Al9/s00uLbW+hGDLYZsf0AljntRR4y9bh7L0Tq6fOJaZ2NpUClxdIdlVXYm23Evetz
         +A9YH3Z8YvVVfW62pkfBBeFnXQ2mdph6bVmbH1HM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/191] PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register
Date:   Mon, 29 Jun 2020 11:37:09 -0400
Message-Id: <20200629154007.2495120-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 90c6cb4a355e7befcb557d217d1d8b8bd5875a05 ]

Trying to change Link Status register does not have any effect as this
is a read-only register. Trying to overwrite bits for Negotiated Link
Width does not make sense.

In future proper change of link width can be done via Lane Count Select
bits in PCIe Control 0 register.

Trying to unconditionally enable ASPM L0s via ASPM Control bits in Link
Control register is wrong. There should be at least some detection if
endpoint supports L0s as isn't mandatory.

Moreover ASPM Control bits in Link Control register are controlled by
pcie/aspm.c code which sets it according to system ASPM settings,
immediately after aardvark driver probes. So setting these bits by
aardvark driver has no long running effect.

Remove code which touches ASPM L0s bits from this driver and let
kernel's ASPM implementation to set ASPM state properly.

Some users are reporting issues that this code is problematic for some
Intel wifi cards and removing it fixes them, see e.g.:
https://bugzilla.kernel.org/show_bug.cgi?id=196339

If problems with Intel wifi cards occur even after this commit, then
pcie/aspm.c code could be modified / hooked to not enable ASPM L0s state
for affected problematic cards.

Link: https://lore.kernel.org/r/20200430080625.26070-3-pali@kernel.org
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 1dbd09c91a7c6..736d9f58438ec 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -363,10 +363,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 
 	advk_pcie_wait_for_link(pcie);
 
-	reg = PCIE_CORE_LINK_L0S_ENTRY |
-		(1 << PCIE_CORE_LINK_WIDTH_SHIFT);
-	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
-
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 	reg |= PCIE_CORE_CMD_MEM_ACCESS_EN |
 		PCIE_CORE_CMD_IO_ACCESS_EN |
-- 
2.25.1

