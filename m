Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE036157DC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiKBCkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiKBCkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D8811C2F
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA8BEB82070
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7EDC43470;
        Wed,  2 Nov 2022 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356817;
        bh=flm/uUKV4mhs7EWfUkurx135fN2KPjZvwASFEHuc4fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ah7R3OzrMArwm/PCcG7986THqI+bcWxR992xKawpIM0K90p842cnzwuWHHWtvXC+j
         Wx/CIzo+XuPpOvepxgs23wC9+g7Dfo0Fx1QHm1GoOe5CjU2xVrY5F5Wl1j4N7D6AFc
         6rRQd6k2DKBowtIJPaew08jgrM2Tl3Zutu+xFeFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hongyu Ning <hongyu.ning@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Michael Walle <michael@walle.cc>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 036/240] mtd: spi-nor: core: Ignore -ENOTSUPP in spi_nor_init()
Date:   Wed,  2 Nov 2022 03:30:11 +0100
Message-Id: <20221102022112.220709200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 69d04ca999499bccb6ca849fa2bfc5e6448f7233 upstream.

The Intel SPI-NOR controller does not support the 4-byte address opcode
so ->set_4byte_addr_mode() ends up returning -ENOTSUPP and the SPI flash
chip probe fail like this:

  [ 12.291082] spi-nor: probe of spi0.0 failed with error -524

Whereas previously before commit 08412e72afba ("mtd: spi-nor: core:
Return error code from set_4byte_addr_mode()") it worked just fine.

Fix this by ignoring -ENOTSUPP in spi_nor_init().

Fixes: 08412e72afba ("mtd: spi-nor: core: Return error code from set_4byte_addr_mode()")
Cc: stable@vger.kernel.org
Reported-by: Hongyu Ning <hongyu.ning@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220923093441.3178-1-mika.westerberg@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2724,7 +2724,9 @@ static int spi_nor_init(struct spi_nor *
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		return nor->params->set_4byte_addr_mode(nor, true);
+		err = nor->params->set_4byte_addr_mode(nor, true);
+		if (err && err != -ENOTSUPP)
+			return err;
 	}
 
 	return 0;


