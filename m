Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B202469491C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBMO4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjBMOzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CF31C7EF
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9676115E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D283EC433D2;
        Mon, 13 Feb 2023 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300140;
        bh=sbhRK+0haLItP7fq4kT2sr5kiF6FilBWs1sVRUzpJwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tdn7Fp0FD4RsjvEWv1iyqj6b2JpDCyBF29EGUE4YlB6CuyiV4wcPs6sIbUdXllbuE
         VRgZFOTDHMcGssfQVW+yd45kwuAaECRyI+JnBGHjeNQqDuzYfKZRIdLPP3V4Pd30J7
         m/6x3rQRwZ62f1oIkI47zfzRW4hBxZk2f+DEIkUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergey Nazarov <Sergey.Nazarov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/114] spi: dw: Fix wrong FIFO level setting for long xfers
Date:   Mon, 13 Feb 2023 15:48:29 +0100
Message-Id: <20230213144746.022211055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit c63b8fd14a7db719f8252038a790638728c4eb66 ]

Due to using the u16 type in the min_t() macros the SPI transfer length
will be cast to word before participating in the conditional statement
implied by the macro. Thus if the transfer length is greater than 64KB the
Tx/Rx FIFO threshold level value will be determined by the leftover of the
truncated after the type-case length. In the worst case it will cause the
dramatical performance drop due to the "Tx FIFO Empty" or "Rx FIFO Full"
interrupts triggered on each xfer word sent/received to/from the bus.

The problem can be easily fixed by specifying the unsigned int type in the
min_t() macros thus preventing the possible data loss.

Fixes: ea11370fffdf ("spi: dw: get TX level without an additional variable")
Reported-by: Sergey Nazarov <Sergey.Nazarov@baikalelectronics.ru>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230113185942.2516-1-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-core.c b/drivers/spi/spi-dw-core.c
index 99edddf9958b9..c3bfb6c84cab2 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -366,7 +366,7 @@ static void dw_spi_irq_setup(struct dw_spi *dws)
 	 * will be adjusted at the final stage of the IRQ-based SPI transfer
 	 * execution so not to lose the leftover of the incoming data.
 	 */
-	level = min_t(u16, dws->fifo_len / 2, dws->tx_len);
+	level = min_t(unsigned int, dws->fifo_len / 2, dws->tx_len);
 	dw_writel(dws, DW_SPI_TXFTLR, level);
 	dw_writel(dws, DW_SPI_RXFTLR, level - 1);
 
-- 
2.39.0



