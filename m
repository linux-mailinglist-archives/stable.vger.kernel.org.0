Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440E7594AC4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355843AbiHPAGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354040AbiHOX6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2104F804AD;
        Mon, 15 Aug 2022 13:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08DA61007;
        Mon, 15 Aug 2022 20:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F3C433C1;
        Mon, 15 Aug 2022 20:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594856;
        bh=aRQIsfM1DlDmmnhgQS9E3HmvnGvp5qyhm8dCDWeSy6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OH8OuCkXIE2u9Qz6AgsTFDMpJ5KKOYgtUQdgsWRfwPfEhMFyHXFVz5dPnqzZXyczn
         822sFr11dM6v6wMIlOo2hMsDbqPJg4XzJBtvWY3VgOAg7Q0cG+lVegULNqhVS6tYQ3
         CPqO7GhoKinp2RCdhc81lZtSFFBONI066GMqd62E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0579/1157] clk: renesas: rzg2l: Fix reset status function
Date:   Mon, 15 Aug 2022 19:58:55 +0200
Message-Id: <20220815180502.808916209@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 02c96ed9e4cd1f47bfcd10296fec6b0b69d6b3c6 ]

As per RZ/G2L HW(Rev.1.10) manual, reset monitor register value 0 means
reset signal is not applied (deassert state) and 1 means reset signal
is applied (assert state).

reset_control_status() expects a positive value if the reset line is
asserted. But rzg2l_cpg_status function returns zero for asserted
state.

This patch fixes the issue by adding double inverted logic, so that
reset_control_status returns a positive value if the reset line is
asserted.

Fixes: ef3c613ccd68 ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20220531071657.104121-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index e2999ab2b53c..3ff6ecd61756 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1180,7 +1180,7 @@ static int rzg2l_cpg_status(struct reset_controller_dev *rcdev,
 	s8 monbit = info->resets[id].monbit;
 
 	if (info->has_clk_mon_regs) {
-		return !(readl(priv->base + CLK_MRST_R(reg)) & bitmask);
+		return !!(readl(priv->base + CLK_MRST_R(reg)) & bitmask);
 	} else if (monbit >= 0) {
 		u32 monbitmask = BIT(monbit);
 
-- 
2.35.1



