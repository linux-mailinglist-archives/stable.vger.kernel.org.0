Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1F56FB12
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiGKJZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiGKJY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690E28701;
        Mon, 11 Jul 2022 02:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6208B80CEF;
        Mon, 11 Jul 2022 09:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C5BC34115;
        Mon, 11 Jul 2022 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530867;
        bh=md5Iwx5idA89husX/GHelj2HKMmJ5QIfXFbbhQRgCII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4z3PlloF/0/XYClrygbl8Yw8WsuzNjrngy23x0qG5HOg16WVjagPc3JkP59JJG/4
         xzfXHZFvUp/H7BtVvT8WOhi9LOE9vPzCO16VT4GPqRLuXdyZYRWrAuFpcHYMtv9AI/
         xtjypcEWdPw2wqKWdPXHzXYK/+hL4bU52jV7aqrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Modilaynen <pavel.modilaynen@volvocars.com>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 013/112] can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
Date:   Mon, 11 Jul 2022 11:06:13 +0200
Message-Id: <20220711090549.934935044@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

commit 406cc9cdb3e8d644b15e8028948f091b82abdbca upstream.

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

Measurements on the mcp2517fd show that the workaround is applicable
not only of the lowest byte is 0x00 or 0x80, but also if 3 least
significant bits are set.

Update check on 1st data byte and workaround description accordingly.

[1] mcp2517fd: DS80000792C: "Incorrect CRC for certain READ_CRC commands"
[2] mcp2518fd: DS80000789C: "Incorrect CRC for certain READ_CRC commands"

Link: https://lore.kernel.org/all/DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com
Fixes: c7eb923c3caf ("can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register")
Cc: stable@vger.kernel.org
Reported-by: Pavel Modilaynen <pavel.modilaynen@volvocars.com>
Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
[mkl: split into 2 patches, update patch description and documentation]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -334,10 +334,12 @@ mcp251xfd_regmap_crc_read(void *context,
 		 * register. It increments once per SYS clock tick,
 		 * which is 20 or 40 MHz.
 		 *
-		 * Observation shows that if the lowest byte (which is
-		 * transferred first on the SPI bus) of that register
-		 * is 0x00 or 0x80 the calculated CRC doesn't always
-		 * match the transferred one.
+		 * Observation on the mcp2518fd shows that if the
+		 * lowest byte (which is transferred first on the SPI
+		 * bus) of that register is 0x00 or 0x80 the
+		 * calculated CRC doesn't always match the transferred
+		 * one. On the mcp2517fd this problem is not limited
+		 * to the first byte being 0x00 or 0x80.
 		 *
 		 * If the highest bit in the lowest byte is flipped
 		 * the transferred CRC matches the calculated one. We
@@ -346,7 +348,8 @@ mcp251xfd_regmap_crc_read(void *context,
 		 * correct.
 		 */
 		if (reg == MCP251XFD_REG_TBC &&
-		    (buf_rx->data[0] == 0x0 || buf_rx->data[0] == 0x80)) {
+		    ((buf_rx->data[0] & 0xf8) == 0x0 ||
+		     (buf_rx->data[0] & 0xf8) == 0x80)) {
 			/* Flip highest bit in lowest byte of le32 */
 			buf_rx->data[0] ^= 0x80;
 


