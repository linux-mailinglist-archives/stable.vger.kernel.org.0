Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E563106F3C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfKVKxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbfKVKxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47B6120715;
        Fri, 22 Nov 2019 10:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419991;
        bh=aFpAA8wU35EfuFHr6Frbd4f3Et0ExszuYiPWOtiTJRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0+0C23wR6/D7Qw7Zv5udR+wNdhM0d2e+5B1pqURuDrslPrYlxnIRJvsH21t9gtK7
         77oe7V430CEW39SRubFJL5hNjSQ7Z3McODfXklAHtokGVnTVNwCKTHSsAhn8h7e5fj
         f/tsAZjgo4KoByc/zlZurNbmnTbS4Ckijj3xQBxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/122] clk: keystone: Enable TISCI clocks if K3_ARCH
Date:   Fri, 22 Nov 2019 11:28:07 +0100
Message-Id: <20191122100749.509920394@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



