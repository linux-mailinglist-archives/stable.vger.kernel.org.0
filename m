Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0CC6356BD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbiKWJcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237823AbiKWJbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254A4769D2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95EBBCE20E5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67736C433C1;
        Wed, 23 Nov 2022 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195820;
        bh=gHyVgwKZ+Zkq8vBTnh9N4y1M7aW36ejzm0lcnhMc6qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4JBX0I7ovXlp4Ukq5Vo5tHpjeP7WtEdftN+YWspXujNOlrCKVoPksmD6Fv60StR7
         hsEEEH2JNvkMCBU2+N9tKgy5U5R1Smt3T/UdmSZOfVSCO7Hxmbv/Fry/XGr457GDKY
         XOjx9MLZdT9X33Xsr5LCYVfbfgYB1RTc/60r4ErI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/181] spi: stm32: Print summary callbacks suppressed message
Date:   Wed, 23 Nov 2022 09:50:05 +0100
Message-Id: <20221123084604.175064115@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index 9bd3fd1652f7..96a73f9e2677 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -886,6 +886,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
-- 
2.35.1



