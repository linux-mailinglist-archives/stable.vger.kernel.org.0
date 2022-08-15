Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95C159506F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiHPEmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiHPEkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E872CA50FB;
        Mon, 15 Aug 2022 13:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8612861089;
        Mon, 15 Aug 2022 20:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7728EC433C1;
        Mon, 15 Aug 2022 20:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595526;
        bh=O+ZF0S3TxUZwPUpgyNNN8n7Tiwbji4dnIU/dpyt8iXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bF4HD1k98iynhGZ0ODgMGK+biiGrZkxXUGSb17wyzskChE6aDu42b9mHpq/h/Y4hK
         oowq7Q7nNH5JCUwB7mOfxxOlpn4t6fWqg2aY3xZCrW9JXZBMJCcMwlUyg0DxHAwmz/
         XurdIw82mNZeKnbXkHo8+IGmxmvv8sjRg31zayYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Travkin <nikita@trvn.ru>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0761/1157] clk: qcom: clk-rcg2: Fail Duty-Cycle configuration if MND divider is not enabled.
Date:   Mon, 15 Aug 2022 20:01:57 +0200
Message-Id: <20220815180509.927263804@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit bdafb609c3bb848d710ad9cd4debd2ee9d6a4049 ]

In cases when MND is not enabled (e.g. when only Half Integer Divider is
used), setting D registers makes no effect.

Fail instead of making ineffective write.

Fixes: 7f891faf596e ("clk: qcom: clk-rcg2: Add support for duty-cycle for RCG")
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220612145955.385787-2-nikita@trvn.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 8e5dce09d162..2375e8122012 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -437,7 +437,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per;
+	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -448,6 +448,11 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
 	regmap_read(rcg->clkr.regmap, RCG_N_OFFSET(rcg), &notn_m);
 	regmap_read(rcg->clkr.regmap, RCG_M_OFFSET(rcg), &m);
+	regmap_read(rcg->clkr.regmap, RCG_CFG_OFFSET(rcg), &cfg);
+
+	/* Duty-cycle cannot be modified if MND divider is in bypass mode. */
+	if (!(cfg & CFG_MODE_MASK))
+		return -EINVAL;
 
 	n = (~(notn_m) + m) & mask;
 
-- 
2.35.1



