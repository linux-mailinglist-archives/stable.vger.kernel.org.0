Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0B2F7B31
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbhAOMdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733127AbhAOMdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56C9E23339;
        Fri, 15 Jan 2021 12:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713986;
        bh=fA0KTB++A7mRqnSitYulWdbeN4Ebxk5der3k//c7uXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ytqw9lemy4Os0n7ED+8ySJSAahUZFVcLcCksPyi0fYbRdPJg0Cqb5/7B3ulXQ6fpg
         hT7v/6ODqEJgS3mnkNfj4QGwiD6iFGesGGIklGjm9ies/SMG2oWeVNqItdRU9i+P5K
         ArslJ0p+IsB9F85iDRWJZnDjRNgzA36L8bsVWpCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 39/43] wan: ds26522: select CONFIG_BITREVERSE
Date:   Fri, 15 Jan 2021 13:28:09 +0100
Message-Id: <20210115121958.937486533@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
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
@@ -295,6 +295,7 @@ config SLIC_DS26522
 	tristate "Slic Maxim ds26522 card support"
 	depends on SPI
 	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE || COMPILE_TEST
+	select BITREVERSE
 	help
 	  This module initializes and configures the slic maxim card
 	  in T1 or E1 mode.


