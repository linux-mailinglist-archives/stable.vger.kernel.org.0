Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E1594215
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243578AbiHOVWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbiHOVU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:20:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBE0E42E5;
        Mon, 15 Aug 2022 12:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 616DCCE12C4;
        Mon, 15 Aug 2022 19:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF1CC433D6;
        Mon, 15 Aug 2022 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591327;
        bh=HrKKffI5O2JNEYG9R4zavF2S4ypNCV02Z8F8Qh6fPuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D07ijHMnnmnej9RY2GaXxhqqLZS6ArYTy7t6/ocX74I7+RnwUb6vw313b1oI/8DMd
         8WJX9J9MFqQKl1oiMTwykk7jBmL0oG9OfvBZ3V9KCHmEzin0GyCk36xrZDl6ZsI4KY
         5iMOhe9iT0/gjPUmxDPGzxpXUDc+1B95pWpeS6Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0545/1095] clk: renesas: rzg2l: Fix reset status function
Date:   Mon, 15 Aug 2022 19:59:04 +0200
Message-Id: <20220815180452.097609847@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 486d0656c58a..1068058a3865 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -744,7 +744,7 @@ static int rzg2l_cpg_status(struct reset_controller_dev *rcdev,
 	unsigned int reg = info->resets[id].off;
 	u32 bitmask = BIT(info->resets[id].bit);
 
-	return !(readl(priv->base + CLK_MRST_R(reg)) & bitmask);
+	return !!(readl(priv->base + CLK_MRST_R(reg)) & bitmask);
 }
 
 static const struct reset_control_ops rzg2l_cpg_reset_ops = {
-- 
2.35.1



