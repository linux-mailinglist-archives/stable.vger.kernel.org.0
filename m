Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A15657C36
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiL1PaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiL1PaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:30:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAFC1581B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B221B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBBBC433EF;
        Wed, 28 Dec 2022 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241403;
        bh=6P/DIBYO4Ji+VS50YZzS39nTNzXJ72JkrGoPQWukJRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziDYUXT1ZwU+zdB2IPNuRSN9zmoflnS6KZ1dVgQM4Qy8XWozGTeET1+09x2KhytcH
         YnaovjSsbXxmwap/83Yc+aKk2mtNLuqjSAOMp9nLTD6JR9H2tvM+jKAIKDKDaj2jMQ
         nqpcbnvRph3ovTzt/LK/1bIAG/h+qSRAlDHClwe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <william.gray@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/731] counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update
Date:   Wed, 28 Dec 2022 15:39:45 +0100
Message-Id: <20221228144310.408406994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit fd5ac974fc25feed084c2d1599d0dddb4e0556bc ]

The ARR (auto reload register) and CMP (compare) registers are
successively written. The status bits to check the update of these
registers are polled together with regmap_read_poll_timeout().
The condition to end the loop may become true, even if one of the register
isn't correctly updated.
So ensure both status bits are set before clearing them.

Fixes: d8958824cf07 ("iio: counter: Add support for STM32 LPTimer")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20221123133609.465614-1-fabrice.gasnier@foss.st.com/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-lptimer-cnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index 13656957c45f..fa7f86cf0ea3 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -69,7 +69,7 @@ static int stm32_lptim_set_enable_state(struct stm32_lptim_cnt *priv,
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
-				       (val & STM32_LPTIM_CMPOK_ARROK),
+				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret)
 		return ret;
-- 
2.35.1



