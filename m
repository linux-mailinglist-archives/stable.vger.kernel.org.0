Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0170F6355D5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiKWJXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiKWJWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32DA8F3CC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69CE6B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2236C433C1;
        Wed, 23 Nov 2022 09:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195319;
        bh=13nkhbatzbHlwo/ozBd7lqI5k+qEzJrZj1Tgej+I2W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwWcv5UatMlky5ibvI8hGiqQpRSoBotPCnbhZ6Znl8lXKjZjO2uXGJDZA9eTSonSt
         /bRnvRxwnF5XLAH/R8U4DqQNnNkyUlw34lTWwnWzq6ANvHBaQ66ISOdcwCQw6gwUNB
         XA2bNjjs5Uclkb//f5DvqrPO1sP7gSWIOrp3Y0dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/149] parport_pc: Avoid FIFO port location truncation
Date:   Wed, 23 Nov 2022 09:50:33 +0100
Message-Id: <20221123084559.730553965@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit ab126f51c93a15093df604f661c9480854c005a3 ]

Match the data type of a temporary holding a reference to the FIFO port
with the type of the original reference coming from `struct parport',
avoiding data truncation with LP64 ports such as SPARC64 that refer to
PCI port I/O locations via their corresponding MMIO addresses and will
therefore have non-zero bits in the high 32-bit part of the reference.
And in any case it is cleaner to have the data types matching here.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/linux-pci/20220419033752.GA1101844@bhelgaas/
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2209231912550.29493@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/parport_pc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index eda4ded4d5e5..925be41eeebe 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -468,7 +468,7 @@ static size_t parport_pc_fifo_write_block_pio(struct parport *port,
 	const unsigned char *bufp = buf;
 	size_t left = length;
 	unsigned long expire = jiffies + port->physport->cad->timeout;
-	const int fifo = FIFO(port);
+	const unsigned long fifo = FIFO(port);
 	int poll_for = 8; /* 80 usecs */
 	const struct parport_pc_private *priv = port->physport->private_data;
 	const int fifo_depth = priv->fifo_depth;
-- 
2.35.1



