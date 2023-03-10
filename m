Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5D46B49A4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjCJPOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjCJPOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCB27E7AE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AF1661A1D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C805C433D2;
        Fri, 10 Mar 2023 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460673;
        bh=GPSO2omHgHfb0/rBP2DpwoGfj+CkB5CfsA/xRvQmkCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3OwVd38bDMkTaKA7ZpLWB4p5vnzJchYSrqAfwGeQeac+FNf1nDZbV1BotUVsHkTD
         n3vqYLYiSRLxbWFjgAl0yx3azoKkRjAMLOrpst5Vc3DdhefXjR2zY1MLb2M7AVu1Lk
         ejKkaOc61LGMLhbxtg4blHogZ33jqdR1/TG3JAwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <Alexander.Stein@tq-group.com>,
        Louis Rannou <lrannou@baylibre.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.10 384/529] mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type
Date:   Fri, 10 Mar 2023 14:38:47 +0100
Message-Id: <20230310133822.803305610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Louis Rannou <lrannou@baylibre.com>

commit f0f0cfdc3a024e21161714f2e05f0df3b84d42ad upstream.

spi_nor_set_erase_type() was used either to set or to mask out an erase
type. When we used it to mask out an erase type a shift-out-of-bounds
was hit:
UBSAN: shift-out-of-bounds in drivers/mtd/spi-nor/core.c:2237:24
shift exponent 4294967295 is too large for 32-bit type 'int'

The setting of the size_{shift, mask} and of the opcode are unnecessary
when the erase size is zero, as throughout the code just the erase size
is considered to determine whether an erase type is supported or not.
Setting the opcode to 0xFF was wrong too as nobody guarantees that 0xFF
is an unused opcode. Thus when masking out an erase type, just set the
erase size to zero. This will fix the shift-out-of-bounds.

Fixes: 5390a8df769e ("mtd: spi-nor: add support to non-uniform SFDP SPI NOR flash memories")
Cc: stable@vger.kernel.org
Reported-by: Alexander Stein <Alexander.Stein@tq-group.com>
Signed-off-by: Louis Rannou <lrannou@baylibre.com>
Tested-by: Alexander Stein <Alexander.Stein@tq-group.com>
Link: https://lore.kernel.org/r/20230203070754.50677-1-tudor.ambarus@linaro.org
[ta: refine changes, new commit message, fix compilation error]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    9 +++++++++
 drivers/mtd/spi-nor/core.h |    1 +
 drivers/mtd/spi-nor/sfdp.c |    4 ++--
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2425,6 +2425,15 @@ void spi_nor_set_erase_type(struct spi_n
 }
 
 /**
+ * spi_nor_mask_erase_type() - mask out a SPI NOR erase type
+ * @erase:	pointer to a structure that describes a SPI NOR erase type
+ */
+void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase)
+{
+	erase->size = 0;
+}
+
+/**
  * spi_nor_init_uniform_erase_map() - Initialize uniform erase map
  * @map:		the erase map of the SPI NOR
  * @erase_mask:		bitmask encoding erase types that can erase the entire
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -424,6 +424,7 @@ void spi_nor_set_pp_settings(struct spi_
 
 void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
 			    u8 opcode);
+void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase);
 struct spi_nor_erase_region *
 spi_nor_region_next(struct spi_nor_erase_region *region);
 void spi_nor_init_uniform_erase_map(struct spi_nor_erase_map *map,
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -852,7 +852,7 @@ spi_nor_init_non_uniform_erase_map(struc
 	 */
 	for (i = 0; i < SNOR_ERASE_TYPE_MAX; i++)
 		if (!(regions_erase_type & BIT(erase[i].idx)))
-			spi_nor_set_erase_type(&erase[i], 0, 0xFF);
+			spi_nor_mask_erase_type(&erase[i]);
 
 	return 0;
 }
@@ -1063,7 +1063,7 @@ static int spi_nor_parse_4bait(struct sp
 			erase_type[i].opcode = (dwords[1] >>
 						erase_type[i].idx * 8) & 0xFF;
 		else
-			spi_nor_set_erase_type(&erase_type[i], 0u, 0xFF);
+			spi_nor_mask_erase_type(&erase_type[i]);
 	}
 
 	/*


