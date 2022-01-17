Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF5490DFE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbiAQRGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242284AbiAQRDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545F5611C0;
        Mon, 17 Jan 2022 17:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81960C36AE7;
        Mon, 17 Jan 2022 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439010;
        bh=jMvOlTe10aiL8xVey/HFWpKZibYbbP0tunjN77I5CEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYf+EpZfNKB4pFuTNXjOPLMcOucPwxvnV4AfV0y6C9RpgDgnCVNDgP27vMtgccGVh
         m4ZR/jtixxaoivKVqasc77/oj/SdYQHPpua7WGybhuaI/jbfHPLwFestp7AH41BJnX
         37gWxRx89m2Onbg9sH3suFFxGtHLrUg0irCwffcDA0hiYw0y7BUtAWWIe4R8yAKf9D
         v+DFfDLCXy+5balyP7fcvErTKRVzSIg6FCzbvfKWgT0bmPVnxqcrD/scabfiYzvbGP
         Cqm2qfTbE3GSobqmhWhXTUtwC0urhS3rkew3nhzgjjjtybP2fZ14jROYYgp4cnfoxl
         0KXRrl1iwXsgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, Abel Vesa <abel.vesa@nxp.com>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        sboyd@kernel.org, shawnguo@kernel.org, linux-clk@vger.kernel.org,
        linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/34] clk: imx: Use div64_ul instead of do_div
Date:   Mon, 17 Jan 2022 12:02:52 -0500
Message-Id: <20220117170326.1471712-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

[ Upstream commit c1b6ad9a902539f9c037b6b3c35cb134c5724022 ]

do_div() does a 64-by-32 division. Here the divisor is an unsigned long
which on some platforms is 64 bit wide. So use div64_ul instead of do_div
to avoid a possible truncation.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20211118080634.165275-1-deng.changcheng@zte.com.cn
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pllv3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-pllv3.c b/drivers/clk/imx/clk-pllv3.c
index 20ee9611ba6e3..eea32f87c60aa 100644
--- a/drivers/clk/imx/clk-pllv3.c
+++ b/drivers/clk/imx/clk-pllv3.c
@@ -247,7 +247,7 @@ static long clk_pllv3_av_round_rate(struct clk_hw *hw, unsigned long rate,
 	div = rate / parent_rate;
 	temp64 = (u64) (rate - div * parent_rate);
 	temp64 *= mfd;
-	do_div(temp64, parent_rate);
+	temp64 = div64_ul(temp64, parent_rate);
 	mfn = temp64;
 
 	temp64 = (u64)parent_rate;
@@ -277,7 +277,7 @@ static int clk_pllv3_av_set_rate(struct clk_hw *hw, unsigned long rate,
 	div = rate / parent_rate;
 	temp64 = (u64) (rate - div * parent_rate);
 	temp64 *= mfd;
-	do_div(temp64, parent_rate);
+	temp64 = div64_ul(temp64, parent_rate);
 	mfn = temp64;
 
 	val = readl_relaxed(pll->base);
@@ -334,7 +334,7 @@ static struct clk_pllv3_vf610_mf clk_pllv3_vf610_rate_to_mf(
 		/* rate = parent_rate * (mfi + mfn/mfd) */
 		temp64 = rate - parent_rate * mf.mfi;
 		temp64 *= mf.mfd;
-		do_div(temp64, parent_rate);
+		temp64 = div64_ul(temp64, parent_rate);
 		mf.mfn = temp64;
 	}
 
-- 
2.34.1

