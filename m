Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5588756FC11
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiGKJif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiGKJhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E4684EFF;
        Mon, 11 Jul 2022 02:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED20612F1;
        Mon, 11 Jul 2022 09:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF97BC341C0;
        Mon, 11 Jul 2022 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531180;
        bh=ohZkBbfigAb/YiXoCchpRwV0Utyu12UcBZomEnYA7T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WiGHUtkAU46Fu5D+IRL3Q6cC1NsD1vXjMvr+/ozZXuBGZlS4gtaV+bSkSh3A+BNY
         4RL3W4kGoTZi1u68pxfMnR4YOwhTQIaRyuxZRIZImBl/c39cgCwuiA0zvPI/Bd/1wl
         vNym0uMIn0bvMyF8kZ4GiUmClrqREopGxGXGHcSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 013/230] can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register
Date:   Mon, 11 Jul 2022 11:04:29 +0200
Message-Id: <20220711090604.447608657@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

commit e3d4ee7d5f7f5256dfe89219afcc7a2d553b731f upstream.

The mcp251xfd compatible chips have an erratum ([1], [2]), where the
received CRC doesn't match the calculated CRC. In commit
c7eb923c3caf ("can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
around broken CRC on TBC register") the following workaround was
implementierend.

- If a CRC read error on the TBC register is detected and the first
  byte is 0x00 or 0x80, the most significant bit of the first byte is
  flipped and the CRC is calculated again.
- If the CRC now matches, the _original_ data is passed to the reader.
  For now we assume transferred data was OK.

New investigations and simulations indicate that the CRC send by the
device is calculated on correct data, and the data is incorrectly
received by the SPI host controller.

Use flipped instead of original data and update workaround description
in mcp251xfd_regmap_crc_read().

[1] mcp2517fd: DS80000792C: "Incorrect CRC for certain READ_CRC commands"
[2] mcp2518fd: DS80000789C: "Incorrect CRC for certain READ_CRC commands"

Link: https://lore.kernel.org/all/DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com
Fixes: c7eb923c3caf ("can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
[mkl: split into 2 patches, update patch description and documentation]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -334,9 +334,8 @@ mcp251xfd_regmap_crc_read(void *context,
 		 *
 		 * If the highest bit in the lowest byte is flipped
 		 * the transferred CRC matches the calculated one. We
-		 * assume for now the CRC calculation in the chip
-		 * works on wrong data and the transferred data is
-		 * correct.
+		 * assume for now the CRC operates on the correct
+		 * data.
 		 */
 		if (reg == MCP251XFD_REG_TBC &&
 		    ((buf_rx->data[0] & 0xf8) == 0x0 ||
@@ -350,10 +349,8 @@ mcp251xfd_regmap_crc_read(void *context,
 								  val_len);
 			if (!err) {
 				/* If CRC is now correct, assume
-				 * transferred data was OK, flip bit
-				 * back to original value.
+				 * flipped data is OK.
 				 */
-				buf_rx->data[0] ^= 0x80;
 				goto out;
 			}
 		}


