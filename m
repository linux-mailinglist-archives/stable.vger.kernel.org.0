Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C764263582D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiKWJuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiKWJuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697C525A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0610361B6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D9AC433C1;
        Wed, 23 Nov 2022 09:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196846;
        bh=3diNYy7zgc0dOYGKnfcf5iKPWlwNAgB4waDsM2iEojw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jomvyya3sA2ZpxhZZxXdXNj3WnpvQn71YiUM5j78BFI2/0K+zpQRPBhb6G2pLqjC+
         Txv0P3Niuy5SRtUYfP67RAgUBZnR0ldOVxrvargkAKok0Kmc9LD23XmvFvG3hiBIfc
         XIVKFsLWD3SeyD07GS8aYUmLnZ0cQuMTspQzHN8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Roger Quadros <rogerq@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/314] mtd: onenand: omap2: add dependency on GPMC
Date:   Wed, 23 Nov 2022 09:49:14 +0100
Message-Id: <20221123084630.444900780@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c717b9b7d6de9e024e47f7cd5bbff49f581d3db9 ]

OMAP2 OneNAND driver uses gpmc_omap_onenand_set_timings() provided by
OMAP_GPMC driver, so the latter cannot be module if OneNAND driver is
built-in:

  /usr/bin/arm-linux-gnueabi-ld: drivers/mtd/nand/onenand/onenand_omap2.o: in function `omap2_onenand_probe':
  onenand_omap2.c:(.text+0x520): undefined reference to `gpmc_omap_onenand_set_timings'

The OMAP_GPMC is also a runtime dependency.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 854fd9209b20 ("memory: omap-gpmc: Allow building as a module")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221107091520.127053-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/onenand/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/onenand/Kconfig b/drivers/mtd/nand/onenand/Kconfig
index 34d9a7a82ad4..c94bf483541e 100644
--- a/drivers/mtd/nand/onenand/Kconfig
+++ b/drivers/mtd/nand/onenand/Kconfig
@@ -26,6 +26,7 @@ config MTD_ONENAND_OMAP2
 	tristate "OneNAND on OMAP2/OMAP3 support"
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || (COMPILE_TEST && ARM)
 	depends on OF || COMPILE_TEST
+	depends on OMAP_GPMC
 	help
 	  Support for a OneNAND flash device connected to an OMAP2/OMAP3 SoC
 	  via the GPMC memory controller.
-- 
2.35.1



