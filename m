Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12F694A3D
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjBMPFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjBMPFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DEF1CF4B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DA50610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51D7C4339B;
        Mon, 13 Feb 2023 15:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300731;
        bh=/aWwNfyOMzjChDgrqbft5LPepNjtNvhc3kebMgw7Sco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hwFNaagFKPZQCjo9V5YhjwhMS/eXu27A6oPSDA0KP6hInZN/zm0VmAzb98tVj8ru
         ZTMknhyCJ+vGwz5XizqoYNjZj5MD5466sD3mDf9SBdEVI6OF1BbSLO82kPGN2gh9G/
         6HlE6PxuJOiAy66/JYRLWQSs0jznRmqY8YicnGPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergey Nazarov <Sergey.Nazarov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/139] spi: dw: Fix wrong FIFO level setting for long xfers
Date:   Mon, 13 Feb 2023 15:51:11 +0100
Message-Id: <20230213144752.587855280@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index c33866f747dbe..aa116cee1fd8d 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -353,7 +353,7 @@ static void dw_spi_irq_setup(struct dw_spi *dws)
 	 * will be adjusted at the final stage of the IRQ-based SPI transfer
 	 * execution so not to lose the leftover of the incoming data.
 	 */
-	level = min_t(u16, dws->fifo_len / 2, dws->tx_len);
+	level = min_t(unsigned int, dws->fifo_len / 2, dws->tx_len);
 	dw_writel(dws, DW_SPI_TXFTLR, level);
 	dw_writel(dws, DW_SPI_RXFTLR, level - 1);
 
-- 
2.39.0



