Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB8F6213FE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiKHN4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiKHN4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:56:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0241166C87
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:56:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4DCC8CE1B8E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18733C433D7;
        Tue,  8 Nov 2022 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915767;
        bh=FKGE6f2PFdsNpwvPzMQ46wVESZS0/0Sg3wmCcvCTj6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Umm5PSK8PJQZPOKekzRwtTl4o/N/x4FaULianl5XYaR8FKPe192H1Lepi6kmSqgL8
         R3MJ30U5y3V0VnBKLPDcWngro9eIfoeyCuZN5G7sSwqeRABiS2DyF5ws1qNMfL/Og6
         2SrGyDMDsJW55sXiqxv05eKexPC4YvbXRmCAUoRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/118] mtd: parsers: bcm47xxpart: Fix halfblock reads
Date:   Tue,  8 Nov 2022 14:38:53 +0100
Message-Id: <20221108133343.087994864@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 05e258c6ec669d6d18c494ea03d35962d6f5b545 ]

There is some code in the parser that tries to read 0x8000
bytes into a block to "read in the middle" of the block. Well
that only works if the block is also 0x10000 bytes all the time,
else we get these parse errors as we reach the end of the flash:

spi-nor spi0.0: mx25l1606e (2048 Kbytes)
mtd_read error while parsing (offset: 0x200000): -22
mtd_read error while parsing (offset: 0x201000): -22
(...)

Fix the code to do what I think was intended.

Cc: stable@vger.kernel.org
Fixes: f0501e81fbaa ("mtd: bcm47xxpart: alternative MAGIC for board_data partition")
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221018091129.280026-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/bcm47xxpart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/parsers/bcm47xxpart.c b/drivers/mtd/parsers/bcm47xxpart.c
index 50fcf4c2174b..13daf9bffd08 100644
--- a/drivers/mtd/parsers/bcm47xxpart.c
+++ b/drivers/mtd/parsers/bcm47xxpart.c
@@ -233,11 +233,11 @@ static int bcm47xxpart_parse(struct mtd_info *master,
 		}
 
 		/* Read middle of the block */
-		err = mtd_read(master, offset + 0x8000, 0x4, &bytes_read,
+		err = mtd_read(master, offset + (blocksize / 2), 0x4, &bytes_read,
 			       (uint8_t *)buf);
 		if (err && !mtd_is_bitflip(err)) {
 			pr_err("mtd_read error while parsing (offset: 0x%X): %d\n",
-			       offset + 0x8000, err);
+			       offset + (blocksize / 2), err);
 			continue;
 		}
 
-- 
2.35.1



