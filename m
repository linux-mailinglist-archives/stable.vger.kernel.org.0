Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB68328BD0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240335AbhCASip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239920AbhCASdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A429E64F00;
        Mon,  1 Mar 2021 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620889;
        bh=0ExyrjjpQ/CckP5moQJw2qC6duuW8N60lGvhI8jFxLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Le6n6XBYK7e9Qx1M1d4i3UO7xoMLubPKo8TdeDjPvv0s6vZ2Ju3hg+SLSmVBFHIQq
         5T6eXePLnv4ZV5uDD7wvDFLHFi1KQ+e3yGQksB7YrQgXR4gmgOwfjGiSs9SE/OfdCI
         431zoWoMQWtfD6knh4Ctzs9eZxu4bhNFVfvXiy6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 299/775] irqchip/imx: IMX_INTMUX should not default to y, unconditionally
Date:   Mon,  1 Mar 2021 17:07:47 +0100
Message-Id: <20210301161216.402851612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a890caeb2ba40ca183969230e204ab144f258357 ]

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of IMX_INTMUX to ARCH_MXC,
and ask the user in case of compile-testing.

Fixes: 66968d7dfc3f5451 ("irqchip: Add COMPILE_TEST support for IMX_INTMUX")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210208145605.422943-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b147f22a78f48..d7d1a0fab2c1a 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -457,7 +457,8 @@ config IMX_IRQSTEER
 	  Support for the i.MX IRQSTEER interrupt multiplexer/remapper.
 
 config IMX_INTMUX
-	def_bool y if ARCH_MXC || COMPILE_TEST
+	bool "i.MX INTMUX support" if COMPILE_TEST
+	default y if ARCH_MXC
 	select IRQ_DOMAIN
 	help
 	  Support for the i.MX INTMUX interrupt multiplexer.
-- 
2.27.0



