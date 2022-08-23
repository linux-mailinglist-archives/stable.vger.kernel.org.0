Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01F259E09F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350554AbiHWLdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbiHWL2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:28:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA246C59C6;
        Tue, 23 Aug 2022 02:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2BB1B81C88;
        Tue, 23 Aug 2022 09:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017BAC433D6;
        Tue, 23 Aug 2022 09:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246722;
        bh=8yMkKzhaIIy3DNw9qsKXKinY89NRF/Ka1TXvMtoYgLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRhBypcRGDBZRsxXKDekTL5tgkcyktuLDwoUAwa8FStYrEaWYefWoHinMbDZURFeh
         uGBs50HlLsB50srgXZtKkHbIuTVIqO3aUnUUJ363YH9Aslt1m23GHxUa8FtEP/aeNC
         MfIzJPvzS82oYKKfTEx6HDTGUNR5c2Q98qKgQEy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/389] clk: qcom: clk-krait: unlock spin after mux completion
Date:   Tue, 23 Aug 2022 10:24:06 +0200
Message-Id: <20220823080122.645856083@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit df83d2c9e72910416f650ade1e07cc314ff02731 ]

Unlock spinlock after the mux switch is completed to prevent any corner
case of mux request while the switch still needs to be done.

Fixes: 4d7dc77babfe ("clk: qcom: Add support for Krait clocks")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220430054458.31321-3-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-krait.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-krait.c b/drivers/clk/qcom/clk-krait.c
index 59f1af415b58..90046428693c 100644
--- a/drivers/clk/qcom/clk-krait.c
+++ b/drivers/clk/qcom/clk-krait.c
@@ -32,11 +32,16 @@ static void __krait_mux_set_sel(struct krait_mux_clk *mux, int sel)
 		regval |= (sel & mux->mask) << (mux->shift + LPL_SHIFT);
 	}
 	krait_set_l2_indirect_reg(mux->offset, regval);
-	spin_unlock_irqrestore(&krait_clock_reg_lock, flags);
 
 	/* Wait for switch to complete. */
 	mb();
 	udelay(1);
+
+	/*
+	 * Unlock now to make sure the mux register is not
+	 * modified while switching to the new parent.
+	 */
+	spin_unlock_irqrestore(&krait_clock_reg_lock, flags);
 }
 
 static int krait_mux_set_parent(struct clk_hw *hw, u8 index)
-- 
2.35.1



