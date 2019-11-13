Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6634FA5E7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfKMBvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:51:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbfKMBvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 300A12246A;
        Wed, 13 Nov 2019 01:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609891;
        bh=FK6rddTPTwK/CMpUf7Wy6HlR4JUMAdjtf1wQY9MQNek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV73X+KhYA+AslQT/jB71taClsrbvY7ZdCJ5CC0UBf4BbByGfd8bAYeo0CyzLN7Ql
         E5TkWUMNtZYCq/zWEgTp3aqXh9+nhTWmubQcaCSDDwFQs5JiRMnK6/0h/Rkv1MHL1e
         nWuuY0+00AtG93L81Ky05SYldOpSvoC6z3Yt/gzc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/209] clk: keystone: Enable TISCI clocks if K3_ARCH
Date:   Tue, 12 Nov 2019 20:47:45 -0500
Message-Id: <20191113015025.9685-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
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
index a84c5573cabea..ed344eb717cc4 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-$(CONFIG_ARCH_MXC)			+= imx/
 obj-$(CONFIG_MACH_INGENIC)		+= ingenic/
+obj-$(CONFIG_ARCH_K3)			+= keystone/
 obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
 obj-$(CONFIG_MACH_LOONGSON32)		+= loongson1/
 obj-y					+= mediatek/
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

