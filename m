Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD38A3CE415
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbhGSPmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348952AbhGSPfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A867061357;
        Mon, 19 Jul 2021 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711338;
        bh=AbZH4p2U8ibvuC2y8pD0XrY1m5aa8+CyFw9KC251fw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6fQqYvYkz733Scy9M7ujkzH5sv/aEQUZjebU91kYpMFeeODVXDnKxBF2F00IvDu0
         jBdrtf0/HzQNj/0Ur0nRBW6tU4f+7rQlf4+xqyKfoZqGD2hQ6zm+5GSrvzCisHPnNx
         c5CKBckoA9Ylm9njZTe9fd/7yoVpri4GKEl7z+W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 273/351] reset: RESET_BRCMSTB_RESCAL should depend on ARCH_BRCMSTB
Date:   Mon, 19 Jul 2021 16:53:39 +0200
Message-Id: <20210719144953.982260938@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 3e7f55e44d84..312b7064cdb4 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -59,7 +59,8 @@ config RESET_BRCMSTB
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



