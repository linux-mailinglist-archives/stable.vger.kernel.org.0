Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06211CB026
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgEHNYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgEHMhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67FEC215A4;
        Fri,  8 May 2020 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941444;
        bh=6uGc8atPdx4bzIbms4a25iCS0qHjYsHYHWKVVa7rGSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbps4D2IwY2GjcZAQBUyE6Z2Mn36XI0KOFuMoVZUK4odBV4lNdZA95DiCllWT6YBm
         Eq6sBaH9/T+4aaWNYv8Ew8hkXivvfs6tRY61aVRRKyL8cKHuimzluXG+ZckuP/NvG5
         N8VeJDeCOp1qd3UBbdg7O6cbm3FjAtc0OogQ6aas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.4 035/312] ARM: imx: select SRC for i.MX7
Date:   Fri,  8 May 2020 14:30:26 +0200
Message-Id: <20200508123126.951988807@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f1858b0e801a45d801dc23bc1ff5be14805022c8 upstream.

The i.MX7 Kconfig option had a couple of missing select lines that
I fixed already, but I missed HAVE_IMX_SRC:

arch/arm/mach-imx/built-in.o: In function `imx7d_init_irq':
platform-spi_imx.c:(.init.text+0x25a8): undefined reference to `imx_src_init'

This adds that one as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 0be5da9dc249 ("ARM: imx: imx7d requires anatop")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -562,6 +562,7 @@ config SOC_IMX7D
 	select ARM_GIC
 	select HAVE_IMX_ANATOP
 	select HAVE_IMX_MMDC
+	select HAVE_IMX_SRC
 	help
 		This enables support for Freescale i.MX7 Dual processor.
 


