Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901D56579AC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiL1PDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiL1PDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165E7633B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A80716153C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF89EC433EF;
        Wed, 28 Dec 2022 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239812;
        bh=Vi7dUtHrEAaNYM9bMxRmH2PMGgJCsA4wijDta0PzS5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np9NEnLx9zGPX9Cm1xpYC0N0J8XxlSBNzNL3OphiQ2RWHZH7hZ0QOf6szk4Mbc6pn
         ft1mNKQyXsYBEiVAmg62Ci/6r6uultMK1h08KDFZ4ZCXEBDOc3UeZpgwaWYapa+wOW
         UgDg0iw0RwzLqXRR6DKD6/BbE1s4DmMHuYnmy/9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Marangi <ansuelsmth@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/731] clk: qcom: clk-krait: fix wrong div2 functions
Date:   Wed, 28 Dec 2022 15:36:20 +0100
Message-Id: <20221228144304.487706712@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit d676d3a3717cf726d3affedbe5ba98fc4ccad7b3 ]

Currently div2 value is applied to the wrong bits. This is caused by a
bug in the code where the shift is done only for lpl, for anything
else the mask is not shifted to the correct bits.

Fix this by correctly shift if lpl is not supported.

Fixes: 4d7dc77babfe ("clk: qcom: Add support for Krait clocks")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221108215625.30186-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-krait.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/clk-krait.c b/drivers/clk/qcom/clk-krait.c
index 90046428693c..e74fc81a14d0 100644
--- a/drivers/clk/qcom/clk-krait.c
+++ b/drivers/clk/qcom/clk-krait.c
@@ -98,6 +98,8 @@ static int krait_div2_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (d->lpl)
 		mask = mask << (d->shift + LPL_SHIFT) | mask << d->shift;
+	else
+		mask <<= d->shift;
 
 	spin_lock_irqsave(&krait_clock_reg_lock, flags);
 	val = krait_get_l2_indirect_reg(d->offset);
-- 
2.35.1



