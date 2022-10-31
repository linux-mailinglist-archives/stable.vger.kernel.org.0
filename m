Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439E1612FE8
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJaFmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJaFmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F81CE19
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582ED60FA5
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBA9C433C1;
        Mon, 31 Oct 2022 05:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194907;
        bh=Jpo32dxHz8LwRxLY1Gok71Ixmpl2xr1dsbRzJBN/jD4=;
        h=Subject:To:Cc:From:Date:From;
        b=M/VVsMRGOzxcQNXQGnGyKKH7ZC9HDa1qpf8AWg2kvtROk4T9v4ncdolDwSvr9noGv
         efxAkZGQo9QVGI3Q79xy2zgwodI7FC7Wi/43Q1MLuahdmIi6ttKeTCcN201sqYEfBb
         gHfSwsKw7ns7JuXg+HKAddv5wjDvYyoo6YeqkHQk=
Subject: FAILED: patch "[PATCH] mtd: parsers: bcm47xxpart: Fix halfblock reads" failed to apply to 4.9-stable tree
To:     linus.walleij@linaro.org, f.fainelli@gmail.com,
        miquel.raynal@bootlin.com, zajec5@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:42:36 +0100
Message-ID: <16671949566074@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

05e258c6ec66 ("mtd: parsers: bcm47xxpart: Fix halfblock reads")
4c38eded8070 ("mtd: parsers: bcm47xxpart: print correct offset on read error")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05e258c6ec669d6d18c494ea03d35962d6f5b545 Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 18 Oct 2022 11:11:29 +0200
Subject: [PATCH] mtd: parsers: bcm47xxpart: Fix halfblock reads
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
 

