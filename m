Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8466A098A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbjBWNIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbjBWNH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:07:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF4B56538
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:07:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99703CE2020
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE7C433D2;
        Thu, 23 Feb 2023 13:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157654;
        bh=c9jDw8CVB+jrwKJzBQNMG5sLSYowvlAiVEjGt6z+yiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUtG2TQRlvZfpQlbt/vgKMkxKHHC7S3ANIBD1Aj260ov+kJjEayDOmtc8FiwNel7K
         eqYXwour6FIAJY7wU54GQ10u5dE1wD3dEGxWwDSjyvt+6ScZFSglBpkiSifYv1XoEf
         f8zJBnmqWWNKZ8ybNyv3QnCOItsrap70GtB0mxGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi xin Zhu <yzhu@maxlinear.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/25] clk: mxl: Fix a clk entry by adding relevant flags
Date:   Thu, 23 Feb 2023 14:06:23 +0100
Message-Id: <20230223130427.073204777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 106ef3bda21006fe37b62c85931230a6355d78d3 ]

One of the clock entry "dcl" clk has some HW limitations. One is that
its rate can only by changed by changing its parent clk's rate & two is
that HW does not support enable/disable for this clk.

Handle above two limitations by adding relevant flags. Add standard flag
CLK_SET_RATE_PARENT to handle rate change and add driver internal flag
DIV_CLK_NO_MASK to handle enable/disable.

Fixes: d058fd9e8984 ("clk: intel: Add CGU clock driver for a new SoC")
Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/a4770e7225f8a0c03c8ab2ba80434a4e8e9afb17.1665642720.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 5 +++--
 drivers/clk/x86/clk-cgu.h | 1 +
 drivers/clk/x86/clk-lgm.c | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 4278a687076c9..89b53f280aee0 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -164,8 +164,9 @@ static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
 
-	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
-			div->width_gate, enable);
+	if (div->flags != DIV_CLK_NO_MASK)
+		lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
+				div->width_gate, enable);
 	return 0;
 }
 
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 73ce84345f81e..bcaf8aec94e5d 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -198,6 +198,7 @@ struct lgm_clk_branch {
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
 #define GATE_CLK_HW		BIT(18)
+#define DIV_CLK_NO_MASK		BIT(19)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index e312af42e97ae..4de77b2c750d3 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -255,8 +255,8 @@ static const struct lgm_clk_branch lgm_branch_clks[] = {
 	LGM_FIXED(LGM_CLK_SLIC, "slic", NULL, 0, CGU_IF_CLK1,
 		  8, 2, CLOCK_FLAG_VAL_INIT, 8192000, 2),
 	LGM_FIXED(LGM_CLK_DOCSIS, "v_docsis", NULL, 0, 0, 0, 0, 0, 16000000, 0),
-	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", 0, CGU_PCMCR,
-		25, 3, 0, 0, 0, 0, dcl_div),
+	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", CLK_SET_RATE_PARENT, CGU_PCMCR,
+		25, 3, 0, 0, DIV_CLK_NO_MASK, 0, dcl_div),
 	LGM_MUX(LGM_CLK_PCM, "pcm", pcm_p, 0, CGU_C55_PCMCR,
 		0, 1, CLK_MUX_ROUND_CLOSEST, 0),
 	LGM_FIXED_FACTOR(LGM_CLK_DDR_PHY, "ddr_phy", "ddr",
-- 
2.39.0



