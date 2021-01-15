Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B962F7ABF
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbhAOMyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:54:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbhAOMfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD122388B;
        Fri, 15 Jan 2021 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714120;
        bh=OfHwcpKeF5C1319OmThlbPWXSa63NkVHz8FSKR2z9AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmJ98PSo1MMsqc3xVaaHWovX2LB19OqEZVcXC04YkOigtfoLdQRIndcXvm2R5lute
         W0WCb0HJ6sMP42MF0jeE+0cB2jqOAm1BVJ3qISODlVG78To+ikhZYGDmOOZ2lnInaY
         AVaxDp+HUuW+nS5L5SMJBFE2cWblAZdguRkCdjzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 56/62] wan: ds26522: select CONFIG_BITREVERSE
Date:   Fri, 15 Jan 2021 13:28:18 +0100
Message-Id: <20210115122001.098824242@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 69931e11288520c250152180ecf9b6ac5e6e40ed upstream.

Without this, the driver runs into a link failure

arm-linux-gnueabi-ld: drivers/net/wan/slic_ds26522.o: in function `slic_ds26522_probe':
slic_ds26522.c:(.text+0x100c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: slic_ds26522.c:(.text+0x1cdc): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/net/wan/slic_ds26522.o: in function `slic_write':
slic_ds26522.c:(.text+0x1e4c): undefined reference to `byte_rev_table'

Fixes: c37d4a0085c5 ("Maxim/driver: Add driver for maxim ds26522")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wan/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -282,6 +282,7 @@ config SLIC_DS26522
 	tristate "Slic Maxim ds26522 card support"
 	depends on SPI
 	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE || COMPILE_TEST
+	select BITREVERSE
 	help
 	  This module initializes and configures the slic maxim card
 	  in T1 or E1 mode.


