Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658756AEF2E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjCGSVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjCGSVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:21:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA369EF5E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:14:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7690961526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878C4C433D2;
        Tue,  7 Mar 2023 18:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212896;
        bh=UUyMh0kMy+GPBAjE+eFPVPObeApdf5MQFnxeAomFIzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgztTOLuJ3s6S+nTjoWz+wF65/eMnoyNPj/h96PB/p57/AgoAzZbnaYu32dC0NBDM
         +kPqgQEGbGGCFkoTjXMNoql3afPXjv6bx42ibfi0lvY1TcKiQVBhO0gIOTAgC7LlqU
         WOQ7DcCfsc2/hP6YejC1kOY0kF8722aPrBNpS4Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/885] spi: dw_bt1: fix MUX_MMIO dependencies
Date:   Tue,  7 Mar 2023 17:54:26 +0100
Message-Id: <20230307170016.613279521@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d4bde04318c0d33705e9a77d4c7df72f262011e0 ]

Selecting a symbol with additional dependencies requires
adding the same dependency here:

WARNING: unmet direct dependencies detected for MUX_MMIO
  Depends on [n]: MULTIPLEXER [=y] && OF [=n]
  Selected by [y]:
  - SPI_DW_BT1 [=y] && SPI [=y] && SPI_MASTER [=y] && SPI_DESIGNWARE [=y] && (MIPS_BAIKAL_T1 || COMPILE_TEST [=y])

Drop the 'select' here to avoid the problem. Anyone using
the dw-bt1 SPI driver should make sure they include the
mux driver as well now.

Fixes: 7218838109fe ("spi: dw-bt1: Fix undefined devm_mux_control_get symbol")
Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Link: https://lore.kernel.org/all/20221218192523.c6vnfo26ua6xqf26@mobilestation/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20230130140156.3620863-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index d1bb62f7368b7..d4b969e68c314 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -295,7 +295,6 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
-- 
2.39.2



