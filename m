Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767C03CE281
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346151AbhGSPal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348025AbhGSPYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7194613E3;
        Mon, 19 Jul 2021 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710449;
        bh=AMxmgdId/9AKJ7yXKxtlwCtKNpkb7gJja9f7Czjvff0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnb96BVV+1LtDB3buDz/VFBMMOYVDMChOszjx91dftfW762heU1xt34zH4NQY5pSn
         Ov2fGVFvqr1RkvoAXBiSpOF84dD6VtTi/DxSrmmkKo7v4dxCGR2jM+Hp70pPxbKPYe
         oAxm0nEu8JL9NtSe5kPwR4vNtwcUbrrf+BniDI20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/243] reset: RESET_BRCMSTB_RESCAL should depend on ARCH_BRCMSTB
Date:   Mon, 19 Jul 2021 16:53:36 +0200
Message-Id: <20210719144946.958150385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 42f6a76fbe85e5243f83a3ed76809b1ebbb7087e ]

The Broadcom STB RESCAL reset controller is only present on Broadcom
BCM7216 platforms.  Hence add a dependency on ARCH_BRCMSTB, to prevent
asking the user about this driver when configuring a kernel without
BCM7216 support.

Also, merely enabling CONFIG_COMPILE_TEST should not enable additional
code, and thus should not enable this driver by default.

Fixes: 4cf176e52397853e ("reset: Add Broadcom STB RESCAL reset controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 07d162b179fc..b1d7369218e8 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -52,7 +52,8 @@ config RESET_BRCMSTB
 config RESET_BRCMSTB_RESCAL
 	bool "Broadcom STB RESCAL reset controller"
 	depends on HAS_IOMEM
-	default ARCH_BRCMSTB || COMPILE_TEST
+	depends on ARCH_BRCMSTB || COMPILE_TEST
+	default ARCH_BRCMSTB
 	help
 	  This enables the RESCAL reset controller for SATA, PCIe0, or PCIe1 on
 	  BCM7216.
-- 
2.30.2



