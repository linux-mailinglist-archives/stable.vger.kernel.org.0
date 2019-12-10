Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC21D119511
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfLJVSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbfLJVMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94682464B;
        Tue, 10 Dec 2019 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012361;
        bh=nrKFeK8ZfpA0LOttrffsxHf9XaNKRKS8gtS1ILBWzz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4O4kVDTPfBp933OWfwDW+Rj692YBkJeJvKNQfrc5jZ5VY+Qgbs7Aeuz35vkpYkkG
         RYEz+jcPbNEc6+3k4fBoBbSb7gKKILzGlDH3K0mqfTL19pNRALNLD9aVk7oms3/hcx
         XmG+zw6AFWqTAQputvb0IdAfvBPkt2ovO7nNZP4I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, ralf@linux-mips.org,
        jhogan@kernel.org, john@phrozen.org, NeilBrown <neil@brown.name>,
        linux-mips@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 288/350] MIPS: ralink: enable PCI support only if driver for mt7621 SoC is selected
Date:   Tue, 10 Dec 2019 16:06:33 -0500
Message-Id: <20191210210735.9077-249-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 3b2fa0c92686562ac0b8cf00c0326a45814f8e18 ]

Some versions of SoC MT7621 have three PCI express hosts. Some boards
make use of those PCI through the staging driver mt7621-pci. Recently
PCI support has been removed from MT7621 Soc kernel configuration due
to a build error. This makes imposible to compile staging driver and
produces a regression for gnubee based boards. Enable support for PCI
again but enable it only if staging mt7621-pci driver is selected.

Fixes: c4d48cf5e2f0 ("MIPS: ralink: deactivate PCI support for SOC_MT7621")
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: john@phrozen.org
Cc: NeilBrown <neil@brown.name>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20191019081233.7337-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/Kconfig           | 1 +
 drivers/staging/mt7621-pci/Kconfig | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/Kconfig b/arch/mips/ralink/Kconfig
index 1434fa60f3db1..94e9ce9944944 100644
--- a/arch/mips/ralink/Kconfig
+++ b/arch/mips/ralink/Kconfig
@@ -51,6 +51,7 @@ choice
 		select MIPS_GIC
 		select COMMON_CLK
 		select CLKSRC_MIPS_GIC
+		select HAVE_PCI if PCI_MT7621
 endchoice
 
 choice
diff --git a/drivers/staging/mt7621-pci/Kconfig b/drivers/staging/mt7621-pci/Kconfig
index af928b75a9403..ce58042f2f211 100644
--- a/drivers/staging/mt7621-pci/Kconfig
+++ b/drivers/staging/mt7621-pci/Kconfig
@@ -2,7 +2,6 @@
 config PCI_MT7621
 	tristate "MediaTek MT7621 PCI Controller"
 	depends on RALINK
-	depends on PCI
 	select PCI_DRIVERS_GENERIC
 	help
 	  This selects a driver for the MediaTek MT7621 PCI Controller.
-- 
2.20.1

