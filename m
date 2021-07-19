Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08B3CE5C3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346538AbhGSPxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348393AbhGSPtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B62861283;
        Mon, 19 Jul 2021 16:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712108;
        bh=ChovUyUvdkUOYxClzF7yGeYencOCYAQPHmG9i+PBqgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZqxp4ODwI65whVajujcaHah2C6A4jg+JtldLKzNskcRBMEi8qhOq9iVgexLS6dV7
         mU6112FA6bIdZKvXCtK2HO3L29sprkFv7+VGJt7W9NSLQljhZQFs58wt0elaJRhnan
         jNOYC/UGaXnxwNQZ1uh6E3XidZlnxIzqUpzaI1Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 226/292] reset: RESET_BRCMSTB_RESCAL should depend on ARCH_BRCMSTB
Date:   Mon, 19 Jul 2021 16:54:48 +0200
Message-Id: <20210719144950.403509683@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 4171c6f76385..6dba675bcec4 100644
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



