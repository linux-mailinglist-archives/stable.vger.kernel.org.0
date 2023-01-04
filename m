Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3E65D8B3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbjADQRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbjADQRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AF1DEB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04C1D6178F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85BBC433EF;
        Wed,  4 Jan 2023 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849029;
        bh=Sh52N/4oQ36B4hWKWoGJgmNOjeg4t01WHjVXah8fEf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGHxMgPs35Lnj0kFsBSrHCrptf4wpe/FImtvEIWJsl5ba3Ulsv5s2yBxW6xlv6YwV
         Qyxm76Ow/QuIXPo79fxO6Q+KV8UJ+lDI21uv2CaKXUnRuMqkMFhZjQf+DHWJ3foJ61
         q+BiJjgXapQvT3kfC/o3YvjTmEpvlC5EKHdxwb5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Yaliang Wang <Yaliang.Wang@windriver.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 6.1 122/207] mtd: spi-nor: gigadevice: gd25q256: replace gd25q256_default_init with gd25q256_post_bfpt
Date:   Wed,  4 Jan 2023 17:06:20 +0100
Message-Id: <20230104160515.778005185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Yaliang Wang <Yaliang.Wang@windriver.com>

commit 4dc49062a7e9c0c7261807fb855df1c611eb78c3 upstream.

When utilizing PARSE_SFDP to initialize the flash parameter, the
deprecated initializing method spi_nor_init_params_deprecated() and the
function spi_nor_manufacturer_init_params() within it will never be
executed, which results in the default_init hook function will also never
be executed.

This is okay for 'D' generation of GD25Q256, because 'D' generation is
implementing the JESD216B standards, it has QER field defined in BFPT,
parsing the SFDP can properly set the quad_enable function. The 'E'
generation also implements the JESD216B standards, and it has the same
status register definitions as 'D' generation, parsing the SFDP to set
the quad_enable function should also work for 'E' generation.

However, the same thing can't apply to 'C' generation. 'C' generation
'GD25Q256C' implements the JESD216 standards, and it doesn't have the
QER field defined in BFPT, since it does have QE bit in status register
1, the quad_enable hook needs to be tweaked to properly set the
quad_enable function, this can be done in post_bfpt fixup hook.

Fixes: 047275f7de18 ("mtd: spi-nor: gigadevice: gd25q256: Init flash based on SFDP")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yaliang Wang <Yaliang.Wang@windriver.com>
[tudor.ambarus@microchip.com: Update comment in gd25q256_post_bfpt]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221016171901.1483542-2-yaliang.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/gigadevice.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/mtd/spi-nor/gigadevice.c
+++ b/drivers/mtd/spi-nor/gigadevice.c
@@ -8,19 +8,29 @@
 
 #include "core.h"
 
-static void gd25q256_default_init(struct spi_nor *nor)
+static int
+gd25q256_post_bfpt(struct spi_nor *nor,
+		   const struct sfdp_parameter_header *bfpt_header,
+		   const struct sfdp_bfpt *bfpt)
 {
 	/*
-	 * Some manufacturer like GigaDevice may use different
-	 * bit to set QE on different memories, so the MFR can't
-	 * indicate the quad_enable method for this case, we need
-	 * to set it in the default_init fixup hook.
+	 * GD25Q256C supports the first version of JESD216 which does not define
+	 * the Quad Enable methods. Overwrite the default Quad Enable method.
+	 *
+	 * GD25Q256 GENERATION | SFDP MAJOR VERSION | SFDP MINOR VERSION
+	 *      GD25Q256C      | SFDP_JESD216_MAJOR | SFDP_JESD216_MINOR
+	 *      GD25Q256D      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
+	 *      GD25Q256E      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
 	 */
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	if (bfpt_header->major == SFDP_JESD216_MAJOR &&
+	    bfpt_header->minor == SFDP_JESD216_MINOR)
+		nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+
+	return 0;
 }
 
 static const struct spi_nor_fixups gd25q256_fixups = {
-	.default_init = gd25q256_default_init,
+	.post_bfpt = gd25q256_post_bfpt,
 };
 
 static const struct flash_info gigadevice_nor_parts[] = {


