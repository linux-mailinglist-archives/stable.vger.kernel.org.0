Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77873A644A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhFNLWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236108AbhFNLUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41F1C61990;
        Mon, 14 Jun 2021 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667913;
        bh=41nKey4KNd6oAa0ShWkGLQ/9Rt5ckOWSjJEfbJE8Q9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjPcfJJcbtRqjHibYyrMyRO+cfy/4h8tqcMcF5xMJ7bkOL502v1XBokSKNccRKbAT
         nbPnDXhOOSlwn/nEG7zOp0fEoVyEzk6tOW+T1+N5yNJSCoGHLSIcom1RjzpVLrltRx
         3T/zbYUu69zMnjck4gLwM5uGzOG26u2QVJXXcijs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Li <chenli@uniontech.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.12 123/173] phy: usb: Fix misuse of IS_ENABLED
Date:   Mon, 14 Jun 2021 12:27:35 +0200
Message-Id: <20210614102702.261109384@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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


