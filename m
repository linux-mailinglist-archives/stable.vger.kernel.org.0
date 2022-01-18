Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900DD492A1D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346281AbiARQG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiARQG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:06:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1ABC06161C;
        Tue, 18 Jan 2022 08:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E395361295;
        Tue, 18 Jan 2022 16:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE451C00446;
        Tue, 18 Jan 2022 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522017;
        bh=LR2kLMcR+apjYWyEcYPnLl/7WPX0fK4eUt1AbzTwVcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnYkmJAs1wNqEQwXZ+KP1eZjqa+UOgM1/OvUpsWsLmxsfPIx1/2XV5sxeam5TwQDO
         3KY3clBTZlvIFhwXY7wx2RHFZXNuJDy33S7V/GGHRdQ9yCmgZeG5PJCqjH5pS2Mhx0
         d7AOmNE0I4pLZCt6QHDiZkzmuSnqBkHNrO2DwMrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 14/15] mtd: fixup CFI on ixp4xx
Date:   Tue, 18 Jan 2022 17:05:53 +0100
Message-Id: <20220118160450.523058120@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 603362b4a58393061dcfed1c7f0d0fd4aba61126 upstream.

drivers/mtd/maps/ixp4xx.c requires MTD_CFI_BE_BYTE_SWAP to be set
in order to compile.

drivers/mtd/maps/ixp4xx.c:57:4: error: #error CONFIG_MTD_CFI_BE_BYTE_SWAP required

This patch avoids the #error output by enforcing the policy in
Kconfig. Not sure if this is the right approach, but it helps doing
randconfig builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210927141045.1597593-1-arnd@kernel.org
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/chips/Kconfig |    2 ++
 drivers/mtd/maps/Kconfig  |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -55,12 +55,14 @@ choice
 	  LITTLE_ENDIAN_BYTE, if the bytes are reversed.
 
 config MTD_CFI_NOSWAP
+	depends on !ARCH_IXP4XX || CPU_BIG_ENDIAN
 	bool "NO"
 
 config MTD_CFI_BE_BYTE_SWAP
 	bool "BIG_ENDIAN_BYTE"
 
 config MTD_CFI_LE_BYTE_SWAP
+	depends on !ARCH_IXP4XX
 	bool "LITTLE_ENDIAN_BYTE"
 
 endchoice
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -303,7 +303,7 @@ config MTD_DC21285
 
 config MTD_IXP4XX
 	tristate "CFI Flash device mapped on Intel IXP4xx based systems"
-	depends on MTD_CFI && MTD_COMPLEX_MAPPINGS && ARCH_IXP4XX
+	depends on MTD_CFI && MTD_COMPLEX_MAPPINGS && ARCH_IXP4XX && MTD_CFI_ADV_OPTIONS
 	help
 	  This enables MTD access to flash devices on platforms based
 	  on Intel's IXP4xx family of network processors such as the


