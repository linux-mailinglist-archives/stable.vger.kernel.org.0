Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DBB3A62EE
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhFNLGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235131AbhFNLEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8794C61920;
        Mon, 14 Jun 2021 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667502;
        bh=41nKey4KNd6oAa0ShWkGLQ/9Rt5ckOWSjJEfbJE8Q9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nT2mj+YhNEOHD+C5ZJ80wwhpOCdt0NdaED8xag7XikYjyevJbEhe+fHE48n4OjHBg
         qs0zyugSm2ywnLwFGr0QMF4o7Jh3PtfVu8R7XzX4f8ihrQv3z5rpMfblVTrWfVAZnx
         Bcr1zaCfwC1wMQ6coZJXE2sQrYlG9XeYiqd4o9cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Li <chenli@uniontech.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 096/131] phy: usb: Fix misuse of IS_ENABLED
Date:   Mon, 14 Jun 2021 12:27:37 +0200
Message-Id: <20210614102656.267398824@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Li <chenli@uniontech.com>

commit 7c2fc79250cafa1a29befeb60163028ec4720814 upstream.

While IS_ENABLED() is perfectly fine for CONFIG_* symbols, it is not
for other symbols such as __BIG_ENDIAN that is provided directly by
the compiler.

Switch to use CONFIG_CPU_BIG_ENDIAN instead of __BIG_ENDIAN.

Signed-off-by: Chen Li <chenli@uniontech.com>
Reviewed-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 94583a41047e ("phy: usb: Restructure in preparation for adding 7216 USB support")
Link: https://lore.kernel.org/r/87czuggpra.wl-chenli@uniontech.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/broadcom/phy-brcm-usb-init.h
+++ b/drivers/phy/broadcom/phy-brcm-usb-init.h
@@ -78,7 +78,7 @@ static inline u32 brcm_usb_readl(void __
 	 * Other architectures (e.g., ARM) either do not support big endian, or
 	 * else leave I/O in little endian mode.
 	 */
-	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(__BIG_ENDIAN))
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		return __raw_readl(addr);
 	else
 		return readl_relaxed(addr);
@@ -87,7 +87,7 @@ static inline u32 brcm_usb_readl(void __
 static inline void brcm_usb_writel(u32 val, void __iomem *addr)
 {
 	/* See brcmnand_readl() comments */
-	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(__BIG_ENDIAN))
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		__raw_writel(val, addr);
 	else
 		writel_relaxed(val, addr);


