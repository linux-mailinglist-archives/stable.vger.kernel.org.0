Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD310635523
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiKWJOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiKWJOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:14:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC1F108901
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E19AA61B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE992C433D7;
        Wed, 23 Nov 2022 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194868;
        bh=jjtMGiW/60n+4V6Eqyt3dhA3e10NO5t2LnXBVN95Mrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjWubO2QjGGkfPA9SzuNff2nAiIstilVhFOd6HF1gcu33r5i1iaFk/b/e9LOe+JiN
         hotQrfKNXRNSvceuD+3q5DO+0PftRo93pNrylp2G+mBGbfH5XYMTaYRndQeuxO6OEC
         qBIIOIyw85cIsOHZ6gkr+K72soOmRGIQcAkodYCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/156] spi: stm32: Print summary callbacks suppressed message
Date:   Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084600.971866381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 195583504be28df5d608a4677dd796117aea875f ]

The original fix "spi: stm32: Rate-limit the 'Communication suspended' message"
still leads to "stm32h7_spi_irq_thread: 1696 callbacks suppressed" spew in the
kernel log. Since this 'Communication suspended' message is a debug print, add
RATELIMIT_MSG_ON_RELEASE flag to inhibit the "callbacks suspended" part during
normal operation and only print summary at the end.

Fixes: ea8be08cc9358 ("spi: stm32: Rate-limit the 'Communication suspended' message")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20221018183513.206706-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 9ae16092206d..a1961a973839 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -937,6 +937,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
-- 
2.35.1



