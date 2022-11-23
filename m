Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A35C6355DB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiKWJYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbiKWJYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08A16174
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46810B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB9AC433C1;
        Wed, 23 Nov 2022 09:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195360;
        bh=N3ASCJl5UJ4VJyTqa6tVZ1xQThYrp+/q7HmMNnSW48Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScO+/APO/EcGMJBD6pN2Tt5I/QxpbdMaDn8NV3XaGqRFbx33IAvSO32nAGyhRDIFm
         vw61MOC4FJu+b/tILYC9EX/SWDr8G6dIAchrZiufug+T8/i9ZZgaQD4lYI1mSE05q9
         TXzc6YKL9+NGmDpq0cCN5Fn6U7bacQz4yLu1SLsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/149] spi: stm32: Print summary callbacks suppressed message
Date:   Wed, 23 Nov 2022 09:50:15 +0100
Message-Id: <20221123084559.149569531@linuxfoundation.org>
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
index a6dfc8fef20c..651a6510fb54 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -941,6 +941,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
-- 
2.35.1



