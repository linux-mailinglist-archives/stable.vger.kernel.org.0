Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C23B111CC5
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfLCWrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbfLCWrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250E72084B;
        Tue,  3 Dec 2019 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413239;
        bh=l0X75f7TRRc1czvTM/xQiDqe0ZSZj58WQSkaPybaDq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUD+3k++Y78qUDuMWtIDK4O4kAUuyPNIObBqNN5ygq/jkO8KGbfwYHkTvG+qHToEX
         H9epYQXE1RIzdkyOYOvlEs6QKRHP/EDz+6JTTAe4kl/UPMJur/8PkbvY1B8iQqYdwf
         jgYoC0oJhye0by4e/ce5dP391g6sJY7UJTQ4r130=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/321] ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed
Date:   Tue,  3 Dec 2019 23:31:59 +0100
Message-Id: <20191203223429.921945108@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 7c41ea57beb2aee96fa63091a457b1a2826f3c42 ]

If debugging on i.MX is enabled DEBUG_IMX_UART_PORT defines which UART
is used for the debug output. If however debugging is off don't only
hide the then unused config item but drop it completely by using a
dependency instead of a conditional prompt.

This fixes DEBUG_IMX_UART_PORT being present in the kernel config even
if DEBUG_LL is disabled.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig.debug | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index f6fcb8a798890..f95a90dfc282a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1432,21 +1432,21 @@ config DEBUG_OMAP2PLUS_UART
 	depends on ARCH_OMAP2PLUS
 
 config DEBUG_IMX_UART_PORT
-	int "i.MX Debug UART Port Selection" if DEBUG_IMX1_UART || \
-						DEBUG_IMX25_UART || \
-						DEBUG_IMX21_IMX27_UART || \
-						DEBUG_IMX31_UART || \
-						DEBUG_IMX35_UART || \
-						DEBUG_IMX50_UART || \
-						DEBUG_IMX51_UART || \
-						DEBUG_IMX53_UART || \
-						DEBUG_IMX6Q_UART || \
-						DEBUG_IMX6SL_UART || \
-						DEBUG_IMX6SX_UART || \
-						DEBUG_IMX6UL_UART || \
-						DEBUG_IMX7D_UART
+	int "i.MX Debug UART Port Selection"
+	depends on DEBUG_IMX1_UART || \
+		   DEBUG_IMX25_UART || \
+		   DEBUG_IMX21_IMX27_UART || \
+		   DEBUG_IMX31_UART || \
+		   DEBUG_IMX35_UART || \
+		   DEBUG_IMX50_UART || \
+		   DEBUG_IMX51_UART || \
+		   DEBUG_IMX53_UART || \
+		   DEBUG_IMX6Q_UART || \
+		   DEBUG_IMX6SL_UART || \
+		   DEBUG_IMX6SX_UART || \
+		   DEBUG_IMX6UL_UART || \
+		   DEBUG_IMX7D_UART
 	default 1
-	depends on ARCH_MXC
 	help
 	  Choose UART port on which kernel low-level debug messages
 	  should be output.
-- 
2.20.1



