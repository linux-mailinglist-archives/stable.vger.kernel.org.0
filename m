Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A36C571911
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiGLLyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 07:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiGLLyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 07:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E4B629D;
        Tue, 12 Jul 2022 04:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0C5561574;
        Tue, 12 Jul 2022 11:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F48C341CD;
        Tue, 12 Jul 2022 11:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657626793;
        bh=6FigCnzE+Dx/FTtyanL8zrhQ0aZVYbr/GBQY5us+fH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNPTMY5FNXdp6Wu6EXjb9vtuAaqtxL26Xu3K917cBSHbDgu+rOonCJdSJLe5EbnM4
         FmYPRS4qpROLP040K+Vg42t49c4l+9g8nYOhvP6oCJwZxCWR2fVq4ZvfzMrSdh7MlB
         0bB8XKMEM0fgyv3DeSmcLJX9bEwLAj2vq4ud+fzHJMkIMjcuv7cO9Kk6Q4mt8VWCsd
         st8MAkjVkYZtKjyc6EFCSD8Q+z50fVJN/hsxsvQgwY4tyoWIZ3BGxIF/bQpYQpbCcV
         jsbISFgqatWdrCB32hheK6gbQU3UeQj3LEhbCOU0EQ+1TvimFpPCdzCu6VXchU0knt
         53QQUHG8nAf5w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/7] USB: serial: ftdi_sio: Fix divisor overflow
Date:   Tue, 12 Jul 2022 13:53:00 +0200
Message-Id: <20220712115306.26471-2-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220712115306.26471-1-kabel@kernel.org>
References: <20220712115306.26471-1-kabel@kernel.org>
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

From: Pali Rohár <pali@kernel.org>

The baud rate generating divisor is a 17-bit wide (14 bits integer part
and 3 bits fractional part).

Example:
  base clock = 48 MHz
  requested baud rate = 180 Baud
  divisor = 48,000,000 / (16 * 180) = 0b100000100011010.101

  In this case the MSB gets discarded because of the overflow, and the
  actually used divisor will be 0b100011010.101 = 282.625, resulting
  in baud rate 10615 Baud, instead of the requested 180 Baud.

The best possible thing to do in this case is to generate lowest possible
baud rate (in the example it would be 183 Baud), by using maximum possible
divisor.

In case of divisor overflow, use maximum possible divisor.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pali Rohár <pali@kernel.org>
Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/usb/serial/ftdi_sio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b440d338a895..ea40f367e70c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1157,6 +1157,8 @@ static unsigned short int ftdi_232am_baud_base_to_divisor(int baud, int base)
 	int divisor3 = DIV_ROUND_CLOSEST(base, 2 * baud);
 	if ((divisor3 & 0x7) == 7)
 		divisor3++; /* round x.7/8 up to x+1 */
+	if (divisor3 > GENMASK(16, 0))
+		divisor3 = GENMASK(16, 0);
 	divisor = divisor3 >> 3;
 	divisor3 &= 0x7;
 	if (divisor3 == 1)
@@ -1181,6 +1183,8 @@ static u32 ftdi_232bm_baud_base_to_divisor(int baud, int base)
 	u32 divisor;
 	/* divisor shifted 3 bits to the left */
 	int divisor3 = DIV_ROUND_CLOSEST(base, 2 * baud);
+	if (divisor3 > GENMASK(16, 0))
+		divisor3 = GENMASK(16, 0);
 	divisor = divisor3 >> 3;
 	divisor |= (u32)divfrac[divisor3 & 0x7] << 14;
 	/* Deal with special cases for highest baud rates. */
@@ -1204,6 +1208,8 @@ static u32 ftdi_2232h_baud_base_to_divisor(int baud, int base)
 
 	/* hi-speed baud rate is 10-bit sampling instead of 16-bit */
 	divisor3 = DIV_ROUND_CLOSEST(8 * base, 10 * baud);
+	if (divisor3 > GENMASK(16, 0))
+		divisor3 = GENMASK(16, 0);
 
 	divisor = divisor3 >> 3;
 	divisor |= (u32)divfrac[divisor3 & 0x7] << 14;
-- 
2.35.1

