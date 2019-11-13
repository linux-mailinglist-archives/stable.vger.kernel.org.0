Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0CDFA165
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfKMB5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbfKMB5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0059122467;
        Wed, 13 Nov 2019 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610219;
        bh=aFpAA8wU35EfuFHr6Frbd4f3Et0ExszuYiPWOtiTJRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwLWuOuROMSDsnkEVvVu0msXpCxG721LyiIdXnIHXElHIrwLnXwRD1QdUZ9hX65AV
         iauc9Rb0MmW53CegKzoqjhtdTd2lCtjIZypa6CyGPFAKDtOxnltkq/Ue/WHa6rvYEE
         9XBAoV+uNUXJEKGSXZP/TO2JxHQ/f3vYaA7Geekw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 026/115] clk: keystone: Enable TISCI clocks if K3_ARCH
Date:   Tue, 12 Nov 2019 20:54:53 -0500
Message-Id: <20191113015622.11592-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 2f149e6e14bcb5e581e49307b54aafcd6f74a74f ]

K3_ARCH uses TISCI for clocks as well. Enable the same
for the driver support.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Makefile         | 1 +
 drivers/clk/keystone/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f7f761b02beda..8ca03d9d693b0 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-$(CONFIG_ARCH_MXC)			+= imx/
 obj-$(CONFIG_MACH_INGENIC)		+= ingenic/
+obj-$(CONFIG_ARCH_K3)			+= keystone/
 obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
 obj-$(CONFIG_MACH_LOONGSON32)		+= loongson1/
 obj-$(CONFIG_ARCH_MEDIATEK)		+= mediatek/
diff --git a/drivers/clk/keystone/Kconfig b/drivers/clk/keystone/Kconfig
index 7e9f0176578a6..b04927d06cd10 100644
--- a/drivers/clk/keystone/Kconfig
+++ b/drivers/clk/keystone/Kconfig
@@ -7,7 +7,7 @@ config COMMON_CLK_KEYSTONE
 
 config TI_SCI_CLK
 	tristate "TI System Control Interface clock drivers"
-	depends on (ARCH_KEYSTONE || COMPILE_TEST) && OF
+	depends on (ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST) && OF
 	depends on TI_SCI_PROTOCOL
 	default ARCH_KEYSTONE
 	---help---
-- 
2.20.1

