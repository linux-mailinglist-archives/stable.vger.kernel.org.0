Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD1492A93
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346903AbiARQL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:11:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41480 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346849AbiARQJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B373CE1A38;
        Tue, 18 Jan 2022 16:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4B3C36AE7;
        Tue, 18 Jan 2022 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522189;
        bh=r4Hq5v2ePiBJT2hP/0OOZ9eNvaLNdMevf4cO+hq/xQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0JJqDmJtjC+rtkRm0u4sjFtxv5WsH3bUqkZohjLpTdTlknq4Cr23W5hufA6aqtoF
         Nsbetdc9r3lV1Mf0KzsoHPBuWlE3kpGlIEIcus11asJPUDgWIKU7nq2pd151a5plKJ
         BoIZC+uWfHremmgPTYWKoFpQQPHqHsHd7yoEY7cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.15 28/28] mtd: fixup CFI on ixp4xx
Date:   Tue, 18 Jan 2022 17:06:14 +0100
Message-Id: <20220118160452.812621295@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
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
@@ -302,7 +302,7 @@ config MTD_DC21285
 
 config MTD_IXP4XX
 	tristate "CFI Flash device mapped on Intel IXP4xx based systems"
-	depends on MTD_CFI && MTD_COMPLEX_MAPPINGS && ARCH_IXP4XX
+	depends on MTD_CFI && MTD_COMPLEX_MAPPINGS && ARCH_IXP4XX && MTD_CFI_ADV_OPTIONS
 	help
 	  This enables MTD access to flash devices on platforms based
 	  on Intel's IXP4xx family of network processors such as the


